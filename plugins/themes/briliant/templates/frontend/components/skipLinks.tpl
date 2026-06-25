<nav class="cmp_skip_to_content br-skip-links" aria-label="{translate key="navigation.skip.description"}">
	<a href="#pkp_content_main">{translate key="navigation.skip.main"}</a>
	<a href="#siteNav">{translate key="navigation.skip.nav"}</a>
	{if !$requestedPage || $requestedPage === 'index'}
		{if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex')}
			<a href="#homepageAbout">{translate key="navigation.skip.about"}</a>
		{/if}
		{if $numAnnouncementsHomepage && $announcements|@count}
			<a href="#homepageAnnouncements">{translate key="navigation.skip.announcements"}</a>
		{/if}
		{if $issue}
			<a href="#homepageIssue">{translate key="navigation.skip.issue"}</a>
		{/if}
	{/if}
	<a href="#pkp_content_footer">{translate key="navigation.skip.footer"}</a>
</nav>
