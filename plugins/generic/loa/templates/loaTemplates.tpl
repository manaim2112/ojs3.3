{extends file="layouts/backend.tpl"}

{block name="page"}
<div class="pkp_page_content">
	<h1 class="app__pageHeading">
		{translate key="plugins.generic.loa.templates"}
	</h1>

	<div class="pkp_help">
		<p>{translate key="plugins.generic.loa.templatesDescription"}</p>
	</div>

	<div style="margin-bottom: 15px;">
		<a href="{$addTemplateUrl|escape}" class="pkp_button pkp_button--primary">
			{translate key="plugins.generic.loa.addTemplate"}
		</a>
		<a href="{$loaManagementUrl|escape}" class="pkp_button">
			{translate key="plugins.generic.loa.backToManagement"}
		</a>
	</div>

	<table class="pkpTable">
		<thead>
			<tr>
				<th scope="col">{translate key="plugins.generic.loa.templateName"}</th>
				<th scope="col">{translate key="plugins.generic.loa.status"}</th>
				<th scope="col">{translate key="common.action"}</th>
			</tr>
		</thead>
		<tbody>
			{iterate from=templates item=template}
				<tr>
					<td>
						<strong>{$template->getTemplateName()|escape}</strong>
						<br>
						<small>{translate key="plugins.generic.loa.dateModified"}: {$template->getDateModified()|escape}</small>
					</td>
					<td>
						{if $template->getIsActive()}
							<span class="pkp_text-success">{translate key="plugins.generic.loa.statusActive"}</span>
						{else}
							<span class="pkp_text-muted">{translate key="plugins.generic.loa.statusInactive"}</span>
						{/if}
					</td>
					<td>
						<a href="{$editTemplateUrl|escape}/{$template->getTemplateId()|escape}" class="pkp_button">
							{translate key="plugins.generic.loa.editTemplate"}
						</a>
						{if !$template->getIsActive()}
							<form method="post" action="{$activateTemplateUrl|escape}" style="display:inline;">
								{csrf}
								<input type="hidden" name="templateId" value="{$template->getTemplateId()|escape}">
								<button type="submit" class="pkp_button pkp_button--primary">
									{translate key="plugins.generic.loa.activateTemplate"}
								</button>
							</form>
						{/if}
						<form method="post" action="{$deleteTemplateUrl|escape}" style="display:inline;" class="loa-delete-form" data-msg="{translate key="plugins.generic.loa.confirmDeleteTemplate"}">
							{csrf}
							<input type="hidden" name="templateId" value="{$template->getTemplateId()|escape}">
							<button type="submit" class="pkp_button pkp_button--danger">
								{translate key="plugins.generic.loa.deleteTemplate"}
							</button>
						</form>
					</td>
				</tr>
			{/iterate}
		</tbody>
	</table>

	<div class="gridPaging">
		{page_info iterator=$templates}
		{page_links name="loa_templates" iterator=$templates}
	</div>

	{if $templates->wasEmpty()}
		<div class="pkp_help">
			<p>{translate key="plugins.generic.loa.noTemplates"}</p>
		</div>
	{/if}
</div>

<script>
(function() {
	var forms = document.querySelectorAll('.loa-delete-form');
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
