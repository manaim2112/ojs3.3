<?php

/**
 * @file plugins/paymethod/stripe/StripePaymentForm.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class StripePaymentForm
 *
 * Form for Stripe-based payments using Checkout Sessions.
 *
 */

import('lib.pkp.classes.form.Form');

class StripePaymentForm extends Form {
	/** @var StripePaymentPlugin */
	var $_stripePaymentPlugin;

	/** @var QueuedPayment */
	var $_queuedPayment;

	/**
	 * @param $stripePaymentPlugin StripePaymentPlugin
	 * @param $queuedPayment QueuedPayment
	 */
	function __construct($stripePaymentPlugin, $queuedPayment) {
		$this->_stripePaymentPlugin = $stripePaymentPlugin;
		$this->_queuedPayment = $queuedPayment;
		parent::__construct(null);
	}

	/**
	 * @copydoc Form::display()
	 */
	function display($request = null, $template = null) {
		try {
			$journal = $request->getJournal();
			$paymentManager = Application::getPaymentManager($journal);

			\Stripe\Stripe::setApiKey($this->_stripePaymentPlugin->getSetting($journal->getId(), 'secretKey'));

			$amount = (int) round($this->_queuedPayment->getAmount() * 100);
			$currency = strtolower($this->_queuedPayment->getCurrencyCode());

			$returnUrl = $request->url(
				null, 'payment', 'plugin',
				array($this->_stripePaymentPlugin->getName(), 'return'),
				array('queuedPaymentId' => $this->_queuedPayment->getId())
			);

			$session = \Stripe\Checkout\Session::create([
				'payment_method_types' => ['card'],
				'line_items' => [[
					'price_data' => [
						'currency' => $currency,
						'product_data' => [
							'name' => $paymentManager->getPaymentName($this->_queuedPayment),
						],
						'unit_amount' => $amount,
					],
					'quantity' => 1,
				]],
				'mode' => 'payment',
				'success_url' => $returnUrl . '&session_id={CHECKOUT_SESSION_ID}',
				'cancel_url' => $request->url(null, 'index'),
				'client_reference_id' => (string) $this->_queuedPayment->getId(),
			]);

			$request->redirectUrl($session->url);
		} catch (\Exception $e) {
			error_log('Stripe transaction exception: ' . $e->getMessage());
			$templateMgr = TemplateManager::getManager($request);
			$templateMgr->assign('message', 'plugins.paymethod.stripe.error');
			$templateMgr->display('frontend/pages/message.tpl');
		}
	}
}
