{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedTitle()|escape}

<div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto">
	{include file="frontend/components/sideLeft.tpl"}
	<div class="page page_announcement order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8 shadow-lg bg-white dark:bg-gray-800 rounded-lg p-6 md:p-8">
		{include file="frontend/components/breadcrumbs_announcement.tpl" currentTitle=$announcement->getLocalizedTitle()}
		{include file="frontend/objects/announcement_full.tpl"}
	</div>
	{include file="frontend/components/sideRight.tpl"}
</div>

{include file="frontend/components/footer.tpl"}