{include file="frontend/components/header.tpl" pageTitle="user.subscriptions.mySubscriptions"}

<div class="br-page br-page-user-subscriptions">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.subscriptions.mySubscriptions"}
	<h1 class="br-page-title">
		{translate key="user.subscriptions.mySubscriptions"}
	</h1>

	<div class="br-card br-card-subscription-contact">
		{include file="frontend/components/subscriptionContact.tpl"}
	</div>

	{if $paymentsEnabled}
		<section class="br-subscription-status br-card">
			<h2 class="br-section-title">{translate key="user.subscriptions.subscriptionStatus"}</h2>
			<p>{translate key="user.subscriptions.statusInformation"}</p>
			<div class="br-table-wrapper">
				<table class="br-table">
					<thead>
						<tr>
							<th>{translate key="user.subscriptions.status"}</th>
							<th>{translate key="user.subscriptions.statusDescription"}</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>{translate key="subscriptions.status.needsInformation"}</td>
							<td>{translate key="user.subscriptions.status.needsInformationDescription"}</td>
						</tr>
						<tr>
							<td>{translate key="subscriptions.status.needsApproval"}</td>
							<td>{translate key="user.subscriptions.status.needsApprovalDescription"}</td>
						</tr>
						<tr>
							<td>{translate key="subscriptions.status.awaitingManualPayment"}</td>
							<td>{translate key="user.subscriptions.status.awaitingManualPaymentDescription"}</td>
						</tr>
						<tr>
							<td>{translate key="subscriptions.status.awaitingOnlinePayment"}</td>
							<td>{translate key="user.subscriptions.status.awaitingOnlinePaymentDescription"}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</section>
	{/if}

	{if $individualSubscriptionTypesExist}
		<section class="br-subscription-individual br-card">
			<h2 class="br-section-title">{translate key="user.subscriptions.individualSubscriptions"}</h2>
			<p>{translate key="subscriptions.individualDescription"}</p>
			{if $userIndividualSubscription}
				<div class="br-table-wrapper">
					<table class="br-table">
						<thead>
							<tr>
								<th>{translate key="user.subscriptions.form.typeId"}</th>
								<th>{translate key="subscriptions.status"}</th>
								{if $payentsEnabled}
									<th></th>
								{/if}
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>{$userIndividualSubscription->getSubscriptionTypeName()|escape}</td>
								<td>
									{assign var="subscriptionStatus" value=$userIndividualSubscription->getStatus()}
									{assign var="isNonExpiring" value=$userIndividualSubscription->isNonExpiring()}
									{if $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
										<span class="br-subscription-badge br-subscription-pending">
											{translate key="subscriptions.status.awaitingOnlinePayment"}
										</span>
									{elseif $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_MANUAL_PAYMENT}
										<span class="br-subscription-badge br-subscription-pending">
											{translate key="subscriptions.status.awaitingManualPayment"}
										</span>
									{elseif $subscriptionStatus != $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
										<span class="br-subscription-badge br-subscription-inactive">
											{translate key="subscriptions.inactive"}
										</span>
									{else}
										{if $isNonExpiring}
											<span class="br-subscription-badge br-subscription-active">
												{translate key="subscriptionTypes.nonExpiring"}
											</span>
										{else}
											{assign var="isExpired" value=$userIndividualSubscription->isExpired()}
											{if $isExpired}
												<span class="br-subscription-badge br-subscription-inactive">
													{translate key="user.subscriptions.expired" date=$userIndividualSubscription->getDateEnd()|date_format:$dateFormatShort}
												</span>
											{else}
												<span class="br-subscription-badge br-subscription-active">
													{translate key="user.subscriptions.expires" date=$userIndividualSubscription->getDateEnd()|date_format:$dateFormatShort}
												</span>
											{/if}
										{/if}
									{/if}
								</td>
								{if $paymentsEnabled}
									<td>
										{if $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
											<a class="br-btn br-btn-primary" href="{url op="completePurchaseSubscription" path="individual"|to_array:$userIndividualSubscription->getId()}">
												{translate key="user.subscriptions.purchase"}
											</a>
										{elseif $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
											{if !$isNonExpiring}
												<a class="br-btn br-btn-outline" href="{url op="payRenewSubscription" path="individual"|to_array:$userIndividualSubscription->getId()}">
													{translate key="user.subscriptions.renew"}
												</a>
											{/if}
											<a class="br-btn br-btn-outline" href="{url op="purchaseSubscription" path="individual"|to_array:$userIndividualSubscription->getId()}">
												{translate key="user.subscriptions.purchase"}
											</a>
										{/if}
									</td>
								{/if}
							</tr>
						</tbody>
					</table>
				</div>
			{elseif $paymentsEnabled}
				<p>
					<a class="br-btn br-btn-primary" href="{url op="purchaseSubscription" path="individual"}">
						{translate key="user.subscriptions.purchaseNewSubscription"}
					</a>
				</p>
			{else}
				<p>
					<a href="{url page="about" op="subscriptions" anchor="subscriptionTypes"}">
						{translate key="user.subscriptions.viewSubscriptionTypes"}
					</a>
				</p>
			{/if}
		</section>
	{/if}

	{if $institutionalSubscriptionTypesExist}
		<section class="br-subscription-institutional br-card">
			<h2 class="br-section-title">{translate key="user.subscriptions.institutionalSubscriptions"}</h2>
			<p>
				{translate key="subscriptions.institutionalDescription"}
				{if $paymentsEnabled}
					{translate key="subscriptions.institutionalOnlinePaymentDescription"}
				{/if}
			</p>
			{if $userInstitutionalSubscriptions}
				<div class="br-table-wrapper">
					<table class="br-table">
						<thead>
							<tr>
								<th>{translate key="user.subscriptions.form.typeId"}</th>
								<th>{translate key="user.subscriptions.form.institutionName"}</th>
								<th>{translate key="subscriptions.status"}</th>
								{if $paymentsEnabled}
									<th></th>
								{/if}
							</tr>
						</thead>
						<tbody>
							{iterate from=userInstitutionalSubscriptions item=userInstitutionalSubscription}
								<tr>
									<td>{$userInstitutionalSubscription->getSubscriptionTypeName()|escape}</td>
									<td>{$userInstitutionalSubscription->getInstitutionName()|escape}</td>
									<td>
										{assign var="subscriptionStatus" value=$userInstitutionalSubscription->getStatus()}
										{assign var="isNonExpiring" value=$userInstitutionalSubscription->isNonExpiring()}
										{if $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
											<span class="br-subscription-badge br-subscription-pending">
												{translate key="subscriptions.status.awaitingOnlinePayment"}
											</span>
										{elseif $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_MANUAL_PAYMENT}
											<span class="br-subscription-badge br-subscription-pending">
												{translate key="subscriptions.status.awaitingManualPayment"}
											</span>
										{elseif $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_NEEDS_APPROVAL}
											<span class="br-subscription-badge br-subscription-pending">
												{translate key="subscriptions.status.needsApproval"}
											</span>
										{elseif $subscriptionStatus != $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
											<span class="br-subscription-badge br-subscription-inactive">
												{translate key="subscriptions.inactive"}
											</span>
										{else}
											{if $isNonExpiring}
												<span class="br-subscription-badge br-subscription-active">
													{translate key="subscriptionTypes.nonExpiring"}
												</span>
											{else}
												{assign var="isExpired" value=$userInstitutionalSubscription->isExpired()}
												{if $isExpired}
													<span class="br-subscription-badge br-subscription-inactive">
														{translate key="user.subscriptions.expired" date=$userInstitutionalSubscription->getDateEnd()|date_format:$dateFormatShort}
													</span>
												{else}
													<span class="br-subscription-badge br-subscription-active">
														{translate key="user.subscriptions.expires" date=$userInstitutionalSubscription->getDateEnd()|date_format:$dateFormatShort}
													</span>
												{/if}
											{/if}
										{/if}
									</td>
									{if $paymentsEnabled}
										<td>
											{if $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
												<a class="br-btn br-btn-primary" href="{url op="completePurchaseSubscription" path="institutional"|to_array:$userInstitutionalSubscription->getId()}">
													{translate key="user.subscriptions.purchase"}
												</a>
											{elseif $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
												{if !$isNonExpiring}
													<a class="br-btn br-btn-outline" href="{url op="payRenewSubscription" path="institutional"|to_array:$userInstitutionalSubscription->getId()}">
														{translate key="user.subscriptions.renew"}
													</a>
												{/if}
												<a class="br-btn br-btn-outline" href="{url op="purchaseSubscription" path="institutional"|to_array:$userInstitutionalSubscription->getId()}">
													{translate key="user.subscriptions.purchase"}
												</a>
											{/if}
										</td>
									{/if}
								</tr>
							{/iterate}
						</tbody>
					</table>
				</div>
			{/if}
			<p>
				{if $paymentsEnabled}
					<a class="br-btn br-btn-primary" href="{url page="user" op="purchaseSubscription" path="institutional"}">
						{translate key="user.subscriptions.purchaseNewSubscription"}
					</a>
				{else}
					<a href="{url page="about" op="subscriptions" anchor="subscriptionTypes"}">
						{translate key="user.subscriptions.viewSubscriptionTypes"}
					</a>
				{/if}
			</p>
		</section>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
