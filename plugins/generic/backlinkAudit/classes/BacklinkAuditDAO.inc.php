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
			$result = $this->retrieve('SHOW TABLES LIKE ?', ['backlink_audit_log']);
			$row = $result->current();
			if (!$row) {
				error_log('BacklinkAuditDAO: backlink_audit_log table missing; re-enable the Backlink Audit plugin to create it.');
			}
		} catch (\Exception $e) {
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
		} catch (\Exception $e) {
			return false;
		}
	}

	/**
	 * Get a paginated list of entries.
	 * @param $contextId int|null null = all contexts (site admin)
	 * @param $rangeInfo RangeInfo
	 * @return DAOResultFactory
	 */
	function getEntries($contextId, $rangeInfo = null) {
		$params = [];
		$sql = 'SELECT * FROM backlink_audit_log';
		if ($contextId !== null) {
			$sql .= ' WHERE context_id = ?';
			$params[] = (int) $contextId;
		}
		$sql .= ' ORDER BY audit_id DESC';
		$countSql = $contextId !== null
			? 'SELECT audit_id FROM backlink_audit_log WHERE context_id = ?'
			: 'SELECT audit_id FROM backlink_audit_log';
		$result = $this->retrieveRange($sql, $params, $rangeInfo);
		return new DAOResultFactory($result, $this, '_fromRow', [], $countSql, $params, $rangeInfo);
	}

	/**
	 * Convert a row to an associative array with decoded links.
	 */
	function _fromRow($row) {
		$row = (array) $row;
		$row['links'] = json_decode($row['links_json'], true);
		if (!is_array($row['links'])) $row['links'] = [];
		return (object) $row;
	}
}
