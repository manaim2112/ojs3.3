{**
 * templates/frontend/components/header.tpl
 * Premium header — top bar, sticky glass nav, portal dropdown, OJS user nav.
 * Design reference: assyfa.com
 *}
{strip}
  {assign var="showingLogo" value=true}
  {if !$displayPageHeaderLogo}
    {assign var="showingLogo" value=false}
  {/if}
{/strip}

<!DOCTYPE html>
<html class="scroll-smooth" lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">

{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}

{include file="frontend/components/headerHead.tpl"}

<body class="antialiased scroll-smooth dark:bg-gray-900 dark:text-gray-100 {if $activeTheme}theme-{$activeTheme->getOption('themesSelection')|escape}{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

{if $activeTheme && $activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
<div class="relative w-full overflow-hidden">
    <img class="w-full h-auto object-cover object-center transition-all duration-500"
         src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"
         {if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}
         onerror="this.onerror=null;this.style.display='none'">
    <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent flex items-end justify-center p-8 opacity-0 hover:opacity-100 transition-opacity duration-500">
        <h1 class="text-white text-3xl md:text-5xl font-bold drop-shadow-lg text-center">
            {$displayPageHeaderTitle|escape}
        </h1>
    </div>
</div>
{/if}

{* Top Info Bar *}
<div class="top_bar">
  <div class="top_bar_inner">
    <div class="top_bar_left">
      <span class="top_bar_pulse"></span>
      <span>{translate key="common.openAccess"} — {translate key="site.journalView"}</span>
      <span class="top_bar_divider">|</span>
      <span>{$applicationName|escape}</span>
    </div>
    <div class="top_bar_right">
      {if $currentContext}
      <a href="mailto:{$currentContext->getData('supportEmail')|escape}" class="top_bar_link">
        <i class="fas fa-envelope"></i> {$currentContext->getData('supportEmail')|escape}
      </a>
      {else}
      <a href="mailto:{$applicationName|escape}@{$smarty.server.SERVER_NAME|escape}" class="top_bar_link">
        <i class="fas fa-envelope"></i> {$applicationName|escape}
      </a>
      {/if}
    </div>
  </div>
</div>

{* Sticky Header Navigation *}
<header id="siteHeader" class="site_header">
  <div class="site_header_gradient"></div>
  <div class="site_header_inner">
    <div class="site_header_main">

      {* Logo *}
      <a href="{url page="index" router=$smarty.const.ROUTE_PAGE}" class="site_logo">
        {if $displayPageHeaderLogo}
          <img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" alt="{$displayPageHeaderTitle|escape}" class="site_logo_img">
        {elseif $displayPageHeaderTitle}
          <span class="site_logo_title">{$displayPageHeaderTitle|escape}</span>
        {else}
          <span class="site_logo_title">{$applicationName|escape}</span>
        {/if}
        <span class="site_logo_sub">{translate key="site.journalView"}</span>
      </a>

      {* Desktop Nav *}
      <nav class="site_nav">
        <a href="#history" class="site_nav_link">History</a>
        <a href="#tim" class="site_nav_link">Tim</a>
        <a href="#organisasi" class="site_nav_link">Organization</a>
      </nav>

      {* Right Actions *}
      <div class="site_actions">
        {* Portal Dropdown *}
        <div class="portal_dropdown">
          <button type="button" class="portal_btn" id="portalBtn">
            <i class="fas fa-door-open"></i>
            <span>{translate key="navigation.portal"}</span>
            <i class="fas fa-chevron-down portal_chevron"></i>
          </button>
          <div class="portal_menu" id="portalMenu">
            <a href="https://journal.assyfa.com/index.php/" target="_blank" class="portal_menu_item">
              <span class="portal_menu_icon portal_menu_icon--ojs"><i class="fas fa-file-signature"></i></span>
              <div>
                <span class="portal_menu_title">{translate key="site.journalView"} OJS</span>
                <span class="portal_menu_desc">{translate key="common.openAccess"}</span>
              </div>
            </a>
            <a href="https://press.assyfa.com" target="_blank" class="portal_menu_item">
              <span class="portal_menu_icon portal_menu_icon--press"><i class="fas fa-book-open"></i></span>
              <div>
                <span class="portal_menu_title">Assyfa Press</span>
                <span class="portal_menu_desc">{translate key="common.license"}</span>
              </div>
            </a>
          </div>
        </div>

        {* Dark Mode *}
        <button id="darkModeToggle" class="site_action_btn" aria-label="{translate key="common.toggleDarkMode"}">
          <svg class="site_icon_dark" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/></svg>
          <svg class="site_icon_light" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
        </button>

        {* User Nav *}
        {load_menu name="user" id="navigationUser" liClass="site_user_nav"}

        {* Mobile Toggle *}
        <button id="mobileToggle" class="site_mobile_btn">
          <i class="fas fa-bars"></i>
        </button>
      </div>

    </div>
  </div>
</header>

{* Mobile Drawer *}
<div id="mobileDrawer" class="mobile_drawer">
  <div class="mobile_drawer_overlay" id="mobileOverlay"></div>
  <aside class="mobile_drawer_panel">
    <div class="mobile_drawer_header">
      <span class="site_logo_title">{$applicationName|escape}</span>
      <button id="mobileClose" class="mobile_close_btn"><i class="fas fa-times"></i></button>
    </div>
    <nav class="mobile_drawer_body">
      <a href="#history" class="mobile_nav_link">History</a>
      <a href="#tim" class="mobile_nav_link">Tim</a>
      <a href="#organisasi" class="mobile_nav_link">Organization</a>
      <hr class="mobile_divider">
    </nav>
    <div class="mobile_drawer_footer">
      <a href="https://journal.assyfa.com/index.php/" target="_blank" class="mobile_portal_btn">
        <i class="fas fa-file-signature"></i> {translate key="site.journalView"} OJS
      </a>
      <a href="https://press.assyfa.com" target="_blank" class="mobile_portal_btn">
        <i class="fas fa-book-open"></i> Assyfa Press
      </a>
    </div>
  </aside>
</div>

{* Header Scripts *}
<script>
(function() {
  var header = document.getElementById('siteHeader');
  if (header) {
    window.addEventListener('scroll', function() {
      header.classList.toggle('site_header--scrolled', window.scrollY > 20);
    }, { passive: true });
  }
})();
(function() {
  var btn = document.getElementById('portalBtn');
  var menu = document.getElementById('portalMenu');
  if (btn && menu) {
    btn.addEventListener('click', function(e) {
      e.stopPropagation();
      menu.classList.toggle('portal_menu--open');
      btn.classList.toggle('portal_btn--active');
    });
    document.addEventListener('click', function() {
      menu.classList.remove('portal_menu--open');
      btn.classList.remove('portal_btn--active');
    });
    menu.addEventListener('click', function(e) { e.stopPropagation(); });
  }
})();
(function() {
  var toggle = document.getElementById('mobileToggle');
  var drawer = document.getElementById('mobileDrawer');
  var overlay = document.getElementById('mobileOverlay');
  var close = document.getElementById('mobileClose');
  if (toggle && drawer && overlay && close) {
    toggle.addEventListener('click', function() { drawer.classList.add('mobile_drawer--open'); document.body.style.overflow = 'hidden'; });
    close.addEventListener('click', function() { drawer.classList.remove('mobile_drawer--open'); document.body.style.overflow = ''; });
    overlay.addEventListener('click', function() { drawer.classList.remove('mobile_drawer--open'); document.body.style.overflow = ''; });
    document.addEventListener('keydown', function(e) { if (e.key === 'Escape') { drawer.classList.remove('mobile_drawer--open'); document.body.style.overflow = ''; } });
  }
})();
(function() {
  var key = 'dimension-theme-pref';
  var html = document.documentElement;
  var stored = localStorage.getItem(key);
  var prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  if (stored === 'dark' || (!stored && prefersDark)) html.classList.add('dark');
  else html.classList.remove('dark');
  document.addEventListener('click', function(e) {
    var btn = e.target.closest('#darkModeToggle');
    if (!btn) return;
    var isDark = html.classList.toggle('dark');
    localStorage.setItem(key, isDark ? 'dark' : 'light');
  });
})();
</script>

<div class="pkp_structure_main page_content">
