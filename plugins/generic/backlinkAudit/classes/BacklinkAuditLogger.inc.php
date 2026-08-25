<?php

/**
 * @file plugins/generic/backlinkAudit/classes/BacklinkAuditLogger.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditLogger
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Extracts <a href> links from rich text content and records who
 * saved them, in which journal, and what changed.
 */

class BacklinkAuditLogger {

	/** @var BacklinkAuditDAO */
	var $_dao;

	/** @var array|null Cached allowed hosts for external-link detection */
	var $_allowedHosts;

	function __construct($dao) {
		$this->_dao = $dao;
	}

	//
	// Public API
	//

	/**
	 * Audit a settings-style save: compares submitted values against the
	 * previous object state and logs any field whose anchor set changed.
	 *
	 * @param $sourceType string context|site|publication
	 * @param $oldObject DataObject|null Previous state.
	 * @param $params array Submitted field => value map (value may be localized array).
	 * @param $newDataObject DataObject|null New state (used when $params unavailable, e.g. add).
	 * @param $contextId int|null
	 * @param $contextPath string|null
	 * @param $objectId int|null
	 * @param $request PKPRequest
	 */
	function auditSettingsSave($sourceType, $oldObject, $params, $newDataObject, $contextId, $contextPath, $objectId, $request) {
		if (!$this->_tableReady()) return;

		$fields = [];
		if (is_array($params)) {
			foreach ($params as $field => $value) {
				if (!is_string($field) || $field === '') continue;
				foreach ($this->_stringifyValue($value) as $localeKey => $stringValue) {
					if ($this->_hasAnchor($stringValue)) {
						$fields[$field][$localeKey] = $stringValue;
					}
				}
			}
		} elseif ($newDataObject !== null && is_array($newDataObject->getAllData())) {
			foreach ($newDataObject->getAllData() as $field => $value) {
				foreach ($this->_stringifyValue($value) as $localeKey => $stringValue) {
					if ($this->_hasAnchor($stringValue)) {
						$fields[$field][$localeKey] = $stringValue;
					}
				}
			}
		}

		foreach ($fields as $field => $localeValues) {
			foreach ($localeValues as $localeKey => $newValue) {
				$oldValue = '';
				if ($oldObject !== null) {
					$rawOld = $oldObject->getData($field);
					if (is_array($rawOld)) {
						$oldValue = isset($rawOld[$localeKey]) ? (string) $rawOld[$localeKey] : '';
					} elseif (is_string($rawOld)) {
						// Only treat scalar settings with matching shape
						$oldValue = $rawOld;
					}
				}

				$newLinks = $this->extractLinks($newValue, $request);
				$oldLinks = $this->extractLinks($oldValue, $request);

				$newHrefs = $this->_hrefSet($newLinks);
				$oldHrefs = $this->_hrefSet($oldLinks);
				$added = count(array_diff($newHrefs, $oldHrefs));
				$removed = count(array_diff($oldHrefs, $newHrefs));

				if (empty($newLinks) && empty($oldLinks)) continue;
				if ($added === 0 && $removed === 0) continue; // unchanged

				$this->_log([
					'user' => $request->getUser(),
					'contextId' => $contextId,
					'contextPath' => $contextPath,
					'sourceType' => $sourceType,
					'sourceDesc' => $field . ($localeKey !== '' ? ' [' . $localeKey . ']' : ''),
					'objectId' => $objectId,
					'action' => ($oldObject === null) ? 'add' : 'edit',
					'links' => $newLinks,
					'addedCount' => $added,
					'removedCount' => $removed,
					'hashSeed' => $sourceType . '|' . $contextId . '|' . $objectId . '|' . $field . '|' . $localeKey . '|' . implode("\n", $newHrefs),
					'oldContent' => $oldValue,
					'newContent' => $newValue,
					'request' => $request,
				]);
			}
		}
	}

	/**
	 * Audit raw form input (broad net): scans POST data of page/component
	 * requests for anchors and logs attempts regardless of which handler runs.
	 *
	 * @param $request PKPRequest
	 */
	function auditInputAttempt($request) {
		if (!$this->_tableReady()) return;
		if (empty($_POST) || !is_array($_POST)) return;

		$user = $request->getUser();
		$context = $request->getContext();

		foreach ($_POST as $fieldName => $value) {
			if (!is_string($fieldName) || strlen($fieldName) > 100) continue;
			foreach ($this->_stringifyValue($value) as $localeKey => $stringValue) {
				if (!$this->_hasAnchor($stringValue)) continue;
				$links = $this->extractLinks($stringValue, $request);
				if (empty($links)) continue;

				$suffix = $localeKey !== '' ? '[' . $localeKey . ']' : '';
				$this->_log([
					'user' => $user,
					'contextId' => $context ? $context->getId() : null,
					'contextPath' => $context ? $context->getPath() : null,
					'sourceType' => 'input',
					'sourceDesc' => 'POST:' . $fieldName . $suffix,
					'objectId' => null,
					'action' => 'attempt',
					'links' => $links,
					'addedCount' => count($links),
					'removedCount' => 0,
					'hashSeed' => 'input|' . ($user ? $user->getId() : 0) . '|' . $fieldName . $suffix . '|' . implode("\n", $this->_hrefSet($links)),
					'oldContent' => '',
					'newContent' => $stringValue,
					'request' => $request,
				]);
			}
		}
	}

	/**
	 * Scan existing database content for anchors and log findings
	 * attributed to "existing data" (no user).
	 *
	 * @return array Summary counts per table.
	 */
	function scanExisting($request) {
		$summary = [];

		// Journal settings (pageFooter etc.)
		$summary['journal_settings'] = $this->_scanTable(
			$request,
			'SELECT context_id, setting_name, setting_value FROM journal_settings WHERE setting_value LIKE ? LIMIT 500',
			['%<a %'],
			'journal_settings',
			function ($row, $logger, $request) {
				return [$row['context_id'], $row['setting_name'], null];
			}
		);

		// Site settings
		$summary['site_settings'] = $this->_scanTable(
			$request,
			'SELECT setting_name, setting_value FROM site_settings WHERE setting_value LIKE ? LIMIT 500',
			['%<a %'],
			'site_settings',
			function ($row, $logger, $request) {
				return [null, $row['setting_name'], null];
			},
			true // site-level
		);

		// Plugin settings (custom blocks, static pages content, theme options...)
		$summary['plugin_settings'] = $this->_scanTable(
			$request,
			'SELECT context_id, plugin_name, setting_name, setting_value FROM plugin_settings WHERE setting_value LIKE ? LIMIT 500',
			['%<a %'],
			'plugin_settings',
			function ($row, $logger, $request) {
				return [$row['context_id'], $row['plugin_name'] . '.' . $row['setting_name'], null];
			}
		);

		// User profile text (biography)
		$summary['user_settings'] = $this->_scanTable(
			$request,
			'SELECT user_id, locale, setting_name, setting_value FROM user_settings WHERE setting_value LIKE ? AND setting_name IN (?, ?) LIMIT 500',
			['%<a %', 'biography', 'interests'],
			'user_settings',
			function ($row, $logger, $request) {
				return [null, 'user.' . $row['setting_name'] . ' #' . $row['user_id'] . ' [' . $row['locale'] . ']', null];
			}
		);

		// Publication metadata (abstracts)
		$summary['publication_settings'] = $this->_scanTable(
			$request,
			'SELECT ps.publication_id, ps.setting_name, ps.setting_value, s.context_id AS ctx FROM publication_settings ps INNER JOIN publications p ON p.publication_id = ps.publication_id INNER JOIN submissions s ON s.submission_id = p.submission_id WHERE ps.setting_value LIKE ? LIMIT 500',
			['%<a %'],
			'publication_settings',
			function ($row, $logger, $request) {
				return [(int) $row['ctx'], $row['setting_name'], (int) $row['publication_id']];
			}
		);

		return $summary;
	}

	//
	// Link extraction
	//

	/**
	 * Extract all anchors from an HTML fragment.
	 * @return array Each item: href, text, rel, target, is_external, suspicious
	 */
	function extractLinks($html, $request) {
		$links = [];
		if (!is_string($html) || strpos($html, '<') === false) return $links;

		if (class_exists('DOMDocument')) {
			try {
				libxml_use_internal_errors(true);
				$doc = new DOMDocument();
				$parsed = $doc->loadHTML('<?xml encoding="utf-8"?><div>' . $html . '</div>', LIBXML_NOWARNING | LIBXML_NOERROR);
				libxml_clear_errors();
				if ($parsed !== false) {
					foreach ($doc->getElementsByTagName('a') as $node) {
						$href = trim((string) $node->getAttribute('href'));
						if ($href === '') continue;
						$links[] = [
							'href' => $href,
							'text' => trim(preg_replace('/\s+/u', ' ', (string) $node->textContent)),
							'rel' => strtolower(trim((string) $node->getAttribute('rel'))),
							'target' => strtolower(trim((string) $node->getAttribute('target'))),
							'is_external' => $this->_isExternal($href, $request),
							'suspicious' => $this->_isSuspiciousScheme($href),
						];
					}
				}
			} catch (\Exception $e) {
				$links = [];
			}
		}

		if (empty($links)) {
			// Regex fallback (or supplement if DOM found nothing but anchors exist)
			preg_match_all('#<a\b[^>]*\bhref\s*=\s*(["\'])(.*?)\1[^>]*>#is', $html, $matches, PREG_SET_ORDER);
			foreach ($matches as $m) {
				$href = html_entity_decode(trim($m[2]), ENT_QUOTES, 'UTF-8');
				if ($href === '') continue;
				$dup = false;
				foreach ($links as $l) {
					if (strcasecmp($l['href'], $href) === 0) { $dup = true; break; }
				}
				if ($dup) continue;
				$text = trim(preg_replace('/\s+/u', ' ', strip_tags($m[0])));
				$rel = '';
				if (preg_match('/\brel\s*=\s*(["\'])(.*?)\1/is', $m[0], $rm)) $rel = strtolower(trim($rm[2]));
				$target = '';
				if (preg_match('/\btarget\s*=\s*(["\'])(.*?)\1/is', $m[0], $tm)) $target = strtolower(trim($tm[2]));
				$links[] = [
					'href' => $href,
					'text' => $text,
					'rel' => $rel,
					'target' => $target,
					'is_external' => $this->_isExternal($href, $request),
					'suspicious' => $this->_isSuspiciousScheme($href),
				];
			}
		}

		return $links;
	}

	//
	// Internals
	//

	/**
	 * Flatten a value into strings keyed by '' or locale code.
	 */
	function _stringifyValue($value) {
		$out = [];
		if (is_string($value)) {
			$out[''] = $value;
		} elseif (is_array($value)) {
			foreach ($value as $k => $v) {
				if (is_string($v)) $out[(string) $k] = $v;
				elseif (is_array($v)) {
					foreach ($this->_stringifyValue($v) as $k2 => $v2) {
						$out[$k . '.' . $k2] = $v2;
					}
				}
			}
		}
		return $out;
	}

	function _hasAnchor($string) {
		return is_string($string) && stripos($string, '<a') !== false;
	}

	function _hrefSet($links) {
		$set = [];
		foreach ($links as $l) $set[] = strtolower($l['href']);
		return array_unique($set);
	}

	function _isExternal($href, $request) {
		$host = parse_url($href, PHP_URL_HOST);
		if ($host === null && strpos(ltrim($href), '//') === 0) {
			// scheme-relative URL; parse_url needs a scheme to see host
			$parts = parse_url('http:' . $href);
			$host = isset($parts['host']) ? $parts['host'] : null;
		}
		if ($host === null || $host === false || $host === '') return false;
		foreach ($this->_getAllowedHosts($request) as $allowed) {
			if (strcasecmp($host, $allowed) === 0) return false;
		}
		return true;
	}

	function _isSuspiciousScheme($href) {
		$scheme = strtolower(parse_url($href, PHP_URL_SCHEME) ?: '');
		return in_array($scheme, ['javascript', 'vbscript', 'data']);
	}

	function _getAllowedHosts($request) {
		if ($this->_allowedHosts !== null) return $this->_allowedHosts;
		$hosts = [];
		if ($request) {
			$hosts[] = $request->getServerHost(false);
			$baseUrl = $request->getBaseUrl();
			$bHost = parse_url($baseUrl, PHP_URL_HOST);
			if ($bHost) $hosts[] = $bHost;
		}
		$this->_allowedHosts = $hosts;
		return $hosts;
	}

	function _tableReady() {
		static $ready = null;
		if ($ready !== null) return $ready;
		try {
			$result = $this->_dao->retrieve('SHOW TABLES LIKE ?', ['backlink_audit_log']);
			$row = $result->current();
			$ready = (bool) $row;
		} catch (\Exception $e) {
			$ready = false;
		}
		return $ready;
	}

	function _log($args) {
		$user = $args['user'];
		$request = $args['request'];
		$hash = sha1($args['hashSeed']);

		if ($this->_dao->hasRecentDuplicate($hash, $user ? $user->getId() : 0, 6)) return;

		$this->_dao->insertEntry([
			'created_at' => date('Y-m-d H:i:s'),
			'user_id' => $user ? $user->getId() : null,
			'username' => $user ? $user->getUsername() : null,
			'user_email' => $user ? $user->getEmail() : null,
			'context_id' => $args['contextId'],
			'context_path' => $args['contextPath'],
			'source_type' => $args['sourceType'],
			'source_desc' => $args['sourceDesc'],
			'object_id' => $args['objectId'],
			'action' => $args['action'],
			'links' => $args['links'],
			'added_count' => $args['addedCount'],
			'removed_count' => $args['removedCount'],
			'content_hash' => $hash,
			'old_content' => $args['oldContent'],
			'new_content' => $args['newContent'],
			'ip' => $request ? $request->getRemoteAddr() : '',
			'user_agent' => isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '',
		]);
	}

	/**
	 * Run a scan query and log each hit.
	 * @param $idCallback callable returns [contextId, sourceDescSuffix, objectId]
	 */
	function _scanTable($request, $sql, $params, $label, $idCallback, $isSiteLevel = false) {
		$count = 0;
		try {
			$result = $this->_dao->retrieve($sql, $params);
			foreach ($result as $row) {
				$row = (array) $row;
				$value = isset($row['setting_value']) ? $row['setting_value'] : '';
				if (!is_string($value)) {
					$unserialized = @unserialize($value);
					if (is_array($unserialized)) {
						$value = implode("\n", $this->_flattenStrings($unserialized));
					} else {
						$value = (string) $value;
					}
				}
				if (!$this->_hasAnchor($value)) continue;
				$links = $this->extractLinks($value, $request);
				if (empty($links)) continue;

				list($contextId, $sourceDesc, $objectId) = $idCallback($row, $this, $request);
				if ($isSiteLevel) {
					$contextId = null;
					$sourceDesc = $sourceDesc;
				}

				$contextPath = '(site)';
				if ($contextId) {
					$contextDao = Application::getContextDAO();
					$context = $contextDao->getById((int) $contextId);
					$contextPath = $context ? $context->getPath() : ('#' . $contextId);
				}

				$ok = $this->_dao->insertEntry([
					'created_at' => date('Y-m-d H:i:s'),
					'user_id' => null,
					'username' => '(data lama / tidak tercatat)',
					'user_email' => null,
					'context_id' => $contextId,
					'context_path' => $contextPath,
					'source_type' => 'scan',
					'source_desc' => $label . ':' . $sourceDesc,
					'object_id' => $objectId,
					'action' => 'scan',
					'links' => $links,
					'added_count' => count($links),
					'removed_count' => 0,
					'content_hash' => sha1('scan|' . $label . '|' . $sourceDesc . '|' . implode("\n", $this->_hrefSet($links))),
					'old_content' => '',
					'new_content' => $value,
					'ip' => '',
					'user_agent' => '',
				]);
				if ($ok) $count++;
			}
		} catch (\Exception $e) {
			error_log('BacklinkAuditLogger::scanExisting(' . $label . ') failed: ' . $e->getMessage());
		}
		return $count;
	}

	function _flattenStrings($array) {
		$out = [];
		array_walk_recursive($array, function ($v) use (&$out) {
			if (is_string($v)) $out[] = $v;
		});
		return $out;
	}
}
