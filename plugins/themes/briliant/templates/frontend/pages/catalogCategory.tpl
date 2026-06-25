{include file="frontend/components/header.tpl" pageTitleTranslated=$category->getLocalizedTitle()}

<div class="br-page br-page-catalog-category">

	{include file="frontend/components/breadcrumbs_catalog.tpl" type="category" parent=$parentCategory currentTitle=$category->getLocalizedTitle()}
	<h1 class="br-page-title">{$category->getLocalizedTitle()|escape}</h1>

	<div class="br-category-meta br-card">
		<div class="br-category-count">
			{translate key="catalog.browseTitles" numTitles=$total}
		</div>

		{assign var="image" value=$category->getImage()}
		{assign var="description" value=$category->getLocalizedDescription()|strip_unsafe_html}
		{if $image || $description}
			<div class="br-category-about">
				{if $image}
					<div class="br-category-cover">
						<img src="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="thumbnail" type="category" id=$category->getId()}" alt="" />
					</div>
				{/if}
				{if $description}
					<div class="br-category-desc">
						{$description|strip_unsafe_html}
					</div>
				{/if}
			</div>
		{/if}
	</div>

	{if $subcategories|@count}
		<nav class="br-subcategories">
			<h2 class="br-section-title">
				{translate key="catalog.category.subcategories"}
			</h2>
			<div class="br-subcategory-grid">
				{foreach from=$subcategories item=subcategory}
					<a href="{url op="category" path=$subcategory->getPath()}" class="br-card br-card-subcategory">
						{$subcategory->getLocalizedTitle()|escape}
					</a>
				{/foreach}
			</div>
		</nav>
	{/if}

	<h2 class="br-section-title">
		{translate key="catalog.category.heading"}
	</h2>

	{if empty($publishedSubmissions)}
		<div class="br-empty-state br-card">
			<p>{translate key="catalog.category.noItems"}</p>
		</div>
	{else}
		<div class="br-article-list">
			{foreach from=$publishedSubmissions item=article}
				<article class="br-card br-card-article">
					{include file="frontend/objects/article_summary.tpl" article=$article hideGalleys=true heading="h3"}
				</article>
			{/foreach}
		</div>

		{if $prevPage > 1}
			{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|to_array:$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|to_array:$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}

</div>

{include file="frontend/components/footer.tpl"}
