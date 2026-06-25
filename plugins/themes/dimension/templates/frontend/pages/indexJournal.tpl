{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="max-w-7xl grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto">
	{include file="frontend/components/sideLeft.tpl"}
	<div class="order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8 shadow-lg bg-white dark:bg-gray-800 rounded-lg p-6 md:p-8">
		<div class="page_index_journal">
			{call_hook name="Templates::Index::journal"}

			{if !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
				<div class="homepage_image">
					<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" {if $homepageImage.altText}
						alt="{$homepageImage.altText|escape}" {/if}>
				</div>
			{/if}

			{* Journal Description *}
			{if $activeTheme->getOption('showDescriptionInJournalIndex')}
				<div class="after:content-[''] after:block after:clear-both p-5 rounded-lg mt-4">
					<a id="homepageAbout"></a>
					<h2 class="text-4xl animation-fade-in font-bold bg-clip-text bg-linear-to-tr from-blue-400 to-blue-700 text-transparent">{$currentJournal->getLocalizedName()}</h2>

					{* Issue cover image *}
					{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
					{if $issueCover}
						<img class="float-right ml-4 mb-4 h-72 w-auto" src="{$issueCover|escape}"
							alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$defaultAltText}">

					{/if}
					<div class="text-justify prose dark:prose-invert prose-img:max-w-full prose-img:h-auto prose-img:rounded-lg prose-img:shadow-md prose-img:transition-all prose-img:duration-300 prose-img:transform prose-img:hover:scale-102 prose-img:m-2 prose-img:inline-block prose-li:m-1 max-w-none text-sm">
						{$currentContext->getLocalizedData('description')}
					</div>
				</div>
			{/if}

			{* Announcements *}
			{if $numAnnouncementsHomepage && $announcements|@count}
				<section class="cmp_announcements highlight_first mb-6">
					<a id="homepageAnnouncements"></a>
					<h2 class="text-4xl animation-fade-in font-bold bg-clip-text bg-linear-to-tr from-blue-400 to-blue-700 text-transparent">
						{translate key="announcement.announcements"}
					</h2>
					{foreach name=announcements from=$announcements item=announcement}
						{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
							{break}
						{/if}
						{if $smarty.foreach.announcements.iteration == 1}
							{include file="frontend/objects/announcement_summary.tpl" heading="h3"}
							<div class="more">
							{else}
								<article class="obj_announcement_summary">
									<h4 class="font-bold">
										<a
											href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
											{$announcement->getLocalizedTitle()|escape}
										</a>
									</h4>
									<div class="date">
										{$announcement->getDatePosted()|date_format:$dateFormatShort}
									</div>
								</article>
							{/if}
						{/foreach}
					</div><!-- .more -->
				</section>
			{/if}

			{* Latest issue *}
			{if $issue}
				<section class="current_issue">
					<a id="homepageIssue"></a>
					<h2 class="text-3xl font-bold">
						{translate key="journal.currentIssue"}
					</h2>
					<div class="current_issue_title mb-4">
						{$issue->getIssueIdentification()|strip_unsafe_html}
					</div>
					{include file="frontend/objects/issue_toc.tpl" heading="h3"}
					<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}" class="read_more mt-4 text-blue-800 hover:underline">
						{translate key="journal.viewAllIssues"}
					</a>
				</section>
			{/if}

			{* Additional Homepage Content *}
			{if $additionalHomeContent}
				<div class="additional_content prose prose-p:py-1/2 text-justify">
					{$additionalHomeContent}
				</div>
			{/if}
		</div><!-- .page -->
	</div>
	{include file="frontend/components/sideRight.tpl"}
</div>


{include file="frontend/components/footer.tpl"}