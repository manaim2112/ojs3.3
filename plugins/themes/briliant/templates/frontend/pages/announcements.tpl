{include file="frontend/components/header.tpl" pageTitle="announcement.announcements"}

<div class="br-page br-page-announcements">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="announcement.announcements"}
	<h1 class="br-page-title">
		{translate key="announcement.announcements"}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}

	{if $announcementsIntroduction}
		<div class="br-card br-card-announcement-intro">
			{$announcementsIntroduction}
		</div>
	{/if}

	{include file="frontend/components/announcements.tpl"}
</div>

{include file="frontend/components/footer.tpl"}
