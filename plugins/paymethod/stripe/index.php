<?php

/**
 * @defgroup plugins_paymethod_stripe Stripe Payment Processing Plugin
 */

/**
 * @file plugins/paymethod/stripe/index.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_paymethod_stripe
 * @brief Wrapper for Stripe payment plugin.
 */

require_once('StripePaymentPlugin.inc.php');

return new StripePaymentPlugin();
