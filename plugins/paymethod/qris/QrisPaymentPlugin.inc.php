<?php

/**
 * @file plugins/paymethod/qris/QrisPaymentPlugin.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class QrisPaymentPlugin
 * @ingroup plugins_paymethod_qris
 *
 * @brief QRIS static payment plugin class
 */

import('lib.pkp.classes.plugins.PaymethodPlugin');

class QrisPaymentPlugin extends PaymethodPlugin {

	/**
	 * @copydoc Plugin::getName
	 */
	function getName() {
		return 'QrisPayment';
	}

	/**
	 * @copydoc Plugin::getDisplayName
	 */
	function getDisplayName() {
		return __('plugins.paymethod.qris.displayName');
	}

	/**
	 * @copydoc Plugin::getDescription
	 */
	function getDescription() {
		return __('plugins.paymethod.qris.description');
	}

	/**
	 * @copydoc Plugin::register()
	 */
	function register($category, $path, $mainContextId = null) {
		if (parent::register($category, $path, $mainContextId)) {
			$this->addLocaleData();
			\HookRegistry::register('Form::config::before', array($this, 'addSettings'));
			return true;
		}
		return false;
	}

	/**
	 * Add settings to the payments form
	 *
	 * @param $hookName string
	 * @param $form FormComponent
	 */
	public function addSettings($hookName, $form) {
		import('lib.pkp.classes.components.forms.context.PKPPaymentSettingsForm'); // Load constant
		if ($form->id !== FORM_PAYMENT_SETTINGS) {
			return;
		}

		$context = Application::get()->getRequest()->getContext();
		if (!$context) {
			return;
		}

		$form->addGroup([
				'id' => 'qrispayment',
				'label' => __('plugins.paymethod.qris.displayName'),
				'showWhen' => 'paymentsEnabled',
			])
			->addField(new \PKP\components\forms\FieldText('qrisImageUrl', [
				'label' => __('plugins.paymethod.qris.settings.qrisImageUrl'),
				'description' => __('plugins.paymethod.qris.settings.qrisImageUrl.description'),
				'value' => $this->getSetting($context->getId(), 'qrisImageUrl'),
				'groupId' => 'qrispayment',
			]))
			->addField(new \PKP\components\forms\FieldTextArea('qrisInstructions', [
				'label' => __('plugins.paymethod.qris.settings.instructions'),
				'value' => $this->getSetting($context->getId(), 'qrisInstructions'),
				'groupId' => 'qrispayment',
			]));

		return;
	}

	/**
	 * @copydoc PaymethodPlugin::saveSettings()
	 */
	public function saveSettings($params, $slimRequest, $request) {
		$allParams = $slimRequest->getParsedBody();
		$qrisImageUrl = isset($allParams['qrisImageUrl']) ? (string) $allParams['qrisImageUrl'] : '';
		$qrisInstructions = isset($allParams['qrisInstructions']) ? (string) $allParams['qrisInstructions'] : '';
		$this->updateSetting($request->getContext()->getId(), 'qrisImageUrl', $qrisImageUrl);
		$this->updateSetting($request->getContext()->getId(), 'qrisInstructions', $qrisInstructions);
		return [];
	}

	/**
	 * @copydoc PaymethodPlugin::isConfigured
	 */
	function isConfigured($context) {
		if (!$context) return false;
		if ($this->getSetting($context->getId(), 'qrisImageUrl') == '') return false;
		return true;
	}

	/**
	 * @copydoc PaymethodPlugin::getPaymentForm
	 */
	function getPaymentForm($context, $queuedPayment) {
		if (!$this->isConfigured($context)) return null;

		AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON);

		import('lib.pkp.classes.form.Form');
		$paymentForm = new Form($this->getTemplateResource('paymentForm.tpl'));
		$paymentManager = Application::getPaymentManager($context);
		$paymentForm->setData(array(
			'itemName' => $paymentManager->getPaymentName($queuedPayment),
			'itemAmount' => $queuedPayment->getAmount()>0?$queuedPayment->getAmount():null,
			'itemCurrencyCode' => $queuedPayment->getAmount()>0?$queuedPayment->getCurrencyCode():null,
			'qrisImageUrl' => $this->getSetting($context->getId(), 'qrisImageUrl'),
			'qrisInstructions' => $this->getSetting($context->getId(), 'qrisInstructions'),
			'queuedPaymentId' => $queuedPayment->getId(),
		));
		return $paymentForm;
	}

	/**
	 * Check whether the given user can act on a queued payment:
	 * the payment's owner, or a Journal Manager / Subscription Manager.
	 * @param $user User
	 * @param $queuedPayment QueuedPayment
	 * @param $context Context
	 * @return boolean
	 */
	protected function _canUserActOnPayment($user, $queuedPayment, $context) {
		if (!$user) return false;
		if ($queuedPayment->getUserId() == $user->getId()) return true;
		$roleDao = DAORegistry::getDAO('RoleDAO'); /* @var $roleDao RoleDAO */
		return $roleDao->userHasRole($context->getId(), $user->getId(), array(ROLE_ID_MANAGER, ROLE_ID_SUBSCRIPTION_MANAGER));
	}

	/**
	 * Handle incoming requests/notifications
	 * @param $args array
	 * @param $request PKPRequest
	 */
	function handle($args, $request) {
		$context = $request->getContext();
		$templateMgr = TemplateManager::getManager($request);
		$user = $request->getUser();
		$op = isset($args[0])?$args[0]:null;
		$queuedPaymentId = isset($args[1])?((int) $args[1]):0;

		$queuedPaymentDao = DAORegistry::getDAO('QueuedPaymentDAO'); /* @var $queuedPaymentDao QueuedPaymentDAO */
		$queuedPayment = $queuedPaymentDao->getById($queuedPaymentId);
		$paymentManager = Application::getPaymentManager($context);
		// if the queued payment doesn't exist, redirect away from payments
		if (!$queuedPayment) $request->redirect(null, 'index');

		switch ($op) {
			case 'notify':
				// Require login: must be payment owner or manager/sub. manager
				if (!$user || !$this->_canUserActOnPayment($user, $queuedPayment, $context)) {
					$request->redirect(null, 'index');
				}

				// Idempotency: if already completed, don't fulfill again
				$completedPaymentDao = DAORegistry::getDAO('OJSCompletedPaymentDAO'); /* @var $completedPaymentDao OJSCompletedPaymentDAO */
				$existingCompleted = $completedPaymentDao->getByAssoc($queuedPayment->getUserId(), $queuedPayment->getType(), $queuedPayment->getAssocId());
				if ($existingCompleted) {
					$templateMgr->assign(array(
						'currentUrl' => $request->url(null, null, 'payment', 'plugin', array('notify', $queuedPaymentId)),
						'pageTitle' => 'plugins.paymethod.qris.paymentNotification',
						'message' => 'plugins.paymethod.qris.notificationSent',
						'backLink' => $queuedPayment->getRequestUrl(),
						'backLinkLabel' => 'common.continue'
					));
					$templateMgr->display('frontend/pages/message.tpl');
					exit();
				}

				import('lib.pkp.classes.mail.MailTemplate');
				AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON);
				$contactName = $context->getData('contactName');
				$contactEmail = $context->getData('contactEmail');
				$mail = new MailTemplate('QRIS_PAYMENT_NOTIFICATION');
				$mail->setReplyTo(null);
				$mail->addRecipient($contactEmail, $contactName);

				// Handle proof-of-payment file upload with server-side validation
				$proofInfo = '';
				if (isset($_FILES['qrisProofOfPayment']) && $_FILES['qrisProofOfPayment']['error'] == UPLOAD_ERR_OK) {
					$allowedMimeTypes = array('image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf');
					$uploadedFile = $_FILES['qrisProofOfPayment'];
					$detectedType = PKPString::mime_content_type($uploadedFile['tmp_name']);

					if (in_array($detectedType, $allowedMimeTypes)) {
						import('lib.pkp.classes.file.TemporaryFileManager');
						$temporaryFileManager = new TemporaryFileManager();
						$temporaryFile = $temporaryFileManager->handleUpload('qrisProofOfPayment', $user->getId());
						if ($temporaryFile) {
							$proofFilePath = $temporaryFileManager->getBasePath() . $temporaryFile->getServerFileName();
							$mail->addAttachment($proofFilePath, $temporaryFile->getOriginalFileName(), $temporaryFile->getFileType());
							$proofDownloadUrl = $request->url(null, 'payment', 'plugin', array('QrisPayment', 'downloadProof', $queuedPaymentId, $temporaryFile->getId()));
							$proofInfo = __('plugins.paymethod.qris.proofUploaded', array('proofUrl' => $proofDownloadUrl));
						}
					}
				}

				$mail->assignParams(array(
					'contextName' => htmlspecialchars($context->getLocalizedName()),
					'userFullName' => htmlspecialchars($user?$user->getFullName():('(' . __('common.none') . ')')),
					'userName' => htmlspecialchars($user?$user->getUsername():('(' . __('common.none') . ')')),
					'itemName' => htmlspecialchars($paymentManager->getPaymentName($queuedPayment)),
					'itemCost' => htmlspecialchars($queuedPayment->getAmount()),
					'itemCurrencyCode' => $queuedPayment->getCurrencyCode(),
					'proofInfo' => $proofInfo
				));
				if ($mail->isEnabled()) {
					$mail->send();
				}

				// Fulfill the queued payment so it appears in completed payments / payments tab
				$paymentManager->fulfillQueuedPayment($request, $queuedPayment, $this->getName());

				$templateMgr->assign(array(
					'currentUrl' => $request->url(null, null, 'payment', 'plugin', array('notify', $queuedPaymentId)),
					'pageTitle' => 'plugins.paymethod.qris.paymentNotification',
					'message' => 'plugins.paymethod.qris.notificationSent',
					'backLink' => $queuedPayment->getRequestUrl(),
					'backLinkLabel' => 'common.continue'
				));
				$templateMgr->display('frontend/pages/message.tpl');
				exit();
			case 'downloadProof':
				if (!$user) $request->redirect(null, 'index');
				import('lib.pkp.classes.file.TemporaryFileManager');
				$temporaryFileManager = new TemporaryFileManager();
				$temporaryFileId = isset($args[2]) ? (int) $args[2] : 0;
				// Owner can download their own upload; managers/sub. managers can download any
				$roleDao = DAORegistry::getDAO('RoleDAO'); /* @var $roleDao RoleDAO */
				$isManager = $roleDao->userHasRole($context->getId(), $user->getId(), array(ROLE_ID_MANAGER, ROLE_ID_SUBSCRIPTION_MANAGER));
				if ($isManager) {
					$temporaryFileDao = DAORegistry::getDAO('TemporaryFileDAO'); /* @var $temporaryFileDao TemporaryFileDAO */
					$temporaryFile = $temporaryFileDao->getTemporaryFile($temporaryFileId, $user->getId());
					if (!$temporaryFile) {
						// Manager: fetch without ownership restriction
						$result = $temporaryFileDao->retrieve('SELECT * FROM temporary_files WHERE file_id = ?', array((int) $temporaryFileId));
						$row = (array) $result->current();
						$temporaryFile = $row ? $temporaryFileDao->_returnTemporaryFileFromRow($row) : null;
					}
					if ($temporaryFile) {
						$filePath = $temporaryFileManager->getBasePath() . $temporaryFile->getServerFileName();
						$temporaryFileManager->downloadByPath($filePath, $temporaryFile->getFileType(), false);
					}
				} else {
					// Regular user: only own file
					$temporaryFileManager->downloadById($temporaryFileId, $user->getId());
				}
				exit();
		}
		parent::handle($args, $request); // Don't know what to do with it
	}

	/**
	 * @copydoc Plugin::getInstallEmailTemplatesFile
	 */
	function getInstallEmailTemplatesFile() {
		return ($this->getPluginPath() . DIRECTORY_SEPARATOR . 'emailTemplates.xml');
	}
}
