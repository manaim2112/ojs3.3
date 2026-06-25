{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Many journals will want to add custom data to this object, either through
 * plugins which attach to hooks on the page or by editing the template
 * themselves. In order to facilitate this, a flexible layout markup pattern has
 * been implemented. If followed, plugins and other content can provide markup
 * in a way that will render consistently with other items on the page. This
 * pattern is used in the .main_entry column and the .entry_details column. It
 * consists of the following:
 *
 * <!-- Wrapper class which provides proper spacing between components -->
 * <div class="item">
 *     <!-- Title/value combination -->
 *     <div class="label">Abstract</div>
 *     <div class="value">Value</div>
 * </div>
 *
 * All styling should be applied by class name, so that titles may use heading
 * elements (eg, <h3>) or any element required.
 *
 * <!-- Example: component with multiple title/value combinations -->
 * <div class="item">
 *     <div class="sub_item">
 *         <div class="label">DOI</div>
 *         <div class="value">12345678</div>
 *     </div>
 *     <div class="sub_item">
 *         <div class="label">Published Date</div>
 *         <div class="value">2015-01-01</div>
 *     </div>
 * </div>
 *
 * <!-- Example: component with no title -->
 * <div class="item">
 *     <div class="value">Whatever you'd like</div>
 * </div>
 *
 * Core components are produced manually below, but can also be added via
 * plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Submission This article
 * @uses $publication Publication The publication being displayed
 * @uses $firstPublication Publication The first published version of this article
 * @uses $currentPublication Publication The most recently published version of this article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $categories Category The category this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $licenseTerms string License terms.
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published submissions.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}
 {if !$heading}
 	{assign var="heading" value="h3"}
 {/if}
<article class="obj_article_details">

	{* Indicate if this is only a preview *}
	{if $publication->getData('status') !== $smarty.const.STATUS_PUBLISHED}
	<div class="cmp_notification notice">
		{capture assign="submissionUrl"}{url page="workflow" op="access" path=$article->getId()}{/capture}
		{translate key="submission.viewingPreview" url=$submissionUrl}
	</div>
	{* Notification that this is an old version *}
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}
	


	<div class="page_title text-center text-xl font-bold">
		{$publication->getLocalizedTitle()|escape}

		</div>
		
		{if $publication->getLocalizedData('subtitle')}
			<div class="subtitle text-lg">
			{$publication->getLocalizedData('subtitle')|escape}
			</div>
		{/if}
		
	<div class="my-4 text-center">
	{if $publication->getData('authors')}
		{assign var="authorSections" value=$publication->getData('authors')}
			{foreach from=$authorSections item=author key=idx}
					<span class="name">
						{$author->getFullName()|escape}
						{if $idx+1 < count($authorSections)}, {/if}
					</span>
					{if $author->getData('orcid')}
						<span class="orcid">
							{if $author->getData('orcidAccessToken')}
								{$orcidIcon}
							{/if}
							<a href="{$author->getData('orcid')|escape}" target="_blank">
								{$author->getData('orcid')|escape}
							</a>
						</span>
					{/if}
			{/foreach}
	{/if}
	</div>
	<div class="row grid grid-cols-1 lg:grid-cols-8 gap-4">
		<div class="main_entry lg:col-span-5">

			{if $publication->getData('authors')}
				<section class="item authors text-sm py-1 border-y-1">
					<h2 class="pkp_screen_reader">{translate key="article.authors"}</h2>
					<ul class="authors">
					{foreach from=$publication->getData('authors') item=author}
						<li>
							<span class="name text-blue-900 dark:text-blue-200">
							{if $author->getData('orcid')}
								<span class="orcid">
									{if $author->getData('orcidAccessToken')}
										{$orcidIcon}
									{/if}
									<a href="{$author->getData('orcid')|escape}" target="_blank">
										<img loading="lazy" src="https://orcid.org/assets/icons/favicon.ico" style="width:15px; height:15px; display:inline-block; margin-right:10px;"/>
										{$author->getFullName()|escape}
									</a>
								</span>
							{else}
								{$author->getFullName()|escape}
							{/if}
							</span>
							{if $author->getLocalizedData('affiliation')}
								<span class="affiliation">
									{$author->getLocalizedData('affiliation')|escape}
									{if $author->getData('rorId')}
										<a href="{$author->getData('rorId')|escape}">{$rorIdIcon}</a>
									{/if}
								</span>
							{/if}
							{if $author->getData('email')}
								<div class="email text-sm ml-3">
									<a class="inline-flex text-blue-600 hover:underline" href="mailto:{$author->getData('email')}" title="Email Author">
										Email : {$author->getData('email')}
										<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
											<path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
										</svg>
									</a>
								</div>

							{/if}
							
						</li>
					{/foreach}
					</ul>
				</section>
			{/if}
			
				{if $publication->getData('pub-id::doi')}
			<div class="text-right mt-2">
				<a href="https://doi.org/{$publication->getData('pub-id::doi')}" target="_blank" class="inline-flex items-center gap-1">
				<img src="/plugins/generic/badges/images/DOI_logo.svg" class="w-4 h-4" alt="Doi Url"/>
				https://doi.org/{$publication->getData('pub-id::doi')}
				</a>
			</div>
		{/if}

		

			{* Keywords *}
			{if !empty($publication->getLocalizedData('keywords'))}
			<section class="item keywords">
				<h2 class="label text-xl my-4">
					
				</h2>
				<span class="value">
				{capture assign=translatedKeywords}{translate key="article.subject"}{/capture}
				{translate key="semicolon" label=$translatedKeywords}
					{foreach name="keywords" from=$publication->getLocalizedData('keywords') item="keyword"}
						{$keyword|escape}{if !$smarty.foreach.keywords.last}{translate key="common.commaListSeparator"}{/if}
					{/foreach}
				</span>
			</section>
			{/if}

			{* Abstract *}
			{if $publication->getLocalizedData('abstract')}
				<section class="item abstract">
					<h2 class="label text-xl my-4">{translate key="article.abstract"}</h2>
					<div class="text-justify">
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}

					</div>
				</section>
			{/if}

			{* Author biographies *}
			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedData('biography')}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<section class="item author_bios">
					<h2 class="label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h2>
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedData('biography')}
							<section class="sub_item">
								<h3 class="label">
									{if $author->getLocalizedData('affiliation')}
										{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
										{capture assign="authorAffiliation"}<span class="affiliation">{$author->getLocalizedData('affiliation')|escape}</span>{/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
									{else}
										{$author->getFullName()|escape}
									{/if}
								</h3>
								<div class="value">
									{$author->getLocalizedData('biography')|strip_unsafe_html}
								</div>
							</section>
						{/if}
					{/foreach}
				</section>
			{/if}

			{* References *}
			{if $parsedCitations || $publication->getData('citationsRaw')}
				<div class="item references bg-gray-50 dark:bg-gray-800/50 rounded-lg border border-gray-200 dark:border-gray-700">
					<button type="button" class="refs-toggle w-full flex items-center justify-between p-3 text-left cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700/50 transition-colors rounded-lg" aria-expanded="false">
						<span class="flex items-center gap-2">
							<svg class="w-5 h-5 text-gray-500 dark:text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
							<span class="text-lg font-semibold text-gray-800 dark:text-gray-100">{translate key="submission.citations"}</span>
							<span class="inline-flex items-center justify-center px-2 py-0.5 text-xs font-bold text-blue-700 dark:text-blue-300 bg-blue-100 dark:bg-blue-900/50 rounded-full">{if $parsedCitations}{$parsedCitations|count}{else}0{/if}</span>
						</span>
						<svg class="refs-chevron w-5 h-5 text-gray-500 dark:text-gray-400 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
					</button>
					<div class="refs-body border-t border-gray-200 dark:border-gray-700 hidden">
						<div class="value overflow-y-auto max-h-48 p-3 space-y-2 text-sm leading-relaxed">
							{if $parsedCitations}
								{foreach from=$parsedCitations item="parsedCitation"}
									<p class="bg-white dark:bg-gray-700/50 rounded-lg border border-blue-100 dark:border-gray-600 p-2.5 hover:border-blue-300 dark:hover:border-blue-500 transition-colors">{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
								{/foreach}
							{else}
								{$publication->getData('citationsRaw')|escape|nl2br}
							{/if}
						</div>
					</div>
				</div>
			{/if}

		</div><!-- .main_entry -->

		<div class="entry_details lg:col-span-3">

			{* Article/Issue cover image *}
			{if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
				<div class="item cover_image">
					<div class="sub_item">
						{if $publication->getLocalizedData('coverImage')}
							{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
							<img
								src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
								alt="{$coverImage.altText|escape|default:''}"
								onerror="this.onerror=null;this.src='https://placehold.co/400x560/f8f9fc/94a3b8?text=No+Cover'"
							>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
									onerror="this.onerror=null;this.src='https://placehold.co/400x560/f8f9fc/94a3b8?text=No+Cover'">
							</a>
						{/if}
					</div>
				</div>
			{/if}

			{* Article Galleys *}
			{if $primaryGalleys}
				<div class="item galleys">
					<h2 class="pkp_screen_reader">
						{translate key="submission.downloads"}
					</h2>
					<ul class="value galleys_links flex gap-4">
						{foreach from=$primaryGalleys item=galley}
							<li class="my-2">
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
			{if $supplementaryGalleys}
				<div class="item galleys">
					<h3 class="pkp_screen_reader">
						{translate key="submission.additionalFiles"}
					</h3>
					<ul class="value supplementary_galleys_links">
						{foreach from=$supplementaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{if $publication->getData('datePublished')}
			<div class="item published my-2 border-y-1">
				<section class="sub_item">
					<h2 class="label">
						{translate key="submissions.published"}
					</h2>
					<div class="value">
						{* If this is the original version *}
						{if $firstPublication->getID() === $publication->getId()}
							<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
						{* If this is an updated version *}
						{else}
							<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
						{/if}
					</div>
				</section>
				{if count($article->getPublishedPublications()) > 1}
					<section class="sub_item versions">
						<h2 class="label">
							{translate key="submission.versions"}
						</h2>
						<ul class="value">
							{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
								{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
								<li>
									{if $iPublication->getId() === $publication->getId()}
										{$name}
									{elseif $iPublication->getId() === $currentPublication->getId()}
										<a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
									{else}
										<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
									{/if}
								</li>
							{/foreach}
						</ul>
					</section>
				{/if}
			</div>
			{/if}

			{* How to cite *}
			{if $citation}
				<div class="item citation my-2 border-y-2">
					<section class="sub_item citation_display">
						<h2 class="label text-xl font-bold">
							{translate key="submission.howToCite"}
						</h2>
						<div class="value">
							<div id="citationOutput" class="break-all text-justify" role="region" aria-live="polite">
								{$citation}
							</div>
							<div class="group relative mb-5">
								<!-- Tombol untuk membuka dropdown -->
								<button class="cmp_button citation_formats_button border border-blue-400 py-1 px-5 text-blue-800 hover:bg-blue-500 bg-blue-300 rounded-lg peer" aria-controls="cslCitationFormats" aria-expanded="false">
									{translate key="submission.howToCite.citationFormats"}
								</button>

								<!-- Daftar format kutipan yang muncul saat tombol di-hover -->
								<div id="cslCitationFormats" class="absolute left-0 hidden bg-white shadow-md w-48 group-hover:block z-10">
									<ul class="py-2 text-sm text-gray-700">
										{foreach from=$citationStyles item="citationStyle"}
											<li>
												<a
													rel="nofollow"
													aria-controls="citationOutput"
													href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
													data-load-citation
													data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
													class="block px-4 py-2 hover:bg-gray-100"
												>
													{$citationStyle.title|escape}
												</a>
											</li>
										{/foreach}
									</ul>

									{if count($citationDownloads)}
										<div class="label px-4 py-2 bg-gray-100 text-sm text-gray-600">
											{translate key="submission.howToCite.downloadCitation"}
										</div>
										<ul class="py-2 text-sm text-gray-700">
											{foreach from=$citationDownloads item="citationDownload"}
															<li>
																<a
																	href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}"
																	class="block px-4 py-2 hover:bg-gray-100"
																>
																	<span class="fa fa-download mr-2"></span>
																	{$citationDownload.title|escape}
																</a>
															</li>
											{/foreach}
										</ul>
									{/if}
								</div>
							</div>
						</div>
					</section>
				</div>
			{/if}

			{* Issue article appears in *}
			{if $issue || $section || $categories}
				<div class="item issue">

					{if $issue}
						<section class="sub_item">
							<h2 class="label">
								{translate key="issue.issue"}
							</h2>
							<div class="value">
								<a class="title" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
									{$issue->getIssueIdentification()}
								</a>
							</div>
						</section>
					{/if}

					{if $section}
						<section class="sub_item">
							<h2 class="label">
								{translate key="section.section"}
							</h2>
							<div class="value">
								{$section->getLocalizedTitle()|escape}
							</div>
						</section>
					{/if}

					{if $categories}
						<section class="sub_item">
							<h2 class="label">
								{translate key="category.category"}
							</h2>
							<div class="value">
								<ul class="categories">
									{foreach from=$categories item=category}
										<li><a href="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a></li>
									{/foreach}
								</ul>
							</div>
						</section>
					{/if}
				</div>
			{/if}

			{* PubIds (requires plugins) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<section class="item pubid">
						<h2 class="label">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</h2>
						<div class="value">
							{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
									{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								</a>
							{else}
								{$pubId|escape}
							{/if}
						</div>
					</section>
				{/if}
			{/foreach}

			{* Licensing info *}
			{if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
				<div class="item copyright">
					<h2 class="label">
						{translate key="submission.license"}
					</h2>
					{if $publication->getData('licenseUrl')}
						{if $ccLicenseBadge}
							{if $publication->getLocalizedData('copyrightHolder')}
								<p>{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$publication->getData('licenseUrl')|escape}" class="copyright">
								{if $publication->getLocalizedData('copyrightHolder')}
									{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$currentContext->getLocalizedData('licenseTerms')}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div><!-- .entry_details -->
	</div><!-- .row -->

</article>
