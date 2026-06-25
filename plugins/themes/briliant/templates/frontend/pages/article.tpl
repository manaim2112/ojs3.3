{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getLocalizedFullTitle()|escape}

<div id="br-reading-progress"></div>

<div class="br-page br-page-article">
	{if $section}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
	{else}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="common.publication"}
	{/if}

	<article class="br-article-container">
		{include file="frontend/objects/article_details.tpl"}
	</article>

	{capture assign="similarArticles"}{call_hook name="Templates::Article::Footer::PageFooter"}{/capture}
	{if $similarArticles|trim}
		<section class="br-similar-articles">
			<button type="button" class="br-similar-toggle" aria-expanded="false">
				<span>{translate key="common.relatedArticles"}</span>
				<span class="fa fa-chevron-down br-similar-chevron"></span>
			</button>
			<div class="br-similar-body">
				{$similarArticles}
			</div>
		</section>
	{/if}
</div>

<script>
(function() {
	var bar = document.getElementById('br-reading-progress');
	if (bar) {
		window.addEventListener('scroll', function() {
			var scrollTop = window.scrollY || document.documentElement.scrollTop;
			var docHeight = document.documentElement.scrollHeight - window.innerHeight;
			var progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
			bar.style.width = progress + '%';
		}, { passive: true });
	}
})();

document.querySelectorAll('.br-similar-toggle').forEach(function(btn) {
	btn.addEventListener('click', function() {
		var body = this.nextElementSibling;
		var chevron = this.querySelector('.br-similar-chevron');
		var isHidden = body.classList.contains('br-hidden');
		body.classList.toggle('br-hidden');
		this.setAttribute('aria-expanded', isHidden);
		if (chevron) chevron.classList.toggle('br-rotate');
	});
});

document.querySelectorAll('.br-refs-toggle').forEach(function(btn) {
	btn.addEventListener('click', function() {
		var body = this.nextElementSibling;
		var chevron = this.querySelector('.br-refs-chevron');
		var isHidden = body.classList.contains('br-hidden');
		body.classList.toggle('br-hidden');
		this.setAttribute('aria-expanded', isHidden);
		if (chevron) chevron.classList.toggle('br-rotate');
	});
});
</script>

{include file="frontend/components/footer.tpl"}
