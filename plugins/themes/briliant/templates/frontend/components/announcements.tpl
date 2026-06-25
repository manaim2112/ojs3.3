<ul class="cmp_announcements br-announcements-list">
	{foreach from=$announcements item=announcement}
		<li class="br-announcements-item">
			{include file="frontend/objects/announcement_summary.tpl"}
		</li>
	{/foreach}
</ul>
