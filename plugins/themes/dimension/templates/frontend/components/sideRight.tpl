<div class="order-3 md:order-3 md:col-span-1 lg:col-span-1 xl:col-span-2">
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
			{if $sidebarCode}
				<div class="pkp_footer_content prose prose-p:my-[2px] text-sm">
					{$sidebarCode}
				</div>
			{/if}
	</div>