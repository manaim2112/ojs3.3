{**
 * plugins/paymethod/qris/templates/paymentForm.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * QRIS static payment page
 *}
{include file="frontend/components/header.tpl" pageTitle="plugins.paymethod.qris"}


<div class="page page_payment_form">
	<h1 class="page_title">
		{translate key="plugins.paymethod.qris"}
	</h1>

	<table class="cmp_table">
		<tr>
			<th>{translate key="plugins.paymethod.qris.purchase.title"}</th>
			<td>{$itemName|escape}</td>
		</tr>
		{if $itemAmount}
			<tr>
				<th>{translate key="plugins.paymethod.qris.purchase.fee"}</th>
				<td>{$itemAmount|string_format:"%.2f"}{if $itemCurrencyCode} ({$itemCurrencyCode|escape}){/if}</td>
			</tr>
		{/if}
	</table>

	<div class="qris_payment">
		<p>{translate key="plugins.paymethod.qris.scanInstructions"}</p>
		<div class="qris_image" style="text-align:center; margin:20px 0;">
			<img src="{$qrisImageUrl|escape}" alt="QRIS" style="max-width:300px; width:100%; height:auto;" />
		</div>

		{if $qrisInstructions}
			<p>{$qrisInstructions|strip_unsafe_html|nl2br}</p>
		{/if}
	</div>

	<form id="qrisPaymentForm" method="post" enctype="multipart/form-data" action="{url page="payment" op="plugin" path="QrisPayment"|to_array:"notify":$queuedPaymentId}">
		<div class="qris_proof_upload" style="margin:20px 0;">
			<label for="qrisProofOfPayment" style="font-weight:bold; display:block; margin-bottom:8px;">
				{translate key="plugins.paymethod.qris.uploadProof"}
			</label>
			<p class="description" style="font-size:0.9em; color:#666; margin-bottom:8px;">
				{translate key="plugins.paymethod.qris.uploadProof.description"}
			</p>
			<input type="file" name="qrisProofOfPayment" id="qrisProofOfPayment" accept="image/*,.pdf" style="max-width:100%;" />
		</div>

		<p>
			<button type="submit" class="cmp_button">
				{translate key="plugins.paymethod.qris.sendNotificationOfPayment"}
			</button>
		</p>
	</form>
</div>

{include file="frontend/components/footer.tpl"}
