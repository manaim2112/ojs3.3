<script>
	$(function() {
		$('#loaSettingsForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
	});
</script>

<form class="pkp_form" id="loaSettingsForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" category="generic" plugin="loa" verb="settings" save=true}" enctype="multipart/form-data">
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

		{fbvFormSection title="plugins.generic.loa.signatureImage"}
			{if $signatureImage}
				<div style="margin-bottom:10px;">
					<p><strong>{translate key="plugins.generic.loa.currentSignature"}:</strong></p>
					<img src="{$baseUrl}/{$signatureImage|escape}" alt="{translate key="plugins.generic.loa.signatureImage"}" style="max-height:80px;border:1px solid #ddd;padding:5px;">
				</div>
			{/if}
			<input type="file" name="signatureImage" id="signatureImage" class="pkp_form_file_input">
		{/fbvFormSection}

		{fbvFormSection title="plugins.generic.loa.stampImage"}
			{if $stampImage}
				<div style="margin-bottom:10px;">
					<p><strong>{translate key="plugins.generic.loa.currentStamp"}:</strong></p>
					<img src="{$baseUrl}/{$stampImage|escape}" alt="{translate key="plugins.generic.loa.stampImage"}" style="max-height:100px;border:1px solid #ddd;padding:5px;">
				</div>
			{/if}
			<input type="file" name="stampImage" id="stampImage" class="pkp_form_file_input">
		{/fbvFormSection}

	{/fbvFormArea}

	{fbvFormButtons submitText="plugins.generic.loa.save"}
</form>

<script>
(function() {
	var form = document.getElementById('loaSettingsForm');
	if (!form) return;

	form.addEventListener('submit', function(e) {
		if (window.File && window.FormData) {
			var hasFile = form.querySelector('input[type="file"]');
			if (hasFile && (hasFile.files.length > 0 || false)) {
				e.preventDefault();
				e.stopPropagation();

				var formData = new FormData(form);
				var xhr = new XMLHttpRequest();
				xhr.open('POST', form.action, true);

				xhr.onload = function() {
					try {
						var response = JSON.parse(xhr.responseText);
						if (response.status === true) {
							$('#loaSettingsForm').parent().html(
								'<div style="text-align:center;padding:40px;">' +
								'<p style="color:green;font-weight:bold;">' + response.content + '</p>' +
								'<button class="pkp_button" onclick="location.reload()">OK</button></div>'
							);
						} else {
							alert('Error: ' + (response.content || 'Unknown error'));
						}
					} catch(e) {
						alert('An error occurred while saving settings.');
					}
				};
				xhr.onerror = function() {
					alert('A network error occurred.');
				};
				xhr.send(formData);
				return false;
			}
		}
		return true;
	});
})();
</script>