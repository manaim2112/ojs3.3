<?php

/**
 * @file plugins/generic/backlinkAudit/pages/BacklinkAuditHandler.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditHandler
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Report page for backlink audit entries (manager / site admin only).
 */

import('classes.handler.Handler');

class BacklinkAuditHandler extends Handler {

	var $_isBackendPage = true;

	static $plugin;

	/** @var array Ops reachable on this handler */
	var $_allowedOps = ['index', 'scan', 'export'];

	static function setPlugin($plugin) {
		self::$plugin = $plugin;
	}

	/**
	 * @copydoc PKPHandler::authorize()
	 *
	 * Requires a signed-in user and restricts the callable ops. Role
	 * scoping (manager vs site admin, per-journal visibility) is enforced
	 * per-op in _authorizeUser().
	 */
	function authorize($request, &$args, $roleAssignments) {
		import('lib.pkp.classes.security.authorization.UserRequiredPolicy');
		$this->addPolicy(new UserRequiredPolicy($request));

		$op = $request->getRequestedOp();
		if (!in_array($op, $this->_allowedOps, true)) {
			return false;
		}

		return parent::authorize($request, $args, $roleAssignments);
	}

	/**
	 * Authorize: journal managers see their own journal; site admins see all.
	 */
	function _authorizeUser($request) {
		$user = $request->getUser();
		if (!$user) return [false, null];
		$context = $request->getContext();
		$isSiteAdmin = $user->hasRole([ROLE_ID_SITE_ADMIN], CONTEXT_SITE);
		if ($isSiteAdmin) return [true, null]; // null context filter = everything
		if ($context && $user->hasRole([ROLE_ID_MANAGER], $context->getId())) {
			return [true, $context->getId()];
		}
		return [false, null];
	}

	function index($args, $request) {
		list($authorized, $contextFilter) = $this->_authorizeUser($request);
		if (!$authorized) {
			$request->redirect(null, 'index');
		}

		$this->setupTemplate($request);
		$templateMgr = TemplateManager::getManager($request);

		$dao = DAORegistry::getDAO('BacklinkAuditDAO');
		$rangeInfo = $this->getRangeInfo($request, 'backlinkAudit');
		$filters = $this->_readFilters($request);
		$entries = $dao->getEntries($contextFilter, $rangeInfo, $filters);

		$scanned = (int) $request->getUserVar('scanned');

		$currentUser = $request->getUser();

		$templateMgr->assign([
			'pageTitle' => __('plugins.generic.backlinkAudit.report.title'),
			'entries' => $entries,
			'isSiteAdmin' => $contextFilter === null,
			'scannedCount' => $scanned,
			'csrfToken' => $request->getSession()->getCsrfToken(),
			// Filter state, echoed back into the search form and into
			// page_links so the next page keeps the same selection.
			'q' => $filters['q'],
			'actionFilter' => $filters['action'],
			'dateFrom' => $filters['from'],
			'dateTo' => $filters['to'],
			'actionOptions' => self::$_actionOptions,
			'currentUserId' => $currentUser ? (int) $currentUser->getId() : 0,
			'scanUrl' => $request->getDispatcher()->url(
				$request, ROUTE_PAGE, $request->getContext() ? $request->getContext()->getPath() : 'index',
				'securityaudit', 'scan'
			),
			'reportUrl' => $request->getDispatcher()->url(
				$request, ROUTE_PAGE, $request->getContext() ? $request->getContext()->getPath() : 'index',
				'securityaudit', 'index'
			),
			'exportUrl' => $request->getDispatcher()->url(
				$request, ROUTE_PAGE, $request->getContext() ? $request->getContext()->getPath() : 'index',
				'securityaudit', 'export', null,
				array_filter($filters, function ($value) { return $value !== ''; })
			),
		]);

		$templateMgr->display(self::$plugin->getTemplateResource('report.tpl'));
	}

	/** Actions the report filter offers; matches what the logger writes. */
	static $_actionOptions = ['add', 'edit', 'attempt', 'scan', 'bootstrap', 'tamper', 'role_change', 'user_change'];

	/**
	 * Read and validate the report filters from the query string.
	 * @return array q / action / from / to, all "" when absent or malformed
	 */
	function _readFilters($request) {
		// Only ever accept scalars: q[] / action[]= produce arrays, and
		// casting one to string would put "Array" into the SQL parameter.
		$scalar = function ($value, $maxLength) {
			if (!is_scalar($value)) return '';
			$value = trim((string) $value);
			return $maxLength ? mb_substr($value, 0, $maxLength) : $value;
		};

		$action = $scalar($request->getUserVar('action'), 32);
		if (!in_array($action, self::$_actionOptions, true)) $action = '';

		$date = function ($value) use ($scalar) {
			$value = $scalar($value, 10);
			return preg_match('/^\d{4}-\d{2}-\d{2}$/', $value) ? $value : '';
		};

		return [
			'q' => $scalar($request->getUserVar('q'), 200),
			'action' => $action,
			'from' => $date($request->getUserVar('from')),
			'to' => $date($request->getUserVar('to')),
		];
	}

	function scan($args, $request) {
		if (!$request->isPost() || !$request->checkCSRF()) {
			$request->redirect(null, 'securityaudit');
		}
		list($authorized, $contextFilter) = $this->_authorizeUser($request);
		if (!$authorized || $contextFilter !== null) {
			// Scanning touches all journals and site data: site admin only
			$request->redirect(null, 'index');
		}

		try {
			$logger = self::$plugin->_getLogger();
			$summary = $logger->scanExisting($request);
			$total = array_sum($summary);
		} catch (\Throwable $e) {
			error_log('BacklinkAudit scan failed: ' . $e->getMessage());
			$total = 0;
		}

		$path = $request->getContext() ? $request->getContext()->getPath() : null;
		$request->redirect($path, 'securityaudit', 'index', null, ['scanned' => $total]);
	}

	function export($args, $request) {
		list($authorized, $contextFilter) = $this->_authorizeUser($request);
		if (!$authorized) {
			$request->redirect(null, 'index');
		}

		$dao = DAORegistry::getDAO('BacklinkAuditDAO');
		// Not SELECT *: the CSV has no column for old_content / new_content /
		// content_hash, and those are LONGTEXT — 10000 rows of them is up to
		// 400 MB read out of the database to write 14 CSV columns.
		$select = 'created_at, action, source_type, source_desc, object_id,
			context_path, user_id, username, user_email, links_json,
			added_count, removed_count, ip, user_agent';
		list($where, $params) = $dao->filterSql($contextFilter, $this->_readFilters($request));
		$result = $dao->retrieve(
			'SELECT ' . $select . ' FROM backlink_audit_log' . $where . ' ORDER BY audit_id DESC LIMIT 10000',
			$params
		);

		header('Content-Type: text/csv; charset=utf-8');
		header('Content-Disposition: attachment; filename=backlink-audit-' . date('Ymd-His') . '.csv');

		$out = fopen('php://output', 'w');
		fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF));
		fputcsv($out, ['date', 'action', 'source_type', 'source', 'object_id', 'journal', 'user_id', 'username', 'email', 'links', 'added', 'removed', 'ip', 'user_agent']);

		// Link text and source_desc are attacker-controlled (a crafted anchor
		// text is exactly what this plugin exists to catch), so neutralise
		// spreadsheet formula injection before the CSV reaches Excel.
		$cell = function ($value) {
			$value = (string) $value;
			if ($value !== '' && strpos('=+-@' . "\t\r", $value[0]) !== false) return "'" . $value;
			return $value;
		};

		foreach ($result as $row) {
			$row = (array) $row;
			$links = json_decode($row['links_json'], true);
			$linkList = '';
			if (is_array($links)) {
				$parts = [];
				foreach ($links as $l) {
					$text = isset($l['text']) ? BacklinkAuditDAO::fixMissingLocale($l['text']) : '';
					$parts[] = $l['href'] . ($text !== '' ? ' (' . $text . ')' : '');
				}
				$linkList = implode('; ', $parts);
			}
			fputcsv($out, [
				$cell($row['created_at']), $cell($row['action']), $cell($row['source_type']),
				$cell(BacklinkAuditDAO::fixMissingLocale($row['source_desc'])),
				$cell($row['object_id']), $cell($row['context_path']), $cell($row['user_id']),
				$cell($row['username']), $cell($row['user_email']), $cell($linkList),
				$cell($row['added_count']), $cell($row['removed_count']),
				$cell($row['ip']), $cell($row['user_agent']),
			]);
		}
		fclose($out);
		exit;
	}
}
