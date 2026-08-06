<?php

import('classes.handler.Handler');

class LoAHandler extends Handler {

	var $_isBackendPage = true;

	static $plugin;

	static function setPlugin($plugin) {
		self::$plugin = $plugin;
	}

	function view($args, $request) {
		$code = array_shift($args);
		if (!$code) {
			$request->redirect(null, 'index');
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->getByUniqueCode($code);

		if (!$loa) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$submissionDao = DAORegistry::getDAO('SubmissionDAO');
		$submission = $submissionDao->getById($loa->getSubmissionId());

		if (!$submission || $submission->getData('contextId') != $context->getId()) {
			$request->redirect(null, 'index');
		}

		$publication = $submission->getCurrentPublication();

		if ($loa->getStatus() === 'active') {
			$loaDao->markDownloaded($loa->getLoaId());
		}

		$templateMgr = TemplateManager::getManager($request);
		$this->setupTemplate($request);

		$plugin = self::$plugin;
		$isRevoked = $loa->getStatus() === 'revoked';

		$snapshot = $loaDao->decompressSnapshot($loa->getContentSnapshot());
		if ($snapshot !== null) {
			$frag = $plugin->extractTemplateFragment($snapshot);
			$templateMgr->assign([
				'loa' => $loa,
				'context' => $context,
				'isRevoked' => $isRevoked,
				'templateStyle' => $frag['style'],
				'templateHtml' => $frag['html'],
			]);
			$templateMgr->display($plugin->getTemplateResource('loaDbView.tpl'));
			return;
		}

		$loaTemplateDao = DAORegistry::getDAO('LoATemplateDAO');
		$activeTemplate = $loaTemplateDao->getActiveByJournalId($context->getId());
		if ($activeTemplate) {
			$tokens = $plugin->getLoATemplateTokens($loa, $submission, $publication, $context, $request);
			$html = $plugin->substituteLoATemplateTokens($activeTemplate->getTemplateContent(), $tokens);
			$frag = $plugin->extractTemplateFragment($html);
			$templateMgr->assign([
				'loa' => $loa,
				'context' => $context,
				'isRevoked' => $isRevoked,
				'templateStyle' => $frag['style'],
				'templateHtml' => $frag['html'],
			]);
			$templateMgr->display($plugin->getTemplateResource('loaDbView.tpl'));
			return;
		}

		$templateMgr->assign([
			'loa' => $loa,
			'submission' => $submission,
			'publication' => $publication,
			'context' => $context,
			'editorInChiefName' => $plugin->getSetting($context->getId(), 'editorInChiefName'),
			'editorInChiefTitle' => $plugin->getSetting($context->getId(), 'editorInChiefTitle'),
			'baseUrl' => $request->getBaseUrl(),
			'loaDateGeneratedFormatted' => date('d/m/Y', strtotime($loa->getDateGenerated())),
			'loaHeaderImageUrl' => $plugin->getSetting($context->getId(), 'loaHeaderImageUrl'),
			'loaIndexingImageUrl' => $plugin->getSetting($context->getId(), 'loaIndexingImageUrl'),
			'loaIssn' => $plugin->getSetting($context->getId(), 'loaIssn'),
			'loaUniversityName' => $plugin->getSetting($context->getId(), 'loaUniversityName'),
		]);

		$pluginPath = dirname(__FILE__) . '/..';
		$defaultTemplate = $pluginPath . '/templates/journals/default/loaView.tpl';
		$journalTemplate = $pluginPath . '/templates/journals/' . $context->getPath() . '/loaView.tpl';

		$templatePath = file_exists($journalTemplate) ? $journalTemplate : $defaultTemplate;
		$templateMgr->display('file:' . $templatePath);
	}

	function _verifySubmissionInContext($request, $submissionId) {
		$context = $request->getContext();
		$submissionDao = DAORegistry::getDAO('SubmissionDAO');
		$submission = $submissionDao->getById($submissionId);
		if (!$submission || $submission->getData('contextId') != $context->getId()) {
			return false;
		}
		return $submission;
	}

	function generate($args, $request) {
		if (!$request->isPost() || !$request->checkCSRF()) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId || !$this->_verifySubmissionInContext($request, $submissionId)) {
			$request->redirect(null, 'index');
		}

		self::$plugin->generateLoAWithSnapshot($submissionId, $context, $user->getId(), $request);

		$request->redirect(null, 'workflow', 'access', $submissionId);
	}

	function regenerate($args, $request) {
		if (!$request->isPost() || !$request->checkCSRF()) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId || !$this->_verifySubmissionInContext($request, $submissionId)) {
			$request->redirect(null, 'index');
		}

		self::$plugin->regenerateLoAWithSnapshot($submissionId, $context, $user->getId(), $request);

		$request->redirect(null, 'workflow', 'access', $submissionId);
	}

	function revoke($args, $request) {
		if (!$request->isPost() || !$request->checkCSRF()) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId || !$this->_verifySubmissionInContext($request, $submissionId)) {
			$request->redirect(null, 'index');
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loaDao->revokeBySubmissionId($submissionId);

		$request->redirect(null, 'workflow', 'access', $submissionId);
	}

	function verification($args, $request) {
		$templateMgr = TemplateManager::getManager($request);
		$this->setupTemplate($request);

		$result = null;
		$submission = null;
		$publication = null;
		$context = $request->getContext();
		$code = '';
		$loa = null;

		if ($request->isPost()) {
			$code = trim($request->getUserVar('code'));
			if (!empty($code)) {
				$loaDao = DAORegistry::getDAO('LoADAO');
				$loa = $loaDao->getByUniqueCode($code);

				if ($loa && $loa->getStatus() === 'active' && $loa->getJournalId() == $context->getId()) {
					$submissionDao = DAORegistry::getDAO('SubmissionDAO');
					$submission = $submissionDao->getById($loa->getSubmissionId());
					if ($submission) {
						$publication = $submission->getCurrentPublication();
					}
					$result = 'valid';
				} else {
					$result = 'invalid';
				}
			} else {
				$result = 'empty';
			}
		}

		$templateMgr->assign([
			'result' => $result,
			'code' => $code,
			'loa' => $loa,
			'submission' => $submission,
			'publication' => $publication,
			'context' => $context,
		]);

		$templateMgr->display(self::$plugin->getTemplateResource('loaVerification.tpl'));
	}

	function management($args, $request) {
		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$templateMgr = TemplateManager::getManager($request);
		$this->setupTemplate($request);

		$dispatcher = $request->getDispatcher();
		$loaDao = DAORegistry::getDAO('LoADAO');

		$rangeInfo = $this->getRangeInfo($request, 'loa_management');

		$articles = $loaDao->getPublishedArticlesByJournalId($context->getId(), $rangeInfo);

		$templateMgr->assign([
			'articles' => $articles,
			'loaGenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'generateFromManagement'),
			'loaRevokeUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'revokeFromManagement'),
			'loaViewUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view'),
			'csrfToken' => $request->getSession()->getCsrfToken(),
		]);

		$templateMgr->display(self::$plugin->getTemplateResource('loaManagement.tpl'));
	}

	function generateFromManagement($args, $request) {
		if (!$request->isPost()) {
			$request->redirect(null, 'loa', 'management');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		if (!$request->checkCSRF()) {
			$request->redirect(null, 'loa', 'management');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId) {
			$request->redirect(null, 'loa', 'management');
		}

		$submissionDao = DAORegistry::getDAO('SubmissionDAO');
		$submission = $submissionDao->getById($submissionId);
		if (!$submission || $submission->getData('contextId') != $context->getId()) {
			$request->redirect(null, 'loa', 'management');
		}

		self::$plugin->generateLoAWithSnapshot($submissionId, $context, $user->getId(), $request);

		$request->redirect(null, 'loa', 'management');
	}

	function revokeFromManagement($args, $request) {
		if (!$request->isPost()) {
			$request->redirect(null, 'loa', 'management');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		if (!$request->checkCSRF()) {
			$request->redirect(null, 'loa', 'management');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId) {
			$request->redirect(null, 'loa', 'management');
		}

		$submissionDao = DAORegistry::getDAO('SubmissionDAO');
		$submission = $submissionDao->getById($submissionId);
		if (!$submission || $submission->getData('contextId') != $context->getId()) {
			$request->redirect(null, 'loa', 'management');
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loaDao->revokeBySubmissionId($submissionId);

		$request->redirect(null, 'loa', 'management');
	}

	function templates($args, $request) {
		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$templateMgr = TemplateManager::getManager($request);
		$this->setupTemplate($request);
		$dispatcher = $request->getDispatcher();

		$templateDao = DAORegistry::getDAO('LoATemplateDAO');
		$rangeInfo = $this->getRangeInfo($request, 'loa_templates');
		$templates = $templateDao->getByJournalId($context->getId(), $rangeInfo);

		$templateMgr->assign([
			'templates' => $templates,
			'addTemplateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'templateForm'),
			'editTemplateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'templateForm'),
			'activateTemplateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'activateTemplate'),
			'deleteTemplateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'deleteTemplate'),
			'loaManagementUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'management'),
			'csrfToken' => $request->getSession()->getCsrfToken(),
		]);

		$templateMgr->display(self::$plugin->getTemplateResource('loaTemplates.tpl'));
	}

	function templateForm($args, $request) {
		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$templateId = (int) array_shift($args);

		$plugin = self::$plugin;
		$plugin->import('classes.LoATemplateForm');
		$form = new LoATemplateForm($plugin, $context->getId(), $templateId ?: null);

		if ($request->isPost()) {
			$form->readInputData();
			if ($form->validate()) {
				$form->execute();
				$request->redirect(null, 'loa', 'templates');
			}
		} else {
			$form->initData();
		}

		$templateMgr = TemplateManager::getManager($request);
		$this->setupTemplate($request);
		$templateMgr->assign([
			'formContent' => $form->fetch($request),
			'backToListUrl' => $request->getDispatcher()->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'templates'),
		]);

		$templateMgr->display($plugin->getTemplateResource('loaTemplateFormPage.tpl'));
	}

	function deleteTemplate($args, $request) {
		$context = $request->getContext();
		$user = $request->getUser();
		if (!$request->isPost() || !$request->checkCSRF()) {
			$request->redirect(null, 'loa', 'templates');
		}
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$templateId = (int) $request->getUserVar('templateId');
		$templateDao = DAORegistry::getDAO('LoATemplateDAO');
		$template = $templateId ? $templateDao->getById($templateId) : null;
		if (!$template || $template->getJournalId() != $context->getId()) {
			$request->redirect(null, 'loa', 'templates');
		}

		$templateDao->deleteById($templateId, $context->getId());

		$request->redirect(null, 'loa', 'templates');
	}

	function activateTemplate($args, $request) {
		$context = $request->getContext();
		$user = $request->getUser();
		if (!$request->isPost() || !$request->checkCSRF()) {
			$request->redirect(null, 'loa', 'templates');
		}
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$templateId = (int) $request->getUserVar('templateId');
		$templateDao = DAORegistry::getDAO('LoATemplateDAO');
		$template = $templateId ? $templateDao->getById($templateId) : null;
		if (!$template || $template->getJournalId() != $context->getId()) {
			$request->redirect(null, 'loa', 'templates');
		}

		$templateDao->activate($templateId, $context->getId());

		$request->redirect(null, 'loa', 'templates');
	}
}
