<?php

import('classes.handler.Handler');

class LoAHandler extends Handler {

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

		$loaDao->markDownloaded($loa->getLoaId());

		$templateMgr = TemplateManager::getManager($request);
		$this->setupTemplate($request);

		$plugin = self::$plugin;
		$baseUrl = $request->getBaseUrl();

		$templateMgr->assign([
			'loa' => $loa,
			'submission' => $submission,
			'publication' => $publication,
			'context' => $context,
			'editorInChiefName' => $plugin->getSetting($context->getId(), 'editorInChiefName'),
			'editorInChiefTitle' => $plugin->getSetting($context->getId(), 'editorInChiefTitle'),
			'signatureImage' => $plugin->getSetting($context->getId(), 'signatureImage'),
			'stampImage' => $plugin->getSetting($context->getId(), 'stampImage'),
			'baseUrl' => $baseUrl,
		]);

		$journalPath = $context->getPath();
		$pluginPath = dirname(__FILE__) . '/..';
		$defaultTemplate = $pluginPath . '/templates/journals/default/loaView.tpl';
		$journalTemplate = $pluginPath . '/templates/journals/' . $journalPath . '/loaView.tpl';

		if (file_exists($journalTemplate)) {
			$templateMgr->display($journalTemplate);
		} else {
			$templateMgr->display($defaultTemplate);
		}
	}

	function generate($args, $request) {
		if (!$request->isPost()) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId) {
			$request->redirect(null, 'index');
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loaDao->generateCode($submissionId, $context->getId());

		$request->redirect(null, 'workflow', 'access', $submissionId);
	}

	function regenerate($args, $request) {
		if (!$request->isPost()) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId) {
			$request->redirect(null, 'index');
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loaDao->regenerateCode($submissionId, $context->getId());

		$request->redirect(null, 'workflow', 'access', $submissionId);
	}

	function revoke($args, $request) {
		if (!$request->isPost()) {
			$request->redirect(null, 'index');
		}

		$context = $request->getContext();
		$user = $request->getUser();
		if (!$user || !$user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId())) {
			$request->redirect(null, 'index');
		}

		$submissionId = (int) $request->getUserVar('submissionId');
		if (!$submissionId) {
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
}
