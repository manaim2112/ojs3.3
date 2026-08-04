{**
 * templates/frontend/objects/issue_summary.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a summary for use in lists
 *
 * @uses $issue Issue The issue
 *}
{if $issue->getShowTitle()}
{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<div class="obj_issue_summary dimension-issue-card">

	{if $issueCover}
		<a class="cover float-left mr-4 mb-4" href="{url op="view" path=$issue->getBestIssueId()}">
			<img class="rounded-lg hover:shadow-sm" src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}" onerror="this.onerror=null;this.src='https://placehold.co/200x260/f8f9fc/94a3b8?text=No+Cover'">
		</a>

		<img class="absolute w-72 blur-lg rotate-45 h-auto right-0 bottom-0 -z-5" loading="lazy"
			src="{$issueCover|escape}"
			alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
			onerror="this.onerror=null;this.style.display='none'"
		>
	{/if}

	<h2>
		<a class="title text-2xl font-bold text-blue-800 dark:text-blue-200" href="{url op="view" path=$issue->getBestIssueId()}">
			{if $issueTitle}
				{$issueTitle|escape}
			{else}
				{$issueSeries|escape}
			{/if}
		</a>
		{if $issueTitle && $issueSeries}
			<div class="series">
				{$issueSeries|escape}
			</div>
		{/if}
	</h2>

	<div class="description prose dark:prose-invert prose-p:my-[2px] w-full text-justify">
		{$issue->getLocalizedDescription()|strip_unsafe_html}
	</div>
</div><!-- .obj_issue_summary -->
