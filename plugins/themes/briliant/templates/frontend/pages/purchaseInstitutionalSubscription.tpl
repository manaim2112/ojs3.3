{include file="frontend/components/header.tpl" pageTitle="user.subscriptions.purchaseInstitutionalSubscription"}

<div class="br-page br-page-purchase-subscription">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.subscriptions.purchaseInstitutionalSubscription"}
	<h1 class="br-page-title">
		{translate key="user.subscriptions.purchaseInstitutionalSubscription"}
	</h1>

	{assign var="formPath" value="institutional"}
	{if $subscriptionId}
		{assign var="formPath" value="institutional"|to_array:$subscriptionId}
	{/if}

	<div class="br-card br-card-form">
		<form class="br-form" method="post" id="subscriptionForm" action="{url op="payPurchaseSubscription" path=$formPath}">
			{csrf}

			{include file="common/formErrors.tpl"}

			<fieldset class="br-fieldset">
				<legend class="br-legend">
					{translate key="payment.subscription.purchase"}
				</legend>
				<div class="br-form-grid">
					<div class="br-field">
						<label for="typeId">
							<span class="br-label">
								{translate key="user.subscriptions.form.typeId"}
								<span class="br-required">*</span>
							</span>
							<select name="typeId" id="typeId" class="br-select" required>
								{foreach name=types from=$subscriptionTypes item=subscriptionType}
									<option value="{$subscriptionType->getId()}"{if $typeId == $subscriptionType->getId()} selected{/if}>{$subscriptionType->getSummaryString()|escape}</option>
								{/foreach}
							</select>
						</label>
					</div>
					<div class="br-field">
						<label for="membership">
							<span class="br-label">{translate key="user.subscriptions.form.membership"}</span>
							<input type="text" name="membership" id="membership" value="{$membership|escape}" class="br-input" aria-describedby="subscriptionMembershipDescription">
							<p class="br-field-hint" id="subscriptionMembershipDescription">{translate key="user.subscriptions.form.membershipInstructions"}</p>
							<p class="br-field-hint" id="subscriptionDomainDescription">{translate key="user.subscriptions.form.domainInstructions"}</p>
							<p class="br-field-hint" id="subscriptionIPDescription">{translate key="user.subscriptions.form.ipRangeInstructions"}</p>
						</label>
					</div>
				</div>
			</fieldset>

			<div class="br-form-actions">
				<button class="br-btn br-btn-primary" type="submit">
					{translate key="common.continue"}
				</button>
				<a class="br-btn br-btn-outline" href="{url page="user" op="subscriptions"}">
					{translate key="common.cancel"}
				</a>
			</div>

		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
