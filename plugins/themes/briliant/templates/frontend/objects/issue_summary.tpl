{if $issue->getShowTitle()}
{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<div class="obj_issue_summary br-issue-summary">

	{if $issueCover}
		<a class="cover br-cover" href="{url op="view" path=$issue->getBestIssueId()}">
			<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
		</a>
	{/if}

	<h2>
		<a class="title br-issue-title" href="{url op="view" path=$issue->getBestIssueId()}">
			{if $issueTitle}
				{$issueTitle|escape}
			{else}
				{$issueSeries|escape}
			{/if}
		</a>
		{if $issueTitle && $issueSeries}
			<div class="series br-issue-series">
				{$issueSeries|escape}
			</div>
		{/if}
	</h2>

	<div class="description br-description">
		{$issue->getLocalizedDescription()|strip_unsafe_html}
	</div>
</div>
