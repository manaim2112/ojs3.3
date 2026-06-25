{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Modern theme — Editorial site index with bento journal grid.
 *}
{include file="frontend/components/header.tpl"}

<div class="page_index_site">

	{* Editorial Hero *}
	<section class="sis_hero">
		<div class="sis_hero_inner">
			<div class="sis_hero_text">
				{if $about}
					<div class="sis_hero_about">{$about}</div>
				{/if}
			</div>
			<div class="sis_hero_badge">
				{if $journals|@count}
					<span class="sis_hero_count">
						<span class="sis_hero_count_num">{$journals|@count}</span>
						<span class="sis_hero_count_label">{if $journals|@count == 1}Journal{else}Journals{/if}</span>
					</span>
				{/if}
			</div>
		</div>
	</section>

	{* Journals Bento Grid *}
	{if $journals|@count}
		<section class="sis_journals">
			{assign var="journalIdx" value=0}
			{foreach from=$journals item=journal}
				{capture assign="url"}{url journal=$journal->getPath()}{/capture}
				{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
				{assign var="description" value=$journal->getLocalizedDescription()}
				{math equation="x % 5" x=$journalIdx assign="modCycle"}

				<a href="{$url|escape}" class="sis_card{if $modCycle == 0} sis_card--hero{elseif $modCycle == 1 || $modCycle == 2} sis_card--tall{/if}" data-reveal>

					{* Cover *}
					<div class="sis_card_media">
						{if $thumb}
							<img
								src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"
								alt="{$journal->getLocalizedName()|escape}"
								loading="lazy"
								onerror="this.onerror=null;this.parentElement.classList.add('sis_card_media--empty')"
							>
						{else}
							<div class="sis_card_media--empty"></div>
						{/if}
					</div>

					{* Content overlay *}
					<div class="sis_card_content">
						<span class="sis_card_path">{$journal->getPath()|escape}</span>
						<h3 class="sis_card_title">{$journal->getLocalizedName()|escape}</h3>
						{if $description}
							<p class="sis_card_desc">{$description|strip_unsafe_html|truncate:120}</p>
						{/if}
						<span class="sis_card_cta">
							{translate key="site.journalView"}
							<span class="fa fa-arrow-right"></span>
						</span>
					</div>
				</a>

				{math equation="x + 1" x=$journalIdx assign="journalIdx"}
			{/foreach}
		</section>
	{else}
		<div class="sis_empty">
			<span class="fa fa-book-open"></span>
			<p>{translate key="site.noJournals"}</p>
		</div>
	{/if}

</div>

{include file="frontend/components/footer.tpl"}
