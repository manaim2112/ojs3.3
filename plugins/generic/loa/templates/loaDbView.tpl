<!DOCTYPE html>
<html lang="{if $currentLocale}{$currentLocale|replace:"_":"-"|truncate:5:"":true}{else}id{/if}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="plugins.generic.loa.documentTitle"}</title>
	<style>
		body { font-family: 'Times New Roman', Times, serif; margin: 0; padding: 0; background: #f0f0f0; }
		.wrap { max-width: 900px; margin: 0 auto; padding: 20px; }
		.toolbar { text-align: center; margin-bottom: 16px; }
		.btn-print { padding: 10px 30px; font-size: 16px; cursor: pointer; }
		.revoked-banner { background: #f8d7da; border: 2px solid #dc3545; color: #721c24; padding: 14px 18px; text-align: center; font-weight: bold; margin-bottom: 16px; border-radius: 6px; }
		.template { background: #ffffff; }
	</style>
	{$templateStyle}
</head>
<body>
	<div class="wrap">
		<div class="toolbar no-print">
			<button class="btn-print" onclick="window.print()">{translate key="plugins.generic.loa.print"}</button>
		</div>
		{if $isRevoked}
			<div class="revoked-banner no-print">
				{translate key="plugins.generic.loa.statusRevoked"}
			</div>
		{/if}
		<div class="template">
			{$templateHtml}
		</div>
	</div>
	<style>
		@media print {
			body { background: #ffffff; }
			.wrap { max-width: 100%; padding: 0; }
			.toolbar, .no-print { display: none !important; }
			.template { background: #ffffff; }
		}
	</style>
</body>
</html>