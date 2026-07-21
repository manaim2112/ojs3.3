<div class="pkp_page_content">
	<h3>{translate key="plugins.generic.loa.settings"}</h3>

	<form method="post" action="{url op="manage" params=["verb" => "settings", "plugin" => "loa", "category" => "generic"]}" enctype="multipart/form-data" id="loaSettingsForm">
		{csrf}

		{fbvFormArea}
			{fbvFormSection title="plugins.generic.loa.editorInChiefName"}
				{fbvElement type="text" id="editorInChiefName" value=$editorInChiefName maxlength="255"}
			{/fbvFormSection}

			{fbvFormSection title="plugins.generic.loa.editorInChiefTitle"}
				{fbvElement type="text" id="editorInChiefTitle" value=$editorInChiefTitle maxlength="255" placeholder="Editor-in-Chief"}
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

			{fbvFormSection title="plugins.generic.loa.customBodyHtml"}
				<p class="pkp_help">{translate key="plugins.generic.loa.customBodyHtmlHelp"}</p>
				{fbvElement type="textarea" id="customBodyHtml" value=$customBodyHtml rows="15" rich="extended"}
			{/fbvFormSection}
		{/fbvFormArea}

		<div class="pkp_form_buttons">
			{fbvElement type="submit" id="save" label="plugins.generic.loa.save"}
		</div>
	</form>
</div>

<script>
(function() {
	var form = document.getElementById('loaSettingsForm');
	if (!form) return;

	form.addEventListener('submit', function(e) {
		e.preventDefault();

		var formData = new FormData(form);
		formData.append('save', 'true');

		var xhr = new XMLHttpRequest();
		xhr.open('POST', form.action, true);
		xhr.setRequestHeader('X-CSRF-Token', document.querySelector('input[name="csrfToken"]')?.value || '');

		xhr.onload = function() {
			try {
				var response = JSON.parse(xhr.responseText);
				if (response.status === true) {
					$('#loaSettingsForm').parent().html(
						'<div class="pkp_page_content"><p style="color:green;font-weight:bold;text-align:center;padding:40px;">' +
						response.content +
						'</p><div style="text-align:center"><button class="pkp_button" onclick="window.location.reload()">OK</button></div></div>'
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
	});
})();
</script>
