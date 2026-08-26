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
		$entries = $dao->getEntries($contextFilter, $rangeInfo);

		$scanned = (int) $request->getUserVar('scanned');

		$templateMgr->assign([
			'pageTitle' => __('plugins.generic.backlinkAudit.report.title'),
			'entries' => $entries,
			'isSiteAdmin' => $contextFilter === null,
			'scannedCount' => $scanned,
			'csrfToken' => $request->getSession()->getCsrfToken(),
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
				'securityaudit', 'export'
			),
		]);

		$templateMgr->display(self::$plugin->getTemplateResource('report.tpl'));
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
		$result = $contextFilter === null
			? $dao->retrieve('SELECT * FROM backlink_audit_log ORDER BY audit_id DESC LIMIT 10000')
			: $dao->retrieve('SELECT * FROM backlink_audit_log WHERE context_id = ? ORDER BY audit_id DESC LIMIT 10000', [(int) $contextFilter]);

		header('Content-Type: text/csv; charset=utf-8');
		header('Content-Disposition: attachment; filename=backlink-audit-' . date('Ymd-His') . '.csv');

		$out = fopen('php://output', 'w');
		fprintf($out, chr(0xEF) . chr(0xBB) . chr(0xBF));
		fputcsv($out, ['date', 'action', 'source_type', 'source', 'object_id', 'journal', 'user_id', 'username', 'email', 'links', 'added', 'removed', 'ip', 'user_agent']);

		foreach ($result as $row) {
			$row = (array) $row;
			$links = json_decode($row['links_json'], true);
			$linkList = '';
			if (is_array($links)) {
				$parts = [];
				foreach ($links as $l) {
					$parts[] = $l['href'] . (isset($l['text']) && $l['text'] !== '' ? ' (' . $l['text'] . ')' : '');
				}
				$linkList = implode('; ', $parts);
			}
			fputcsv($out, [
				$row['created_at'], $row['action'], $row['source_type'], $row['source_desc'],
				$row['object_id'], $row['context_path'], $row['user_id'], $row['username'],
				$row['user_email'], $linkList, $row['added_count'], $row['removed_count'],
				$row['ip'], $row['user_agent'],
			]);
		}
		fclose($out);
		exit;
	}
}
