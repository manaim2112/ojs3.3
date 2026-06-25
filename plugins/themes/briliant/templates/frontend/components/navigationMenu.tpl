{if $navigationMenu}
	<ul id="{$id|escape}" class="{$ulClass|escape} pkp_nav_list br-nav-list">
		{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
			{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
				{continue}
			{/if}
			<li class="{$liClass|escape} br-nav-item">
				<a href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}">
					{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
				</a>
				{if $navigationMenuItemAssignment->navigationMenuItem->getIsChildVisible()}
					<ul class="br-nav-sublist">
						{foreach key=childField item=childNavigationMenuItemAssignment from=$navigationMenuItemAssignment->children}
							{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
								<li class="{$liClass|escape} br-nav-subitem">
									<a href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}">
										{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
									</a>
								</li>
							{/if}
						{/foreach}
					</ul>
				{/if}
			</li>
		{/foreach}
	</ul>
{/if}
