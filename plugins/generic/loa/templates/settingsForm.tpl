<script>
	$(function() {
		$('#loaSettingsForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
	});
</script>

<form class="pkp_form" id="loaSettingsForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" category="generic" plugin=$pluginName verb="settings" save=true}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="loaSettingsFormNotification"}

	<div id="description">{translate key="plugins.generic.loa.description"}</div>

	{fbvFormArea id="loaSettingsFormArea"}
		{fbvFormSection title="plugins.generic.loa.editorInChiefName"}
			{fbvElement type="text" id="editorInChiefName" value=$editorInChiefName maxlength="255"}
		{/fbvFormSection}

		{fbvFormSection title="plugins.generic.loa.editorInChiefTitle"}
			{fbvElement type="text" id="editorInChiefTitle" value=$editorInChiefTitle maxlength="255"}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons submitText="plugins.generic.loa.save"}
</form>
