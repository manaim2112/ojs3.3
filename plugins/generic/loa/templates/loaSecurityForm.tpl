<script>
	$(function() {
		$('#loaSecurityForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
	});
</script>

<form class="pkp_form" id="loaSecurityForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" category="generic" plugin=$pluginName verb="saveSecuritySettings" save=true}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="loaSecurityFormNotification"}

	{fbvFormArea id="loaSecurityFormArea"}
		{fbvFormSection list=true}
			{fbvElement type="checkbox" id="loaSecurityEnabled" name="loaSecurityEnabled" value="1" checked=$loaSecurityEnabled label="plugins.generic.loa.securityEnableLabel"}
		{/fbvFormSection}

		{fbvFormSection title="plugins.generic.loa.securityTitleLabel"}
			{fbvElement type="text" id="loaSecurityTitle" name="loaSecurityTitle" value=$loaSecurityTitle maxlength="255"}
		{/fbvFormSection}

		{fbvFormSection title="plugins.generic.loa.securityContentLabel"}
			{fbvElement type="textarea" name="loaSecurityContent" id="loaSecurityContent" value=$loaSecurityContent rich=true height=$fbvStyles.height.MEDIUM}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons submitText="plugins.generic.loa.save"}
</form>
