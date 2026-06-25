{include file="frontend/components/header.tpl" pageTitle="manager.setup.privacyStatement"}

<div class="br-page br-page-privacy">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="manager.setup.privacyStatement"}
	<h1 class="br-page-title">
		{translate key="manager.setup.privacyStatement"}
	</h1>
	<div class="br-card br-card-privacy">
		{$privacyStatement}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
