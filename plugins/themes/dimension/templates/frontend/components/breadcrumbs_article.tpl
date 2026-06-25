<nav class="bg-blue-50 dark:bg-gray-800 rounded-lg px-4 py-2 mb-6" role="navigation" aria-label="{translate key="navigation.breadcrumbLabel"}">
	<ol class="flex items-center gap-x-1 text-sm flex-wrap">
		<li class="flex items-center">
			<a href="{url page="index" router=$smarty.const.ROUTE_PAGE}" class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 hover:underline transition-colors whitespace-nowrap">
				{translate key="common.homepageNavigationLabel"}
			</a>
			<span class="mx-1.5 text-gray-400 dark:text-gray-500 select-none">/</span>
		</li>
		<li class="flex items-center">
			<a href="{url page="issue" op="archive"}" class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 hover:underline transition-colors whitespace-nowrap">
				{translate key="navigation.archives"}
			</a>
			<span class="mx-1.5 text-gray-400 dark:text-gray-500 select-none">/</span>
		</li>
		{if $issue}
		<li class="flex items-center">
			<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}" class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 hover:underline transition-colors whitespace-nowrap truncate max-w-[200px]">
				{$issue->getIssueIdentification()}
			</a>
			<span class="mx-1.5 text-gray-400 dark:text-gray-500 select-none">/</span>
		</li>
		{/if}
		<li class="flex items-center text-gray-600 dark:text-gray-300 font-medium truncate max-w-[300px]" aria-current="page">
			{if $currentTitleKey}
				{translate key=$currentTitleKey}
			{else}
				{$currentTitle|escape}
			{/if}
		</li>
	</ol>
</nav>
