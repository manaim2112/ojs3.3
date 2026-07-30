<?php

import('lib.pkp.classes.plugins.GenericPlugin');
import('plugins.generic.loa.classes.LoADAO');

use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;

class LoAPlugin extends GenericPlugin {

	public function register($category, $path, $mainContextId = null) {
		$success = parent::register($category, $path, $mainContextId);

		if (!Config::getVar('general', 'installed') || defined('RUNNING_UPGRADE')) {
			return true;
		}

		if ($success && $this->getEnabled($mainContextId)) {
			$this->runMigration();
			$loaDao = new LoADAO();
			DAORegistry::registerDAO('LoADAO', $loaDao);

			HookRegistry::register('LoadHandler', [$this, 'callbackHandleContent']);
			HookRegistry::register('Template::Workflow::Publication', [$this, 'addToWorkflow']);
			HookRegistry::register('Templates::Article::Details', [$this, 'addToArticleDetails']);
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'addToBackendMenu']);
		}

		return $success;
	}

	public function setEnabled($enabled) {
		parent::setEnabled($enabled);
		if ($enabled) {
			$this->runUpgradeMigration();
		}
	}

	private function runMigration() {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			$migration = $this->getInstallMigration();
			$migration->up();
		}
	}

	private function runUpgradeMigration() {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return;
		}
		if (!Capsule::schema()->hasColumn('article_loa_codes', 'generated_by')) {
			Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
				$table->bigInteger('generated_by')->nullable();
			});
		}
		try {
			Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
				$table->dropUnique('article_loa_codes_submission_status');
			});
		} catch (\Exception $e) {
		}
	}

	public function getActions($request, $verb) {
		$router = $request->getRouter();
		import('lib.pkp.classes.linkAction.request.AjaxModal');
		return array_merge(
			$this->getEnabled() ? [
				new LinkAction(
					'settings',
					new AjaxModal(
						$router->url($request, null, null, 'manage', null, ['verb' => 'settings', 'plugin' => $this->getName(), 'category' => $this->getCategory()]),
						$this->getDisplayName()
					),
					__('plugins.generic.loa.settings'),
					null
				),
			] : [],
			parent::getActions($request, $verb)
		);
	}

	public function manage($args, $request) {
		$context = $request->getContext();
		switch ($request->getUserVar('verb')) {
			case 'settings':
				$this->import('LoASettingsForm');
				$form = new LoASettingsForm($this, $context->getId());
				if ($request->getUserVar('save')) {
					$form->readInputData();
					if ($form->validate()) {
						$form->execute();
						return new JSONMessage(true, __('plugins.generic.loa.settingsSaved'));
					}
				} else {
					$form->initData();
				}
				return new JSONMessage(true, $form->fetch($request));
		}
		return parent::manage($args, $request);
	}

	public function getDisplayName() {
		return __('plugins.generic.loa.displayName');
	}

	public function getDescription() {
		return __('plugins.generic.loa.description');
	}

	public function getInstallMigration() {
		$this->import('LoASchemaMigration');
		return new LoASchemaMigration();
	}

	public function callbackHandleContent($hookName, $args) {
		$page =& $args[0];
		$op =& $args[1];

		if ($page === 'loa') {
			define('HANDLER_CLASS', 'LoAHandler');
			$this->import('pages.LoAHandler');
			LoAHandler::setPlugin($this);
			return true;
		}
		return false;
	}

	public function addToWorkflow($hookName, $params) {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return false;
		}

		$smarty = &$params[1];
		$output = &$params[2];
		$submission = $smarty->get_template_vars('submission');

		if (!$submission) {
			return false;
		}

		$request = Application::get()->getRequest();
		$context = $request->getContext();
		$dispatcher = $request->getDispatcher();

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->getBySubmissionId($submission->getId());

		$generatedByUser = null;
		if ($loa && $loa->getGeneratedBy()) {
			$userDao = DAORegistry::getDAO('UserDAO');
			$generatedByUser = $userDao->getById($loa->getGeneratedBy());
		}

		$user = $request->getUser();
		$canManage = $user && $user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId());

		$smarty->assign([
			'loa' => $loa,
			'submissionId' => $submission->getId(),
			'generatedByUser' => $generatedByUser,
			'canManage' => $canManage,
			'loaGenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'generate'),
			'loaRegenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'regenerate'),
			'loaRevokeUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'revoke'),
			'loaViewUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view'),
		]);

		$output .= sprintf(
			'<tab id="loa" label="%s">%s</tab>',
			__('plugins.generic.loa.displayName'),
			$smarty->fetch($this->getTemplateResource('loaTab.tpl'))
		);

		return false;
	}

	public function addToBackendMenu($hookName, $args) {
		$templateMgr =& $args[0];
		$request = Application::get()->getRequest();
		$context = $request->getContext();
		$user = $request->getUser();

		if (!$context || !$user) {
			return false;
		}

		$router = $request->getRouter();
		$handler = $router->getHandler();
		$userRoles = (array) $handler->getAuthorizedContextObject(ASSOC_TYPE_USER_ROLES);

		if (!in_array(ROLE_ID_MANAGER, $userRoles) && !in_array(ROLE_ID_SITE_ADMIN, $userRoles)) {
			return false;
		}

		$menu = (array) $templateMgr->getState('menu');

		$loaLink = [
			'name' => __('plugins.generic.loa.management'),
			'url' => $router->url($request, $context->getPath(), 'loa', 'management'),
			'isCurrent' => $request->getRequestedPage() === 'loa' && $request->getRequestedOp() === 'management',
		];

		$index = array_search('issues', array_keys($menu));
		if ($index === false) {
			$index = array_search('submissions', array_keys($menu));
		}
		if ($index === false || count($menu) <= ($index + 1)) {
			$menu['loa'] = $loaLink;
		} else {
			$menu = array_slice($menu, 0, $index + 1, true) +
					['loa' => $loaLink] +
					array_slice($menu, $index + 1, null, true);
		}

		$templateMgr->setState(['menu' => $menu]);

		return false;
	}

	public function addToArticleDetails($hookName, $params) {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return false;
		}

		$smarty = &$params[1];
		$output = &$params[2];

		$submission = $smarty->get_template_vars('article');
		if (!$submission) {
			$submission = $smarty->get_template_vars('submission');
		}
		if (!$submission) {
			return false;
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->getBySubmissionId($submission->getId());

		if (!$loa) {
			return false;
		}

		$request = Application::get()->getRequest();
		$context = $request->getContext();
		$dispatcher = $request->getDispatcher();

		$smarty->assign([
			'loaDownloadUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view', [$loa->getUniqueCode()]),
			'loaUniqueCode' => $loa->getUniqueCode(),
		]);

		$output .= $smarty->fetch($this->getTemplateResource('loaDownloadLink.tpl'));

		return false;
	}
}
