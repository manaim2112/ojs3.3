{**
 * templates/frontend/pages/article.tpl
 *
 * Modern theme — Article page with collapsible references.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getLocalizedFullTitle()|escape}

<div class="page page_article">
	{if $section}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
	{else}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="common.publication"}
	{/if}

	{* Show article overview *}
	{include file="frontend/objects/article_details.tpl"}

	{call_hook name="Templates::Article::Footer::PageFooter"}

</div><!-- .page -->

<script>
document.querySelectorAll('.modern-refs-toggle').forEach(function(btn) {
	btn.addEventListener('click', function() {
		var body = this.nextElementSibling;
		var chevron = this.querySelector('.modern-refs-chevron');
		var isHidden = body.style.display === 'none';
		body.style.display = isHidden ? 'block' : 'none';
		this.setAttribute('aria-expanded', isHidden);
		if (chevron) chevron.classList.toggle('fa-rotate-180');
	});
});
</script>

{include file="frontend/components/footer.tpl"}
