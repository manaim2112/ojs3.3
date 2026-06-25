{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Modern theme — Article summary with flags, view/download counts, and cover images.
 *}
{assign var=articlePath value=$article->getBestId()}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}

{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

{assign var=publication value=$article->getCurrentPublication()}
{assign var=hasOpenAccess value=0}
{if $currentContext->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == $smarty.const.ARTICLE_ACCESS_OPEN}
	{assign var="hasOpenAccess" value=1}
{/if}

{assign var=coverImageUrl value=$publication->getLocalizedCoverImageUrl($article->getData('contextId'))}

<div class="obj_article_summary">
	{* Open Access Badge *}
	{if $hasOpenAccess}
		<span class="modern-oa-badge">OA</span>
	{/if}

	{* Cover Image with placeholder fallback *}
	{if $coverImageUrl}
		<div class="cover">
			<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if} class="file">
				{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
				<img
					src="{$coverImageUrl|escape}"
					alt="{$coverImage.altText|escape|default:''}"
					loading="lazy"
					onerror="this.src='https://placehold.co/600x400/f8f9fc/94a3b8?text=No+Cover+Image'"
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

	{* Authors with country flags *}
	{assign var=submissionPages value=$publication->getData('pages')}
	{assign var=submissionDatePublished value=$publication->getData('datePublished')}
	{if $showAuthor || $submissionPages || ($submissionDatePublished && $showDatePublished)}
	<div class="meta">
		{if $showAuthor}
		<div class="authors">
			{assign var=articleData value=$article->_data}
			{assign var=pubAuthors value=$articleData['publications'][0]->_data['authors']}
			{if $pubAuthors}
				{foreach from=$pubAuthors item=author name=authorList}
					<span class="modern-author-with-flag">
						{if $author->_data.country}
							<img loading="lazy" src="https://flagcdn.com/w20/{$author->_data.country|lower}.png" alt="{$author->_data.country|escape}" class="modern-flag" width="12" height="8">
						{/if}
						{$author->getLocalizedData("givenName")|escape} {$author->getLocalizedData("familyName")|escape}{if !$smarty.foreach.authorList.last}, {/if}
					</span>
				{/foreach}
			{else}
				{$article->getAuthorString()|escape}
			{/if}
		</div>
		{/if}

		{* Page numbers *}
		{if $submissionPages}
			<div class="pages">
				<span class="fa fa-file-text-o"></span>
				{$submissionPages|escape}
			</div>
		{/if}

		{* Published date *}
		{if $showDatePublished && $submissionDatePublished}
			<div class="published">
				<span class="fa fa-calendar"></span>
				{$submissionDatePublished|date_format:$dateFormatShort}
			</div>
		{/if}

	</div>
	{/if}

	{* Galley links with view/download counts *}
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
					{if $hasOpenAccess}
						{assign var="hasArticleAccess" value=1}
					{/if}
					{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication labelledBy="article-{$article->getId()}" hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
				</li>
			{/foreach}

			{* View count *}
			<li>
				<span class="modern-stat-badge modern-stat-views">
					<span class="fa fa-eye"></span>
					{$article->getViews()}
				</span>
			</li>

			{* Download count *}
			<li>
				{assign var="totalDownloads" value=0}
				{foreach from=$article->getGalleys() item=galley}
					{assign var="totalDownloads" value=$totalDownloads + $galley->getViews()}
				{/foreach}
				<span class="modern-stat-badge modern-stat-downloads">
					<span class="fa fa-download"></span>
					{$totalDownloads}
				</span>
			</li>
		</ul>
	{/if}

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
