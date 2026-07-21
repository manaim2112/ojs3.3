<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"|truncate:5:"":true}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="plugins.generic.loa.verificationPageTitle"}</title>
	<style>
		body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background: #f4f4f4; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
		.container { max-width: 600px; width: 100%; padding: 20px; }
		.card { background: #fff; border-radius: 8px; padding: 40px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
		h1 { font-size: 24px; margin: 0 0 10px 0; color: #333; text-align: center; }
		p.desc { text-align: center; color: #666; margin-bottom: 30px; font-size: 14px; }
		.form-group { margin-bottom: 20px; }
		label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; font-size: 14px; }
		input[type="text"] { width: 100%; padding: 12px 15px; border: 2px solid #ddd; border-radius: 4px; font-size: 16px; box-sizing: border-box; }
		input[type="text"]:focus { border-color: #007bff; outline: none; }
		button { width: 100%; padding: 12px; background: #007bff; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
		button:hover { background: #0056b3; }
		.result { margin-top: 30px; padding: 20px; border-radius: 4px; }
		.result.valid { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
		.result.invalid { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
		.result.empty { background: #fff3cd; border: 1px solid #ffeeba; color: #856404; }
		.result h3 { margin: 0 0 10px 0; }
		.result p { margin: 5px 0; font-size: 14px; }
		.result table { width: 100%; border-collapse: collapse; margin-top: 10px; }
		.result td { padding: 6px 10px; border-bottom: 1px solid rgba(0,0,0,0.05); font-size: 14px; }
		.result td:first-child { font-weight: bold; width: 120px; }
		.back-link { display: block; text-align: center; margin-top: 20px; color: #007bff; text-decoration: none; font-size: 14px; }
	</style>
</head>
<body>
	<div class="container">
		<div class="card">
			<h1>{translate key="plugins.generic.loa.verificationPageTitle"}</h1>
			<p class="desc">{translate key="plugins.generic.loa.verificationDesc"}</p>

			<form method="post">
				<div class="form-group">
					<label for="code">{translate key="plugins.generic.loa.verificationCode"}</label>
					<input type="text" id="code" name="code" value="{$code|escape}" placeholder="{translate key="plugins.generic.loa.enterCode"}" required>
				</div>
				<button type="submit">{translate key="plugins.generic.loa.verify"}</button>
			</form>

			{if $result}
				<div class="result {$result|escape}">
					{if $result == 'valid'}
						<h3>{translate key="plugins.generic.loa.verificationValid"}</h3>
						<p>{translate key="plugins.generic.loa.verificationCodeValid"} <strong>{$code|escape}</strong></p>
						{if $publication}
						<table>
							<tr><td>{translate key="plugins.generic.loa.articleTitle"}</td><td>{$publication->getLocalizedTitle()|escape}</td></tr>
							<tr><td>{translate key="plugins.generic.loa.authors"}</td><td>
								{assign var=authors value=$publication->getData('authors')}
								{foreach name=authors from=$authors item=author}
									{$author->getFullName()|escape}{if !$smarty.foreach.authors.last}, {/if}
								{/foreach}
							</td></tr>
							<tr><td>{translate key="plugins.generic.loa.dateGenerated"}</td><td>{$loa->getDateGenerated()|escape}</td></tr>
							<tr><td>{translate key="plugins.generic.loa.journal"}</td><td>{$context->getLocalizedData('name')|escape}</td></tr>
						</table>
						{/if}
					{elseif $result == 'invalid'}
						<h3>{translate key="plugins.generic.loa.verificationInvalid"}</h3>
						<p>{translate key="plugins.generic.loa.verificationCodeInvalid"}</p>
					{elseif $result == 'empty'}
						<h3>{translate key="plugins.generic.loa.verificationEmpty"}</h3>
						<p>{translate key="plugins.generic.loa.verificationCodeEmpty"}</p>
					{/if}
				</div>
			{/if}

			<a href="{$requestedPage|escape}" class="back-link">{translate key="plugins.generic.loa.backToHome"}</a>
		</div>
	</div>
</body>
</html>
