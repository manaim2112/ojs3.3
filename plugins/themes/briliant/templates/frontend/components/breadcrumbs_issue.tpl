<nav class="cmp_breadcrumbs br-breadcrumbs" role="navigation" aria-label="{translate key="navigation.breadcrumbLabel"}">
	<ol class="br-breadcrumbs-list">
		<li class="br-breadcrumbs-item">
			<a href="{url page="index" router=$smarty.const.ROUTE_PAGE}">
				{translate key="common.homepageNavigationLabel"}
			</a>
			<span class="separator br-separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		<li class="br-breadcrumbs-item">
			<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
				{translate key="navigation.archives"}
			</a>
			<span class="separator br-separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
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
