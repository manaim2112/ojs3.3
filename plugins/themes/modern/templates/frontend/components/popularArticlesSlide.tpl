<style>
.popular_articles_slide {
    background: #f8f9fc;
    border-bottom: 1px solid #e9ecef;
    padding: 24px 0;
}
.popular_articles_inner {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 16px;
}
.popular_articles_header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16px;
}
.popular_articles_title {
    font-size: 15px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: #1e293b;
    display: flex;
    align-items: center;
    gap: 8px;
}
.popular_articles_title svg {
    color: #f59e0b;
}
.popular_articles_nav {
    display: flex;
    gap: 6px;
}
.pa-nav {
    width: 32px;
    height: 32px;
    border-radius: 999px;
    border: 1px solid #d1d5db;
    background: #fff;
    color: #64748b;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all .2s;
}
.pa-nav:hover {
    background: #1e293b;
    color: #fff;
    border-color: #1e293b;
}
.popular_articles_track_wrapper {
    overflow: hidden;
    position: relative;
}
.popular_articles_track {
    display: flex;
    gap: 14px;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
    padding-bottom: 4px;
}
.popular_articles_track::-webkit-scrollbar { display: none; }
.popular_article_card {
    flex: 0 0 220px;
    scroll-snap-align: start;
    background: #fff;
    border-radius: 12px;
    border: 1px solid #e9ecef;
    overflow: hidden;
    text-decoration: none;
    transition: all .25s;
    display: flex;
    flex-direction: column;
    box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}
.popular_article_card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 28px rgba(0,0,0,0.08);
    border-color: #cbd5e1;
}
.pac_visual {
    position: relative;
    width: 100%;
    height: 120px;
    overflow: hidden;
    background: #e2e8f0;
}
.pac_visual img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}
.pac_visual_fallback {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 24px;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
}
.pac_views_badge {
    position: absolute;
    top: 8px;
    right: 8px;
    background: rgba(0,0,0,0.55);
    backdrop-filter: blur(4px);
    color: #fff;
    font-size: 10px;
    font-weight: 700;
    padding: 3px 8px;
    border-radius: 999px;
    display: flex;
    align-items: center;
    gap: 4px;
}
.pac_body {
    padding: 12px 14px 14px;
    flex: 1;
    display: flex;
    flex-direction: column;
}
.pac_title {
    font-size: 13px;
    font-weight: 700;
    color: #0f172a;
    line-height: 1.4;
    margin: 0 0 4px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
.pac_authors {
    font-size: 11px;
    color: #64748b;
    margin: 0;
    line-height: 1.3;
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
    margin-top: auto;
}
</style>
<section class="popular_articles_slide">
    <div class="popular_articles_inner">
        <div class="popular_articles_header">
            <h2 class="popular_articles_title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                Popular Articles
            </h2>
            <div class="popular_articles_nav">
                <button class="pa-nav pa-nav-prev" aria-label="Previous">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                </button>
                <button class="pa-nav pa-nav-next" aria-label="Next">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                </button>
            </div>
        </div>
        <div class="popular_articles_track_wrapper">
            <div class="popular_articles_track">
                {foreach from=$popularArticles item=article}
                <a href="{$article.url}" class="popular_article_card">
                    <div class="pac_visual">
                        {if $article.coverUrl}
                            <img src="{$article.coverUrl}" alt="" loading="lazy" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                            <div class="pac_visual_fallback" style="display:none;background:linear-gradient(135deg,var(--bg-base,#1E6292),var(--primary,#0EA5E9))">
                                <span>{$article.title|truncate:2:''|escape}</span>
                            </div>
                        {else}
                            <div class="pac_visual_fallback" style="background:linear-gradient(135deg,var(--bg-base,#1E6292),var(--primary,#0EA5E9))">
                                <span>{$article.title|truncate:2:''|escape}</span>
                            </div>
                        {/if}
                        <div class="pac_views_badge">
                            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            {$article.views|default:0}
                        </div>
                    </div>
                    <div class="pac_body">
                        <h3 class="pac_title">{$article.title|escape}</h3>
                        <p class="pac_authors">{$article.authors|escape}</p>
                    </div>
                </a>
                {/foreach}
            </div>
        </div>
    </div>
</section>
<script>
(function(){
    var track = document.querySelector('.popular_articles_track');
    if (!track) return;
    var prev = document.querySelector('.pa-nav-prev');
    var next = document.querySelector('.pa-nav-next');
    if (prev) prev.addEventListener('click', function(){ track.scrollBy({left: -240, behavior:'smooth'}); });
    if (next) next.addEventListener('click', function(){ track.scrollBy({left: 240, behavior:'smooth'}); });
})();
</script>
