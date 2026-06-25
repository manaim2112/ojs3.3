{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<div class="br-page br-page-issue">
	{if !$issue}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitleKey="current.noCurrentIssue"}
		<div class="br-empty-state br-card">
			<h1 class="br-page-title">{translate key="current.noCurrentIssue"}</h1>
			{include file="frontend/components/notification.tpl" type="warning" messageKey="current.noCurrentIssueDesc"}
		</div>
	{else}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}
		<h1 class="br-page-title">{$issueIdentification|escape}</h1>
		<div class="br-issue-toc">
			{include file="frontend/objects/issue_toc.tpl"}
		</div>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
