{include file="frontend/components/header.tpl" pageTitle="about.aboutSoftware"}

<div class="br-page br-page-about-publishing-system">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.aboutSoftware"}
	<h1 class="br-page-title">
		{translate key="about.aboutSoftware"}
	</h1>

	<div class="br-card br-card-about-software">
		<p>
			{if $currentContext}
				{translate key="about.aboutOJSJournal" ojsVersion=$appVersion contactUrl=$contactUrl}
			{else}
				{translate key="about.aboutOJSSite" ojsVersion=$appVersion}
			{/if}
		</p>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
