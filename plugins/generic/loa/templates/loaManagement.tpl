{extends file="layouts/backend.tpl"}

{block name="page"}
<div class="pkp_page_content">
	<h1 class="app__pageHeading">
		{translate key="plugins.generic.loa.management"}
	</h1>

	<div class="pkp_help">
		<p>{translate key="plugins.generic.loa.managementDescription"}</p>
	</div>

	{if $articles|@count}
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
				{foreach from=$articles item=article}
					<tr>
						<td>{$article.submission_id|escape}</td>
						<td>{$article.title|escape|default:"-"}<br><small>{$article.authors|escape|default:"-"}</small></td>
						<td>
							{if $article.issue && $article.issue.title}
								{$article.issue.title|escape}
								<br>
								<small>{$article.issue.volume|escape} {$article.issue.number|escape} ({$article.issue.year|escape})</small>
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
								<form method="post" action="{$loaRevokeUrl|escape}" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRevoke"}">
									<input type="hidden" name="submissionId" value="{$article.submission_id|escape}">
									<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
									<button type="submit" class="pkp_button pkp_button--danger">
										{translate key="plugins.generic.loa.revoke"}
									</button>
								</form>
							{elseif $article.loa_status == 'revoked'}
								<form method="post" action="{$loaGenerateUrl|escape}" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRegenerate"}">
									<input type="hidden" name="submissionId" value="{$article.submission_id|escape}">
									<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
									<button type="submit" class="pkp_button">
										{translate key="plugins.generic.loa.regenerate"}
									</button>
								</form>
							{else}
								<form method="post" action="{$loaGenerateUrl|escape}" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRegenerate"}">
									<input type="hidden" name="submissionId" value="{$article.submission_id|escape}">
									<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
									<button type="submit" class="pkp_button">
										{translate key="plugins.generic.loa.generate"}
									</button>
								</form>
							{/if}
						</td>
					</tr>
				{/foreach}
			</tbody>
		</table>
		<div class="gridPaging">
			{page_info iterator=$articles}
			{page_links name="loa_management" iterator=$articles}
		</div>
	{else}
		<div class="pkp_help">
			<p>{translate key="plugins.generic.loa.noPublishedArticles"}</p>
		</div>
	{/if}
</div>

<script>
(function() {
	var forms = document.querySelectorAll('.loa-confirm-form');
	Array.prototype.forEach.call(forms, function(form) {
		form.addEventListener('submit', function(e) {
			if (!confirm(this.getAttribute('data-msg'))) {
				e.preventDefault();
			}
		});
	});
})();
</script>
{/block}