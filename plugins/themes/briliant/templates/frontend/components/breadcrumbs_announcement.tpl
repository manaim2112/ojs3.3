<nav class="cmp_breadcrumbs cmp_breadcrumbs_announcement br-breadcrumbs" role="navigation" aria-label="{translate key="navigation.breadcrumbLabel"}">
	<ol class="br-breadcrumbs-list">
		<li class="br-breadcrumbs-item">
			<a href="{url page="index" router=$smarty.const.ROUTE_PAGE}">
				{translate key="common.homepageNavigationLabel"}
			</a>
			<span class="separator br-separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		<li class="br-breadcrumbs-item">
			<a href="{url page="announcement" router=$smarty.const.ROUTE_PAGE}">
				{translate key="announcement.announcements"}
			</a>
			<span class="separator br-separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		<li class="current br-breadcrumbs-current">
			<span aria-current="page">{$currentTitle|escape}</span>
		</li>
	</ol>
</nav>
