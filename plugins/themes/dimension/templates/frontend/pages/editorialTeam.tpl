{**
 * plugins/themes/dimension/templates/frontend/pages/editorialTeam.tpl
 *
 * @brief Display the page to view the editorial team.
 *
 * @uses $currentContext Journal|Press The current journal or press
 *}
{include file="frontend/components/header.tpl" pageTitle="about.editorialTeam"}

<div class="dim-page-hero">
	<div class="dim-page-hero-inner">
		<span class="dim-eyebrow">{translate key="about.editorialTeam"}</span>
		<h1 class="line-mask"><span>{translate key="about.editorialTeam"}</span></h1>
		<p>
			{if $currentContext}
				{$currentContext->getLocalizedName()|escape} &middot;
			{/if}
			{translate key="about.editorialTeam"}
		</p>
	</div>
</div>

<div class="page page_editorial_team">
	<div class="grid grid-cols-1 md:grid-cols-12 gap-8">
		<div class="md:col-span-8 lg:col-span-9 bg-white dark:bg-gray-800 shadow-lg rounded-2xl border border-gray-100 dark:border-gray-700 p-6 md:p-10 animate-fade-up">
			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.editorialTeam"}
			<div class="prose dark:prose-invert prose-img:max-w-full prose-img:rounded-lg max-w-none">
				{$currentContext->getLocalizedData('editorialTeam')}
			</div>
		</div>
		{include file="frontend/components/sideRight.tpl"}
	</div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
