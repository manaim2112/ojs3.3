{include file="frontend/components/header.tpl" pageTitleTranslated=$currentContext->getLocalizedName()}

<div class="page_index_journal">

	{call_hook name="Templates::Index::journal"}

	{if !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
		<div class="homepage_image">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
		</div>
	{/if}

	<section class="hero-section">
		<div class="hero-shape hero-shape-1"></div>
		<div class="hero-shape hero-shape-2"></div>
		<div class="hero-shape hero-shape-3"></div>
		<div class="hero-inner">
			<h1 class="hero-journal-name">{$currentContext->getLocalizedName()}</h1>
			{if $currentContext->getLocalizedData('description')}
				<p class="hero-description">{$currentContext->getLocalizedData('description')|strip_unsafe_html}</p>
			{/if}
			<div class="hero-search">
				<form method="post" action="{url page="search" op="search"}">
					<input type="text" name="query" placeholder="{translate key="common.search"}" aria-label="{translate key="common.search"}">
					<button type="submit"><span class="fa fa-search"></span> {translate key="common.search"}</button>
				</form>
			</div>
		</div>
	</section>

	{* Announcements *}
	{if $numAnnouncementsHomepage && $announcements|@count}
		<section class="cmp_announcements highlight_first">
			<h2>{translate key="announcement.announcements"}</h2>
			{foreach name=announcements from=$announcements item=announcement}
				{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
					{break}
				{/if}
				{if $smarty.foreach.announcements.iteration == 1}
					{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
					<div class="more">
				{else}
					<article class="obj_announcement_summary">
						<h4>
							<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
								{$announcement->getLocalizedTitle()|escape}
							</a>
						</h4>
						<div class="date">{$announcement->getDatePosted()|date_format:$dateFormatShort}</div>
					</article>
				{/if}
			{/foreach}
			</div>
		</section>
	{/if}

	{* Latest issue *}
	{if $issue}
		<section class="current_issue_section">
			<h2>{translate key="journal.currentIssue"}</h2>
			<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="current"}" class="current_issue_link">{$issue->getIssueIdentification()|strip_unsafe_html}</a>
			{include file="frontend/objects/issue_toc.tpl" heading="h3"}
			<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}" class="read_more">
				{translate key="journal.viewAllIssues"}
			</a>
		</section>
	{/if}

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="additional_content">{$additionalHomeContent}</div>
	{/if}

</div>

{include file="frontend/components/footer.tpl"}
