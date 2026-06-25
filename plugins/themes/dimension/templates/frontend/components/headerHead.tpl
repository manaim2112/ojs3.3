<head>
	<meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>
		{$pageTitleTranslated|strip_tags}{* Add the journal name to the end of page titles *}{if $requestedPage|escape|default:"index" != 'index' && $currentContext && $currentContext->getLocalizedName()}
			| {$currentContext->getLocalizedName()}
		{/if}
	</title>
	<meta name="generator" content="{$pageTitleTranslated|strip_tags}{if $requestedPage|escape|default:"index" != 'index' && $currentContext && $currentContext->getLocalizedName()}
			| {$currentContext->getLocalizedName()}{/if}">
	{* enable google scholar plugin *}
	{load_header context="frontend"}
	{load_stylesheet context="frontend"}
	<link rel="stylesheet" href="/plugins/themes/dimension/styles/reboot.css" type="text/css"/>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	{* <link rel="stylesheet" href="/plugins/themes/dimension/js/script.js" type="text/css"/> *}
</head>
