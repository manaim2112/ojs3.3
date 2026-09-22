{**
 * plugins/themes/difusi/templates/frontend/components/footer.tpl
 *
 * Child theme override of lib/pkp/templates/frontend/components/footer.tpl.
 *
 * Adds the publisher contact block (globe / phone icons in dark green circles,
 * see style.md §3.D) above the configured page footer.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars?
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

		{assign var="jdiPublisherName" value=$activeTheme->getOption('publisherName')}
		{assign var="jdiPublisherUrl" value=$activeTheme->getOption('publisherUrl')}
		{assign var="jdiPublisherPhone" value=$activeTheme->getOption('publisherPhone')}
		{if $jdiPublisherName || $jdiPublisherUrl || $jdiPublisherPhone}
			<div class="jdi_footer_contact">
				{if $jdiPublisherUrl}
					<a class="jdi_contact_icon" href="{$jdiPublisherUrl|escape}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.difusi.contact.website"}">
						<span class="fa fa-globe" aria-hidden="true"></span>
					</a>
				{/if}
				{if $jdiPublisherPhone}
					<a class="jdi_contact_icon" href="tel:{$jdiPublisherPhone|escape:"url"}" aria-label="{translate|escape key="plugins.themes.difusi.contact.phone"}">
						<span class="fa fa-phone" aria-hidden="true"></span>
					</a>
				{/if}
				{if $jdiPublisherName}
					<span class="jdi_publisher_name">{$jdiPublisherName|escape}</span>
				{/if}
			</div>
		{/if}

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
