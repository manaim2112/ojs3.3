<?php

/**
 * @defgroup plugins_paymethod_qris QRIS Payment Processing Plugin
 */

/**
 * @file plugins/paymethod/qris/index.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_paymethod_qris
 * @brief Wrapper for QRIS static payment plugin.
 */

require_once('QrisPaymentPlugin.inc.php');

return new QrisPaymentPlugin();
