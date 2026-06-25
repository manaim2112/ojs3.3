{**
 * templates/frontend/pages/search.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to search and view search results.
 *
 * @uses $query Value of the primary search query
 * @uses $authors Value of the authors search filter
 * @uses $dateFrom Value of the date from search filter (published after).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $dateTo Value of the date to search filter (published before).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $yearStart Earliest year that can be used in from/to filters
 * @uses $yearEnd Latest year that can be used in from/to filters
 *}
{include file="frontend/components/header.tpl" pageTitle="common.search"}

{if !$heading}
	{assign var="heading" value="h2"}
{/if}

<div class="page page_search">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.search"}

	<div class="container mx-auto grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-2">

		{include file="frontend/components/sideLeft.tpl"}
		<div class="grid-col-1 order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8 shadow-lg">
			<div class="container mx-auto px-6 py-8">
				<div
					class="bg-white dark:bg-gray-800 shadow-xl rounded-lg overflow-hidden p-6 lg:p-8 animate-fade-in-up">
					<h1
						class="text-4xl lg:text-5xl font-extrabold text-center mb-8 text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-blue-900 dark:from-blue-400 dark:to-blue-600 animate-slide-in-heading">
						{translate key="common.search"}
					</h1>

					{capture name="searchFormUrl"}{url escape=false}{/capture}
					{assign var=formUrlParameters value=[]}{* Prevent Smarty warning *}
					{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|parse_str:$formUrlParameters}

					<form class="cmp_form space-y-6" method="get"
						action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}">
						{foreach from=$formUrlParameters key=paramKey item=paramValue}
							<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}" />
						{/foreach}

						<div class="relative mb-6">
							<label class="pkp_screen_reader" for="query_main">
								{translate key="search.searchFor"}
							</label>
							<div
								class="flex items-center border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus-within:ring-2 focus-within:ring-blue-500 focus-within:border-blue-500 transition-all duration-200">
								<input type="text" id="query_main" name="query" value="{$query|escape}"
									class="flex-grow bg-transparent text-gray-900 dark:text-white text-lg rounded-l-lg p-3 focus:outline-none"
									placeholder="{translate|escape key="common.search"}...">
								<button type="submit"
									class="bg-blue-600 text-white rounded-r-lg px-6 py-3 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800 transition-colors duration-300 transform hover:scale-105 active:scale-95 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75">
									<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"
										xmlns="http://www.w3.org/2000/svg">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
											d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
									</svg>
								</button>
							</div>
						</div>

						<fieldset class="border border-gray-200 dark:border-gray-700 rounded-lg p-5 mb-6">
							<legend
								class="text-lg font-semibold text-gray-800 dark:text-gray-100 px-2 animate-fade-in-down-heading cursor-pointer"
								id="advancedFiltersToggle">
								{translate key="search.advancedFilters"}
								<svg id="toggleIcon"
									class="inline-block ml-2 w-4 h-4 transform transition-transform duration-300 rotate-0"
									fill="none" stroke="currentColor" viewBox="0 0 24 24"
									xmlns="http://www.w3.org/2000/svg">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
										d="M19 9l-7 7-7-7"></path>
								</svg>
							</legend>
							<div id="advancedFiltersContent" class="space-y-5 mt-4 hidden animate-fade-in-up">
								<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
									<div>
										<label
											class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">{translate key="search.dateFrom"}</label>
										{capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
										{html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd
                                class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 p-2.5"}
									</div>
									<div>
										<label
											class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">{translate key="search.dateTo"}</label>
										{capture assign="dateFromTo"}{translate key="search.dateTo"}{/capture}
										{html_select_date_a11y legend=$dateFromTo prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd
                                class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 p-2.5"}
									</div>
								</div>

								<div>
									<label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300"
										for="authors_filter">
										{translate key="search.author"}
									</label>
									{block name=searchAuthors}
										<input type="text" id="authors_filter" name="authors" value="{$authors|escape}"
											class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 p-2.5"
											placeholder="{translate|escape key="search.author"}">
									{/block}
								</div>

								{call_hook name="Templates::Search::SearchResults::AdditionalFilters"}

							</div>
						</fieldset>

						<div class="text-center mt-8">
							<button type="submit" class="inline-flex items-center px-8 py-3 bg-blue-600 text-white font-semibold rounded-full shadow-lg hover:bg-blue-700
                               dark:bg-blue-700 dark:hover:bg-blue-800 transition-all duration-300 transform hover:scale-105 active:scale-95
                               focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75">
								<svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
									xmlns="http://www.w3.org/2000/svg">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
										d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
								</svg>
								{translate key="common.search"}
							</button>
						</div>
					</form>

					{call_hook name="Templates::Search::SearchResults::PreResults"}

					<h2 class="pkp_screen_reader">{translate key="search.searchResults"}</h2>

					<div class="mt-10">
						{if !$results->wasEmpty()}
							<div class="bg-blue-50 dark:bg-gray-700 rounded-lg p-4 mb-6 shadow-sm animate-fade-in">
								<p class="text-blue-800 dark:text-blue-200 text-center font-medium" role="status">
									{if $results->count > 1}
										{translate key="search.searchResults.foundPlural" count=$results->count}
									{else}
										{translate key="search.searchResults.foundSingle"}
									{/if}
								</p>
							</div>

							<ul class="space-y-6">
								{iterate from=results item=result}
								<li
									class="bg-gray-50 dark:bg-gray-700 rounded-lg shadow-md p-5 hover:shadow-lg transition-shadow duration-300 animate-fade-in-delay-{$smarty.foreach.results.iteration}">
									{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
								</li>
								{/iterate}
							</ul>

							<div
								class="cmp_pagination mt-8 flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0 animate-fade-in-up">
								<div class="text-gray-700 dark:text-gray-300 text-sm">
									{page_info iterator=$results}
								</div>
								<div class="flex flex-wrap justify-center gap-2">
									{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear
	                            class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200 text-gray-700 dark:text-gray-300"
	                            currentClass="bg-blue-600 text-white border-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:border-blue-700 dark:hover:bg-blue-800"}
								</div>
							</div>
						{else}
							<div class="mt-8 animate-fade-in">
								{if $error}
									{include file="frontend/components/notification.tpl" type="error" message=$error|escape
		                            class="bg-red-100 text-red-700 border border-red-400 p-4 rounded-md"}
								{else}
									{include file="frontend/components/notification.tpl" type="notice" messageKey="search.noResults"
		                            class="bg-blue-100 text-blue-700 border border-blue-400 p-4 rounded-md"}
								{/if}
							</div>
						{/if}
					</div>
				</div>
			</div>

			<script>
				document.addEventListener('DOMContentLoaded', function() {
					const toggleBtn = document.getElementById('advancedFiltersToggle');
					const filtersContent = document.getElementById('advancedFiltersContent');
					const toggleIcon = document.getElementById('toggleIcon');

					if (toggleBtn && filtersContent && toggleIcon) {
						toggleBtn.addEventListener('click', function() {
							filtersContent.classList.toggle('hidden');
							toggleIcon.classList.toggle('rotate-180'); // Rotate arrow icon
						});
					}
				});
			</script>

			{* Search Syntax Instructions *}
			{block name=searchSyntaxInstructions}{/block}
		</div>
		{include file="frontend/components/sideRight.tpl"}

	</div><!-- .container -->
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}