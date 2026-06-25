{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
 
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}


<!DOCTYPE html>
<html class="scroll-smooth" lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">

{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}

{include file="frontend/components/headerHead.tpl"}

<body class="antialiased scroll-smooth dark:bg-gray-900 dark:text-gray-100 theme-{$activeTheme->getOption('themesSelection')|default:'default'}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">
{if $activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
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

<header class="bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-lg sticky top-0 z-[100] dark:from-gray-800 dark:to-gray-900">
    <div class="max-w-7xl mx-auto px-6 py-3 flex justify-between items-center">
		{capture assign="homeUrl"}
			{url page="index" router=$smarty.const.ROUTE_PAGE}
	 	{/capture}
        <a href="{$homeUrl}" class="flex items-center animate-fade-in-down">
        	{if $displayPageHeaderLogo}
	        	<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" alt="{$displayPageHeaderTitle|escape}"
	        		class="h-10" onerror="this.onerror=null;this.src='https://placehold.co/160x40/1E6292/ffffff?text=Logo'">
        	{elseif $displayPageHeaderTitle}
	        	<span class="text-base font-bold tracking-tight">{$displayPageHeaderTitle|escape}</span>
        	{else}
	        	<img class="w-10" src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}"
	        		title="{$applicationName|escape}" onerror="this.onerror=null;this.src='https://placehold.co/40x40/1E6292/ffffff?text=OJ'" />
        	{/if}
		</a>

        <div class="hidden md:flex md:flex-grow md:justify-end md:items-center">
            {capture assign="primaryMenu"}
                {load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary flex space-x-2 items-center" liClass="relative group"}
            {/capture}
            {$primaryMenu}
        </div>

            <div class="relative ml-4 z-50 flex items-center gap-2">
            <button id="darkModeToggle" class="text-white p-2 rounded-full hover:bg-white/10 transition-colors" aria-label="{translate key="common.toggleDarkMode"}" data-testid="dark-toggle">
                <svg class="w-5 h-5 dark:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                </svg>
                <svg class="w-5 h-5 hidden dark:block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
            </button>
            {load_menu name="user" id="navigationUser" liClass="profile"}
        </div>

        <button id="mobileMenuButton" class="md:hidden text-white p-2 focus:outline-none transition-transform duration-300 hover:scale-110">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
            </svg>
        </button>

        <script>
        {literal}
            document.addEventListener("DOMContentLoaded", function() {
            const mobileMenuButton = document.getElementById('mobileMenuButton');
            const mobileMenu = document.getElementById('mobileMenu');
            const mobileMenuClose = document.getElementById('mobileMenuClose');
            const mobileMenuBackdrop = document.getElementById('mobileMenuBackdrop');

            // Fungsi untuk membuka menu
            function openMobileMenu() {
                mobileMenu.classList.remove('translate-x-full');
                document.body.style.overflow = 'hidden'; // Mencegah scroll di background
            }

            // Fungsi untuk menutup menu
            function closeMobileMenu() {
                mobileMenu.classList.add('translate-x-full');
                document.body.style.overflow = ''; // Mengembalikan scroll
            }

            // Event listeners
            mobileMenuButton.addEventListener('click', openMobileMenu);
            mobileMenuClose.addEventListener('click', closeMobileMenu);
            mobileMenuBackdrop.addEventListener('click', closeMobileMenu);

            // Menutup menu ketika link di dalam menu diklik
            const mobileMenuLinks = document.querySelectorAll('#mobileMenu a');
            mobileMenuLinks.forEach(link => {
                link.addEventListener('click', closeMobileMenu);
            });

            // Menutup menu ketika tombol Escape ditekan
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape' && !mobileMenu.classList.contains('translate-x-full')) {
                    closeMobileMenu();
                }
            });

            // Optional: Menutup menu ketika window di-resize ke ukuran desktop
            window.addEventListener('resize', function() {
                if (window.innerWidth >= 768) { // Sesuai dengan breakpoint md di Tailwind
                    closeMobileMenu();
                }
            });
        });
        {/literal}
        </script>
    </div>

    <div id="mobileMenu" class="fixed inset-0 z-[1000] transform translate-x-full transition-transform duration-500 ease-in-out md:hidden">
        <div class="absolute inset-0 bg-black bg-opacity-70" id="mobileMenuBackdrop"></div>
        <div class="relative h-full bg-white dark:bg-gray-700 w-3/4 max-w-sm ml-auto shadow-xl overflow-y-auto p-6">
            <button id="mobileMenuClose" class="absolute top-4 right-4 p-2 text-gray-700 hover:text-gray-900 transition-colors duration-300">
                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
            
            <nav class="mt-10">
                <ul class="space-y-3">
                    {capture assign="mobilePrimaryMenu"}
                        {load_menu name="primary" id="mobileNavigationPrimary" ulClass="space-y-2" liClass="mobile-menu-item"}
                    {/capture}
                    {$mobilePrimaryMenu}
                </ul>
            </nav>
        </div>
    </div>
</header>

<script>
(function() {
    const key = 'dimension-theme-pref';
    const html = document.documentElement;
    const stored = localStorage.getItem(key);
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    if (stored === 'dark' || (!stored && prefersDark)) {
        html.classList.add('dark');
    } else {
        html.classList.remove('dark');
    }
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('#darkModeToggle');
        if (!btn) return;
        const isDark = html.classList.toggle('dark');
        localStorage.setItem(key, isDark ? 'dark' : 'light');
    });
})();
</script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('img').forEach(function(img) {
        if (img.complete && img.naturalWidth === 0) {
            img.setAttribute('onerror', '');
            img.src = 'https://placehold.co/' + (img.getAttribute('width') || 400) + 'x' + (img.getAttribute('height') || 300) + '/e2e8f0/64748b?text=Image';
        }
    });
});
document.addEventListener('error', function(e) {
    if (e.target.tagName === 'IMG') {
        e.target.onerror = null;
        var w = e.target.getAttribute('width') || e.target.clientWidth || 400;
        var h = e.target.getAttribute('height') || e.target.clientHeight || 300;
        e.target.src = 'https://placehold.co/' + w + 'x' + h + '/e2e8f0/64748b?text=Image';
    }
}, true);
</script>

<div class="max-w-7xl mx-auto">



