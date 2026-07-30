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
			]))
			->addField(new \PKP\components\forms\FieldText('webhookUrl', [
				'label' => __('plugins.paymethod.stripe.settings.webhookUrl'),
				'value' => Application::get()->getRequest()->url($context->getPath(), 'payment', 'plugin', array($this->getName(), 'webhook')),
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
		$secretKey = $this->getSetting($contextId, 'secretKey');
		\Stripe\Stripe::setApiKey($secretKey);
	}

	/**
	 * Handle requests from Stripe (return redirect and webhook).
	 * @param $args array First element is the action: 'return' (default) or 'webhook'.
	 * @param $request PKPRequest
	 */
	function handle($args, $request) {
		$op = isset($args[0]) ? $args[0] : null;
		switch ($op) {
			case 'webhook':
				$this->_handleWebhook($request);
				break;
			default:
				$this->_handleReturn($request);
				break;
		}
	}

	/**
	 * Handle the return redirect from Stripe Checkout and verify the session.
	 * Idempotent: if the payment was already fulfilled (e.g. via webhook),
	 * getById returns null and we simply redirect to the request URL.
	 * @param $request PKPRequest
	 */
	private function _handleReturn($request) {
		$journal = $request->getJournal();
		$queuedPaymentDao = DAORegistry::getDAO('QueuedPaymentDAO'); /* @var $queuedPaymentDao QueuedPaymentDAO */
		import('classes.payment.ojs.OJSPaymentManager'); // Class definition required for unserializing

		try {
			$queuedPayment = $queuedPaymentDao->getById($queuedPaymentId = $request->getUserVar('queuedPaymentId'));
			if (!$queuedPayment) {
				// Already fulfilled (likely by webhook) — nothing to do.
				$request->redirect(null, null, 'index');
			}

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
	 * Handle incoming Stripe webhook events.
	 * Verifies the signature using the configured webhook secret,
	 * then fulfills the payment if it hasn't been already.
	 * @param $request PKPRequest
	 */
	private function _handleWebhook($request) {
		$journal = $request->getJournal();
		$contextId = $journal->getId();
		$webhookSecret = $this->getSetting($contextId, 'webhookSecret');

		// Read the raw POST body (Stripe sends JSON)
		$payload = @file_get_contents('php://input');
		$sigHeader = isset($_SERVER['HTTP_STRIPE_SIGNATURE']) ? $_SERVER['HTTP_STRIPE_SIGNATURE'] : '';

		try {
			$this->_initStripe($contextId);

			// Verify webhook signature if a secret is configured
			if ($webhookSecret) {
				$event = \Stripe\Webhook::constructEvent($payload, $sigHeader, $webhookSecret);
			} else {
				$event = json_decode($payload);
			}

			// Only process checkout.session.completed events
			if ($event->type !== 'checkout.session.completed') {
				http_response_code(200);
				echo 'ok';
				return;
			}

			$session = $event->data->object;

			// client_reference_id holds the queued payment ID
			$queuedPaymentId = (int) $session->client_reference_id;
			if (!$queuedPaymentId) {
				throw new \Exception('No client_reference_id in webhook session!');
			}

			$queuedPaymentDao = DAORegistry::getDAO('QueuedPaymentDAO'); /* @var $queuedPaymentDao QueuedPaymentDAO */
			import('classes.payment.ojs.OJSPaymentManager'); // Class definition required for unserializing

			$queuedPayment = $queuedPaymentDao->getById($queuedPaymentId);
			if (!$queuedPayment) {
				// Already fulfilled (idempotent) — return success
				http_response_code(200);
				echo 'ok';
				return;
			}

			// Verify amount and currency match
			$expectedAmount = (int) round($queuedPayment->getAmount() * 100);
			if ((int) $session->amount_total !== $expectedAmount) {
				throw new \Exception('Webhook amounts (' . ($session->amount_total / 100) . ' vs ' . $queuedPayment->getAmount() . ') don\'t match!');
			}

			// Inject the payment's user into the request context so that
			// fulfillQueuedPayment can call $request->getUser()->getId()
			// (webhooks have no session user).
			$userDao = DAORegistry::getDAO('UserDAO'); /* @var $userDao UserDAO */
			$user = $userDao->getById($queuedPayment->getUserId());
			if ($user) {
				\Registry::set('user', $user);
			}

			$paymentManager = Application::getPaymentManager($journal);
			$paymentManager->fulfillQueuedPayment($request, $queuedPayment, $this->getName());

			http_response_code(200);
			echo 'ok';
		} catch (\Stripe\Error\SignatureVerification $e) {
			error_log('Stripe webhook signature verification failed: ' . $e->getMessage());
			http_response_code(400);
			echo 'Invalid signature';
		} catch (\Exception $e) {
			error_log('Stripe webhook exception: ' . $e->getMessage());
			http_response_code(400);
			echo 'Error';
		}
	}

	/**
	 * @see Plugin::getInstallEmailTemplatesFile
	 */
	function getInstallEmailTemplatesFile() {
		return ($this->getPluginPath() . DIRECTORY_SEPARATOR . 'emailTemplates.xml');
	}
}
