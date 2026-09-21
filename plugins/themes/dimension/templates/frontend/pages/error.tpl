{**
 * plugins/themes/dimension/templates/frontend/pages/error.tpl
 *
 * Generic error page.
 * Displays a simple error message and (optionally) a return link.
 *}
{include file="frontend/components/header.tpl"}

<div class="dim-page-hero">
	<div class="dim-page-hero-inner">
		<span class="dim-eyebrow">404</span>
		<h1 class="line-mask"><span>{translate key=$pageTitle}</span></h1>
	</div>
</div>

<div class="page page_error">
	<div class="grid grid-cols-1 md:grid-cols-12 gap-8">
		<div class="md:col-span-8 lg:col-span-9 bg-white dark:bg-gray-800 shadow-lg rounded-2xl border border-gray-100 dark:border-gray-700 p-6 md:p-10 animate-fade-up">
			<div class="description prose dark:prose-invert max-w-none">
				{translate key=$errorMsg params=$errorParams}
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
