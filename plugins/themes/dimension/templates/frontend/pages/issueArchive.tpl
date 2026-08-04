{**
 * templates/frontend/pages/issueArchive.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a list of recent issues.
 *
 * @uses $issues Array Collection of issues to display
 * @uses $prevPage int The previous page number
 * @uses $nextPage int The next page number
 * @uses $showingStart int The number of the first item on this page
 * @uses $showingEnd int The number of the last item on this page
 * @uses $total int Count of all published monographs
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}
{include file="frontend/components/breadcrumbs.tpl" currentTitle=$pageTitle}

<div class="dimension-page-shell grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto">
	{include file="frontend/components/sideLeft.tpl"}

	<div class="page page_issue_archive dimension-archive order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8">
		<header class="dimension-archive-header">
			<p class="dimension-eyebrow">{translate key="archive.archives"}</p>
			<div class="text-3xl md:text-5xl font-bold">
			{$pageTitle|escape}
			</div>
		</header>
	
		{* No issues have been published *}
		{if empty($issues)}
			<p>{translate key="current.noCurrentIssueDesc"}</p>
	
		{* List issues *}
		{else}
			<ul class="issues_archive">
				{foreach from=$issues item="issue"}
					<li>
						{include file="frontend/objects/issue_summary.tpl"}
					</li>
				{/foreach}
			</ul>
	
			{* Pagination *}
			{if $prevPage > 1}
				{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
			{elseif $prevPage === 1}
				{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}{/capture}
			{/if}
			{if $nextPage}
				{capture assign=nextUrl}{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
			{/if}
			{include
				file="frontend/components/pagination.tpl"
				prevUrl=$prevUrl
				nextUrl=$nextUrl
				showingStart=$showingStart
				showingEnd=$showingEnd
				total=$total
			}
		{/if}
	</div>
	{include file="frontend/components/sideRight.tpl"}

</div>

{include file="frontend/components/footer.tpl"}
