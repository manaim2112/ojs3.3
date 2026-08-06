<form id="loaTemplateForm" class="pkp_form" method="post" action="{$saveUrl|escape}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="loaTemplateFormNotification"}

	<style type="text/css">
		.loaTokenPanel { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; padding: 14px 16px; margin: 18px 0; }
		.loaTokenPanel h4 { margin: 0 0 6px; }
		.loaTokenPanelHelp { margin: 0 0 10px; color: #6c757d; }
		.loaTokenTable { width: 100%; max-width: 720px; border-collapse: collapse; }
		.loaTokenTable th, .loaTokenTable td { text-align: left; padding: 6px 10px; border-bottom: 1px solid #e9ecef; vertical-align: top; font-size: 13px; }
		.loaTokenTable th { background: #eef0f3; }
		code.loaToken { background: #f1f3f5; border: 1px solid #dee2e6; border-radius: 3px; padding: 2px 6px; color: #c7254e; white-space: nowrap; }
	</style>

	<div id="description">{translate key="plugins.generic.loa.templateFormDescription"}</div>

	{fbvFormArea id="loaTemplateFormArea"}
		{fbvFormSection title="plugins.generic.loa.templateName" required=true}
			{fbvElement type="text" id="templateName" name="templateName" value=$templateName maxlength="255"}
		{/fbvFormSection}

		{fbvFormSection title="plugins.generic.loa.templateContent" label="plugins.generic.loa.templateContentHelp"}
			{fbvElement type="textarea" name="templateContent" id="templateContent" value=$templateContent rich=true height=$fbvStyles.height.TALL}
		{/fbvFormSection}

		<div class="pkp_help_block loaTokenPanel">
			<h4>{translate key="plugins.generic.loa.tokensTitle"}</h4>
			<p class="loaTokenPanelHelp">{translate key="plugins.generic.loa.tokensHelp"}</p>
			<table class="data loaTokenTable">
				<thead>
					<tr>
						<th>{translate key="plugins.generic.loa.tokenColumn"}</th>
						<th>{translate key="plugins.generic.loa.tokenDescriptionColumn"}</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$availableTokens key=token item=labelKey}
						<tr>
							<td><code class="loaToken">{$token}</code></td>
							<td>{translate key=$labelKey}</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>

		{fbvFormSection list=true title="plugins.generic.loa.activateTemplateLabel"}
			{fbvElement type="checkbox" id="isActive" name="isActive" value="1" checked=$isActive label="plugins.generic.loa.activateTemplate"}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons submitText="plugins.generic.loa.save"}
</form>
