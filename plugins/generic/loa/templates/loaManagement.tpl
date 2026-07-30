<div class="pkp_page_content">
	<h1 class="app__pageHeading">
		{translate key="plugins.generic.loa.management"}
	</h1>

	<div class="pkp_help" style="margin-bottom: 15px;">
		<p>{translate key="plugins.generic.loa.managementDescription"}</p>
	</div>

	{if $articles|@count}
		<table class="pkpTable" style="width: 100%;">
			<thead>
				<tr>
					<th style="width: 5%;">{translate key="common.id"}</th>
					<th style="width: 25%;">{translate key="plugins.generic.loa.articleTitle"}</th>
					<th style="width: 20%;">{translate key="plugins.generic.loa.authors"}</th>
					<th style="width: 15%;">{translate key="plugins.generic.loa.issue"}</th>
					<th style="width: 15%;">{translate key="plugins.generic.loa.uniqueCode"}</th>
					<th style="width: 10%;">{translate key="plugins.generic.loa.status"}</th>
					<th style="width: 15%;">{translate key="common.action"}</th>
				</tr>
			</thead>
			<tbody>
				{foreach from=$articles item=article}
					<tr>
						<td>{$article.submission_id|escape}</td>
						<td>{$article.title|escape|default:"-"}</td>
						<td>{$article.authors|escape|default:"-"}</td>
						<td>
							{if $article.issue}
								{$article.issue.title|escape}
								<br>
								<small style="color: #666;">{$article.issue.volume|escape} {$article.issue.number|escape} ({$article.issue.year|escape})</small>
							{else}
								<span style="color: #999;">-</span>
							{/if}
						</td>
						<td>
							{if $article.loa_id}
								<code style="font-size: 11px;">{$article.unique_code|escape}</code>
								<br>
								<small style="color: #666;">{$article.date_generated|escape}</small>
							{else}
								<span style="color: #999;">{translate key="plugins.generic.loa.notGenerated"}</span>
							{/if}
						</td>
						<td>
							{if $article.loa_status == 'active'}
								<span style="color: green; font-weight: bold;">{translate key="plugins.generic.loa.statusActive"}</span>
							{elseif $article.loa_status == 'revoked'}
								<span style="color: red; font-weight: bold;">{translate key="plugins.generic.loa.statusRevoked"}</span>
							{else}
								<span style="color: #999;">{translate key="plugins.generic.loa.notGenerated"}</span>
							{/if}
						</td>
						<td>
							{if $article.loa_id && $article.loa_status == 'active'}
								<a href="{$loaViewUrl|escape}/{$article.unique_code|escape}" class="pkp_button" target="_blank" style="font-size: 12px;">
									{translate key="plugins.generic.loa.download"}
								</a>
							<form method="post" action="{$loaRevokeUrl|escape}" style="display:inline;" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRevoke"}">
								<input type="hidden" name="submissionId" value="{$article.submission_id|escape}">
								<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
								<button type="submit" class="pkp_button" style="margin-left: 3px; font-size: 12px; background-color: #dc3545;">
									{translate key="plugins.generic.loa.revoke"}
								</button>
							</form>
						{else}
							<form method="post" action="{$loaGenerateUrl|escape}" style="display:inline;">
								<input type="hidden" name="submissionId" value="{$article.submission_id|escape}">
								<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
									<button type="submit" class="pkp_button" style="font-size: 12px;">
										{if $article.loa_status == 'revoked'}
											{translate key="plugins.generic.loa.regenerate"}
										{else}
											{translate key="plugins.generic.loa.generate"}
										{/if}
									</button>
								</form>
							{/if}
						</td>
					</tr>
				{/foreach}
			</tbody>
		</table>
	{else}
		<div class="pkp_help" style="margin-bottom: 15px;">
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