	</div>

	{* Sidebars *}
	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
				{$sidebarCode}
			</div>
		{/if}
	{/if}
</div>

<section class="br-prefooter">
	<div class="br-prefooter-inner">
		<div class="br-prefooter-left">
			<h3 class="br-prefooter-title">{translate key="common.submitNow"}</h3>
			<p class="br-prefooter-text">{translate key="common.openAccess"}</p>
			<a href="{url page="about" op="submissions"}" class="br-btn br-btn-primary">
				<span class="fa fa-pencil-square-o"></span>
				{translate key="common.submitNow"}
			</a>
		</div>
		<div class="br-prefooter-right">
			<div class="br-prefooter-block">
				<h4 class="br-prefooter-block-title">{translate key="common.waitlistContributor"}</h4>
				<p class="br-prefooter-text-sm">{translate key="common.sponsorship"}</p>
			</div>
		</div>
	</div>
</section>

<div class="pkp_structure_footer_wrapper" role="contentinfo">
	<a id="pkp_content_footer"></a>
	<div class="pkp_structure_footer">
		{if $pageFooter}
			<div class="pkp_footer_content">
				{$pageFooter}
			</div>
		{/if}
		<div class="pkp_brand_footer" role="complementary" data-label="{translate key="common.poweredBy"}">
			<a href="{url page="about" op="aboutThisPublishingSystem"}">
				<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
			</a>
		</div>
	</div>
</div>

</div>

<script>
(function() {
	function fallback(img) {
		if (img.hasAttribute('data-fallback')) return;
		img.setAttribute('data-fallback', '1');
		var w = img.getAttribute('width') || img.naturalWidth || 400;
		var h = img.getAttribute('height') || img.naturalHeight || 300;
		var text = img.getAttribute('alt') || 'Image';
		img.src = 'https://placehold.co/' + w + 'x' + h + '/EEE/999?text=' + encodeURIComponent(text);
	}
	document.addEventListener('error', function(e) {
		if (e.target.tagName === 'IMG') fallback(e.target);
	}, true);
	document.querySelectorAll('img').forEach(function(img) {
		if (img.complete && (img.naturalWidth === 0 || img.naturalHeight === 0)) fallback(img);
	});
})();
</script>

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
