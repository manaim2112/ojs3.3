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
				import('lib.pkp.classes.mail.MailTemplate');
				AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON);
				$contactName = $context->getData('contactName');
				$contactEmail = $context->getData('contactEmail');
				$mail = new MailTemplate('QRIS_PAYMENT_NOTIFICATION');
				$mail->setReplyTo(null);
				$mail->addRecipient($contactEmail, $contactName);
				$mail->assignParams(array(
					'contextName' => htmlspecialchars($context->getLocalizedName()),
					'userFullName' => htmlspecialchars($user?$user->getFullName():('(' . __('common.none') . ')')),
					'userName' => htmlspecialchars($user?$user->getUsername():('(' . __('common.none') . ')')),
					'itemName' => htmlspecialchars($paymentManager->getPaymentName($queuedPayment)),
					'itemCost' => htmlspecialchars($queuedPayment->getAmount()),
					'itemCurrencyCode' => $queuedPayment->getCurrencyCode()
				));
				if ($mail->isEnabled()) {
					$mail->send();
				}

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
		parent::handle($args, $request); // Don't know what to do with it
	}

	/**
	 * @copydoc Plugin::getInstallEmailTemplatesFile
	 */
	function getInstallEmailTemplatesFile() {
		return ($this->getPluginPath() . DIRECTORY_SEPARATOR . 'emailTemplates.xml');
	}
}
