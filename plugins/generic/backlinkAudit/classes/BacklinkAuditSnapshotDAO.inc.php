<?php

/**
 * @file plugins/generic/backlinkAudit/classes/BacklinkAuditSnapshotDAO.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditSnapshotDAO
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Stores the last observed user-group membership and account state so
 * privilege changes can be detected by comparison.
 *
 * OJS 3.3 fires no hook when a user is assigned to a user group
 * (UserGroupDAO::assignUserToGroup / UserGroupAssignmentDAO::insertObject
 * call HookRegistry nowhere) and user_user_groups has no timestamp column.
 * Comparing end state is therefore the only way to notice a role change, and
 * it has the side benefit of catching changes made outside the UI entirely.
 */

import('lib.pkp.classes.db.DAO');

use Illuminate\Database\Capsule\Manager as Capsule;

class BacklinkAuditSnapshotDAO extends DAO {

	/** @var bool */
	var $_tablesChecked = false;

	/**
	 * @var bool|null Memoised tablesExist() result. Tables cannot appear or
	 * disappear mid-request, and this used to run six information_schema
	 * queries on every single page view (once here, once in the plugin's
	 * _ensureSchema()), so the answer is kept for the whole request.
	 */
	static $_tablesExistMemo = null;

	/** @var string Advisory lock name used to serialise concurrent diffs */
	var $_lockName = 'backlink_audit_snapshot_diff';

	/**
	 * Cheap guard; the migration runs at plugin registration.
	 */
	function _ensureTables() {
		if ($this->_tablesChecked) return;
		$this->_tablesChecked = true;
		try {
			$schema = Capsule::schema();
			foreach (['backlink_audit_role_snapshot', 'backlink_audit_user_snapshot'] as $table) {
				if (!$schema->hasTable($table)) {
					error_log('BacklinkAuditSnapshotDAO: ' . $table . ' missing; re-enable the Backlink Audit plugin to create it.');
				}
			}
		} catch (\Throwable $e) {
			error_log('BacklinkAuditSnapshotDAO::_ensureTables failed: ' . $e->getMessage());
		}
	}

	/**
	 * Whether the log table and both snapshots exist, used to skip the
	 * watcher entirely before the migration has run.
	 *
	 * This must not be expressed as "SHOW TABLES LIKE ?": DAO::retrieve()
	 * hands the statement to PDO (Capsule::cursor(Capsule::raw($sql), ...)),
	 * and MariaDB refuses to prepare a placeholder inside SHOW TABLES
	 * (SQLSTATE 42000, "syntax error ... near '?'"), which made this check
	 * throw and silently disable the whole detector.
	 *
	 * @return bool
	 */
	function tablesExist() {
		if (self::$_tablesExistMemo !== null) return self::$_tablesExistMemo;
		try {
			$schema = Capsule::schema();
			self::$_tablesExistMemo = $schema->hasTable('backlink_audit_log')
				&& $schema->hasTable('backlink_audit_role_snapshot')
				&& $schema->hasTable('backlink_audit_user_snapshot');
		} catch (\Throwable $e) {
			self::$_tablesExistMemo = false;
		}
		return self::$_tablesExistMemo;
	}

	/**
	 * Serialise concurrent diffs. Two managers browsing at the same time would
	 * otherwise each read the same "before" snapshot, and whichever wrote last
	 * would clobber the other's view — producing duplicate alerts (never a
	 * missed change, since a regressed snapshot simply re-detects). Returns
	 * false when another process already holds the lock, in which case the
	 * caller should skip this run rather than queue up.
	 *
	 * @return bool
	 */
	function acquireLock($timeoutSeconds = 3) {
		try {
			$result = $this->retrieve('SELECT GET_LOCK(?, ?) AS got', [$this->_lockName, (int) $timeoutSeconds]);
			// DAO::retrieve() yields PDO::FETCH_OBJ rows (Illuminate's default
			// fetch mode), so cast before using array syntax.
			$row = $result->current();
			$row = $row ? (array) $row : null;
			return $row && (int) $row['got'] === 1;
		} catch (\Throwable $e) {
			// Locking is an optimisation, not a correctness requirement.
			return true;
		}
	}

	function releaseLock() {
		try {
			$this->retrieve('SELECT RELEASE_LOCK(?) AS released', [$this->_lockName]);
		} catch (\Exception $e) {
			// Released automatically when the connection closes.
		}
	}

	//
	// Role membership snapshot
	//

	/**
	 * Current membership as a set of "userId:groupId" keys.
	 * @return array Keys are "userId:groupId", values are true.
	 */
	function getLiveRoleMembership() {
		$set = [];
		$result = $this->retrieve('SELECT user_id, user_group_id FROM user_user_groups');
		foreach ($result as $row) {
			$row = (array) $row;
			$set[((int) $row['user_id']) . ':' . ((int) $row['user_group_id'])] = true;
		}
		return $set;
	}

	/**
	 * Last observed membership, same key format.
	 * @return array
	 */
	function getSnapshotRoleMembership() {
		$this->_ensureTables();
		$set = [];
		try {
			$result = $this->retrieve('SELECT user_id, user_group_id FROM backlink_audit_role_snapshot');
			foreach ($result as $row) {
				$row = (array) $row;
				$set[((int) $row['user_id']) . ':' . ((int) $row['user_group_id'])] = true;
			}
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::getSnapshotRoleMembership failed: ' . $e->getMessage());
		}
		return $set;
	}

	/**
	 * Replace the stored membership with the given set.
	 * @param $set array Keys "userId:groupId"
	 * @return bool
	 */
	function replaceRoleMembership($set) {
		$this->_ensureTables();
		try {
			$this->update('DELETE FROM backlink_audit_role_snapshot');
			$rows = [];
			foreach (array_keys($set) as $key) {
				list($userId, $groupId) = explode(':', $key, 2);
				$rows[] = [(int) $userId, (int) $groupId];
			}
			foreach (array_chunk($rows, 500) as $chunk) {
				$placeholders = implode(',', array_fill(0, count($chunk), '(?, ?)'));
				$params = [];
				foreach ($chunk as $pair) {
					$params[] = $pair[0];
					$params[] = $pair[1];
				}
				$this->update('INSERT INTO backlink_audit_role_snapshot (user_id, user_group_id) VALUES ' . $placeholders, $params);
			}
			return true;
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::replaceRoleMembership failed: ' . $e->getMessage());
			return false;
		}
	}

	function isRoleSnapshotEmpty() {
		return !$this->getSnapshotRoleMembership();
	}

	//
	// Account state snapshot
	//

	/**
	 * Current account state, keyed by user id.
	 * @return array userId => ['username' =>, 'email' =>, 'disabled' =>, 'password_fp' =>]
	 */
	function getLiveUserState() {
		$state = [];
		$result = $this->retrieve('SELECT user_id, username, email, disabled, password FROM users');
		foreach ($result as $row) {
			$row = (array) $row;
			$state[(int) $row['user_id']] = [
				'username' => (string) $row['username'],
				'email' => (string) $row['email'],
				'disabled' => (int) $row['disabled'],
				// Hash of the stored hash: detects a reset without keeping
				// anything that could be used to authenticate.
				'password_fp' => sha1((string) $row['password']),
			];
		}
		return $state;
	}

	/**
	 * @return array userId => same shape as getLiveUserState()
	 */
	function getSnapshotUserState() {
		$this->_ensureTables();
		$state = [];
		try {
			$result = $this->retrieve('SELECT user_id, username, email, disabled, password_fp FROM backlink_audit_user_snapshot');
			foreach ($result as $row) {
				$row = (array) $row;
				$state[(int) $row['user_id']] = [
					'username' => (string) $row['username'],
					'email' => (string) $row['email'],
					'disabled' => (int) $row['disabled'],
					'password_fp' => (string) $row['password_fp'],
				];
			}
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::getSnapshotUserState failed: ' . $e->getMessage());
		}
		return $state;
	}

	/**
	 * @param $state array userId => state row
	 * @return bool
	 */
	function replaceUserState($state) {
		$this->_ensureTables();
		try {
			$this->update('DELETE FROM backlink_audit_user_snapshot');
			$rows = [];
			foreach ($state as $userId => $row) {
				$rows[] = [
					(int) $userId,
					substr((string) $row['username'], 0, 255),
					substr((string) $row['email'], 0, 255),
					(int) $row['disabled'],
					(string) $row['password_fp'],
				];
			}
			foreach (array_chunk($rows, 500) as $chunk) {
				$placeholders = implode(',', array_fill(0, count($chunk), '(?, ?, ?, ?, ?)'));
				$params = [];
				foreach ($chunk as $r) {
					foreach ($r as $v) $params[] = $v;
				}
				$this->update(
					'INSERT INTO backlink_audit_user_snapshot (user_id, username, email, disabled, password_fp) VALUES ' . $placeholders,
					$params
				);
			}
			return true;
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::replaceUserState failed: ' . $e->getMessage());
			return false;
		}
	}

	function isUserSnapshotEmpty() {
		return !$this->getSnapshotUserState();
	}

	//
	// Lookups used to describe a change
	//

	/**
	 * Group metadata keyed by group id, for building readable descriptions.
	 * @return array groupId => ['context_id' =>, 'role_id' =>, 'name' =>]
	 */
	function getGroupInfo() {
		$info = [];
		try {
			$result = $this->retrieve(
				'SELECT ug.user_group_id, ug.context_id, ug.role_id,
						MAX(CASE WHEN ugs.setting_name = ? AND ugs.locale = ? THEN ugs.setting_value END) AS name_en,
						MAX(CASE WHEN ugs.setting_name = ? THEN ugs.setting_value END) AS name_any
				 FROM user_groups ug
				 LEFT JOIN user_group_settings ugs ON ugs.user_group_id = ug.user_group_id
				 GROUP BY ug.user_group_id, ug.context_id, ug.role_id',
				['name', 'en_US', 'name']
			);
			foreach ($result as $row) {
				$row = (array) $row;
				$name = $row['name_en'] ?: $row['name_any'];
				$info[(int) $row['user_group_id']] = [
					'context_id' => (int) $row['context_id'],
					'role_id' => (int) $row['role_id'],
					'name' => $name ?: ('#' . (int) $row['user_group_id']),
				];
			}
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::getGroupInfo failed: ' . $e->getMessage());
		}
		return $info;
	}

	/**
	 * Whether the user holds a manager-level group in any journal, or is a
	 * site admin. Read straight from the database rather than the session,
	 * because the privilege check runs at shutdown when the session has
	 * already been closed.
	 *
	 * Note the role ids, not the group names: in OJS 3.3 the "Journal editor"
	 * and "Production editor" groups share role_id 16 with "Journal manager"
	 * (registry/userGroups.xml), so all three are privileged.
	 *
	 * @param $userId int
	 * @return bool
	 */
	function isPrivilegedUser($userId) {
		if (!$userId) return false;
		try {
			$result = $this->retrieve(
				'SELECT 1 FROM user_user_groups uug
				 JOIN user_groups ug ON ug.user_group_id = uug.user_group_id
				 WHERE uug.user_id = ? AND ug.role_id IN (?, ?) LIMIT 1',
				[(int) $userId, ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN]
			);
			return (bool) $result->current();
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::isPrivilegedUser failed: ' . $e->getMessage());
			return false;
		}
	}

	/**
	 * Usernames keyed by user id, so a log line can name the affected account.
	 * @return array
	 */
	function getUsernames() {
		$names = [];
		try {
			$result = $this->retrieve('SELECT user_id, username FROM users');
			foreach ($result as $row) {
				$row = (array) $row;
				$names[(int) $row['user_id']] = (string) $row['username'];
			}
		} catch (\Exception $e) {
			error_log('BacklinkAuditSnapshotDAO::getUsernames failed: ' . $e->getMessage());
		}
		return $names;
	}
}
