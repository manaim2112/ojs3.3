{**
 * plugins/themes/klausula/templates/frontend/components/header.tpl
 *
 * Child theme override of lib/pkp/templates/frontend/components/header.tpl.
 *
 * Adds the Klausula serif journal title, an optional seal emblem and body
 * classes that carry the theme options to the stylesheet.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars?
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}

	{* Klausula theme options *}
	{assign var="klausulaEmblem" value=""}
	{assign var="klausulaCoverFrame" value=""}
	{assign var="klausulaColourScheme" value="classic"}
	{assign var="klausulaHeaderBg" value=""}
	{assign var="klausulaFooterBg" value=""}
	{if $activeTheme}
		{assign var="klausulaEmblem" value=$activeTheme->getOption('emblem')}
		{assign var="klausulaCoverFrame" value=$activeTheme->getOption('coverFrame')}
		{assign var="klausulaColourScheme" value=$activeTheme->getOption('colourScheme')}
		{assign var="klausulaHeaderBg" value=$activeTheme->getBackgroundImageUrl('headerBgImage')}
		{assign var="klausulaFooterBg" value=$activeTheme->getBackgroundImageUrl('footerBgImage')}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
{if $klausulaHeaderBg || $klausulaFooterBg}
	{* Background images for the header/footer bands, blended with the maroon base colour. *}
	<style>
		:root {
			{if $klausulaHeaderBg}--klausula-header-bg-image: url('{$klausulaHeaderBg}');{/if}
			{if $klausulaFooterBg}--klausula-footer-bg-image: url('{$klausulaFooterBg}');{/if}
		}
	</style>
{/if}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}{if $klausulaColourScheme == 'strong'} klausula_scheme_strong{/if}{if $klausulaEmblem == 'seal'} klausula_emblem_seal{/if}{if $klausulaCoverFrame == 'ruled'} klausula_cover_ruled{elseif $klausulaCoverFrame == 'plain'} klausula_cover_plain{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		{* Header *}
		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
			{* Skip to content nav links *}
			{include file="frontend/components/skipLinks.tpl"}

			<div class="pkp_head_wrapper">

				<div class="pkp_site_name_wrapper">
					<button class="pkp_site_nav_toggle">
						<span>Open Menu</span>
					</button>
					{if !$requestedPage || $requestedPage === 'index'}
						<h1 class="pkp_screen_reader">
							{if $currentContext}
								{$displayPageHeaderTitle|escape}
							{else}
								{$siteTitle|escape}
							{/if}
						</h1>
					{/if}
					<div class="pkp_site_name">
					{capture assign="homeUrl"}
						{url page="index" router=$smarty.const.ROUTE_PAGE}
					{/capture}
					{if $displayPageHeaderLogo}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if} />
						</a>
					{elseif $displayPageHeaderTitle}
						<a href="{$homeUrl}" class="is_text klausula_site_title">
							{if $klausulaEmblem == 'seal'}<span class="klausula_emblem" aria-hidden="true"><span class="fa fa-balance-scale"></span></span>{/if}<span class="klausula_site_title_text">{$displayPageHeaderTitle|escape}</span>
						</a>
					{else}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
						</a>
					{/if}
					</div>
				</div>

				{capture assign="primaryMenu"}
					{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}

				<nav class="pkp_site_nav_menu" aria-label="{translate|escape key="common.navigation.site"}">
					<a id="siteNav"></a>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{* Primary navigation menu for current application *}
							{$primaryMenu}

							{* Search form *}
							{if $currentContext && $requestedPage !== 'search'}
								<div class="pkp_navigation_search_wrapper">
									<a href="{url page="search"}" class="pkp_search pkp_search_desktop">
										<span class="fa fa-search" aria-hidden="true"></span>
										{translate key="common.search"}
									</a>
								</div>
							{/if}
						</div>
					</div>
					<div class="pkp_navigation_user_wrapper" id="navigationUserWrapper">
						{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
					</div>
				</nav>
			</div><!-- .pkp_head_wrapper -->
		</header><!-- .pkp_structure_head -->

		{* Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
