{**
 * plugins/blocks/mostRead/block.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * "Most Read" block.
 *}
<style>
    .block_developed_by {
        background: #ffffff;
        border-radius: 1.5rem;
        padding: 2rem;
        border: 1px solid rgba(0, 0, 0, 0.05); /* Border sangat tipis */
        /* Bayangan berlapis agar terlihat halus (Soft Shadow) */
        box-shadow: 
            0 10px 15px -3px rgba(0, 0, 0, 0.1), 
            0 4px 6px -2px rgba(0, 0, 0, 0.05);
        transition: transform 0.3s ease;
    }
    
    .block_developed_by:hover {
        transform: translateY(-5px);
    }
</style>
<div class="pkp_block block_developed_by">
	<div class="content">
		<span class="title">{$blockTitle}</span>
			<ul class="most_read">
			{foreach from=$resultMetrics item=article}
				<li class="most_read_article">
					<div class="most_read_article_title"><a href="{url journal=$article.journalPath page="article" op="view" path=$article.articleId}">{$article.articleTitle}{if !empty($article.articleSubTitle)} {$article.articleSubTitle}{/if}</a></div>
					<div class="most_read_article_journal"><span class="fa fa-eye"></span> {$article.metric}</div>
				</li>
			{/foreach}
			</ul>
	</div>
</div>
