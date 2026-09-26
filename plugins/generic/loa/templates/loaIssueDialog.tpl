<div class="loaIssueDialog" id="loaIssueDialog" hidden>
	<div class="loaIssueDialog__backdrop" data-loa-dialog-close="1"></div>
	<div class="loaIssueDialog__panel" role="dialog" aria-modal="true" aria-labelledby="loaIssueDialogTitle">
		<div class="loaIssueDialog__header">
			<h2 class="loaIssueDialog__title" id="loaIssueDialogTitle">
				<span data-loa-label="generate">{translate key="plugins.generic.loa.publishTitle"}</span>
				<span data-loa-label="regenerate" hidden>{translate key="plugins.generic.loa.regenerateTitle"}</span>
			</h2>
			<button type="button" class="loaIssueDialog__close" data-loa-dialog-close="1" aria-label="{translate key="common.close"}">&times;</button>
		</div>

		<p class="loaIssueDialog__desc" data-loa-desc="generate">{translate key="plugins.generic.loa.selectIssueDesc"}</p>
		<p class="loaIssueDialog__desc" data-loa-desc="regenerate" hidden>{translate key="plugins.generic.loa.selectIssueRegenerateDesc"}</p>

		<form method="post" class="loaIssueDialog__form">
			{csrf}
			<input type="hidden" name="submissionId" value="">
			<input type="hidden" name="stageId" value="{$loaReturnStageId|escape}">

			<div class="loaIssueDialog__field" data-loa-issue-field="1">
				<label for="loaIssueDialogSelect">{translate key="plugins.generic.loa.selectIssue"}</label>
				<select id="loaIssueDialogSelect" name="issueId">
					{foreach from=$loaIssues item=issue}
						<option value="{$issue.id|escape}">{$issue.label|escape}</option>
					{/foreach}
				</select>
			</div>
			<p class="loaIssueDialog__hint" data-loa-no-issues="1" hidden>{translate key="plugins.generic.loa.noIssues"}</p>

			<div class="loaIssueDialog__actions">
				<button type="button" class="pkp_button" data-loa-dialog-close="1">{translate key="plugins.generic.loa.cancel"}</button>
				<button type="submit" class="pkp_button pkp_button--primary">
					<span data-loa-submit="generate">{translate key="plugins.generic.loa.publish"}</span>
					<span data-loa-submit="regenerate" hidden>{translate key="plugins.generic.loa.regenerate"}</span>
				</button>
			</div>
		</form>
	</div>
</div>
