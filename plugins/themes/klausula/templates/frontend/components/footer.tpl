{**
 * plugins/themes/klausula/templates/frontend/components/footer.tpl
 *
 * Child theme override of lib/pkp/templates/frontend/components/footer.tpl.
 *
 * Adds the publisher contact block above the configured page footer.
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

		{assign var="klausulaPublisherName" value=$activeTheme->getOption('publisherName')}
		{assign var="klausulaPublisherUrl" value=$activeTheme->getOption('publisherUrl')}
		{assign var="klausulaPublisherPhone" value=$activeTheme->getOption('publisherPhone')}
		{if $klausulaPublisherName || $klausulaPublisherUrl || $klausulaPublisherPhone}
			<div class="klausula_footer_contact">
				{if $klausulaPublisherUrl}
					<a class="klausula_contact_icon" href="{$klausulaPublisherUrl|escape}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.klausula.contact.website"}">
						<span class="fa fa-globe" aria-hidden="true"></span>
					</a>
				{/if}
				{if $klausulaPublisherPhone}
					<a class="klausula_contact_icon" href="tel:{$klausulaPublisherPhone|escape:"url"}" aria-label="{translate|escape key="plugins.themes.klausula.contact.phone"}">
						<span class="fa fa-phone" aria-hidden="true"></span>
					</a>
				{/if}
				{if $klausulaPublisherName}
					<span class="klausula_publisher_name">{$klausulaPublisherName|escape}</span>
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
