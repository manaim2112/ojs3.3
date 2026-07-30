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
				<form method="post" action="{$loaRegenerateUrl|escape}" style="display:inline;" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRegenerate"}">
					<input type="hidden" name="submissionId" value="{$submissionId|escape}">
					<button type="submit" class="pkp_button" style="margin-left: 5px;">
						{translate key="plugins.generic.loa.regenerate"}
					</button>
				</form>

				{if $loa->getStatus() == 'active'}
					<form method="post" action="{$loaRevokeUrl|escape}" style="display:inline;" class="loa-confirm-form" data-msg="{translate key="plugins.generic.loa.confirmRevoke"}">
						<input type="hidden" name="submissionId" value="{$submissionId|escape}">
						<button type="submit" class="pkp_button" style="margin-left: 5px; background-color: #dc3545;">
							{translate key="plugins.generic.loa.revoke"}
						</button>
					</form>
				{/if}
			{/if}
		</div>

<script>
{literal}
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
{/literal}
</script>
	{else}
		<div class="pkp_help" style="margin-bottom: 15px;">
			<p>{translate key="plugins.generic.loa.noLoA"}</p>
		</div>

		{if $canManage}
			<form method="post" action="{$loaGenerateUrl|escape}">
				<input type="hidden" name="submissionId" value="{$submissionId|escape}">
				<button type="submit" class="pkp_button">
					{translate key="plugins.generic.loa.generate"}
				</button>
			</form>
		{/if}
	{/if}
</div>