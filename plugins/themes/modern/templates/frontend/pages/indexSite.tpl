{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Modern theme — Clean editorial site index.
 *}
{include file="frontend/components/header.tpl"}

<div class="page_index_site">

	{* Page Header *}
	<div class="sis_header">
		<h1 class="sis_header_title">{translate key="context.contexts"}</h1>
		{if $about}
			<div class="sis_header_about">{$about}</div>
		{/if}
	</div>

	{* Journals List *}
	{if $journals|@count}
		<div class="sis_list">
			{foreach from=$journals item=journal}
				{capture assign="url"}{url journal=$journal->getPath()}{/capture}
				{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
				{assign var="description" value=$journal->getLocalizedDescription()}

				<a href="{$url|escape}" class="sis_journal{if !$thumb} sis_journal--no-thumb{/if}" data-reveal>
					{if $thumb}
						<div class="sis_journal_thumb">
							<img
								src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"
								alt="{$journal->getLocalizedName()|escape}"
								loading="lazy"
								onerror="this.onerror=null;this.parentElement.classList.add('sis_journal_thumb--fallback')"
							>
						</div>
					{/if}

					<div class="sis_journal_body">
						<div class="sis_journal_meta">
							<span class="sis_journal_path">{$journal->getPath()|upper|escape}</span>
						</div>
						<h2 class="sis_journal_name">{$journal->getLocalizedName()|escape}</h2>
						{if $description}
							<p class="sis_journal_desc">{$description|strip_unsafe_html|truncate:200}</p>
						{/if}
						<span class="sis_journal_link">
							{translate key="site.journalView"}
							<span class="fa fa-arrow-right"></span>
						</span>
					</div>
				</a>
			{/foreach}
		</div>
	{else}
		<div class="sis_empty">
			<span class="fa fa-book-open"></span>
			<p>{translate key="site.noJournals"}</p>
		</div>
	{/if}

</div>

{include file="frontend/components/footer.tpl"}
