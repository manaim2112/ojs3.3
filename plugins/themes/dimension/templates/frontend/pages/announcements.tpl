{**
 * templates/frontend/pages/announcements.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the latest announcements
 *
 * @uses $announcements array List of announcements
 *}
{include file="frontend/components/header.tpl" pageTitle="announcement.announcements"}

<div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto">
{include file="frontend/components/sideLeft.tpl"}

<div class="page page_announcements order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8 shadow-lg bg-white dark:bg-gray-800 rounded-lg p-6 md:p-8">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="announcement.announcements"}
	<h1 class="text-3xl md:text-5xl">
		{translate key="announcement.announcements"}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}

	<div class="prose prose-p:my-[2px] mx-auto text-justify w-full">
	{$announcementsIntroduction}
	</div>

	{include file="frontend/components/announcements.tpl"}
</div><!-- .page -->

{include file="frontend/components/sideRight.tpl"}


</div>

{include file="frontend/components/footer.tpl"}
