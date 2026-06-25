{include file="frontend/components/header.tpl"}

<div class="br-page br-page-index-site">

	{if $about}
		<section class="br-about-site">
			<div class="br-card br-card-about">
				{$about}
			</div>
		</section>
	{/if}

	<section class="br-journals">
		<h2 class="br-section-title">
			{translate key="context.contexts"}
		</h2>
		{if !$journals|@count}
			<div class="br-empty-state">
				{translate key="site.noJournals"}
			</div>
		{else}
			<div class="br-journal-grid">
				{foreach from=$journals item=journal}
					{capture assign="url"}{url journal=$journal->getPath()}{/capture}
					{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
					{assign var="description" value=$journal->getLocalizedDescription()}
					<article class="br-journal-card">
						{if $thumb}
							<div class="br-journal-card-thumb">
								<a href="{$url|escape}">
									<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText} alt="{$thumb.altText|escape|default:''}"{/if}>
								</a>
							</div>
						{/if}
						<div class="br-journal-card-body">
							<h3 class="br-journal-card-title">
								<a href="{$url|escape}" rel="bookmark">
									{$journal->getLocalizedName()|escape}
								</a>
							</h3>
							{if $description}
								<div class="br-journal-card-desc">
									{$description}
								</div>
							{/if}
							<div class="br-journal-card-links">
								<a href="{$url|escape}" class="br-btn br-btn-outline">
									{translate key="site.journalView"}
								</a>
								<a href="{url|escape journal=$journal->getPath() page="issue" op="current"}" class="br-btn br-btn-primary">
									{translate key="site.journalCurrent"}
								</a>
							</div>
						</div>
					</article>
				{/foreach}
			</div>
		{/if}
	</section>

</div>

{include file="frontend/components/footer.tpl"}
