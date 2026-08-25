<?php

/**
 * @file plugins/generic/backlinkAudit/BacklinkAuditPlugin.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditPlugin
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Audit plugin: records who inserted <a href> backlinks into rich
 * text fields (TinyMCE textareas) — which user, which journal, and every
 * link — so spam backlink injections can be traced to a person.
 */

import('lib.pkp.classes.plugins.GenericPlugin');
import('plugins.generic.backlinkAudit.classes.BacklinkAuditDAO');
import('plugins.generic.backlinkAudit.classes.BacklinkAuditLogger');

use Illuminate\Database\Capsule\Manager as Capsule;

class BacklinkAuditPlugin extends GenericPlugin {

	/** @var BacklinkAuditLogger */
	var $_logger;

	/**
	 * @copydoc LazyLoadPlugin::register()
	 */
	public function register($category, $path, $mainContextId = null) {
		$success = parent::register($category, $path, $mainContextId);

		if (!Config::getVar('general', 'installed') || defined('RUNNING_UPGRADE')) {
			return true;
		}

		if ($success && $this->getEnabled($mainContextId)) {
			$dao = new BacklinkAuditDAO();
			DAORegistry::registerDAO('BacklinkAuditDAO', $dao);
			$this->_logger = new BacklinkAuditLogger($dao);

			// Create the log table if missing (idempotent)
			$this->_ensureSchema();

			// Precise attribution: settings saves through services (covers the REST API)
			HookRegistry::register('Context::add', [$this, 'callbackContextAdd']);
			HookRegistry::register('Context::edit', [$this, 'callbackContextEdit']);
			HookRegistry::register('Site::edit', [$this, 'callbackSiteEdit']);
			HookRegistry::register('Publication::add', [$this, 'callbackPublicationAdd']);
			HookRegistry::register('Publication::edit', [$this, 'callbackPublicationEdit']);

			// Broad net: any page/component POST containing anchors
			HookRegistry::register('LoadHandler', [$this, 'callbackInputCapture']);
			HookRegistry::register('LoadComponentHandler', [$this, 'callbackInputCapture']);

			// Report page + backend menu
			HookRegistry::register('LoadHandler', [$this, 'callbackHandleContent']);
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'addToBackendMenu']);
		}

		return $success;
	}

	//
	// Plugin metadata
	//

	public function getDisplayName() {
		return __('plugins.generic.backlinkAudit.displayName');
	}

	public function getDescription() {
		return __('plugins.generic.backlinkAudit.description');
	}

	public function getInstallMigration() {
		$this->import('BacklinkAuditSchemaMigration');
		return new BacklinkAuditSchemaMigration();
	}

	//
	// Hooks: precise service-level capture
	//

	public function callbackContextAdd($hookName, $args) {
		$context =& $args[0];
		$request = $args[1];
		try {
			$this->_getLogger()->auditSettingsSave(
				'context', null, null, $context,
				$context ? $context->getId() : null,
				$context && method_exists($context, 'getPath') ? $context->getPath() : null,
				null, $request
			);
		} catch (\Throwable $e) {
			error_log('BacklinkAudit Context::add failed: ' . $e->getMessage());
		}
		return false;
	}

	public function callbackContextEdit($hookName, $args) {
		$newContext =& $args[0];
		$oldContext = $args[1];
		$params = isset($args[2]) ? $args[2] : null;
		$request = $args[3];
		try {
			$this->_getLogger()->auditSettingsSave(
				'context', $oldContext, $params, $newContext,
				$newContext ? $newContext->getId() : ($oldContext ? $oldContext->getId() : null),
				$newContext && method_exists($newContext, 'getPath') ? $newContext->getPath() : null,
				null, $request
			);
		} catch (\Throwable $e) {
			error_log('BacklinkAudit Context::edit failed: ' . $e->getMessage());
		}
		return false;
	}

	public function callbackSiteEdit($hookName, $args) {
		$newSite =& $args[0];
		$oldSite = $args[1];
		$params = isset($args[2]) ? $args[2] : null;
		$request = $args[3];
		try {
			$this->_getLogger()->auditSettingsSave(
				'site', $oldSite, $params, $newSite,
				null, '(site)', null, $request
			);
		} catch (\Throwable $e) {
			error_log('BacklinkAudit Site::edit failed: ' . $e->getMessage());
		}
		return false;
	}

	public function callbackPublicationAdd($hookName, $args) {
		$publication =& $args[0];
		$request = $args[1];
		try {
			$this->_getLogger()->auditSettingsSave(
				'publication', null, null, $publication,
				$publication ? $publication->getData('contextId') : null,
				$this->_contextPathForId($publication ? $publication->getData('contextId') : null),
				$publication ? $publication->getId() : null,
				$request
			);
		} catch (\Throwable $e) {
			error_log('BacklinkAudit Publication::add failed: ' . $e->getMessage());
		}
		return false;
	}

	public function callbackPublicationEdit($hookName, $args) {
		$newPublication =& $args[0];
		$oldPublication = $args[1];
		$params = isset($args[2]) ? $args[2] : null;
		$request = $args[3];
		try {
			$this->_getLogger()->auditSettingsSave(
				'publication', $oldPublication, $params, $newPublication,
				$newPublication ? $newPublication->getData('contextId') : null,
				$this->_contextPathForId($newPublication ? $newPublication->getData('contextId') : null),
				$newPublication ? $newPublication->getId() : null,
				$request
			);
		} catch (\Throwable $e) {
			error_log('BacklinkAudit Publication::edit failed: ' . $e->getMessage());
		}
		return false;
	}

	//
	// Hooks: broad input capture + report routing
	//

	public function callbackInputCapture($hookName, $args) {
		try {
			$method = isset($_SERVER['REQUEST_METHOD']) ? strtoupper($_SERVER['REQUEST_METHOD']) : 'GET';
			if ($method === 'POST') {
				$request = Application::get()->getRequest();
				$this->_getLogger()->auditInputAttempt($request);
			}
		} catch (\Throwable $e) {
			error_log('BacklinkAudit input capture failed: ' . $e->getMessage());
		}
		return false;
	}

	public function callbackHandleContent($hookName, $args) {
		$page =& $args[0];

		if ($page === 'securityaudit') {
			define('HANDLER_CLASS', 'BacklinkAuditHandler');
			$this->import('pages.BacklinkAuditHandler');
			BacklinkAuditHandler::setPlugin($this);
			return true;
		}
		return false;
	}

	public function addToBackendMenu($hookName, $args) {
		$request = Application::get()->getRequest();
		if (!is_array($args)) return false;
		$templateMgr = TemplateManager::getManager($request);
		if (!$templateMgr) return false;

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$context || !$user) return false;

		$router = $request->getRouter();
		$handler = $router ? $router->getHandler() : null;
		if (!$handler) return false;

		$userRoles = (array) $handler->getAuthorizedContextObject(ASSOC_TYPE_USER_ROLES);
		if (!in_array(ROLE_ID_MANAGER, $userRoles) && !in_array(ROLE_ID_SITE_ADMIN, $userRoles)) {
			return false;
		}

		$menu = (array) $templateMgr->getState('menu');
		$menu['backlinkAudit'] = [
			'name' => __('plugins.generic.backlinkAudit.menu'),
			'url' => $router->url($request, $context->getPath(), 'securityaudit'),
			'isCurrent' => $request->getRequestedPage() === 'securityaudit',
		];
		$templateMgr->setState(['menu' => $menu]);

		return false;
	}

	//
	// Helpers
	//

	/**
	 * Run the schema migration if the table is missing (idempotent).
	 */
	function _ensureSchema() {
		try {
			if (!Capsule::schema()->hasTable('backlink_audit_log')) {
				$this->getInstallMigration()->up();
			}
		} catch (\Throwable $e) {
			error_log('BacklinkAuditPlugin::_ensureSchema failed: ' . $e->getMessage());
		}
	}

	function _getLogger() {
		if ($this->_logger === null) {
			$dao = DAORegistry::getDAO('BacklinkAuditDAO');
			$this->_logger = new BacklinkAuditLogger($dao);
		}
		return $this->_logger;
	}

	function _contextPathForId($contextId) {
		if (!$contextId) return null;
		static $cache = [];
		if (isset($cache[$contextId])) return $cache[$contextId];
		try {
			$contextDao = Application::getContextDAO();
			$context = $contextDao->getById((int) $contextId);
			$path = $context ? $context->getPath() : ('#' . $contextId);
		} catch (\Throwable $e) {
			$path = '#' . $contextId;
		}
		$cache[$contextId] = $path;
		return $path;
	}
}
