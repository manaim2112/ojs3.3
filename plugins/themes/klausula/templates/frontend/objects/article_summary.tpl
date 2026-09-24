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
<div class="obj_article_summary">
	{if $publication->getLocalizedData('coverImage')}
		<div class="cover">
			<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if} class="file">
				{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
				<img
					src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
					alt="{$coverImage.altText|escape|default:''}"
				>
			</a>
		</div>
	{/if}

	<{$heading} class="title">
		<a id="article-{$article->getId()}" {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
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
	{if $showAuthor || $submissionPages || ($submissionDatePublished && $showDatePublished) || $activeTheme->getOption('showStats')}
	<div class="meta">
		{if $showAuthor}
		<div class="authors">
			{assign var="klausulaAuthors" value=$publication->getData('authors')}
			{if $activeTheme->getOption('showFlags') && $klausulaAuthors}
				{foreach from=$klausulaAuthors item=author name=klausulaAuthorLoop}
					<span class="klausula_author">{if $author->getData('country')}<span class="fi fi-{$author->getData('country')|lower|escape}" title="{$author->getData('country')|escape}" aria-hidden="true"></span>{/if}<span class="klausula_author_name">{$author->getFullName()|escape}</span></span>{if !$smarty.foreach.klausulaAuthorLoop.last}{translate key="common.commaListSeparator"}{/if}
				{/foreach}
			{else}
				{$article->getAuthorString()|escape}
			{/if}
		</div>
		{/if}

		{* Page numbers for this article *}
		{if $submissionPages}
			<div class="pages">
				{$submissionPages|escape}
			</div>
		{/if}

		{if $showDatePublished && $submissionDatePublished}
			<div class="published">
				{$submissionDatePublished|date_format:$dateFormatShort}
			</div>
		{/if}

		{* Klausula: total abstract views and file downloads *}
		{if $activeTheme->getOption('showStats')}
			{assign var="klausulaStats" value=$activeTheme->getArticleStats($article)}
			<ul class="klausula_stats">
				<li class="klausula_stat klausula_stat_views">
					<span class="fa fa-eye" aria-hidden="true"></span>
					<span class="klausula_stat_value">{$klausulaStats.views}</span>
					<span class="pkp_screen_reader">{translate key="submission.views"}</span>
				</li>
				<li class="klausula_stat klausula_stat_downloads">
					<span class="fa fa-download" aria-hidden="true"></span>
					<span class="klausula_stat_value">{$klausulaStats.downloads}</span>
					<span class="pkp_screen_reader">{translate key="submission.downloads"}</span>
				</li>
			</ul>
		{/if}

	</div>
	{/if}

	{if !$hideGalleys}
		<ul class="galleys_links">
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
		</ul>
	{/if}

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
