{include file="frontend/components/header.tpl" pageTitle="user.subscriptions.purchaseIndividualSubscription"}

<div class="br-page br-page-purchase-subscription">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.subscriptions.purchaseIndividualSubscription"}
	<h1 class="br-page-title">
		{translate key="user.subscriptions.purchaseIndividualSubscription"}
	</h1>

	<div class="br-card br-card-form">
		<form class="br-form" method="post" id="subscriptionForm" action="{url op="payPurchaseSubscription" path="individual"|to_array:$subscriptionId}">
			{csrf}

			<fieldset class="br-fieldset">
				<legend class="br-legend">
					{translate key="payment.subscription.purchase"}
				</legend>
				<div class="br-form-grid">
					<div class="br-field">
						<label for="typeId">
							<span class="br-label">{translate key="user.subscriptions.form.typeId"}</span>
							<select name="typeId" id="typeId" class="br-select">
								{foreach name=types from=$subscriptionTypes key=thisTypeId item=subscriptionType}
									<option value="{$thisTypeId|escape}"{if $typeId == $thisTypeId} selected{/if}>{$subscriptionType|escape}</option>
								{/foreach}
							</select>
						</label>
					</div>
					<div class="br-field">
						<label for="membership">
							<span class="br-label">{translate key="user.subscriptions.form.membership"}</span>
							<input type="text" name="membership" id="membership" value="{$membership|escape}" class="br-input">
						</label>
					</div>
				</div>
			</fieldset>

			<div class="br-form-actions">
				<button class="br-btn br-btn-primary" type="submit">
					{translate key="common.save"}
				</button>
			</div>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
