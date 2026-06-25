{include file="frontend/components/header.tpl" pageTitle="about.subscriptions"}

<div class="br-page br-page-subscriptions">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.subscriptions"}
	<h1 class="br-page-title">
		{translate key="about.subscriptions"}
	</h1>

	<div class="br-card br-card-subscription-contact">
		{include file="frontend/components/subscriptionContact.tpl"}
	</div>

	<a name="subscriptionTypes"></a>
	{if $individualSubscriptionTypes|@count}
		<section class="br-subscription-section">
			<h2 class="br-section-title">{translate key="about.subscriptions.individual"}</h2>
			<p class="br-section-desc">{translate key="subscriptions.individualDescription"}</p>
			<div class="br-table-wrapper">
				<table class="br-table">
					<thead>
						<tr>
							<th>{translate key="about.subscriptionTypes.name"}</th>
							<th>{translate key="about.subscriptionTypes.format"}</th>
							<th>{translate key="about.subscriptionTypes.duration"}</th>
							<th>{translate key="about.subscriptionTypes.cost"}</th>
						</tr>
					</thead>
					<tbody>
						{foreach from=$individualSubscriptionTypes item=subscriptionType}
							<tr>
								<td>
									<div class="br-subscription-name">
										{$subscriptionType->getLocalizedName()|escape}
									</div>
									<div class="br-subscription-desc">
										{$subscriptionType->getLocalizedDescription()|strip_unsafe_html}
									</div>
								</td>
								<td>{translate key=$subscriptionType->getFormatString()}</td>
								<td>{$subscriptionType->getDurationYearsMonths()|escape}</td>
								<td>{$subscriptionType->getCost()|string_format:"%.2f"}&nbsp;({$subscriptionType->getCurrencyStringShort()|escape})</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
			{if $isUserLoggedIn}
				<div class="br-subscription-actions">
					<a class="br-btn br-btn-primary" href="{url page="user" op="purchaseSubscription" path="individual"}">
						{translate key="user.subscriptions.purchaseNewSubscription"}
					</a>
				</div>
			{/if}
		</section>
	{/if}

	{if $institutionalSubscriptionTypes|@count}
		<section class="br-subscription-section">
			<h2 class="br-section-title">{translate key="about.subscriptions.institutional"}</h2>
			<p class="br-section-desc">{translate key="subscriptions.institutionalDescription"}</p>
			<div class="br-table-wrapper">
				<table class="br-table">
					<thead>
						<tr>
							<th>{translate key="about.subscriptionTypes.name"}</th>
							<th>{translate key="about.subscriptionTypes.format"}</th>
							<th>{translate key="about.subscriptionTypes.duration"}</th>
							<th>{translate key="about.subscriptionTypes.cost"}</th>
						</tr>
					</thead>
					<tbody>
						{foreach from=$institutionalSubscriptionTypes item=subscriptionType}
							<tr>
								<td>
									<div class="br-subscription-name">
										{$subscriptionType->getLocalizedName()|escape}
									</div>
									<div class="br-subscription-desc">
										{$subscriptionType->getLocalizedDescription()|strip_unsafe_html}
									</div>
								</td>
								<td>{translate key=$subscriptionType->getFormatString()}</td>
								<td>{$subscriptionType->getDurationYearsMonths()|escape}</td>
								<td>{$subscriptionType->getCost()|string_format:"%.2f"}&nbsp;({$subscriptionType->getCurrencyStringShort()|escape})</td>
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
			{if $isUserLoggedIn}
				<div class="br-subscription-actions">
					<a class="br-btn br-btn-primary" href="{url page="user" op="purchaseSubscription" path="institutional"}">
						{translate key="user.subscriptions.purchaseNewSubscription"}
					</a>
				</div>
			{/if}
		</section>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
