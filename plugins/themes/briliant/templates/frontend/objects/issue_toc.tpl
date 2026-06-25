{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{assign var="articleHeading" value="h3"}
{if $heading == "h3"}
	{assign var="articleHeading" value="h4"}
{elseif $heading == "h4"}
	{assign var="articleHeading" value="h5"}
{elseif $heading == "h5"}
	{assign var="articleHeading" value="h6"}
{/if}
<div class="obj_issue_toc br-issue-toc">

	{if !$issue->getPublished()}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
	{/if}

	<div class="heading br-issue-heading">

		{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
		{if $issueCover}
			<a class="cover br-cover" href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
				{capture assign="defaultAltText"}
					{translate key="issue.viewIssueIdentification" identification=$issue->getIssueIdentification()|escape}
				{/capture}
				<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$defaultAltText}">
			</a>
		{/if}

		{if $issue->hasDescription()}
			<div class="description br-description">
				{$issue->getLocalizedDescription()|strip_unsafe_html}
			</div>
		{/if}

		{foreach from=$pubIdPlugins item=pubIdPlugin}
			{assign var=pubId value=$issue->getStoredPubId($pubIdPlugin->getPubIdType())}
			{if $pubId}
				{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
				<div class="pub_id {$pubIdPlugin->getPubIdType()|escape} br-pub-id">
					<span class="type">
						{$pubIdPlugin->getPubIdDisplayType()|escape}:
					</span>
					<span class="id">
						{if $doiUrl}
							<a href="{$doiUrl|escape}">
								{$doiUrl}
							</a>
						{else}
							{$pubId}
						{/if}
					</span>
				</div>
			{/if}
		{/foreach}

		{if $issue->getDatePublished()}
			<div class="published br-published">
				<span class="label br-label">
					{translate key="submissions.published"}:
				</span>
				<span class="value br-value">
					{$issue->getDatePublished()|date_format:$dateFormatShort}
				</span>
			</div>
		{/if}
	</div>

	{if $issueGalleys}
		<div class="galleys br-galleys">
			<{$heading} id="issueTocGalleyLabel">
				{translate key="issue.fullIssue"}
			</{$heading}>
			<ul class="galleys_links br-galley-links">
				{foreach from=$issueGalleys item=galley}
					<li>
						{include file="frontend/objects/galley_link.tpl" parent=$issue labelledBy="issueTocGalleyLabel" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
					</li>
				{/foreach}
			</ul>
		</div>
	{/if}

	<div class="sections br-sections">
	{foreach name=sections from=$publishedSubmissions item=section}
		<div class="section br-section">
		{if $section.articles}
			{if $section.title}
				<{$heading}>
					{$section.title|escape}
				</{$heading}>
			{/if}
			<ul class="cmp_article_list articles br-article-list">
				{foreach from=$section.articles item=article}
					<li>
						{include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
					</li>
				{/foreach}
			</ul>
		{/if}
		</div>
	{/foreach}
	</div>
</div>
