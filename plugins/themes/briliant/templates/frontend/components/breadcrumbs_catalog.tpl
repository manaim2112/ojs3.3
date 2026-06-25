<nav class="cmp_breadcrumbs cmp_breadcrumbs_catalog br-breadcrumbs" role="navigation" aria-label="{translate key="navigation.breadcrumbLabel"}">
	<ol class="br-breadcrumbs-list">
		<li class="br-breadcrumbs-item">
			<a href="{url page="index" router=$smarty.const.ROUTE_PAGE}">
				{translate key="common.homepageNavigationLabel"}
			</a>
			<span class="separator br-separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		{if $parent}
			<li class="br-breadcrumbs-item">
				<a href="{url op=$type path=$parent->getPath()}">
					{$parent->getLocalizedTitle()|escape}
				</a>
				<span class="separator br-separator">{translate key="navigation.breadcrumbSeparator"}</span>
			</li>
		{/if}
		<li class="current br-breadcrumbs-current" aria-current="page">
			<span aria-current="page">
				{if $currentTitleKey}
					{translate key=$currentTitleKey}
				{else}
					{$currentTitle|escape}
				{/if}
			</span>
		</li>
	</ol>
</nav>
