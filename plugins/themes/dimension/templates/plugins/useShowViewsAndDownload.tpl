<style>
.views {

}
</style>


<div class="item views grid grid-cols-2 my-4 dark:text-black">
    <div class="bg-white p-3 ">
        {if $publication->getData('datePublished')}
            <div class="item published">
                <section class="sub_item">
                    <h2 class="label text-lg!">
                        {translate key="submissions.published"}
                    </h2>
                    <div class="value text-md">
                        {* If this is the original version *}
                        {if $firstPublication->getID() === $publication->getId()}
                            <span>{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
                            {* If this is an updated version *}
                        {else}
                            <span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
                        {/if}
                    </div>
                </section>
                {if count($article->getPublishedPublications()) > 1}
                    <section class="sub_item versions">
                        <h2 class="label">
                            {translate key="submission.versions"}
                        </h2>
                        <ul class="value">
                            {foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
                                {capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
                                <li>
                                    {if $iPublication->getId() === $publication->getId()}
                                        {$name}
                                    {elseif $iPublication->getId() === $currentPublication->getId()}
                                        <a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
                                    {else}
                                        <a
                                            href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
                                    {/if}
                                </li>
                            {/foreach}
                        </ul>
                    </section>
                {/if}
            </div>
        {/if}
    </div>
    <div class="border-l p-3 bg-orange-200">
        <span class="text-md">Views</span>
        <p class="view count" data-min="1" data-max="{$article->getViews()}"> {$article->getViews()} </p>
    </div>
    <div class="bg-lime-300 p-3">
        Citation Google Scholar
        {foreach from=$statistic_scholar->cited_by->table item=metric}
            {if $metric->citations}
                <p class="font-bold text-2xl google-citation-count">
                    {$metric->citations->all} 
                </p>
                Citations
            {/if}
            {if $metric->h_index}
                <p class="font-bold text-2xl google-citation-h">
                    {$metric->h_index->all} 
                </p>
                H-index
            {/if}
            {if $metric->i10_index}
                <p class="font-bold text-2xl google-citation-i10">
                    {$metric->i10_index->all} 
                </p>
                i10-index
            {/if}
        {/foreach}


        {assign var=pubIdDoi value=$publication->getData("pub-id::doi")}
        {capture assign="urlPathMe"}{url page="index" router=$smarty.const.ROUTE_PAGE}{/capture}

    </div>
    <div class="border-l p-3 bg-slate-200 text-black">
        <span class="text-md">Downloads</span>
        {if $galleys}
            {assign var="totalViews" value=0}
            {foreach from=$galleys item=galley name=galleyList}
                {assign var="totalViews" value=$totalViews + $galley->getViews()}
            {/foreach}
            <p class="download count" data-min="1" data-max="{$totalViews}">
                {$totalViews}
            </p>
        {/if}
    </div>
    <div id="area-chart" class="col-span-2 p-2 bg-linear-to-b from-white to-lime-300">
    </div>
    <div id="buttonCitationUpdate" class="col-span-2 text-center text-sm text-blue-500 mt-4">
        <button type="button"
            class="py-1 px-5 me-2 mb-2 text-sm font-medium text-gray-900 focus:outline-hidden bg-linear-to-tr from-white to-blue-200 rounded-full border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100"
            onclick="updateCitation()">Update Citation</button>
    </div>


</div>

<script src="https://cdn.jsdelivr.net/npm/apexcharts" integrity="sha384-7QMVf2SRGQLP+7Qs3NcPqNqN3JpC7x+eFCzAD4rBJgW6ioBX6cJfB4M2NjLJ7xK" crossorigin="anonymous"></script>
<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", async () => {
        const graphData = {$statistic_scholar->cited_by->graph|@json_encode};

        const seriesData =[
            {
                name : "Cited",
                data : graphData.map(e => parseInt(e.citations)),
                color : "#ff951c"
            }
        ];

        const labelSaja = graphData.map(e => e.year);

        const options = {
            chart: {
                height: "200px",
                maxWidth: "100%",
                type: "area",
                fontFamily: "Inter, sans-serif",
                dropShadow: { enabled: false },
                toolbar: { show: false },
            },
            tooltip: { enabled: true, x: { show: false } },
            fill: {
                type: "gradient",
                gradient: {
                    opacityFrom: 0.55,
                    opacityTo: 0,
                    shade: "#ff951c",
                    gradientToColors: ["#ff951c"],
                },
            },
            dataLabels: { enabled: false },
            stroke: { width: 3, curve : 'smooth' },
            grid: {
                show: true,
                strokeDashArray: 4,
                padding: { left: 2, right: 2, top: 0 },
            },
            series: seriesData,
            xaxis: {
                categories: labelSaja,
                labels: { show: false },
                axisBorder: { show: false },
                axisTicks: { show: false },
            },
            yaxis: { show: false },
        }

        if (document.getElementById("area-chart") && typeof ApexCharts !== 'undefined') {
            const chart = new ApexCharts(document.getElementById("area-chart"), options);
            chart.render();
        }
    });
</script>