</div><!-- pkp_structure_main -->

{* Pre-footer section *}
<section class="bg-gradient-to-r from-blue-600 to-blue-800 dark:from-gray-800 dark:to-gray-900 py-12">
    <div class="max-w-7xl mx-auto px-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
            <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded-xl p-8 text-center md:text-left">
                <h3 class="text-2xl font-bold text-white mb-3">{translate key="common.submitNow"}</h3>
                <p class="text-blue-100 dark:text-gray-300 text-sm mb-6">
                    {translate key="about.aboutContext"} — {translate key="common.openAccess"}
                </p>
                <a href="{url page="submission" op="wizard"}"
                    class="inline-flex items-center gap-2 bg-white text-blue-700 hover:bg-blue-50 font-semibold rounded-lg px-6 py-3 transition-colors shadow-lg">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                    {translate key="about.onlineSubmissions.newSubmission"}
                </a>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded-xl p-6 text-center">
                    <svg class="w-10 h-10 mx-auto text-blue-200 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"/></svg>
                    <h4 class="text-lg font-bold text-white mb-2">{translate key="common.waitlistContributor"}</h4>
                    <p class="text-blue-100 dark:text-gray-300 text-xs">Join as reviewer, editor, or author</p>
                </div>
                <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded-xl p-6 text-center">
                    <svg class="w-10 h-10 mx-auto text-blue-200 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    <h4 class="text-lg font-bold text-white mb-2">{translate key="common.sponsorship"}</h4>
                    <p class="text-blue-100 dark:text-gray-300 text-xs">Support open access with sponsorship</p>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="bg-gradient-to-r from-blue-700 to-blue-900 py-10 text-blue-100 dark:from-gray-900 dark:to-black dark:text-gray-200">
    <div class="max-w-7xl mx-auto px-6">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10 mb-8">
            <div>
                <h4 class="text-xl font-bold mb-4 text-blue-200 dark:text-gray-100">{translate key="about.aboutContext"}</h4>
                <div class="text-sm leading-relaxed prose prose-sm prose-invert max-w-none prose-p:my-1 prose-a:text-blue-200 prose-a:hover:text-white">
                    {if $currentContext}{$currentContext->getLocalizedData('description')|default:$currentContext->getLocalizedName()|strip_unsafe_html}{elseif $site}{$site->getLocalizedTitle()|escape}{/if}
                </div>
                {if $displayPageHeaderLogo}
                <div class="mt-4">
                    <img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" alt="{$displayPageHeaderTitle|escape}" class="h-12 opacity-90 hover:opacity-100 transition-opacity duration-300">
                </div>
                {/if}
            </div>

            <div>
                <h4 class="text-xl font-bold mb-4 text-blue-200 dark:text-gray-100">{translate key="common.importantLinks"}</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="{url page="index" router=$smarty.const.ROUTE_PAGE}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300 flex items-center"><svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg> {translate key="navigation.home"}</a></li>
                    <li><a href="{url page="issue" op="archive"}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300 flex items-center"><svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4"/></svg> {translate key="navigation.archives"}</a></li>
                    <li><a href="{url page="about"}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300 flex items-center"><svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> {translate key="about.aboutContext"}</a></li>
                    <li><a href="{url page="about" op="editorialTeam"}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300 flex items-center"><svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"/></svg> {translate key="about.editorialTeam"}</a></li>
                    <li><a href="{url page="about" op="contact"}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300 flex items-center"><svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg> {translate key="about.contact"}</a></li>
                </ul>
            </div>

            <div>
                <h4 class="text-xl font-bold mb-4 text-blue-200 dark:text-gray-100">{translate key="about.contact"}</h4>
                <div class="space-y-3 text-sm">
                    {if $currentContext}
                    {if $currentContext->getLocalizedData('mailingAddress')}
                    <p class="flex items-start">
                        <svg class="w-5 h-5 mr-3 flex-shrink-0 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                        {$currentContext->getLocalizedData('mailingAddress')|escape}
                    </p>
                    {/if}
                    {/if}
                    {if $activeTheme && $activeTheme->getOption('contactPhone')}
                    <p class="flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/></svg>
                        <a href="tel:{$activeTheme->getOption('contactPhone')}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300">{$activeTheme->getOption('contactPhone')}</a>
                    </p>
                    {/if}
                    {if $currentContext}
                    <p class="flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                        <a href="mailto:{$currentContext->getData('supportEmail')}" class="hover:text-blue-300 dark:hover:text-blue-400 transition-colors duration-300">{$currentContext->getData('supportEmail')}</a>
                    </p>
                    {/if}
                </div>
            </div>

            <div>
                <h4 class="text-xl font-bold mb-4 text-blue-200 dark:text-gray-100">{translate key="common.pageFooter"}</h4>
                {if $pageFooter}
                    <div class="text-sm leading-relaxed prose prose-sm prose-invert max-w-none prose-p:my-1 prose-a:text-blue-200 prose-a:hover:text-white">
                        {$pageFooter|strip_unsafe_html}
                    </div>
                {else}
                    <p class="text-sm leading-relaxed mb-4">
                        {translate key="common.openAccess"}
                    </p>
                {/if}
            </div>
        </div>

        <hr class="border-blue-600 dark:border-gray-700 my-8">

        <div class="flex flex-col md:flex-row items-center justify-between text-xs text-blue-300 dark:text-gray-400">
            <p class="mb-3 md:mb-0 text-center md:text-left">
                &copy; {$smarty.now|date_format:"%Y"} {if $currentContext}{$currentContext->getLocalizedName()|escape}{elseif $site}{$site->getLocalizedTitle()|escape}{/if}.<br class="md:hidden">
                {translate key="common.poweredBy"} <a href="https://pkp.sfu.ca/ojs/" target="_blank" class="text-blue-200 hover:underline dark:text-blue-300 transition-colors duration-300">Open Journal Systems</a>.
            </p>
            <p class="flex items-center text-center md:text-right">
                {translate key="common.license"}:
                <a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" title="Creative Commons Attribution 4.0 International License" class="ml-2 text-blue-200 hover:underline dark:text-blue-300 flex items-center">
                    <svg class="w-4 h-4 mr-1" viewBox="0 0 16 16" fill="currentColor"><circle cx="8" cy="8" r="7.5" fill="none" stroke="currentColor" stroke-width="1"/><path d="M6.5 6a2 2 0 013 0M6.5 10a2 2 0 013 0" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round"/></svg>
                    <svg class="w-4 h-4 mr-1" viewBox="0 0 16 16" fill="currentColor"><circle cx="8" cy="8" r="7.5" fill="none" stroke="currentColor" stroke-width="1"/><path d="M4.5 8h7M10 5.5L12.5 8 10 10.5" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    CC BY 4.0
                </a>
            </p>
        </div>
    </div>
</footer>

{if $activeTheme && $activeTheme->getOption('contactPhone')}
<a href="https://wa.me/{$activeTheme->getOption('contactPhone')}?text=Halo%20admin%20jurnal%2C%20saya%20punya%20pertanyaan."
   class="fixed bottom-6 right-6 bg-green-500 text-white rounded-full p-4 shadow-lg hover:bg-green-600
          transition-all duration-300 flex items-center hover:scale-110 z-50"
   target="_blank" rel="noopener noreferrer" title="Chat via WhatsApp">
    <svg class="w-8 h-8" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
    <span class="ml-2 text-base md:text-lg">{translate key="common.chatViaWhatsapp"}</span>
</a>
{/if}

<button id="scrollToTopBtn"
        class="fixed bottom-24 right-6 bg-blue-600 text-white rounded-full p-3 shadow-lg hover:bg-blue-700
               transition-all duration-300 hover:scale-110 z-50 opacity-0 invisible"
        title="{translate key="common.scrollToTop"}">
    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"></path>
    </svg>
</button>

<script>
  const scrollToTopBtn = document.getElementById('scrollToTopBtn');
  if (scrollToTopBtn) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 300) {
        scrollToTopBtn.classList.remove('opacity-0', 'invisible');
        scrollToTopBtn.classList.add('opacity-100', 'visible');
      } else {
        scrollToTopBtn.classList.remove('opacity-100', 'visible');
        scrollToTopBtn.classList.add('opacity-0', 'invisible');
      }
    });
    scrollToTopBtn.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }
</script>

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>