{include file="frontend/components/header.tpl"}

<div class="br-page br-page-message">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey=$pageTitle}
	<h1 class="br-page-title">
		{translate key=$pageTitle}
	</h1>
	<div class="br-card br-card-message">
		<div class="br-card-body">
			{if $messageTranslated}
				{$messageTranslated}
			{else}
				{translate key=$message}
			{/if}
		</div>
	</div>
	{if $backLink}
		<div class="br-back-link">
			<a class="br-btn br-btn-outline" href="{$backLink}">{translate key=$backLinkLabel}</a>
		</div>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
