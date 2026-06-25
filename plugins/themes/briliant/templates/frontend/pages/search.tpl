{include file="frontend/components/header.tpl" pageTitle="common.search"}

{if !$heading}
	{assign var="heading" value="h2"}
{/if}

<div class="br-page br-page-search">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.search"}
	<h1 class="br-page-title">
		{translate key="common.search"}
	</h1>

	{capture name="searchFormUrl"}{url escape=false}{/capture}
	{assign var=formUrlParameters value=[]}
	{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$formUrlParameters}
	<form class="br-search-form" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}">
		{foreach from=$formUrlParameters key=paramKey item=paramValue}
			<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
		{/foreach}

		<div class="br-search-input-group">
			<label class="br-sr-only" for="query">
				{translate key="search.searchFor"}
			</label>
			{block name=searchQuery}
				<input type="text" id="query" name="query" value="{$query|escape}" class="br-search-query" placeholder="{translate|escape key="common.search"}">
			{/block}
			<button class="br-btn br-btn-primary" type="submit">{translate key="common.search"}</button>
		</div>

		<details class="br-search-filters">
			<summary class="br-search-filters-toggle">{translate key="search.advancedFilters"}</summary>
			<div class="br-search-filters-body">
				<div class="br-search-date-range">
					<div class="br-field">
						{capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
						{html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
					</div>
					<div class="br-field">
						{capture assign="dateFromTo"}{translate key="search.dateTo"}{/capture}
						{html_select_date_a11y legend=$dateFromTo prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
					</div>
				</div>
				<div class="br-field">
					<label for="authors">
						{translate key="search.author"}
					</label>
					{block name=searchAuthors}
						<input type="text" id="authors" name="authors" value="{$authors|escape}">
					{/block}
				</div>
				{call_hook name="Templates::Search::SearchResults::AdditionalFilters"}
			</div>
		</details>
	</form>

	{call_hook name="Templates::Search::SearchResults::PreResults"}

	<h2 class="br-sr-only">{translate key="search.searchResults"}</h2>

	{if !$results->wasEmpty()}
		{assign var="count" value=$results->count}
		<div class="br-sr-only" role="status">
			{if $results->count > 1}
				{translate key="search.searchResults.foundPlural" count=$results->count}
			{else}
				{translate key="search.searchResults.foundSingle"}
			{/if}
		</div>
	{/if}

	<div class="br-search-results">
		{iterate from=results item=result}
			<article class="br-card br-card-search-result">
				{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
			</article>
		{/iterate}
	</div>

	{if $results->wasEmpty()}
		<span role="status">
			{if $error}
				{include file="frontend/components/notification.tpl" type="error" message=$error|escape}
			{else}
				{include file="frontend/components/notification.tpl" type="notice" messageKey="search.noResults"}
			{/if}
		</span>
	{else}
		<div class="br-pagination">
			{page_info iterator=$results}
			{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear}
		</div>
	{/if}

	{block name=searchSyntaxInstructions}{/block}
</div>

{include file="frontend/components/footer.tpl"}
