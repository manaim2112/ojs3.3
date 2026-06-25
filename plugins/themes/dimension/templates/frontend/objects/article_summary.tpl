{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 * @uses $heading string HTML heading element, default: h2
 *}
{assign var=articlePath value=$article->getBestId()}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}

{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

{assign var=publication value=$article->getCurrentPublication()}
<div class="obj_article_summary border-y-1 my-3 p-4 border-blue-400 py-2 relative overflow-hidden bg-linear-to-tr from-blue-300/20 dark:to-gray-800 to-white">
	{if $publication->getLocalizedData('coverImage')}
		<img class="absolute w-32 rotate-45 h-auto right-0 bottom-0 -z-3" loading="lazy"
			src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
			alt="{$coverImage.altText|escape|default:''}"
		>
		<img class="absolute w-72 blur-lg rotate-45 h-auto right-0 bottom-0 -z-5" loading="lazy"
			src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
			alt="{$coverImage.altText|escape|default:''}"
		>
		{* <div class="cover absolute right-0 bottom-0">
			<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if} class="file">
				{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
			</a>
		</div> *}
		{* <div class="cover absolute right-0 bottom-0">
			<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if} class="file">
				{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
				<img
					src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
					alt="{$coverImage.altText|escape|default:''}"
				>
			</a>
		</div> *}
	{/if}

	<{$heading} class="title">
		<a class="text-blue-800 hover:text-blue-900 dark:text-blue-100 dark:hover:text-blue-300 hover:underline" id="article-{$article->getId()}" {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
			{$article->getLocalizedTitle()|strip_unsafe_html}
			{if $article->getLocalizedSubtitle()}
				<span class="subtitle">
					{$article->getLocalizedSubtitle()|escape}
				</span>
			{/if}
		</a>
	</{$heading}>

	{assign var=submissionPages value=$publication->getData('pages')}
	{assign var=submissionDatePublished value=$publication->getData('datePublished')}
	{if $showAuthor || $submissionPages || ($submissionDatePublished && $showDatePublished)}
	<div class="meta">
		{if $showAuthor}
		<div class="authors">
			{assign var=data value=$article->_data}
			{assign var=authors value=$data['publications'][0]->_data['authors']}
			{if $authors}
				
				{foreach from=$authors item=author name=authorList key="idx"}
					<span class="inline-flex items-center space-x-2">
						<img loading="lazy" style="display:inline-block;margin-right:5px;width: 20px;border:1px solid #000;" src="https://journal.assyfa.com/public/site/flags/{$author->_data["country"]|lower}.svg" alt="Country Of {$author->getFullName()|escape}">
						{$author->getLocalizedData("givenName")|escape} 
            			{$author->getLocalizedData("familyName")|escape}
				{if $idx+1 < count($authors)}, {/if}
					</span>
				{/foreach}

			{/if}
		</div>
		{/if}

		{* Page numbers for this article *}
		{if $submissionPages}
			<div class="pages text-right">
				{$submissionPages|escape}
			</div>
		{/if}

		{if $showDatePublished && $submissionDatePublished}
			<div class="published">
				{$submissionDatePublished|date_format:$dateFormatShort}
			</div>
		{/if}

	</div>
	{/if}

	{if !$hideGalleys}
		<ul class="galleys_links flex gap-3 items-center ml-auto">
			{foreach from=$article->getGalleys() item=galley}
				{if $primaryGenreIds}
					{assign var="file" value=$galley->getFile()}
					{if !$galley->getRemoteUrl() && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
						{continue}
					{/if}
				{/if}
				<li>
					{assign var="hasArticleAccess" value=$hasAccess}
					{if $currentContext->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == $smarty.const.ARTICLE_ACCESS_OPEN}
						{assign var="hasArticleAccess" value=1}
					{/if}
					{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication labelledBy="article-{$article->getId()}" hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
				</li>
			{/foreach}

			<li>
				<span style="    padding: 5px 10px;
					border-radius: 1rem;
					border: 2px solid #ffe257;
					background: #ffff8842;display:inline-block;">
					<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 448 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M160 80c0-26.5 21.5-48 48-48h32c26.5 0 48 21.5 48 48V432c0 26.5-21.5 48-48 48H208c-26.5 0-48-21.5-48-48V80zM0 272c0-26.5 21.5-48 48-48H80c26.5 0 48 21.5 48 48V432c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V272zM368 96h32c26.5 0 48 21.5 48 48V432c0 26.5-21.5 48-48 48H368c-26.5 0-48-21.5-48-48V144c0-26.5 21.5-48 48-48z"/></svg>
					 view {$article->getViews()}
				   </span>
			
			</li>
			<li style="margin-top:5px;" class="flex items-center gap-2">
			  {if $galleys}
					{assign var="totalViews" value=0}
				  {foreach from=$galleys item=galley name=galleyList}
					  {assign var="totalViews" value=$totalViews + $galley->getViews()}
				  {/foreach}
				   <span style="    padding: 5px 10px;
						border-radius: 1rem;
						border: 2px solid #5e57ff;
						background: #3280ff1a;
						display:inline-block;"
						
						> 
							<svg xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 512 512"><!--! Font Awesome Free 6.4.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M288 32c0-17.7-14.3-32-32-32s-32 14.3-32 32V274.7l-73.4-73.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3l128 128c12.5 12.5 32.8 12.5 45.3 0l128-128c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L288 274.7V32zM64 352c-35.3 0-64 28.7-64 64v32c0 35.3 28.7 64 64 64H448c35.3 0 64-28.7 64-64V416c0-35.3-28.7-64-64-64H346.5l-45.3 45.3c-25 25-65.5 25-90.5 0L165.5 352H64zm368 56a24 24 0 1 1 0 48 24 24 0 1 1 0-48z"/></svg>
						Dilihat  {$totalViews}</span>
			  {/if}
			</li>
		</ul>
	{/if}

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
