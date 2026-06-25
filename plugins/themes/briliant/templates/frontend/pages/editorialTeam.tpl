{include file="frontend/components/header.tpl" pageTitle="about.editorialTeam"}

<div class="br-page br-page-editorial-team">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.editorialTeam"}
	<h1 class="br-page-title">
		{translate key="about.editorialTeam"}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.editorialTeam"}

	<div class="br-card br-card-editorial">
		{$currentContext->getLocalizedData('editorialTeam')}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
