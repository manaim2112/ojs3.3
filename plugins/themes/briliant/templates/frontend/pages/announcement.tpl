{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedTitle()|escape}

<div class="br-page br-page-announcement">
	{include file="frontend/components/breadcrumbs_announcement.tpl" currentTitle=$announcement->getLocalizedTitle()}

	<article class="br-card br-card-announcement-full">
		{include file="frontend/objects/announcement_full.tpl"}
	</article>
</div>

{include file="frontend/components/footer.tpl"}
