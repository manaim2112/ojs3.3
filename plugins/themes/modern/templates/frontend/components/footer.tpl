{**
 * templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common site frontend footer.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}

	</div><!-- pkp_structure_main -->

	{* Sidebars *}
	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
				{$sidebarCode}
			</div><!-- pkp_sidebar.left -->
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

<div class="pkp_structure_footer_wrapper" role="contentinfo">
	<a id="pkp_content_footer"></a>

	<div class="pkp_structure_footer">

		{if $pageFooter}
			<div class="pkp_footer_content">
				{$pageFooter}
			</div>
		{/if}

		<div class="pkp_brand_footer" role="complementary">
			<a href="{url page="about" op="aboutThisPublishingSystem"}">
				<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
			</a>
		</div>
	</div>
</div><!-- pkp_structure_footer_wrapper -->

{assign var="sc_project" value=$activeTheme->getOption('statCounter_project_id')}
{assign var="sc_security" value=$activeTheme->getOption('statCounter_security_id')}
{if $sc_project && $sc_security}
<div class="pkp_statcounter_badge" style="text-align:center;padding:8px 0;background:#f8f9fa;border-top:1px solid #e9ecef;">
    <a href="https://statcounter.com/p{$sc_project}/?guest=1" target="_blank" rel="noopener">
        <img src="https://statcounter.com/images/logo-statcounter-arc.svg" alt="StatCounter" style="height:28px;">
    </a>
</div>
{/if}
</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
{if $sc_project && $sc_security}
<script type="text/javascript">
    var sc_project="{$sc_project}";
    var sc_invisible=1;
    var sc_security="{$sc_security}";
    var scJsHost = "https://";
    document.write("<sc"+"ript type='text/javascript' src='" +
    scJsHost+
    "statcounter.com/counter/counter.js'></"+"script>");
</script>
<noscript><div class="statcounter"><a title="Web Analytics
    Made Easy - Statcounter" href="https://statcounter.com/"
    target="_blank"><img class="statcounter"
    src="https://c.statcounter.com/{$sc_project}/0/{$sc_security}/0/"
    alt="Web Analytics Made Easy - Statcounter"
    referrerPolicy="no-referrer-when-downgrade"></a></div></noscript>
{/if}
</body>
</html>
