<div class="pkp_form">
	<h3>{translate key="plugins.generic.loa.management"}</h3>

	{if $loa}
		<div class="pkp_help" style="margin-bottom: 15px;">
			<p><strong>{translate key="plugins.generic.loa.uniqueCode"}:</strong> {$loa->getUniqueCode()|escape}</p>
			<p><strong>{translate key="plugins.generic.loa.dateGenerated"}:</strong> {$loa->getDateGenerated()|escape}</p>
			<p><strong>{translate key="plugins.generic.loa.status"}:</strong>
				{if $loa->getStatus() == 'active'}
					<span style="color: green; font-weight: bold;">{translate key="plugins.generic.loa.statusActive"}</span>
				{else}
					<span style="color: red; font-weight: bold;">{translate key="plugins.generic.loa.statusRevoked"}</span>
				{/if}
			</p>
			{if $loa->getDateDownloaded()}
				<p><strong>{translate key="plugins.generic.loa.lastDownloaded"}:</strong> {$loa->getDateDownloaded()|escape}</p>
			{/if}
			{if $generatedByUser}
				<p><strong>{translate key="plugins.generic.loa.generatedBy"}:</strong> {$generatedByUser->getFullName()|escape}</p>
			{/if}
		</div>

		<div class="pkp_form_area">
			<a href="{$loaViewUrl|escape}/{$loa->getUniqueCode()|escape}" class="pkp_button" target="_blank">
				{translate key="plugins.generic.loa.download"}
			</a>

			{if $canManage}
				<button
					type="button"
					class="pkp_button"
					style="margin-left: 5px;"
					data-loa-issue-trigger="1"
					data-mode="regenerate"
					data-action="{$loaRegenerateUrl|escape}"
					data-submission-id="{$submissionId|escape}"
					data-issue-id="{$currentIssueId|escape}"
				>
					{translate key="plugins.generic.loa.regenerate"}
				</button>

				{if $loa->getStatus() == 'active'}
					<form method="post" action="{$loaRevokeUrl|escape}" style="display:inline;" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRevoke"}">
						{csrf}
						<input type="hidden" name="submissionId" value="{$submissionId|escape}">
						<input type="hidden" name="stageId" value="{$loaReturnStageId|escape}">
						<button type="submit" class="pkp_button" style="margin-left: 5px; background-color: #dc3545;">
							{translate key="plugins.generic.loa.revoke"}
						</button>
					</form>
				{/if}
			{/if}
		</div>
	{else}
		<div class="pkp_help" style="margin-bottom: 15px;">
			<p>{translate key="plugins.generic.loa.noLoA"}</p>
		</div>

		{if $canManage}
			<button
				type="button"
				class="pkp_button"
				data-loa-issue-trigger="1"
				data-mode="generate"
				data-action="{$loaGenerateUrl|escape}"
				data-submission-id="{$submissionId|escape}"
				data-issue-id="{$currentIssueId|escape}"
			>
				{translate key="plugins.generic.loa.publish"}
			</button>
		{/if}
	{/if}
</div>
