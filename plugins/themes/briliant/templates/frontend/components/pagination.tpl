{if $prevUrl || $nextUrl}
	<div class="cmp_pagination br-pagination" aria-label="{translate|escape key="common.pagination.label"}">
		{if $prevUrl}
			<a class="prev br-pagination-prev" href="{$prevUrl}">{translate key="help.previous"}</a>
		{/if}
		<span class="current br-pagination-current">
			{translate key="common.pagination" start=$showingStart end=$showingEnd total=$total}
		</span>
		{if $nextUrl}
			<a class="next br-pagination-next" href="{$nextUrl}">{translate key="help.next"}</a>
		{/if}
	</div>
{/if}
