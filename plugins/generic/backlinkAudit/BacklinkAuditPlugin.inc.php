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
import('plugins.generic.backlinkAudit.classes.BacklinkAuditSnapshotDAO');
import('plugins.generic.backlinkAudit.classes.BacklinkAuditNotifier');

use Illuminate\Database\Capsule\Manager as Capsule;

class BacklinkAuditPlugin extends GenericPlugin {

	/**
	 * Stored in the schema_ready plugin setting once the three tables are
	 * confirmed present. Bump whenever BacklinkAuditSchemaMigration changes so
	 * the stored token forces exactly one re-probe after that upgrade.
	 */
	const SCHEMA_TOKEN = '1';

	/** @var BacklinkAuditLogger */
	var $_logger;

	/** @var BacklinkAuditSnapshotDAO */
	var $_snapshotDao;

	/** @var BacklinkAuditNotifier */
	var $_notifier;

	/** @var bool True once setupBackendPage() has fired for this request */
	var $_isBackendRender = false;

	/**
	 * @var bool Static, not per-instance: PluginRegistry::loadCategory() builds
	 * a fresh plugin object every time it runs, so an instance flag would let
	 * the full diff fire twice in one request.
	 */
	static $_watcherRegistered = false;

	/**
	 * @var bool Guards the hook registrations below. PluginRegistry::register()
	 * runs $plugin->register() before it checks whether the plugin is already
	 * loaded, so a second loadCategory() inside one request reaches here again
	 * — and HookRegistry::register() does not de-duplicate, which would fire
	 * every callback twice for the rest of the request.
	 */
	static $_hooksRegistered = false;

	/**
	 * @var bool|null Whether all three tables are known to exist for this
	 * request. null = not checked yet. Set by _ensureSchema() so the shutdown
	 * diff answers from memory instead of re-running the same probes.
	 */
	var $_schemaOk = null;

	/**
	 * @var array|null Acting user, read from the registry at shutdown — see
	 * _captureActor() for why it is not read earlier.
	 */
	var $_actor = null;

	/** @var int Seconds between full diffs on non-POST requests */
	var $_diffThrottleSeconds = 300;

	/**
	 * @copydoc LazyLoadPlugin::register()
	 */
	public function register($category, $path, $mainContextId = null) {
		$success = parent::register($category, $path, $mainContextId);

		if (!Config::getVar('general', 'installed') || defined('RUNNING_UPGRADE')) {
			return true;
		}

		if (!$success) return $success;

		// The DAOs are created OUTSIDE the getEnabled() gate on purpose. The
		// shutdown diff below is armed unconditionally, and DAORegistry::getDAO()
		// does not return null for an unknown name — it calls fatalError() and
		// kills the page with "Unrecognized DAO BacklinkAuditSnapshotDAO!".
		// getEnabled() can be false while register() still runs: another plugin
		// calling PluginRegistry::loadCategory('generic') without $enabledOnly
		// re-registers every plugin found on disk, enabled or not. The watcher
		// must therefore never depend on this block having run.
		$dao = new BacklinkAuditDAO();
		DAORegistry::registerDAO('BacklinkAuditDAO', $dao);
		$this->_logger = new BacklinkAuditLogger($dao);

		$snapshotDao = new BacklinkAuditSnapshotDAO();
		DAORegistry::registerDAO('BacklinkAuditSnapshotDAO', $snapshotDao);
		$this->_snapshotDao = $snapshotDao;

		// Create the log tables if missing (idempotent; effectively free once
		// the schema_ready token below has been written).
		$this->_ensureSchema();

		if ($this->getEnabled($mainContextId) && !self::$_hooksRegistered) {
			self::$_hooksRegistered = true;
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
			// Registered before addToBackendMenu so the backend flag is always set
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'callbackMarkBackendRender']);
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'addToBackendMenu']);

			// Prevention: strip the SEO value from links pointing off-site by
			// tagging them rel="nofollow" in the rendered HTML.
			//
			// Registered here rather than from the TemplateManager::display hook
			// because the journal landing page is rendered by
			// pages/index/IndexHandler.inc.php via a direct $templateMgr->fetch()
			// call that never goes through display(). register() runs from
			// Dispatcher::dispatch() before the router routes, so the filter is
			// already in place for that path too.
			$templateMgr = TemplateManager::getManager(Application::get()->getRequest());
			if ($templateMgr) {
				$templateMgr->registerFilter('output', [$this, 'callbackNoFollowFilter']);
			}
		}

		// The privilege watcher is registered OUTSIDE the getEnabled() gate on
		// purpose. getEnabled() resolves a context-less request to CONTEXT_SITE
		// (0), so site-level and API requests would otherwise skip this block
		// entirely — and the snapshots are global anyway, so detection must not
		// depend on which journal the manager happens to be browsing.
		$this->_registerPrivilegeWatcher();

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

	//
	// Hooks: nofollow prevention
	//

	/**
	 * Flag that the current render is a backend (editorial/admin) page, so the
	 * output filter can leave those pages untouched. `$isBackendPage` on the
	 * template manager is private with no getter, and the output filter only
	 * receives a Smarty_Internal_Template (not the template manager), so the
	 * hook is the reliable signal.
	 */
	public function callbackMarkBackendRender($hookName, $args) {
		$this->_isBackendRender = true;
		return false;
	}

	/**
	 * Smarty output filter: tag off-site links with rel="nofollow".
	 *
	 * @param $output string Fully rendered page HTML
	 * @param $templateMgr Smarty_Internal_Template
	 * @return string
	 */
	public function callbackNoFollowFilter($output, $templateMgr) {
		if ($this->_isBackendRender || !is_string($output) || stripos($output, '<a') === false) {
			return $output;
		}
		try {
			return $this->_getLogger()->rewriteExternalLinks($output, Application::get()->getRequest());
		} catch (\Throwable $e) {
			// Never let this break a page: on failure serve the original HTML.
			error_log('BacklinkAudit nofollow filter failed: ' . $e->getMessage());
			return $output;
		}
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
		$entry = [
			'name' => __('plugins.generic.backlinkAudit.menu'),
			'url' => $router->url($request, $context->getPath(), 'securityaudit'),
			'isCurrent' => $request->getRequestedPage() === 'securityaudit',
		];

		if (isset($menu['statistics']) && is_array($menu['statistics'])) {
			// Nest under Statistics submenu
			$menu['statistics']['submenu']['backlinkAudit'] = $entry;
		} else {
			// Fallback: no Statistics group (e.g. pure site admin) — top-level entry
			$menu['backlinkAudit'] = $entry;
		}
		$templateMgr->setState(['menu' => $menu]);

		return false;
	}

	//
	// Privilege-change detection
	//
	// OJS 3.3 fires no hook when a user is assigned to a user group, and
	// user_user_groups has no timestamp, so membership is snapshotted and
	// diffed instead. Comparing end state also catches changes made outside
	// the UI entirely — which is the case worth alarming about.
	//

	/**
	 * Arm the shutdown diff. Deliberately touches nothing else.
	 */
	function _registerPrivilegeWatcher() {
		if (self::$_watcherRegistered) return;
		self::$_watcherRegistered = true;

		// Do not read the user here. register() is called from
		// Dispatcher::dispatch(), which runs BEFORE PKPPageRouter::route() has
		// had the chance to define SESSION_DISABLE_INIT, so calling
		// $request->getUser() at this point constructs SessionManager and
		// starts a session on requests that are meant to run without one (OAI,
		// the CLI tools, and every front-end request of a guest). The acting
		// user is read from the registry at shutdown instead.
		if (defined('SESSION_DISABLE_INIT')) return;

		register_shutdown_function([$this, 'shutdownDiff']);
	}

	/**
	 * The acting user for this request, read without starting a session.
	 *
	 * PKPRequest::getUser() writes the user into the Registry by reference on
	 * its first call, so whatever already resolved the session user —
	 * PKPPageRouter::route() does it for every normal page, the API router for
	 * every token-authenticated call — is still there at shutdown. Reading the
	 * Registry never constructs SessionManager, which is the whole point: a
	 * request that never resolved a user cannot have changed a privilege, and
	 * OAI/CLI requests must not be given a session now.
	 * @return array|null
	 */
	function _captureActor() {
		try {
			$user = Registry::get('user', false, null);
			if (!is_object($user) || !method_exists($user, 'getId') || !$user->getId()) return null;

			return [
				'userId' => (int) $user->getId(),
				'username' => (string) $user->getUsername(),
				'email' => (string) $user->getEmail(),
				'isPost' => isset($_SERVER['REQUEST_METHOD']) && strtoupper($_SERVER['REQUEST_METHOD']) === 'POST',
				// A role change submitted through the UI always carries
				// userGroupIds: UserForm::readInputData() reads it, and both
				// UserDetailsForm and UserRoleForm inherit that. Without this
				// signal the change cannot honestly be attributed to whoever
				// happens to be signed in when it is noticed.
				'submittedGroups' => isset($_POST['userGroupIds']),
			];
		} catch (\Throwable $e) {
			error_log('BacklinkAudit: could not capture the acting user: ' . $e->getMessage());
			return null;
		}
	}

	/**
	 * Shutdown entry point. The response has already been produced by now, so
	 * nothing here may be allowed to disturb it.
	 */
	public function shutdownDiff() {
		// The client may have disconnected already; finish the audit anyway.
		ignore_user_abort(true);
		@set_time_limit(30);

		try {
			// Labels baked into source_desc are frozen for the life of the
			// row, so make absolutely sure this plugin's locale file is
			// registered before the diff runs rather than relying on it
			// having been registered at register() time.
			$this->addLocaleData();
			$this->_actor = $this->_captureActor();
			$this->diffSnapshots();
		} catch (\Throwable $e) {
			error_log('BacklinkAudit privilege diff failed: ' . $e->getMessage());
		}
	}

	/**
	 * Decide whether to run the diff, then hand off to _runPrivilegeDiff().
	 *
	 * Gates are ordered cheapest first. They used to run table checks and the
	 * role query before the throttle, so every single page view paid for them
	 * even though the diff only actually runs every 300s on a GET.
	 */
	function diffSnapshots() {
		if (empty($this->_actor) || empty($this->_actor['userId'])) return;

		$isPost = !empty($this->_actor['isPost']);

		// 1. Read-only throttle. On a GET inside the window this is one
		//    settings read and the request stops here.
		if (!$isPost && !$this->_throttleExpired()) return;

		$dao = $this->_getSnapshotDao();
		if (!$dao) return;

		// 2. Schema. Answered from _ensureSchema()'s result when the plugin is
		//    loaded; memoised otherwise.
		if (!$this->_tablesOk()) return;

		// 3. Only manager-level users can change privileges; skipping everyone
		//    else keeps this off the hot path for ordinary readers and authors.
		if (!$dao->isPrivilegedUser($this->_actor['userId'])) return;

		// 4. Consume the window only now that the run was actually worth doing:
		//    a reader's GET must never postpone a manager's run.
		if (!$isPost) $this->_throttleMark();

		if (!$dao->acquireLock()) return;
		try {
			$this->_runPrivilegeDiff($dao);
		} finally {
			$dao->releaseLock();
		}
	}

	/**
	 * @param $dao BacklinkAuditSnapshotDAO
	 */
	function _runPrivilegeDiff($dao) {
		$oldRoles = $dao->getSnapshotRoleMembership();
		$newRoles = $dao->getLiveRoleMembership();
		$oldUsers = $dao->getSnapshotUserState();
		$newUsers = $dao->getLiveUserState();

		$bootstrappedAt = $this->getSetting(CONTEXT_ID_NONE, 'snapshot_bootstrapped_at');

		// First ever run: record the baseline and stay silent. Logging 751
		// users and 1521 assignments as "added" would bury the real signal.
		if (!$bootstrappedAt) {
			$dao->replaceRoleMembership($newRoles);
			$dao->replaceUserState($newUsers);
			$this->updateSetting(CONTEXT_ID_NONE, 'snapshot_bootstrapped_at', date('Y-m-d H:i:s'), 'string');
			$this->_getLogger()->logSecurityRow([
				'contextId' => null,
				'contextPath' => '(site)',
				'sourceType' => 'role',
				'sourceDesc' => 'baseline: ' . count($newRoles) . ' assignments, ' . count($newUsers) . ' accounts',
				'objectId' => null,
				'action' => 'bootstrap',
				'links' => [],
				'addedCount' => 0,
				'removedCount' => 0,
				'oldContent' => '',
				'newContent' => '',
				'request' => Application::get()->getRequest(),
			]);
			return;
		}

		// The snapshot existed and is now empty: someone cleared it. Seeding
		// silently would hand an attacker a way to switch detection off.
		if (!$oldRoles) {
			$dao->replaceRoleMembership($newRoles);
			$dao->replaceUserState($newUsers);
			$tamper = [[
				'action' => 'tamper',
				'sourceType' => 'role',
				'contextId' => null,
				'contextPath' => '(site)',
				'userId' => 0,
				'username' => '(snapshot)',
				'actor' => null,
				'unexplained' => true,
				'added' => [],
				'removed' => [],
				'accountChanges' => [],
				'oldContent' => '',
				'newContent' => '',
				'createdAt' => date('Y-m-d H:i:s'),
			]];
			$this->_getLogger()->logSecurityRow([
				'contextId' => null,
				'contextPath' => '(site)',
				'sourceType' => 'role',
				'sourceDesc' => 'snapshot was emptied; detection had to be rebuilt',
				'objectId' => null,
				'action' => 'tamper',
				'links' => [],
				'addedCount' => 0,
				'removedCount' => 0,
				'oldContent' => '',
				'newContent' => '',
				'request' => Application::get()->getRequest(),
			]);
			$this->_getNotifier()->notify($tamper);
			return;
		}

		$groupInfo = $dao->getGroupInfo();
		$usernames = $dao->getUsernames();
		$actor = $this->_resolveActor();

		$changes = array_merge(
			$this->_collectRoleChanges($oldRoles, $newRoles, $groupInfo, $usernames, $actor),
			$this->_collectAccountChanges($oldUsers, $newUsers, $usernames, $actor)
		);

		// Store the new baseline before reporting, so a failure while logging
		// or emailing cannot cause the same change to be reported twice.
		$dao->replaceRoleMembership($newRoles);
		$dao->replaceUserState($newUsers);

		if (empty($changes)) return;

		foreach ($changes as $change) {
			$this->_logSecurityChange($change);
		}
		$this->_getNotifier()->notify($changes);
	}

	/**
	 * Who to credit or blame. Only a POST that carried userGroupIds is
	 * attributable; anything else is reported as unexplained, which is the
	 * case that deserves attention.
	 *
	 * The session user is a fact either way, so it is always returned: the
	 * report must be able to name — and link — whoever was signed in when
	 * the change was noticed. `unexplained` keeps saying whether the change
	 * itself came from the OJS interface, and [UNEXPLAINED] still leads the
	 * description; dropping the user for those rows just left the column
	 * blank on the cases that matter most.
	 * @return array ['userId' =>, 'username' =>, 'email' =>, 'label' =>, 'unexplained' =>]
	 */
	function _resolveActor() {
		$attributed = !empty($this->_actor['isPost']) && !empty($this->_actor['submittedGroups']);
		return [
			'userId' => $this->_actor['userId'],
			'username' => $this->_actor['username'],
			'email' => $this->_actor['email'],
			'label' => '#' . $this->_actor['userId'] . ' ' . $this->_actor['username'],
			'unexplained' => !$attributed,
		];
	}

	/**
	 * One change entry per (affected user, affected journal), so the recorded
	 * context_id is always accurate.
	 */
	function _collectRoleChanges($oldRoles, $newRoles, $groupInfo, $usernames, $actor) {
		$added = array_diff_key($newRoles, $oldRoles);
		$removed = array_diff_key($oldRoles, $newRoles);
		if (!$added && !$removed) return [];

		// Bucket by user + context.
		$buckets = [];
		foreach ([['set' => $added, 'kind' => 'added'], ['set' => $removed, 'kind' => 'removed']] as $side) {
			foreach (array_keys($side['set']) as $key) {
				list($userId, $groupId) = explode(':', $key, 2);
				$userId = (int) $userId;
				$groupId = (int) $groupId;
				if (!isset($groupInfo[$groupId])) continue;
				$contextId = (int) $groupInfo[$groupId]['context_id'];
				$bucketKey = $userId . ':' . $contextId;
				if (!isset($buckets[$bucketKey])) {
					$buckets[$bucketKey] = ['userId' => $userId, 'contextId' => $contextId, 'added' => [], 'removed' => []];
				}
				$buckets[$bucketKey][$side['kind']][] = $groupInfo[$groupId]['name'];
			}
		}

		$changes = [];
		foreach ($buckets as $bucket) {
			sort($bucket['added']);
			sort($bucket['removed']);

			$labels = [];
			foreach ($bucket['added'] as $name) $labels[] = '+' . $name;
			foreach ($bucket['removed'] as $name) $labels[] = '-' . $name;

			$before = $this->_roleLabelsInContext($oldRoles, $bucket['userId'], $bucket['contextId'], $groupInfo);
			$after = $this->_roleLabelsInContext($newRoles, $bucket['userId'], $bucket['contextId'], $groupInfo);

			$username = isset($usernames[$bucket['userId']]) ? $usernames[$bucket['userId']] : ('#' . $bucket['userId']);

			$changes[] = [
				'action' => 'role_change',
				'sourceType' => 'role',
				'contextId' => $bucket['contextId'] ?: null,
				'contextPath' => $this->_contextPathForId($bucket['contextId']),
				'userId' => $bucket['userId'],
				'username' => $username,
				'actor' => $actor['label'],
				'unexplained' => $actor['unexplained'],
				'added' => $bucket['added'],
				'removed' => $bucket['removed'],
				'accountChanges' => [],
				'oldContent' => implode(', ', $before),
				'newContent' => implode(', ', $after),
				'createdAt' => date('Y-m-d H:i:s'),
				'actorUserId' => $actor['userId'],
				'actorUsername' => $actor['username'],
				'actorEmail' => $actor['email'],
				'description' => $username . ' ' . implode(' ', $labels),
			];
		}
		return $changes;
	}

	/**
	 * Account-level changes have no journal, so they are recorded at site
	 * level and surface to site administrators only.
	 */
	function _collectAccountChanges($oldUsers, $newUsers, $usernames, $actor) {
		$changes = [];

		foreach ($newUsers as $userId => $new) {
			$old = isset($oldUsers[$userId]) ? $oldUsers[$userId] : null;
			$labels = [];

			if ($old === null) {
				$labels[] = __('plugins.generic.backlinkAudit.change.newAccount');
			} else {
				if ($old['email'] !== $new['email']) {
					$labels[] = __('plugins.generic.backlinkAudit.change.email', ['old' => $old['email'], 'new' => $new['email']]);
				}
				if ($old['username'] !== $new['username']) {
					$labels[] = __('plugins.generic.backlinkAudit.change.username', ['old' => $old['username'], 'new' => $new['username']]);
				}
				if ($old['password_fp'] !== $new['password_fp']) {
					$labels[] = __('plugins.generic.backlinkAudit.change.password');
				}
				if ((int) $old['disabled'] !== (int) $new['disabled']) {
					$labels[] = $new['disabled']
						? __('plugins.generic.backlinkAudit.change.disabled')
						: __('plugins.generic.backlinkAudit.change.enabled');
				}
			}

			if (!$labels) continue;

			$username = isset($usernames[$userId]) ? $usernames[$userId] : ('#' . $userId);
			$changes[] = [
				'action' => 'user_change',
				'sourceType' => 'user',
				'contextId' => null,
				'contextPath' => '(site)',
				'userId' => (int) $userId,
				'username' => $username,
				'actor' => $actor['label'],
				'unexplained' => $actor['unexplained'],
				'added' => [],
				'removed' => [],
				'accountChanges' => $labels,
				'oldContent' => $old ? ('username=' . $old['username'] . ' email=' . $old['email'] . ' disabled=' . $old['disabled']) : '',
				'newContent' => 'username=' . $new['username'] . ' email=' . $new['email'] . ' disabled=' . $new['disabled'],
				'createdAt' => date('Y-m-d H:i:s'),
				'actorUserId' => $actor['userId'],
				'actorUsername' => $actor['username'],
				'actorEmail' => $actor['email'],
				'description' => $username . ' ' . implode('; ', $labels),
			];
		}

		// Accounts that disappeared.
		foreach ($oldUsers as $userId => $old) {
			if (isset($newUsers[$userId])) continue;
			$username = isset($usernames[$userId]) ? $usernames[$userId] : ('#' . $userId);
			$changes[] = [
				'action' => 'user_change',
				'sourceType' => 'user',
				'contextId' => null,
				'contextPath' => '(site)',
				'userId' => (int) $userId,
				'username' => $username,
				'actor' => $actor['label'],
				'unexplained' => $actor['unexplained'],
				'added' => [],
				'removed' => [],
				'accountChanges' => [__('plugins.generic.backlinkAudit.change.deletedAccount')],
				'oldContent' => 'username=' . $old['username'] . ' email=' . $old['email'],
				'newContent' => '',
				'createdAt' => date('Y-m-d H:i:s'),
				'actorUserId' => $actor['userId'],
				'actorUsername' => $actor['username'],
				'actorEmail' => $actor['email'],
				'description' => $username . ' ' . __('plugins.generic.backlinkAudit.change.deletedAccount'),
			];
		}

		return $changes;
	}

	/**
	 * Role names the user held in one journal, from a membership set.
	 */
	function _roleLabelsInContext($set, $userId, $contextId, $groupInfo) {
		$labels = [];
		$prefix = $userId . ':';
		foreach (array_keys($set) as $key) {
			if (strpos($key, $prefix) !== 0) continue;
			$groupId = (int) substr($key, strlen($prefix));
			if (!isset($groupInfo[$groupId])) continue;
			if ((int) $groupInfo[$groupId]['context_id'] !== (int) $contextId) continue;
			$labels[] = $groupInfo[$groupId]['name'];
		}
		sort($labels);
		return $labels;
	}

	/**
	 * Write one change row. Role names go into `links` so the existing report
	 * table renders them without a new column; href stays empty so the
	 * template renders plain text instead of an anchor.
	 */
	function _logSecurityChange($change) {
		$links = [];
		foreach ($change['added'] as $label) {
			$links[] = ['href' => '', 'text' => '+' . $label, 'is_external' => false, 'suspicious' => false];
		}
		foreach ($change['removed'] as $label) {
			$links[] = ['href' => '', 'text' => '-' . $label, 'is_external' => false, 'suspicious' => false];
		}
		foreach ($change['accountChanges'] as $label) {
			$links[] = ['href' => '', 'text' => $label, 'is_external' => false, 'suspicious' => false];
		}

		$description = $change['description'];
		if (!empty($change['unexplained'])) {
			$description = '[UNEXPLAINED] ' . $description;
		}

		$this->_getLogger()->logSecurityRow([
			'actorUserId' => $change['actorUserId'],
			'actorUsername' => $change['actorUsername'],
			'actorEmail' => $change['actorEmail'],
			'contextId' => $change['contextId'],
			'contextPath' => $change['contextPath'],
			'sourceType' => $change['sourceType'],
			'sourceDesc' => $description,
			'objectId' => $change['userId'],
			'action' => $change['action'],
			'links' => $links,
			'addedCount' => count($change['added']),
			'removedCount' => count($change['removed']),
			'oldContent' => $change['oldContent'],
			'newContent' => $change['newContent'],
			'request' => Application::get()->getRequest(),
		]);
	}

	/**
	 * Read-only half of the rate limit: has the window on non-POST requests
	 * elapsed? Must not write anything, otherwise a reader's GET would consume
	 * the window before a manager's run had a chance to take it.
	 * @return bool True when a run may be considered
	 */
	function _throttleExpired() {
		try {
			$last = (int) $this->getSetting(CONTEXT_ID_NONE, 'last_snapshot_check');
			return !$last || (time() - $last) >= $this->_diffThrottleSeconds;
		} catch (\Throwable $e) {
			return true;
		}
	}

	/**
	 * Write half of the rate limit. Only called once a run has been approved,
	 * and only on non-POST requests (POSTs always run).
	 */
	function _throttleMark() {
		try {
			$this->updateSetting(CONTEXT_ID_NONE, 'last_snapshot_check', time(), 'string');
		} catch (\Throwable $e) {
			// A failed write only means the next GET may run the diff again.
		}
	}

	/**
	 * Whether the snapshot tables are present, without repeating work.
	 *
	 * _ensureSchema() has normally already answered this at registration time;
	 * falling back to the memoised tablesExist() costs nothing extra either.
	 *
	 * @return bool
	 */
	function _tablesOk() {
		if ($this->_schemaOk !== null) return $this->_schemaOk;
		$dao = $this->_getSnapshotDao();
		if (!$dao) return false;
		return $dao->tablesExist();
	}

	function _getSnapshotDao() {
		if ($this->_snapshotDao === null) {
			// DAORegistry::getDAO() fatals for names it does not know instead of
			// returning null, so look the instance up directly.
			$daos = DAORegistry::getDAOs();
			if (isset($daos['BacklinkAuditSnapshotDAO'])) {
				$this->_snapshotDao = $daos['BacklinkAuditSnapshotDAO'];
			} else {
				try {
					$this->_snapshotDao = new BacklinkAuditSnapshotDAO();
					DAORegistry::registerDAO('BacklinkAuditSnapshotDAO', $this->_snapshotDao);
				} catch (\Throwable $e) {
					return null;
				}
			}
		}
		return $this->_snapshotDao;
	}

	function _getNotifier() {
		if ($this->_notifier === null) {
			$this->_notifier = new BacklinkAuditNotifier($this);
		}
		return $this->_notifier;
	}

	//
	// Helpers
	//

	/**
	 * Run the schema migration if any of our tables is missing (idempotent).
	 *
	 * Every table has to be checked, not just the first one: the log table
	 * already exists on installs that ran an earlier version of this plugin,
	 * so guarding on it alone would silently skip creating the snapshots.
	 *
	 * The result is remembered twice over: in the schema_ready setting across
	 * requests (so the three information_schema probes normally never run at
	 * all) and in $_schemaOk within this request (so the shutdown diff does
	 * not repeat them).
	 */
	function _ensureSchema() {
		if ($this->_schemaOk !== null) return;
		try {
			if ((string) $this->getSetting(CONTEXT_ID_NONE, 'schema_ready') === self::SCHEMA_TOKEN) {
				$this->_schemaOk = true;
				return;
			}

			$schema = Capsule::schema();
			$ok = $schema->hasTable('backlink_audit_log')
				&& $schema->hasTable('backlink_audit_role_snapshot')
				&& $schema->hasTable('backlink_audit_user_snapshot');
			if (!$ok) {
				$this->getInstallMigration()->up();
				$ok = $schema->hasTable('backlink_audit_log')
					&& $schema->hasTable('backlink_audit_role_snapshot')
					&& $schema->hasTable('backlink_audit_user_snapshot');
			}

			$this->_schemaOk = $ok;
			if ($ok) {
				$this->updateSetting(CONTEXT_ID_NONE, 'schema_ready', self::SCHEMA_TOKEN, 'string');
			}
		} catch (\Throwable $e) {
			error_log('BacklinkAuditPlugin::_ensureSchema failed: ' . $e->getMessage());
		}
	}

	function _getLogger() {
		if ($this->_logger === null) {
			// Same reasoning as _getSnapshotDao(): getDAO() fatals on unknown names.
			$daos = DAORegistry::getDAOs();
			$dao = isset($daos['BacklinkAuditDAO']) ? $daos['BacklinkAuditDAO'] : new BacklinkAuditDAO();
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
