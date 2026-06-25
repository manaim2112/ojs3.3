{include file="frontend/components/header.tpl" pageTitle="about.aboutContext"}

<div class="br-page br-page-about">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.aboutContext"}
	<h1 class="br-page-title">
		{translate key="about.aboutContext"}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}

	<div class="br-card br-card-about">
		{$currentContext->getLocalizedData('about')}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
