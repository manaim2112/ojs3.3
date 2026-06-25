{if !$heading}
	{assign var="heading" value="h3"}
{/if}
<article class="br-article-details">

	{if $publication->getData('status') !== $smarty.const.STATUS_PUBLISHED}
	<div class="br-notification notice">
		{capture assign="submissionUrl"}{url page="workflow" op="access" path=$article->getId()}{/capture}
		{translate key="submission.viewingPreview" url=$submissionUrl}
	</div>
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="br-notification notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<h1 class="br-page-title">
		{$publication->getLocalizedTitle()|escape}
	</h1>

	{if $publication->getLocalizedData('subtitle')}
		<h2 class="br-subtitle">
			{$publication->getLocalizedData('subtitle')|escape}
		</h2>
	{/if}

	<div class="br-row">
		<div class="br-main-entry">

			{if $publication->getData('authors')}
				<section class="br-item">
					<h2 class="br-sr-only">{translate key="article.authors"}</h2>
					<ul class="br-authors-list">
					{foreach from=$publication->getData('authors') item=author}
						<li class="br-author-li">
							<span class="name br-author-name">
								{$author->getFullName()|escape}
								{if $author->getData('country')}
									<img loading="lazy" src="https://flagcdn.com/w40/{$author->getData('country')|lower}.png" alt="{$author->getData('country')|escape}" class="br-flag br-flag-detail" width="16" height="11">
								{/if}
							</span>
							{if $author->getLocalizedData('affiliation')}
								<span class="affiliation br-affiliation">
									{$author->getLocalizedData('affiliation')|escape}
									{if $author->getData('rorId')}
										<a href="{$author->getData('rorId')|escape}">{$rorIdIcon}</a>
									{/if}
								</span>
							{/if}
							{if $author->getData('orcid')}
								<span class="orcid br-orcid">
									<a href="{$author->getData('orcid')|escape}" target="_blank">
										{if $author->getData('orcidAccessToken')}
											{$orcidIcon}
										{else}
											<span class="fa fa-id-card-o"></span>
										{/if}
									</a>
								</span>
							{/if}
							{if $author->getEmail()}
								<span class="br-author-email">
									<span class="fa fa-envelope-o"></span>
									<a href="mailto:{$author->getEmail()|escape}">{$author->getEmail()|escape}</a>
								</span>
							{/if}
						</li>
					{/foreach}
					</ul>
				</section>
			{/if}

			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<section class="br-item">
						<h2 class="br-label">
							{capture assign=translatedDOI}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
							{translate key="semicolon" label=$translatedDOI}
						</h2>
						<span class="br-value">
							<a href="{$doiUrl}">
								{$doiUrl}
							</a>
						</span>
					</section>
				{/if}
			{/foreach}

			{if !empty($publication->getLocalizedData('keywords'))}
			<section class="br-item">
				<h2 class="br-label">
					{capture assign=translatedKeywords}{translate key="article.subject"}{/capture}
					{translate key="semicolon" label=$translatedKeywords}
				</h2>
				<span class="br-value">
					{foreach name="keywords" from=$publication->getLocalizedData('keywords') item="keyword"}
						{$keyword|escape}{if !$smarty.foreach.keywords.last}{translate key="common.commaListSeparator"}{/if}
					{/foreach}
				</span>
			</section>
			{/if}

			{if $publication->getLocalizedData('abstract')}
				<section class="br-item br-abstract">
					<h2 class="br-label">{translate key="article.abstract"}</h2>
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}
				</section>
			{/if}

			{call_hook name="Templates::Article::Main"}

			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedData('biography')}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<section class="br-item br-biographies-item">
					<h2 class="br-label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h2>
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedData('biography')}
							<section class="br-sub-item br-bio-item">
								<h3 class="br-label">
									{if $author->getLocalizedData('affiliation')}
										{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
										{capture assign="authorAffiliation"}<span class="br-affiliation">{$author->getLocalizedData('affiliation')|escape}</span>{/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
									{else}
										{$author->getFullName()|escape}
									{/if}
								</h3>
								<div class="br-value">
									{$author->getLocalizedData('biography')|strip_unsafe_html}
								</div>
							</section>
						{/if}
					{/foreach}
				</section>
			{/if}

			{if $parsedCitations || $publication->getData('citationsRaw')}
				<section class="br-item br-refs-section">
					<button type="button" class="br-refs-toggle" aria-expanded="false">
						<span>
							{translate key="submission.citations"}
							<span class="br-refs-count">({if $parsedCitations}{$parsedCitations|count}{else}0{/if})</span>
						</span>
						<span class="fa fa-chevron-down br-refs-chevron"></span>
					</button>
					<div class="br-refs-body br-hidden">
						<div class="br-refs-list">
							{if $parsedCitations}
								{foreach from=$parsedCitations item="parsedCitation"}
									<p class="br-ref-item">{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
								{/foreach}
							{else}
								{$publication->getData('citationsRaw')|escape|nl2br}
							{/if}
						</div>
					</div>
				</section>
			{/if}

		</div>

		<div class="br-entry-details">

			{if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
				<div class="br-item br-cover-item">
					<div class="br-sub-item">
						{if $publication->getLocalizedData('coverImage')}
							{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
							<img class="br-cover-image"
								src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
								alt="{$coverImage.altText|escape|default:''}"
							>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img class="br-cover-image" src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
							</a>
						{/if}
					</div>
				</div>
			{/if}

			{if $primaryGalleys}
				<div class="br-item br-galleys-item">
					<h2 class="br-sr-only">
						{translate key="submission.downloads"}
					</h2>
					<h3 class="br-label">{translate key="submission.downloads"}</h3>
					<ul class="br-galley-links">
						{foreach from=$primaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
			{if $supplementaryGalleys}
				<div class="br-item br-galleys-item">
					<h3 class="br-sr-only">
						{translate key="submission.additionalFiles"}
					</h3>
					<h4 class="br-label">{translate key="submission.additionalFiles"}</h4>
					<ul class="br-galley-links">
						{foreach from=$supplementaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{if $publication->getData('datePublished')}
			<div class="br-item br-published-item">
				<section class="br-sub-item">
					<h2 class="br-label">
						{translate key="submissions.published"}
					</h2>
					<div class="br-value">
						{if $firstPublication->getID() === $publication->getId()}
							<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
						{else}
							<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
						{/if}
					</div>
				</section>
				{if count($article->getPublishedPublications()) > 1}
					<section class="br-sub-item br-versions-item">
						<h2 class="br-label">
							{translate key="submission.versions"}
						</h2>
						<ul class="br-versions-list">
							{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
								{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
								<li class="br-version-item">
									{if $iPublication->getId() === $publication->getId()}
										<span class="br-version-current">{$name}</span>
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

			{if $citation}
				<div class="br-item br-citation-item">
					<section class="br-sub-item">
						<h2 class="br-label">
							{translate key="submission.howToCite"}
						</h2>
						<div class="br-value">
							<div class="br-citation-output" id="citationOutput" role="region" aria-live="polite">
								{$citation}
							</div>
							<div class="br-citation-formats">
								<button class="br-citation-toggle br-btn br-btn-outline" aria-controls="cslCitationFormats" aria-expanded="false" data-csl-dropdown="true">
									<span class="fa fa-chevron-down"></span>
									{translate key="submission.howToCite.citationFormats"}
								</button>
								<div id="cslCitationFormats" class="br-citation-list" aria-hidden="true">
									<ul class="br-citation-styles">
										{foreach from=$citationStyles item="citationStyle"}
											<li>
												<a
													rel="nofollow"
													aria-controls="citationOutput"
													href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
													data-load-citation
													data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
												>
													{$citationStyle.title|escape}
												</a>
											</li>
										{/foreach}
									</ul>
									{if count($citationDownloads)}
										<div class="br-citation-download-label br-label">{translate key="submission.howToCite.downloadCitation"}</div>
										<ul class="br-citation-styles">
											{foreach from=$citationDownloads item="citationDownload"}
												<li>
													<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
														<span class="fa fa-download"></span>
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

			{if $issue || $section || $categories}
				<div class="br-item br-meta-item">

					{if $issue}
						<section class="br-sub-item">
							<h2 class="br-label">
								{translate key="issue.issue"}
							</h2>
							<div class="br-value">
								<a class="br-issue-link" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
									{$issue->getIssueIdentification()}
								</a>
							</div>
						</section>
					{/if}

					{if $section}
						<section class="br-sub-item">
							<h2 class="br-label">
								{translate key="section.section"}
							</h2>
							<div class="br-value">
								{$section->getLocalizedTitle()|escape}
							</div>
						</section>
					{/if}

					{if $categories}
						<section class="br-sub-item">
							<h2 class="br-label">
								{translate key="category.category"}
							</h2>
							<div class="br-value">
								<ul class="br-categories-list">
									{foreach from=$categories item=category}
										<li><a href="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a></li>
									{/foreach}
								</ul>
							</div>
						</section>
					{/if}
				</div>
			{/if}

			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<section class="br-item br-pubid-item">
						<h2 class="br-label">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</h2>
						<div class="br-value">
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

			{if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
				<div class="br-item br-license-item">
					<h2 class="br-label">
						{translate key="submission.license"}
					</h2>
					<div class="br-license-body">
					{if $publication->getData('licenseUrl')}
						{if $ccLicenseBadge}
							{if $publication->getLocalizedData('copyrightHolder')}
								<p class="br-copyright-statement">{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
							{/if}
							<div class="br-cc-badge">{$ccLicenseBadge}</div>
						{else}
							<a href="{$publication->getData('licenseUrl')|escape}" class="br-license-link">
								{if $publication->getLocalizedData('copyrightHolder')}
									{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					<div class="br-license-terms">{$currentContext->getLocalizedData('licenseTerms')}</div>
					</div>
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div>
	</div>

</article>
