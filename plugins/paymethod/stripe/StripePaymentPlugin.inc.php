<?php

/**
 * @file plugins/paymethod/stripe/StripePaymentPlugin.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class StripePaymentPlugin
 * @ingroup plugins_paymethod_stripe
 *
 * @brief Stripe payment plugin class
 */

import('lib.pkp.classes.plugins.PaymethodPlugin');
require_once(dirname(__FILE__) . '/vendor/autoload.php');

class StripePaymentPlugin extends PaymethodPlugin {

	/**
	 * @see Plugin::getName
	 */
	function getName() {
		return 'StripePayment';
	}

	/**
	 * @see Plugin::getDisplayName
	 */
	function getDisplayName() {
		return __('plugins.paymethod.stripe.displayName');
	}

	/**
	 * @see Plugin::getDescription
	 */
	function getDescription() {
		return __('plugins.paymethod.stripe.description');
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
				'id' => 'stripepayment',
				'label' => __('plugins.paymethod.stripe.displayName'),
				'showWhen' => 'paymentsEnabled',
			])
			->addField(new \PKP\components\forms\FieldOptions('testMode', [
				'label' => __('plugins.paymethod.stripe.settings.testMode'),
				'options' => [
					['value' => true, 'label' => __('common.enable')]
				],
				'value' => (bool) $this->getSetting($context->getId(), 'testMode'),
				'groupId' => 'stripepayment',
			]))
			->addField(new \PKP\components\forms\FieldText('publishableKey', [
				'label' => __('plugins.paymethod.stripe.settings.publishableKey'),
				'value' => $this->getSetting($context->getId(), 'publishableKey'),
				'groupId' => 'stripepayment',
			]))
			->addField(new \PKP\components\forms\FieldText('secretKey', [
				'label' => __('plugins.paymethod.stripe.settings.secretKey'),
				'value' => $this->getSetting($context->getId(), 'secretKey'),
				'groupId' => 'stripepayment',
			]))
			->addField(new \PKP\components\forms\FieldText('webhookSecret', [
				'label' => __('plugins.paymethod.stripe.settings.webhookSecret'),
				'value' => $this->getSetting($context->getId(), 'webhookSecret'),
				'groupId' => 'stripepayment',
			]));

		return;
	}

	/**
	 * @copydoc PaymethodPlugin::saveSettings()
	 */
	public function saveSettings($params, $slimRequest, $request) {
		$allParams = $slimRequest->getParsedBody();
		$saveParams = [];
		foreach ($allParams as $param => $val) {
			switch ($param) {
				case 'publishableKey':
				case 'secretKey':
				case 'webhookSecret':
					$saveParams[$param] = (string) $val;
					break;
				case 'testMode':
					$saveParams[$param] = $val === 'true';
					break;
			}
		}
		$contextId = $request->getContext()->getId();
		foreach ($saveParams as $param => $val) {
			$this->updateSetting($contextId, $param, $val);
		}
		return [];
	}

	/**
	 * @copydoc PaymethodPlugin::getPaymentForm()
	 */
	function getPaymentForm($context, $queuedPayment) {
		$this->import('StripePaymentForm');
		return new StripePaymentForm($this, $queuedPayment);
	}

	/**
	 * @copydoc PaymethodPlugin::isConfigured
	 */
	function isConfigured($context) {
		if (!$context) return false;
		if ($this->getSetting($context->getId(), 'secretKey') == '') return false;
		return true;
	}

	/**
	 * Initialize the Stripe SDK with the configured secret key
	 * @param $contextId int
	 */
	private function _initStripe($contextId) {
		\Stripe\Stripe::setApiKey($this->getSetting($contextId, 'secretKey'));
		if ($this->getSetting($contextId, 'testMode')) {
			\Stripe\Stripe::setApiKey($this->getSetting($contextId, 'secretKey'));
		}
	}

	/**
	 * Handle the return from Stripe Checkout and verify the session
	 * @param $args array
	 * @param $request PKPRequest
	 */
	function handle($args, $request) {
		$journal = $request->getJournal();
		$queuedPaymentDao = DAORegistry::getDAO('QueuedPaymentDAO'); /* @var $queuedPaymentDao QueuedPaymentDAO */
		import('classes.payment.ojs.OJSPaymentManager'); // Class definition required for unserializing

		try {
			$queuedPayment = $queuedPaymentDao->getById($queuedPaymentId = $request->getUserVar('queuedPaymentId'));
			if (!$queuedPayment) throw new \Exception("Invalid queued payment ID $queuedPaymentId!");

			$this->_initStripe($journal->getId());

			// Stripe redirects back with a session_id parameter
			$sessionId = $request->getUserVar('session_id');
			if (!$sessionId) throw new \Exception('No Stripe session ID returned!');

			$session = \Stripe\Checkout\Session::retrieve($sessionId);

			if ($session->payment_status !== 'paid') {
				throw new \Exception('Stripe payment status is ' . $session->payment_status . ', not paid!');
			}

			// Verify amount and currency match
			$expectedAmount = (int) round($queuedPayment->getAmount() * 100);
			if ((int) $session->amount_total !== $expectedAmount) {
				throw new \Exception('Amounts (' . ($session->amount_total / 100) . ' vs ' . $queuedPayment->getAmount() . ') don\'t match!');
			}
			if (strtolower($session->currency) !== strtolower($queuedPayment->getCurrencyCode())) {
				throw new \Exception('Currencies (' . $session->currency . ' vs ' . $queuedPayment->getCurrencyCode() . ') don\'t match!');
			}

			$paymentManager = Application::getPaymentManager($journal);
			$paymentManager->fulfillQueuedPayment($request, $queuedPayment, $this->getName());
			$request->redirectUrl($queuedPayment->getRequestUrl());
		} catch (\Exception $e) {
			error_log('Stripe transaction exception: ' . $e->getMessage());
			$templateMgr = TemplateManager::getManager($request);
			$templateMgr->assign('message', 'plugins.paymethod.stripe.error');
			$templateMgr->display('frontend/pages/message.tpl');
		}
	}

	/**
	 * @see Plugin::getInstallEmailTemplatesFile
	 */
	function getInstallEmailTemplatesFile() {
		return ($this->getPluginPath() . DIRECTORY_SEPARATOR . 'emailTemplates.xml');
	}
}
