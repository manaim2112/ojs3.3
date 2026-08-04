{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
			{include file="frontend/components/skipLinks.tpl"}

			<div class="pkp_head_wrapper">

				<div class="pkp_site_name_wrapper">
					<button class="pkp_site_nav_toggle" type="button" aria-expanded="false" aria-controls="siteNavigation" aria-label="{translate key="common.navigation"}">
						<span></span>
						<span></span>
						<span></span>
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
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{$applicationName|escape}"{/if} onerror="this.onerror=null;this.src='{$baseUrl}/templates/images/structure/logo.png';this.classList.add('is-fallback');" />
						</a>
					{elseif $displayPageHeaderTitle}
						<a href="{$homeUrl}" class="is_text">{$displayPageHeaderTitle|escape}</a>
					{else}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
						</a>
					{/if}
					</div>
				</div>

				<nav class="pkp_site_nav_menu" id="siteNavigation" aria-label="{translate|escape key="common.navigation.site"}">
					<a id="siteNav"></a>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
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

				<button id="darkModeToggle" aria-label="{translate key="common.toggleDarkMode"}">
					<span class="fa fa-moon-o" id="darkIcon"></span>
				</button>

			</div>
		</header>

		<script>
		(function() {
			var key = 'briliant-theme-mode';
			var html = document.documentElement;
			var stored = localStorage.getItem(key);
			var prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
			if (stored === 'dark' || (!stored && prefersDark)) {
				html.classList.add('dark');
			}
			document.addEventListener('click', function(e) {
				var btn = e.target.closest('#darkModeToggle');
				if (!btn) return;
				var isDark = html.classList.toggle('dark');
				localStorage.setItem(key, isDark ? 'dark' : 'light');
				var icon = document.getElementById('darkIcon');
				if (icon) {
					icon.className = isDark ? 'fa fa-sun-o' : 'fa fa-moon-o';
				}
			});
		})();
		</script>

		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
