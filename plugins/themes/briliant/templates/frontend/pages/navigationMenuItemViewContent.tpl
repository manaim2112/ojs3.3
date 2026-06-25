{include file="frontend/components/header.tpl" pageTitleTranslated=$title}

{include file="frontend/components/breadcrumbs.tpl" currentTitle=$title}

<div class="br-page br-page-navigation-item">
	<h1 class="br-page-title">{$title|escape}</h1>
	<div class="br-card br-card-navigation-content">
		{$content}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
