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
		<a class="dimension-issue-card-cover" href="{url op="view" path=$issue->getBestIssueId()}">
			<img loading="lazy" src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
		</a>
	{/if}

	<div class="dimension-issue-card-content">
		<p class="dimension-issue-card-label">{translate key="issue.issue"}</p>
		<h2>
			<a class="title" href="{url op="view" path=$issue->getBestIssueId()}">
				{if $issueTitle}{$issueTitle|escape}{else}{$issueSeries|escape}{/if}
			</a>
		</h2>
		{if $issueTitle && $issueSeries}
			<div class="series">{$issueSeries|escape}</div>
		{/if}
		{if $issue->getLocalizedDescription()}
			<div class="description prose dark:prose-invert">
				{$issue->getLocalizedDescription()|strip_unsafe_html}
			</div>
		{/if}
	</div>
</div><!-- .obj_issue_summary -->
