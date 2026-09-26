{extends file="layouts/backend.tpl"}

{block name="page"}
<div class="pkp_page_content">
	<div class="loaPageHeader">
		<h1 class="app__pageHeading">
			{translate key="plugins.generic.loa.management"}
		</h1>
		<a href="{$loaTemplatesUrl|escape}" class="pkp_button">
			{translate key="plugins.generic.loa.templates"}
		</a>
	</div>

	<div class="pkp_help">
		<p>{translate key="plugins.generic.loa.managementDescription"}</p>
	</div>

	<form class="loaFilters" method="get" action="{url page="loa" op="management"}">
		<div class="loaFilters__item loaFilters__item--search">
			<label for="loaFilterSearch">{translate key="plugins.generic.loa.search"}</label>
			<input
				type="search"
				id="loaFilterSearch"
				name="search"
				value="{$currentSearch|escape}"
				placeholder="{translate key="plugins.generic.loa.searchPlaceholder"}"
			>
		</div>
		<div class="loaFilters__item loaFilters__item--issue">
			<label for="loaFilterIssue">{translate key="plugins.generic.loa.filterByIssue"}</label>
			<select id="loaFilterIssue" name="issueId">
				<option value="">{translate key="plugins.generic.loa.allIssues"}</option>
				{foreach from=$loaIssues item=issue}
					<option value="{$issue.id|escape}"{if $currentIssueId == $issue.id} selected{/if}>{$issue.label|escape}</option>
				{/foreach}
			</select>
		</div>
		<div class="loaFilters__actions">
			<button type="submit" class="pkp_button pkp_button--primary">{translate key="plugins.generic.loa.search"}</button>
			<a class="pkp_button" href="{$loaManagementUrl|escape}">{translate key="plugins.generic.loa.resetFilters"}</a>
		</div>
	</form>

	<table class="pkpTable">
		<thead>
			<tr>
				<th scope="col">{translate key="common.id"}</th>
				<th scope="col">{translate key="plugins.generic.loa.articleTitle"}</th>
				<th scope="col">{translate key="plugins.generic.loa.issue"}</th>
				<th scope="col">{translate key="plugins.generic.loa.status"}</th>
				<th scope="col">{translate key="plugins.generic.loa.uniqueCode"}</th>
				<th scope="col">{translate key="common.action"}</th>
			</tr>
		</thead>
		<tbody>
			{iterate from=articles item=article}
				<tr>
					<td>{$article.submission_id|escape}</td>
					<td>{$article.title|escape|default:"-"}<br><small>{$article.authors|escape|default:"-"}</small></td>
					<td>
						{if $article.issue && $article.issue.title}
							{$article.issue.title|escape}
							<br>
							<small>{$article.issue.volume|escape} {$article.issue.number|escape} ({$article.issue.year|escape})</small>
						{elseif $article.issue}
							{$article.issue.volume|escape} {$article.issue.number|escape} ({$article.issue.year|escape})
						{else}
							<span class="pkp_text-muted">-</span>
						{/if}
					</td>
					<td>
						{if $article.loa_status == 'active'}
							<span class="pkp_text-success">{translate key="plugins.generic.loa.statusActive"}</span>
						{elseif $article.loa_status == 'revoked'}
							<span class="pkp_text-danger">{translate key="plugins.generic.loa.statusRevoked"}</span>
						{else}
							<span class="pkp_text-muted">{translate key="plugins.generic.loa.notGenerated"}</span>
						{/if}
					</td>
					<td>
						{if $article.loa_id}
							<code>{$article.unique_code|escape}</code>
							<br>
							<small>{translate key="plugins.generic.loa.dateGenerated"}: {$article.date_generated|escape}</small>
						{else}
							<span class="pkp_text-muted">-</span>
						{/if}
					</td>
					<td>
						{if $article.loa_id && $article.loa_status == 'active'}
							<a href="{$loaViewUrl|escape}/{$article.unique_code|escape}" class="pkp_button pkp_button--primary" target="_blank">
								{translate key="plugins.generic.loa.download"}
							</a>
							{if $canManage}
								<form method="post" action="{$loaRevokeUrl|escape}" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRevoke"}">
									<input type="hidden" name="submissionId" value="{$article.submission_id|escape}">
									<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
									<button type="submit" class="pkp_button pkp_button--danger">
										{translate key="plugins.generic.loa.revoke"}
									</button>
								</form>
							{/if}
						{elseif $canManage}
							<button
								type="button"
								class="pkp_button"
								data-loa-issue-trigger="1"
								data-mode="{if $article.loa_status == 'revoked'}regenerate{else}generate{/if}"
								data-action="{$loaGenerateUrl|escape}"
								data-submission-id="{$article.submission_id|escape}"
								data-issue-id="{$article.issue_id|escape}"
							>
								{if $article.loa_status == 'revoked'}
									{translate key="plugins.generic.loa.regenerate"}
								{else}
									{translate key="plugins.generic.loa.publish"}
								{/if}
							</button>
						{/if}
					</td>
				</tr>
			{/iterate}
		</tbody>
	</table>
	<div class="gridPaging">
		{page_info iterator=$articles}
		{page_links name="loa_management" iterator=$articles params=$pageParams}
	</div>
	{if $articles->wasEmpty()}
		<div class="pkp_help">
			<p>{translate key="plugins.generic.loa.noPublishedArticles"}</p>
		</div>
	{/if}
</div>

{$loaIssueDialog}
{/block}
