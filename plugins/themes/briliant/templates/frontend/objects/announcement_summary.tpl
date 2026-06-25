{if !$heading}
	{assign var="heading" value="h2"}
{/if}

<article class="obj_announcement_summary br-announcement-summary">
	<{$heading} class="br-announcement-title">
		<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
			{$announcement->getLocalizedTitle()|escape}
		</a>
	</{$heading}>
	<div class="date br-date">
		{$announcement->getDatePosted()|date_format:$dateFormatShort}
	</div>
	<div class="summary br-summary">
		{$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}
		<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}" class="read_more br-read-more">
			<span aria-hidden="true" role="presentation">
				{translate key="common.readMore"}
			</span>
			<span class="pkp_screen_reader br-sr-only">
				{translate key="common.readMoreWithTitle" title=$announcement->getLocalizedTitle()|escape}
			</span>
		</a>
	</div>
</article>
