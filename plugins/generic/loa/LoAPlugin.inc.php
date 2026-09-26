<?php

import('lib.pkp.classes.plugins.GenericPlugin');
import('classes.i18n.AppLocale');
import('plugins.generic.loa.classes.LoADAO');
import('plugins.generic.loa.classes.LoATemplateDAO');

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
			$loaTemplateDao = new LoATemplateDAO();
			DAORegistry::registerDAO('LoATemplateDAO', $loaTemplateDao);

			HookRegistry::register('LoadHandler', [$this, 'callbackHandleContent']);
			HookRegistry::register('Template::Workflow', [$this, 'addToWorkflow']);
			HookRegistry::register('Templates::Article::Details', [$this, 'addToArticleDetails']);
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'addToBackendMenu']);
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'addIssueDialogAssets']);
			HookRegistry::register('Template::Settings::distribution', [$this, 'callbackShowDistributionTabs']);
			HookRegistry::register('Templates::Index::journal', [$this, 'callbackShowSecurityPopup']);
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
		try {
			$migration = $this->getInstallMigration();
			$migration->up();
		} catch (\Throwable $e) {
			error_log('LoA runMigration() FAILED: ' . get_class($e) . ': ' . $e->getMessage());
		}
	}

	private function runUpgradeMigration() {
		$this->runMigration();
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return;
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

			case 'saveSecuritySettings':
				$this->import('classes.LoASecurityForm');
				$form = new LoASecurityForm($this, $context->getId());
				if ($request->getUserVar('save')) {
					$form->readInputData();
					if ($form->validate()) {
						$form->execute();
						return new JSONMessage(true, __('plugins.generic.loa.securitySaved'));
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

	/**
	 * Only Journal Managers and Site Admins may publish/regenerate/revoke a LoA.
	 */
	public function canManageLoA($user, $context) {
		if (!$user || !$context) {
			return false;
		}
		return $user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN], $context->getId())
			|| $user->hasRole([ROLE_ID_SITE_ADMIN], 0);
	}

	/**
	 * Issue choices offered when publishing a LoA.
	 * @return array Array of ['id' => int, 'label' => string]
	 */
	public function getIssuesForTemplate($context) {
		$issues = [];
		if (!$context) {
			return $issues;
		}
		$issueDao = DAORegistry::getDAO('IssueDAO');
		$result = $issueDao->getIssues($context->getId());
		while ($issue = $result->next()) {
			$label = $issue->getIssueIdentification();
			if (!$issue->getPublished()) {
				$label .= ' — ' . __('plugins.generic.loa.issueUnpublished');
			}
			$issues[] = [
				'id' => (int) $issue->getId(),
				'label' => $label,
			];
		}
		return $issues;
	}

	/**
	 * Put the publication of a submission into the issue chosen in the dialog.
	 * @return object|null The matched Issue, or null when nothing was applied.
	 */
	public function assignPublicationToIssue($submissionId, $context, $issueId) {
		$issueId = (int) $issueId;
		if (!$issueId || !$context) {
			return null;
		}

		$issueDao = DAORegistry::getDAO('IssueDAO');
		$issue = $issueDao->getById($issueId, $context->getId());
		if (!$issue) {
			return null;
		}

		$submissionDao = DAORegistry::getDAO('SubmissionDAO');
		$submission = $submissionDao->getById($submissionId, $context->getId());
		if (!$submission) {
			return null;
		}

		$publication = $submission->getCurrentPublication();
		if (!$publication) {
			return null;
		}

		if ((int) $publication->getData('issueId') !== $issueId) {
			$publication->setData('issueId', $issueId);
			$publicationDao = DAORegistry::getDAO('PublicationDAO');
			$publicationDao->updateObject($publication);
		}

		return $issue;
	}

	/**
	 * Inject the shared issue-selection dialog behaviour (backend pages only).
	 */
	public function addIssueDialogAssets($hookName, $args = null) {
		$templateMgr = TemplateManager::getManager(Application::get()->getRequest());

		$templateMgr->addStyleSheet(
			'loaIssueDialog',
			$this->getIssueDialogCss(),
			['contexts' => ['backend'], 'inline' => true]
		);
		$templateMgr->addJavaScript(
			'loaIssueDialog',
			$this->getIssueDialogJs(),
			['contexts' => ['backend'], 'inline' => true]
		);
	}

	public function getIssueDialogJs() {
		return <<<'JS'
(function () {
	'use strict';

	function one(root, sel) { return root ? root.querySelector(sel) : null; }

	function findByAttr(el, attr) {
		while (el && el.nodeType === 1) {
			if (el.hasAttribute(attr)) { return el; }
			el = el.parentNode;
		}
		return null;
	}

	function showOnly(root, attr, mode) {
		var nodes = root.querySelectorAll('[data-' + attr + ']');
		for (var i = 0; i < nodes.length; i++) {
			nodes[i].hidden = nodes[i].getAttribute('data-' + attr) !== mode;
		}
	}

	function openLoaIssueDialog(trigger) {
		var d = document.getElementById('loaIssueDialog');
		if (!d) { return; }
		var form = one(d, 'form');
		var submissionInput = one(d, 'input[name="submissionId"]');
		var select = one(d, 'select[name="issueId"]');
		var field = one(d, '[data-loa-issue-field]');
		var emptyHint = one(d, '[data-loa-no-issues]');
		if (!form || !submissionInput || !select) { return; }

		var mode = trigger.getAttribute('data-mode') || 'generate';

		form.setAttribute('action', trigger.getAttribute('data-action') || '');
		submissionInput.value = trigger.getAttribute('data-submission-id') || '';

		var hasIssues = select.options.length > 0;
		if (field) { field.hidden = !hasIssues; }
		if (emptyHint) { emptyHint.hidden = hasIssues; }
		select.required = hasIssues;
		select.disabled = !hasIssues;
		if (hasIssues) {
			var wanted = trigger.getAttribute('data-issue-id') || '';
			if (wanted && select.querySelector('option[value="' + wanted + '"]')) {
				select.value = wanted;
			} else {
				select.selectedIndex = 0;
			}
		}

		showOnly(d, 'loa-label', mode);
		showOnly(d, 'loa-desc', mode);
		showOnly(d, 'loa-submit', mode);

		d.hidden = false;
		document.documentElement.classList.add('loaIssueDialogIsOpen');
		if (hasIssues) { select.focus(); }
	}

	function closeLoaIssueDialog() {
		var d = document.getElementById('loaIssueDialog');
		if (!d) { return; }
		d.hidden = true;
		document.documentElement.classList.remove('loaIssueDialogIsOpen');
	}

	window.loaOpenIssueDialog = openLoaIssueDialog;
	window.loaCloseIssueDialog = closeLoaIssueDialog;

	document.addEventListener('click', function (e) {
		var t = e.target;
		if (!t || t.nodeType !== 1) { return; }
		if (findByAttr(t, 'data-loa-dialog-close')) {
			closeLoaIssueDialog();
			return;
		}
		var trigger = findByAttr(t, 'data-loa-issue-trigger');
		if (trigger) {
			e.preventDefault();
			openLoaIssueDialog(trigger);
		}
	});

	document.addEventListener('keydown', function (e) {
		if (e.key === 'Escape') { closeLoaIssueDialog(); }
	});

	document.addEventListener('submit', function (e) {
		var form = e.target;
		if (!form || form.nodeType !== 1) { return; }
		if (form.classList.contains('loa-confirm-form')) {
			var msg = form.getAttribute('data-msg');
			if (msg && !window.confirm(msg)) { e.preventDefault(); }
		}
	}, false);
})();
JS;
	}

	public function getIssueDialogCss() {
		return <<<'CSS'
html.loaIssueDialogIsOpen, html.loaIssueDialogIsOpen body { overflow: hidden; }
.loaPageHeader { display: -webkit-box; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; -webkit-box-flex: wrap; flex-wrap: wrap; gap: 1rem; margin-bottom: 1rem; }
.loaPageHeader .app__pageHeading { margin: 0; }
.loaFilters { display: -webkit-box; display: flex; -webkit-box-flex: wrap; flex-wrap: wrap; -webkit-box-align: end; align-items: flex-end; gap: 1rem; margin: 1.25rem 0; padding: 1rem; background: #f4f6f8; border: 1px solid #d9dee3; border-radius: .25rem; }
.loaFilters__item { display: -webkit-box; display: flex; -webkit-box-orient: vertical; flex-direction: column; gap: .375rem; }
.loaFilters__item--search { -webkit-box-flex: 1; flex: 1 1 18rem; }
.loaFilters__item--issue { -webkit-box-flex: 1; flex: 1 1 16rem; }
.loaFilters__item label { font-size: .875rem; font-weight: 600; color: #1e2b34; }
.loaFilters__item input, .loaFilters__item select { width: 100%; padding: .5rem .625rem; border: 1px solid #b8c0c6; border-radius: .25rem; background: #fff; font-size: .9375rem; color: #1e2b34; }
.loaFilters__actions { display: -webkit-box; display: flex; gap: .5rem; }
.loaIssueDialog { position: fixed; top: 0; right: 0; bottom: 0; left: 0; z-index: 100000; display: -webkit-box; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: center; justify-content: center; }
.loaIssueDialog[hidden] { display: none !important; }
.loaIssueDialog__backdrop { position: absolute; top: 0; right: 0; bottom: 0; left: 0; background: rgba(18, 21, 26, .6); }
.loaIssueDialog__panel { position: relative; width: 30rem; max-width: 92vw; max-height: 90vh; overflow: auto; background: #fff; border-radius: .25rem; box-shadow: 0 18px 48px rgba(0, 0, 0, .3); padding: 1.25rem 1.5rem 1.5rem; }
.loaIssueDialog__header { display: -webkit-box; display: flex; -webkit-box-align: start; align-items: flex-start; -webkit-box-pack: justify; justify-content: space-between; gap: 1rem; margin-bottom: .5rem; }
.loaIssueDialog__title { margin: 0; font-size: 1.25rem; font-weight: 700; color: #1e2b34; }
.loaIssueDialog__close { border: 0; background: none; font-size: 1.5rem; line-height: 1; color: #67727a; cursor: pointer; padding: 0; }
.loaIssueDialog__close:hover { color: #1e2b34; }
.loaIssueDialog__desc { margin: 0 0 1rem; color: #46515a; font-size: .9375rem; line-height: 1.5; }
.loaIssueDialog__field { margin-bottom: 1rem; }
.loaIssueDialog__field[hidden] { display: none; }
.loaIssueDialog__field > label { display: block; margin-bottom: .375rem; font-weight: 600; color: #1e2b34; }
.loaIssueDialog__field select { width: 100%; padding: .5rem .625rem; border: 1px solid #b8c0c6; border-radius: .25rem; background: #fff; font-size: .9375rem; color: #1e2b34; }
.loaIssueDialog__field select:focus { outline: 2px solid #2a6ebb; outline-offset: 1px; }
.loaIssueDialog__hint { margin: .5rem 0 0; font-size: .8125rem; color: #8a6d3b; }
.loaIssueDialog__hint[hidden] { display: none; }
.loaIssueDialog__actions { display: -webkit-box; display: flex; -webkit-box-pack: end; justify-content: flex-end; gap: .5rem; margin-top: 1.25rem; }
CSS;
	}

	public function addToWorkflow($hookName, $params) {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return false;
		}

		$request = Application::get()->getRequest();
		if ($request->getRequestedPage() !== 'workflow') {
			return false;
		}

		$smarty = &$params[1];
		$output = &$params[2];
		$submission = $smarty->get_template_vars('submission');

		if (!$submission) {
			return false;
		}

		$context = $request->getContext();
		$dispatcher = $request->getDispatcher();

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->getBySubmissionId($submission->getId());

		$generatedByUser = null;
		if ($loa && $loa->getGeneratedBy()) {
			$userDao = DAORegistry::getDAO('UserDAO');
			$generatedByUser = $userDao->getById($loa->getGeneratedBy());
		}

		$publication = $submission->getCurrentPublication();
		$currentIssueId = $publication ? (int) $publication->getData('issueId') : 0;

		$smarty->assign([
			'loa' => $loa,
			'submissionId' => $submission->getId(),
			'generatedByUser' => $generatedByUser,
			'canManage' => $this->canManageLoA($request->getUser(), $context),
			'currentIssueId' => $currentIssueId,
			'loaReturnStageId' => (int) $smarty->get_template_vars('requestedStageId'),
			'loaIssues' => $this->getIssuesForTemplate($context),
			'loaGenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'generate'),
			'loaRegenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'regenerate'),
			'loaRevokeUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'revoke'),
			'loaViewUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view'),
		]);

		$output .= sprintf(
			'<tab id="loa" label="%s">%s%s</tab>',
			__('plugins.generic.loa.tabLabel'),
			$smarty->fetch($this->getTemplateResource('loaTab.tpl')),
			$smarty->fetch($this->getTemplateResource('loaIssueDialog.tpl'))
		);

		return false;
	}

	public function addToBackendMenu($hookName, $args) {
		$request = Application::get()->getRequest();
		$templateMgr = TemplateManager::getManager($request);
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

		$loaOps = ['management', 'templates', 'templateForm', 'activateTemplate', 'deleteTemplate'];
		$loaLink = [
			'name' => __('plugins.generic.loa.management'),
			'url' => $router->url($request, $context->getPath(), 'loa', 'management'),
			'isCurrent' => $request->getRequestedPage() === 'loa'
				&& in_array($request->getRequestedOp(), $loaOps, true),
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

	public function callbackShowDistributionTabs($hookName, $args) {
		$templateMgr = $args[1];
		$output =& $args[2];
		$request = Application::get()->getRequest();
		$context = $request->getContext();

		if (!$context) {
			return false;
		}

		$this->import('classes.LoASecurityForm');
		$form = new LoASecurityForm($this, $context->getId());
		$form->initData();

		$templateMgr->assign([
			'loaSecurityFormContent' => $form->fetch($request),
		]);

		$output .= $templateMgr->fetch($this->getTemplateResource('loaSecurityTab.tpl'));
		return false;
	}

	public function callbackShowSecurityPopup($hookName, $args) {
		$request = Application::get()->getRequest();
		$context = $request->getContext();

		if (!$context) {
			return false;
		}

		$enabled = $this->getSetting($context->getId(), 'loaSecurityEnabled');
		$content = $this->getSetting($context->getId(), 'loaSecurityContent');
		$title = $this->getSetting($context->getId(), 'loaSecurityTitle');

		if ($enabled && !empty(trim(strip_tags($content, '<img><p><br><div><span><a><b><i><strong><em><ul><ol><li>')))) {
			$smarty = &$args[1];
			$output = &$args[2];

			$smarty->assign([
				'loaSecurityTitle' => !empty($title) ? $title : __('plugins.generic.loa.securityModalTitle'),
				'loaSecurityContent' => $content,
			]);

			$output .= $smarty->fetch($this->getTemplateResource('loaSecurityPopup.tpl'));
		}

		return false;
	}

	public function getLoATemplateTokens($loa, $submission, $publication, $context, $request) {
		$authorNames = '';
		if ($publication) {
			$authors = $publication->getData('authors');
			if ($authors) {
				$names = [];
				foreach ($authors as $author) {
					$names[] = $author->getFullName();
				}
				$authorNames = implode(', ', $names);
			}
		}

		$validationUrl = '';
		if ($context && $request && $loa) {
			$dispatcher = $request->getDispatcher();
			$validationUrl = $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view', [$loa->getUniqueCode()]);
		}

		return [
			'[[article_title]]' => $publication ? $publication->getLocalizedTitle() : '',
			'[[authors]]' => $authorNames,
			'[[journal_name]]' => $context ? $context->getLocalizedData('name') : '',
			'[[e_issn]]' => $context ? (string) $context->getData('onlineIssn') : '',
			'[[p_issn]]' => $context ? (string) $context->getData('printIssn') : '',
			'[[unique_code]]' => $loa ? $loa->getUniqueCode() : '',
			'[[date_generated]]' => $loa ? $loa->getDateGenerated() : '',
			'[[status]]' => $loa ? $loa->getStatus() : '',
			'[[editor_in_chief_name]]' => $context ? (string) $this->getSetting($context->getId(), 'editorInChiefName') : '',
			'[[editor_in_chief_title]]' => $context ? (string) $this->getSetting($context->getId(), 'editorInChiefTitle') : '',
			'[[base_url]]' => $request ? $request->getBaseUrl() : '',
			'[[current_locale]]' => AppLocale::getLocale(),
			'[[validation_url]]' => $validationUrl,
			'[[qr_code]]' => $validationUrl !== '' ? '<img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=' . urlencode($validationUrl) . '" alt="QR Code" />' : '',
		];
	}

	public function substituteLoATemplateTokens($templateContent, array $tokens) {
		foreach ($tokens as $token => $value) {
			$templateContent = str_replace($token, $value, $templateContent);
		}
		return $templateContent;
	}

	/**
	 * Extract a renderable fragment from a (possibly full) HTML document.
	 * Returns ['style' => combined <style> blocks, 'html' => <body> content
	 * (or the whole input minus document scaffolding when no <body>)].
	 */
	public function extractTemplateFragment($html) {
		if ($html === null || trim($html) === '') {
			return ['style' => '', 'html' => ''];
		}

		$styleBlocks = [];

		if (preg_match('/<body[^>]*>(.*)<\/body>/is', $html, $matches)) {
			$body = $matches[1];
			if (preg_match_all('/<style[^>]*>(.*?)<\/style>/is', $html, $matches)) {
				foreach ($matches[1] as $block) {
					if (trim($block) !== '') {
						$styleBlocks[] = trim($block);
					}
				}
			}
		} else {
			$body = $html;
			$body = preg_replace('/<!DOCTYPE[^>]*>/i', '', $body);
			$body = preg_replace('/<\/?(html|head)[^>]*>/i', '', $body);

			$body = preg_replace_callback('/<style[^>]*>(.*?)<\/style>/is', function ($matches) use (&$styleBlocks) {
				if (trim($matches[1]) !== '') {
					$styleBlocks[] = trim($matches[1]);
				}
				return '';
			}, $body);

			if (preg_match('/<([a-z][a-z0-9]*)[^>]*>/is', $body, $m, PREG_OFFSET_CAPTURE)) {
				$pos = $m[0][1];
				$headRaw = trim(substr($body, 0, $pos));
				$body = substr($body, $pos);
				if ($headRaw !== '') {
					$styleBlocks[] = $headRaw;
				}
			}
		}

		$style = $styleBlocks ? '<style>' . implode("\n", $styleBlocks) . '</style>' : '';

		return ['style' => trim($style), 'html' => trim($body)];
	}

	public function generateLoAWithSnapshot($submissionId, $context, $userId, $request, $issueId = null) {
		$this->assignPublicationToIssue($submissionId, $context, $issueId);

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->generateCode($submissionId, $context->getId(), $userId, null, null, $issueId);

		if ($loa && $loa->getContentSnapshot() === null) {
			$loaTemplateDao = DAORegistry::getDAO('LoATemplateDAO');
			$activeTemplate = $loaTemplateDao->getActiveByJournalId($context->getId());
			if ($activeTemplate) {
				$submissionDao = DAORegistry::getDAO('SubmissionDAO');
				$submission = $submissionDao->getById($submissionId);
				$publication = $submission ? $submission->getCurrentPublication() : null;
				$tokens = $this->getLoATemplateTokens($loa, $submission, $publication, $context, $request);
				$html = $this->substituteLoATemplateTokens($activeTemplate->getTemplateContent(), $tokens);
				$frag = $this->extractTemplateFragment($html);
				$loa->setTemplateId($activeTemplate->getTemplateId());
				$loa->setContentSnapshot($loaDao->compressSnapshot($frag['style'] . "\n" . $frag['html']));
				$loaDao->updateObject($loa);
			}
		}

		return $loa;
	}

	public function regenerateLoAWithSnapshot($submissionId, $context, $userId, $request, $issueId = null) {
		$this->assignPublicationToIssue($submissionId, $context, $issueId);

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loaDao->revokeBySubmissionId($submissionId);
		return $this->generateLoAWithSnapshot($submissionId, $context, $userId, $request, $issueId);
	}

	public function sanitizeHtml($html) {
		if ($html === null || trim($html) === '') {
			return '';
		}

		$html = preg_replace('/\son[a-z]+\s*=\s*("[^"]*"|\'[^\']*\'|[^\s>]+)/i', '', $html);
		$html = preg_replace_callback('/\bstyle\s*=\s*(["\'])(.*?)\1/i', function ($m) {
			$value = $m[2];
			$value = preg_replace('/expression\s*\(/i', '', $value);
			$value = preg_replace('/\bjavascript\s*:/i', '', $value);
			$value = preg_replace('/\bbase64\s*:/i', '', $value);
			return 'style="' . $value . '"';
		}, $html);
		$html = preg_replace('/<(a|img)[^>]*\b(href|src)\s*=\s*(["\'])\s*(javascript|data):[^"\']*\3[^>]*>/i', '<$1>', $html);

		return $html;
	}
}

