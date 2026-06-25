<article class="obj_announcement_full br-announcement-full">
	<h1 class="br-page-title">
		{$announcement->getLocalizedTitle()|escape}
	</h1>
	<div class="date br-date">
		{$announcement->getDatePosted()|date_format:$dateFormatShort}
	</div>
	<div class="description br-description">
		{if $announcement->getLocalizedDescription()}
			{$announcement->getLocalizedDescription()|strip_unsafe_html}
		{else}
			{$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}
		{/if}
	</div>
</article>
