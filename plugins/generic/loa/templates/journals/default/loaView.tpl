<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"|truncate:5:"":true}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="plugins.generic.loa.documentTitle"}</title>
	<style>
		body { font-family: 'Times New Roman', Times, serif; margin: 0; padding: 40px; color: #333; }
		.loa-container { max-width: 800px; margin: 0 auto; border: 2px solid #333; padding: 40px; position: relative; }
		.header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px; }
		.header h1 { font-size: 24px; margin: 0 0 5px 0; text-transform: uppercase; }
		.header h2 { font-size: 18px; margin: 0; color: #555; }
		.content { margin-bottom: 30px; }
		.content p { font-size: 14px; line-height: 1.8; text-align: justify; }

		.loa-code { text-align: center; margin: 30px 0; padding: 20px; background: #f5f5f5; border: 1px dashed #333; }
		.loa-code .label { font-size: 12px; text-transform: uppercase; color: #777; }
		.loa-code .code { font-size: 28px; font-weight: bold; letter-spacing: 3px; color: #000; margin-top: 5px; }
		.meta { margin: 20px 0; }
		.meta table { width: 100%; border-collapse: collapse; }
		.meta td { padding: 8px 10px; border-bottom: 1px solid #eee; font-size: 14px; }
		.meta td:first-child { font-weight: bold; width: 150px; color: #555; }
		.status-active { color: green; font-weight: bold; }
		.status-revoked { color: red; font-weight: bold; }
		.signature-area { margin-top: 50px; display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; }
		.signature-box { text-align: center; min-width: 200px; }
		.signature-box .signature-line { margin-bottom: 5px; }
		.signature-box .signature-line img { max-height: 70px; }
		.signature-box .title { font-size: 12px; color: #555; margin-bottom: 2px; }
		.signature-box .name { font-weight: bold; font-size: 14px; }
		.stamp-box { text-align: center; }
		.stamp-box img { max-height: 100px; }
		.stamp-box .stamp-label { font-size: 11px; color: #777; margin-top: 5px; }
		.footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #ccc; font-size: 12px; color: #777; }
		.clearfix { clear: both; }
		@media print {
			body { padding: 0; }
			.loa-container { border: none; padding: 20px; }
			.no-print { display: none; }
		}
		.btn-print { display: block; margin: 20px auto; padding: 10px 30px; font-size: 16px; cursor: pointer; }
	</style>
</head>
<body>
	<button class="btn-print no-print" onclick="window.print()">{translate key="plugins.generic.loa.print"}</button>

	<div class="loa-container">
		<div class="header">
			<h1>{translate key="plugins.generic.loa.documentTitle"}</h1>
			<h2>{$context->getLocalizedData('name')|escape}</h2>
		</div>

		<div class="content">
			<p>{translate key="plugins.generic.loa.intro"}</p>
		</div>

		<div class="meta">
			<table>
				<tr>
					<td>{translate key="plugins.generic.loa.articleTitle"}</td>
					<td>{$publication->getLocalizedTitle()|escape}</td>
				</tr>
				<tr>
					<td>{translate key="plugins.generic.loa.authors"}</td>
					<td>
						{assign var=authors value=$publication->getData('authors')}
						{foreach name=authors from=$authors item=author}
							{$author->getFullName()|escape}{if !$smarty.foreach.authors.last}, {/if}
						{/foreach}
					</td>
				</tr>
				<tr>
					<td>{translate key="plugins.generic.loa.dateGenerated"}</td>
					<td>{$loa->getDateGenerated()|escape}</td>
				</tr>
				<tr>
					<td>{translate key="plugins.generic.loa.status"}</td>
					<td>
						<span class="status-{$loa->getStatus()|escape}">
							{if $loa->getStatus() == 'active'}
								{translate key="plugins.generic.loa.statusActive"}
							{else}
								{translate key="plugins.generic.loa.statusRevoked"}
							{/if}
						</span>
					</td>
				</tr>
			</table>
		</div>

		<div class="loa-code">
			<div class="label">{translate key="plugins.generic.loa.verificationCode"}</div>
			<div class="code">{$loa->getUniqueCode()|escape}</div>
		</div>

		<div class="signature-area">
			{if $signatureImage || $editorInChiefName}
			<div class="signature-box">
				<div class="signature-line">
					{if $signatureImage}
						<img src="{$baseUrl}/{$signatureImage|escape}" alt="{translate key="plugins.generic.loa.signatureImage"}">
					{else}
						<br><br>
					{/if}
				</div>
				<div class="title">{translate key="plugins.generic.loa.signatureCaption"}</div>
				{if $editorInChiefTitle}
					<div class="title">{$editorInChiefTitle|escape}</div>
				{/if}
				<div class="name">{$editorInChiefName|escape}</div>
			</div>
			{/if}

			{if $stampImage}
			<div class="stamp-box">
				<img src="{$baseUrl}/{$stampImage|escape}" alt="{translate key="plugins.generic.loa.stampImage"}">
				<div class="stamp-label">{translate key="plugins.generic.loa.stampCaption"}</div>
			</div>
			{/if}
		</div>
		<div class="clearfix"></div>

		<div class="content">
			<p>{translate key="plugins.generic.loa.disclaimer"}</p>
		</div>

		<div class="footer">
			<p>{translate key="plugins.generic.loa.footer"}</p>
		</div>
	</div>

	<button class="btn-print no-print" onclick="window.print()" style="margin-top:20px;">{translate key="plugins.generic.loa.print"}</button>
</body>
</html>
