<style>
.popular_articles_slide {
    background: #102a43;
    border-bottom: 1px solid #e9ecef;
    padding: 32px 0;
}
.popular_articles_inner {
    max-width: 1160px;
    margin: 0 auto;
    padding: 0 16px;
}
.popular_articles_header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 18px;
}
.popular_articles_title {
    font-size: 15px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: #f8fafc;
    display: flex;
    align-items: center;
    gap: 8px;
}
.popular_articles_title svg { color: #f5b544; }
.popular_articles_nav { display: flex; gap: 6px; }
.pa-nav {
    width: 34px;
    height: 34px;
    border-radius: 999px;
    border: 1px solid rgba(255,255,255,.28);
    background: rgba(255,255,255,.08);
    color: #fff;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all .2s;
}
.pa-nav:hover, .pa-nav:focus-visible { background: #f5b544; color: #102a43; border-color: #f5b544; }
.popular_articles_track_wrapper { overflow: hidden; position: relative; }
.popular_articles_track { display: flex; transition: transform .55s cubic-bezier(.22,.61,.36,1); }
.popular_article_card {
    position: relative;
    flex: 0 0 100%;
    min-height: 280px;
    background: #173f5f;
    border-radius: 4px;
    overflow: hidden;
    text-decoration: none;
    display: flex;
    align-items: flex-end;
}
.pac_visual { position: absolute; inset: 0; background: #173f5f; }
.pac_visual img { width: 100%; height: 100%; object-fit: cover; opacity: .72; }
.pac_visual_fallback {
    width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;
    color: #fff; font-size: clamp(30px, 7vw, 72px); font-weight: 700; letter-spacing: 4px; text-transform: uppercase;
}
.pac_views_badge {
    position: absolute; top: 18px; right: 20px; background: rgba(0,0,0,.55); backdrop-filter: blur(4px);
    color: #fff; font-size: 10px; font-weight: 700; padding: 3px 8px; border-radius: 999px; display: flex; align-items: center; gap: 4px;
}
.pac_body {
    position: relative; z-index: 1; width: min(720px, 82%); padding: 42px 32px 34px;
    display: flex; flex-direction: column; gap: 10px; background: linear-gradient(90deg, rgba(16,42,67,.96), rgba(16,42,67,.68), transparent);
}
.pac_title { font-size: clamp(22px, 3.5vw, 38px); font-weight: 800; color: #fff; line-height: 1.15; margin: 0; }
.pac_authors { font-size: 13px; color: rgba(255,255,255,.78); margin: 0; line-height: 1.3; }
.popular_articles_progress { display: flex; gap: 6px; margin-top: 14px; }
.popular_articles_dot { width: 28px; height: 3px; padding: 0; border: 0; background: rgba(255,255,255,.3); cursor: pointer; }
.popular_articles_dot.is-active { background: #f5b544; }
@media (max-width: 600px) {
    .popular_articles_slide { padding: 24px 0; }
    .popular_article_card { min-height: 320px; }
    .pac_body { width: 100%; padding: 34px 22px 26px; background: linear-gradient(0deg, rgba(16,42,67,.97), rgba(16,42,67,.25), transparent); }
    .pac_views_badge { top: 14px; right: 14px; }
}
@media (prefers-reduced-motion: reduce) { .popular_articles_track { transition: none; } }
</style>
<section class="popular_articles_slide">
    <div class="popular_articles_inner">
        <div class="popular_articles_header">
            <h2 class="popular_articles_title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                Popular Articles
            </h2>
            <div class="popular_articles_nav">
                <button class="pa-nav pa-nav-prev" aria-label="Previous popular article" type="button">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                </button>
                <button class="pa-nav pa-nav-next" aria-label="Next popular article" type="button">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                </button>
            </div>
        </div>
        <div class="popular_articles_track_wrapper">
            <div class="popular_articles_track" role="region" aria-label="Popular articles" aria-live="polite">
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
        <div class="popular_articles_progress" aria-label="Choose a popular article">
            {foreach from=$popularArticles item=article name=popularArticles}
                <button class="popular_articles_dot{if $smarty.foreach.popularArticles.first} is-active{/if}" type="button" aria-label="Show popular article {$smarty.foreach.popularArticles.iteration}" aria-current="{if $smarty.foreach.popularArticles.first}true{else}false{/if}"></button>
            {/foreach}
        </div>
    </div>
</section>
{literal}
<script>
(function(){
    var root = document.querySelector('.popular_articles_slide');
    var track = root && root.querySelector('.popular_articles_track');
    if (!track) return;
    var cards = track.querySelectorAll('.popular_article_card');
    var dots = root.querySelectorAll('.popular_articles_dot');
    var index = 0;
    var timer;
    function show(next) {
        index = (next + cards.length) % cards.length;
        track.style.transform = 'translateX(-' + (index * 100) + '%)';
        dots.forEach(function(dot, i) {
            dot.classList.toggle('is-active', i === index);
            dot.setAttribute('aria-current', i === index ? 'true' : 'false');
        });
    }
    function restart() {
        clearInterval(timer);
        timer = setInterval(function(){ show(index + 1); }, 6000);
    }
    root.querySelector('.pa-nav-prev').addEventListener('click', function(){ show(index - 1); restart(); });
    root.querySelector('.pa-nav-next').addEventListener('click', function(){ show(index + 1); restart(); });
    dots.forEach(function(dot, i) { dot.addEventListener('click', function(){ show(i); restart(); }); });
    root.addEventListener('mouseenter', function(){ clearInterval(timer); });
    root.addEventListener('mouseleave', restart);
    root.addEventListener('focusin', function(){ clearInterval(timer); });
    root.addEventListener('focusout', restart);
    if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) restart();
})();
</script>
{/literal}
