{**
 * templates/frontend/pages/paymentSelect.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Payment method selection page when multiple payment methods are enabled.
 *}
{include file="frontend/components/header.tpl" pageTitle="common.payment"}

<div class="page page_payment_selection">
	<h1 class="page_title">
		{translate key="common.payment"}
	</h1>

	<p>{translate key="payment.selectMethod"}</p>

	<div class="payment_methods">
		{foreach from=$paymentPlugins item=plugin key=pluginName}
			<div class="payment_method_item">
				<a href="{url page="payment" op="pay" path=$queuedPaymentId paymentPlugin=$pluginName}" class="cmp_button">
					{$plugin->getDisplayName()|escape}
				</a>
			</div>
		{/foreach}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
