{extends file="layouts/backend.tpl"}

{block name="page"}
<div class="pkp_page_content">
	<h1 class="app__pageHeading">
		{translate key="plugins.generic.loa.templateForm"}
	</h1>

	{$formContent}

	<a href="{$backToListUrl|escape}" class="pkp_button" style="margin-top: 15px;">
		{translate key="plugins.generic.loa.backToTemplates"}
	</a>
</div>
{/block}
