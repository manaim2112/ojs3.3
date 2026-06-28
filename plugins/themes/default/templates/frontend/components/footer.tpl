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
				{assign var="statCounter_project" value=$activeTheme->getOption('statCounter_project_id')}
				{assign var="statCounter_security" value=$activeTheme->getOption('statCounter_security_id')}
				
				{if isset($statCounter_project) && isset($statCounter_security)}
				<script type="text/javascript">
                    var sc_project="{$statCounter_project}"; 
                    var sc_invisible=0; 
                    var sc_security="{$statCounter_security}"; 
                    var scJsHost = "https://";
                    document.write("<sc"+"ript type='text/javascript' src='" +
                    scJsHost+
                    "statcounter.com/counter/counter.js'></"+"script>");
                </script>
                <noscript><div class="statcounter"><a title="Web Analytics
                    Made Easy - Statcounter" href="https://statcounter.com/"
                    target="_blank"><img class="statcounter"
                    src="https://c.statcounter.com/{$statCounter_project}/0/{$statCounter_security}/0/"
                    alt="Web Analytics Made Easy - Statcounter"
                    referrerPolicy="no-referrer-when-downgrade"></a></div></noscript>
                    <!-- End of Statcounter Code -->
                    <a
                    href="https://statcounter.com/p{$statCounter_project}/?guest=1">
                        <img style="background-color: #3a59d1; padding: 10px;" src="https://statcounter.com/images/logo-statcounter-arc.svg"></a>
				
				{/if}
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

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
