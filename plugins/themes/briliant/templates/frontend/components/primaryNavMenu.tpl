<ul id="navigationPrimary" class="pkp_navigation_primary pkp_nav_list br-primary-nav">
	{if $enableAnnouncements}
		<li class="br-nav-item">
			<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement"}">
				{translate key="announcement.announcements"}
			</a>
		</li>
	{/if}
	{if $currentJournal}
		{if $currentJournal->getData('publishingMode') != $smarty.const.PUBLISHING_MODE_NONE}
			<li class="br-nav-item">
				<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="current"}">
					{translate key="navigation.current"}
				</a>
			</li>
			<li class="br-nav-item">
				<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
					{translate key="navigation.archives"}
				</a>
			</li>
		{/if}
		<li class="br-nav-item br-nav-has-dropdown">
			<a href="{url router=$smarty.const.ROUTE_PAGE page="about"}">
				{translate key="navigation.about"}
			</a>
			<ul class="br-nav-dropdown">
				<li class="br-nav-subitem">
					<a href="{url router=$smarty.const.ROUTE_PAGE page="about"}">
						{translate key="about.aboutContext"}
					</a>
				</li>
				{if $currentJournal->getLocalizedData('editorialTeam')}
					<li class="br-nav-subitem">
						<a href="{url router=$smarty.const.ROUTE_PAGE page="about" op="editorialTeam"}">
							{translate key="about.editorialTeam"}
						</a>
					</li>
				{/if}
				<li class="br-nav-subitem">
					<a href="{url router=$smarty.const.ROUTE_PAGE page="about" op="submissions"}">
						{translate key="about.submissions"}
					</a>
				</li>
				{if $currentJournal->getData('mailingAddress') || $currentJournal->getData('contactName')}
					<li class="br-nav-subitem">
						<a href="{url router=$smarty.const.ROUTE_PAGE page="about" op="contact"}">
							{translate key="about.contact"}
						</a>
					</li>
				{/if}
			</ul>
		</li>
	{/if}
</ul>
