<form id="loaTemplateForm" class="pkp_form" method="post" action="{$saveUrl|escape}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="loaTemplateFormNotification"}

	<div id="description">{translate key="plugins.generic.loa.templateFormDescription"}</div>

	{fbvFormArea id="loaTemplateFormArea"}
		{fbvFormSection title="plugins.generic.loa.templateName" required=true}
			{fbvElement type="text" id="templateName" name="templateName" value=$templateName maxlength="255"}
		{/fbvFormSection}

		{fbvFormSection title="plugins.generic.loa.templateContent" label="plugins.generic.loa.templateContentHelp"}
			{fbvElement type="textarea" name="templateContent" id="templateContent" value=$templateContent rich=true height=$fbvStyles.height.TALL}
		{/fbvFormSection}

		{fbvFormSection list=true title="plugins.generic.loa.activateTemplateLabel"}
			{fbvElement type="checkbox" id="isActive" name="isActive" value="1" checked=$isActive label="plugins.generic.loa.activateTemplate"}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons submitText="plugins.generic.loa.save"}
</form>
