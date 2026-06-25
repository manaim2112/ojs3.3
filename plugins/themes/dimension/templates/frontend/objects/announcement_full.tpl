{**
 * templates/frontend/objects/announcement_full.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the full view of an announcement, when the announcement is
 *  the primary element on the page.
 *
 * @uses $announcement Announcement The announcement to display
 *}

<article class="obj_announcement_full px-4">
	<h1 class="text-4xl">
		{$announcement->getLocalizedTitle()|escape}
	</h1>
	<div class="date bg-blue-700 text-white inline-block pr-4">
		{$announcement->getDatePosted()|date_format:$dateFormatShort}
	</div>
	<div class="description prose prose-p:mt-[2px]">
		{if $announcement->getLocalizedDescription()}
			{$announcement->getLocalizedDescription()|strip_unsafe_html}
		{else}
			{$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}
		{/if}
	</div>
</article><!-- .obj_announcement_full -->
