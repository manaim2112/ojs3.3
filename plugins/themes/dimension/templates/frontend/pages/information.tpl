{**
 * plugins/themes/dimension/templates/frontend/pages/information.tpl
 *
 * Information page.
 *}
{if !$contentOnly}
	{include file="frontend/components/header.tpl" pageTitle=$pageTitle}

	<div class="dim-page-hero">
		<div class="dim-page-hero-inner">
			<span class="dim-eyebrow">{translate key="manager.website.information"}</span>
			<h1 class="line-mask"><span>{translate key=$pageTitle}</span></h1>
		</div>
	</div>
{/if}

<div class="page page_information">
	<div class="grid grid-cols-1 md:grid-cols-12 gap-8">
		<div class="md:col-span-8 lg:col-span-9 bg-white dark:bg-gray-800 shadow-lg rounded-2xl border border-gray-100 dark:border-gray-700 p-6 md:p-10 animate-fade-up">
			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/information" sectionTitleKey="manager.website.information"}
			<div class="description prose dark:prose-invert prose-img:max-w-full prose-img:rounded-lg max-w-none">
				{$content}
			</div>
		</div>
		{include file="frontend/components/sideRight.tpl"}
	</div>
</div><!-- .page -->

{if !$contentOnly}
	{include file="frontend/components/footer.tpl"}
{/if}
