{**
 * plugins/themes/dimension/templates/frontend/pages/message.tpl
 *
 * Generic message page.
 * Displays a simple message and (optionally) a return link.
 *}
{include file="frontend/components/header.tpl"}

<div class="dim-page-hero">
	<div class="dim-page-hero-inner">
		{if $messageTranslated}
			<h1 class="line-mask"><span>{translate key=$message}</span></h1>
		{else}
			<h1 class="line-mask"><span>{translate key=$message}</span></h1>
		{/if}
	</div>
</div>

<div class="page page_message">
	<div class="grid grid-cols-1 md:grid-cols-12 gap-8">
		<div class="md:col-span-8 lg:col-span-9 bg-white dark:bg-gray-800 shadow-lg rounded-2xl border border-gray-100 dark:border-gray-700 p-6 md:p-10 animate-fade-up">
			<div class="description prose dark:prose-invert max-w-none">
				{if $messageTranslated}
					{$messageTranslated}
				{else}
					{translate key=$message}
				{/if}
			</div>
			{if $backLink}
				<div class="cmp_back_link">
					<a href="{$backLink}">{translate key=$backLinkLabel}</a>
				</div>
			{/if}
		</div>
	</div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
