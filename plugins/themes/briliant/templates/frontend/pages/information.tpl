{if !$contentOnly}
	{include file="frontend/components/header.tpl" pageTitle=$pageTitle}
{/if}

<div class="br-page br-page-information">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey=$pageTitle}
	<h1 class="br-page-title">
		{translate key=$pageTitle}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/information" sectionTitleKey="manager.website.information"}

	<div class="br-card br-card-information">
		{$content}
	</div>
</div>

{if !$contentOnly}
	{include file="frontend/components/footer.tpl"}
{/if}
