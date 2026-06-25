{**
 * templates/frontend/pages/article.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view an article with all of it's details.
 *
 * @uses $article Submission This article
 * @uses $publication Publication The publication being displayed
 * @uses $firstPublication Publication The first published version of this article
 * @uses $currentPublication Publication The most recently published version of this article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $journal Journal The journal currently being viewed.
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getLocalizedFullTitle()|escape}
<div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-2 container mx-auto px-3">
	<div class="grid-col-1 order-2 md:order-1 md:col-span-1 lg:col-span-1 xl:col-span-2 my-10">
		{capture assign="articleMainHook"}{call_hook name="Templates::Article::Main"}{/capture}
		{if $articleMainHook|trim}
			<div class="aside-hook-wrap bg-gray-50 dark:bg-gray-800/50 rounded-lg border border-gray-200 dark:border-gray-700 mb-4">
				<button type="button" class="aside-toggle w-full flex items-center justify-between p-3 text-left cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700/50 transition-colors rounded-lg" aria-expanded="false">
					<span class="flex items-center gap-2">
						<svg class="w-5 h-5 text-gray-500 dark:text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/></svg>
						<span class="text-sm font-semibold text-gray-800 dark:text-gray-100">{translate key="common.relatedArticles"}</span>
					</span>
					<svg class="aside-chevron w-4 h-4 text-gray-500 dark:text-gray-400 transition-transform duration-200 rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
				</button>
				<div class="aside-body border-t border-gray-200 dark:border-gray-700 hidden">
					<div class="p-2 text-sm">
						{$articleMainHook}
					</div>
				</div>
			</div>
		{/if}

		{* DOI (requires plugin) *}
		{foreach from=$pubIdPlugins item=pubIdPlugin}
			{if $pubIdPlugin->getPubIdType() != 'doi'}
				{continue}
			{/if}
			{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
			{if $pubId}
			{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
				{assign var="doi" value=str_replace("https://doi.org/", "", $doiUrl)}
				<div class="sub_item">
					<span class="text-sm text-gray-600 dark:text-gray-300">DOI: {$doi|escape}</span>
				</div>
			{/if}
		{/foreach}

		{* DOI Prefix from theme settings *}
		{if $activeTheme->getOption('doiPrefix')}
			<div class="sub_item mt-2">
				<span class="text-xs text-gray-500 dark:text-gray-400">{translate key="manager.setup.doiPrefix"}: {$activeTheme->getOption('doiPrefix')|escape}</span>
			</div>
		{/if}
 
		
	</div>
	<div class="grid-col-1 order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8">
		<div class="page page_article">
			{if $section}
				{include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
			{else}
				{include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="common.publication"}
			{/if}


			{* Show article overview *}
			{include file="frontend/objects/article_details.tpl"}

			{capture assign="similarArticles"}{call_hook name="Templates::Article::Footer::PageFooter"}{/capture}
			{if $similarArticles|trim}
				<div class="similar-articles-wrap bg-gray-50 dark:bg-gray-800/50 rounded-lg border border-gray-200 dark:border-gray-700 my-4">
					<button type="button" class="similar-toggle w-full flex items-center justify-between p-3 text-left cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700/50 transition-colors rounded-lg" aria-expanded="false">
						<span class="flex items-center gap-2">
							<svg class="w-5 h-5 text-gray-500 dark:text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
							<span class="text-lg font-semibold text-gray-800 dark:text-gray-100">{translate key="common.relatedArticles"}</span>
						</span>
						<svg class="similar-chevron w-5 h-5 text-gray-500 dark:text-gray-400 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
					</button>
					<div class="similar-body border-t border-gray-200 dark:border-gray-700 hidden">
						<div class="p-3 text-sm prose prose-p:my-1/2 max-w-none">
							{$similarArticles}
						</div>
					</div>
				</div>
			{/if}
		</div><!-- .page -->
	</div>
	<div class="grid-col-1 order-3 md:order-3 md:col-span-1 lg:col-span-1 xl:col-span-2">
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
			{if $sidebarCode}
				<div class="pkp_footer_content text-justify mx-auto">
					{$sidebarCode}
				</div>
			{/if}
	</div>
</div>


<script>
document.querySelectorAll('.refs-toggle, .similar-toggle, .aside-toggle').forEach(function(btn) {
	btn.addEventListener('click', function() {
		var body = this.nextElementSibling;
		var chevron = this.querySelector('.refs-chevron, .similar-chevron, .aside-chevron');
		var isHidden = body.classList.contains('hidden');
		body.classList.toggle('hidden');
		body.classList.toggle('block');
		this.setAttribute('aria-expanded', isHidden);
		if (chevron) chevron.classList.toggle('rotate-180');
	});
});
</script>

{include file="frontend/components/footer.tpl"}
