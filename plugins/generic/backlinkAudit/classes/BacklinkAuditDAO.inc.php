<?php

/**
 * @file plugins/generic/backlinkAudit/classes/BacklinkAuditDAO.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditDAO
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Operations for retrieving and adding backlink audit log entries.
 */

import('lib.pkp.classes.db.DAO');

use Illuminate\Database\Capsule\Manager as Capsule;

class BacklinkAuditDAO extends DAO {

	/** @var bool */
	var $_tableChecked = false;

	/**
	 * Ensure the audit table exists (migration runs at plugin registration;
	 * this is only a cheap guard).
	 */
	function _ensureTable() {
		if ($this->_tableChecked) return;
		$this->_tableChecked = true;
		try {
			// Not "SHOW TABLES LIKE ?": DAO::retrieve() prepares through PDO
			// and MariaDB rejects a placeholder inside SHOW TABLES.
			if (!Capsule::schema()->hasTable('backlink_audit_log')) {
				error_log('BacklinkAuditDAO: backlink_audit_log table missing; re-enable the Backlink Audit plugin to create it.');
			}
		} catch (\Throwable $e) {
			error_log('BacklinkAuditDAO::_ensureTable failed: ' . $e->getMessage());
		}
	}

	/**
	 * Insert one audit entry.
	 * @param $entry array Associative row.
	 * @return int|false New audit_id or false on failure.
	 */
	function insertEntry($entry) {
		$this->_ensureTable();
		try {
			$this->update(
				'INSERT INTO backlink_audit_log
					(created_at, user_id, username, user_email, context_id, context_path,
					source_type, source_desc, object_id, action, links_json,
					link_count, added_count, removed_count, content_hash,
					old_content, new_content, ip, user_agent)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
				[
					$entry['created_at'],
					(int) $entry['user_id'] ?: null,
					strlen((string) $entry['username']) > 255 ? substr((string) $entry['username'], 0, 255) : $entry['username'],
					$entry['user_email'],
					(int) $entry['context_id'] ?: null,
					$entry['context_path'],
					$entry['source_type'],
					mb_substr((string) $entry['source_desc'], 0, 190),
					(int) $entry['object_id'] ?: null,
					$entry['action'],
					json_encode($entry['links']),
					count($entry['links']),
					(int) $entry['added_count'],
					(int) $entry['removed_count'],
					$entry['content_hash'],
					strlen((string) $entry['old_content']) > 20000 ? substr((string) $entry['old_content'], 0, 20000) : $entry['old_content'],
					strlen((string) $entry['new_content']) > 20000 ? substr((string) $entry['new_content'], 0, 20000) : $entry['new_content'],
					substr((string) $entry['ip'], 0, 64),
					substr((string) $entry['user_agent'], 0, 255),
				]
			);
			return $this->_getInsertId();
		} catch (\Exception $e) {
			error_log('BacklinkAuditDAO::insertEntry failed: ' . $e->getMessage());
			return false;
		}
	}

	/**
	 * Check whether an identical entry was logged recently (dedupe).
	 * @param $hash string
	 * @param $userId int|null
	 * @param $hours int
	 */
	function hasRecentDuplicate($hash, $userId, $hours = 6) {
		try {
			$cutoff = date('Y-m-d H:i:s', time() - ($hours * 3600));
			$result = $this->retrieve(
				'SELECT audit_id FROM backlink_audit_log WHERE content_hash = ? AND created_at > ? AND (user_id IS NULL OR user_id = ?) LIMIT 1',
				[$hash, $cutoff, (int) $userId]
			);
			$row = $result->current();
			return (bool) $row;
		} catch (\Throwable $e) {
			return false;
		}
	}

	/**
	 * Shared WHERE clause for the report list, its count query and the CSV
	 * export, so all three always agree on which rows are in scope.
	 * @param $contextId int|null null = all contexts (site admin)
	 * @param $filters array q / action / from / to, all optional strings
	 * @return array [string suffix ("" or " WHERE ..."), array bind params]
	 */
	function filterSql($contextId, $filters = []) {
		$where = [];
		$params = [];

		if ($contextId !== null) {
			$where[] = 'context_id = ?';
			$params[] = (int) $contextId;
		}

		$action = isset($filters['action']) ? trim($filters['action']) : '';
		if ($action !== '') {
			$where[] = 'action = ?';
			$params[] = $action;
		}

		$q = isset($filters['q']) ? trim($filters['q']) : '';
		if ($q !== '') {
			$like = '%' . str_replace(['\\', '%', '_'], ['\\\\', '\%', '\_'], $q) . '%';
			$where[] = '(username LIKE ? OR user_email LIKE ? OR source_desc LIKE ? OR context_path LIKE ? OR ip LIKE ?)';
			for ($i = 0; $i < 5; $i++) $params[] = $like;
		}

		$from = isset($filters['from']) ? trim($filters['from']) : '';
		if ($from !== '') {
			$where[] = 'created_at >= ?';
			$params[] = $from . ' 00:00:00';
		}
		$to = isset($filters['to']) ? trim($filters['to']) : '';
		if ($to !== '') {
			$where[] = 'created_at <= ?';
			$params[] = $to . ' 23:59:59';
		}

		return [$where ? ' WHERE ' . implode(' AND ', $where) : '', $params];
	}

	/**
	 * Get a paginated list of entries.
	 * @param $contextId int|null null = all contexts (site admin)
	 * @param $rangeInfo RangeInfo
	 * @param $filters array q / action / from / to
	 * @return DAOResultFactory
	 */
	function getEntries($contextId, $rangeInfo = null, $filters = []) {
		list($where, $params) = $this->filterSql($contextId, $filters);
		// old_content / new_content are LONGTEXT capped at 20 KB each, and the
		// report only renders them for role and account changes, where they are
		// a few hundred bytes of labels at most. Pulling them for every
		// link-save row meant up to a megabyte of HTML per page that was never
		// displayed. The CASE keeps them for exactly the two actions that use
		// them and yields NULL for the rest, so MySQL never reads those columns
		// for a row it is not going to return them for.
		$sql = 'SELECT audit_id, created_at, user_id, username, user_email, context_id, context_path,
				source_type, source_desc, object_id, action, links_json, link_count,
				added_count, removed_count, content_hash, ip, user_agent,
				CASE WHEN action IN (\'role_change\', \'user_change\') THEN old_content END AS old_content,
				CASE WHEN action IN (\'role_change\', \'user_change\') THEN new_content END AS new_content
			FROM backlink_audit_log' . $where . ' ORDER BY audit_id DESC';
		$countSql = 'SELECT audit_id FROM backlink_audit_log' . $where;
		$result = $this->retrieveRange($sql, $params, $rangeInfo);
		return new DAOResultFactory($result, $this, '_fromRow', [], $countSql, $params, $rangeInfo);
	}

	/**
	 * Convert a row to an associative array with decoded links.
	 */
	function _fromRow($row) {
		$row = (array) $row;
		$row['source_desc'] = self::fixMissingLocale($row['source_desc']);
		$row['links'] = json_decode($row['links_json'], true);
		if (!is_array($row['links'])) $row['links'] = [];
		foreach ($row['links'] as $k => $link) {
			if (isset($link['text'])) $row['links'][$k]['text'] = self::fixMissingLocale($link['text']);
		}
		return (object) $row;
	}

	/**
	 * Rows written while the plugin's locale file was not readable were
	 * stored with the marker OJS leaves behind for an unknown key (##key##),
	 * and source_desc is a frozen copy of a translated string. Look the key
	 * up again at render time so those rows show text instead of the marker.
	 * @param $text string
	 * @return string
	 */
	static function fixMissingLocale($text) {
		if (!is_string($text) || strpos($text, '##') === false) return $text;
		return preg_replace_callback('/##([A-Za-z0-9_.]+)##/', function ($matches) {
			$translated = __($matches[1]);
			return $translated === '##' . $matches[1] . '##' ? $matches[0] : $translated;
		}, $text);
	}
}
