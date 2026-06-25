{**
 * templates/frontend/pages/about.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view a journal's or press's description, contact
 *  details, policies and more.
 *
 * @uses $currentContext Journal|Press The current journal or press
 *}
{include file="frontend/components/header.tpl" pageTitle="about.aboutContext"}
<div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto">
    {include file="frontend/components/sideLeft.tpl"}
    <div class="order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8 shadow-lg bg-white dark:bg-gray-800 rounded-lg p-6 md:p-8">
        <div class="text-center text-3xl md:text-4xl font-bold mb-6 animate-fade-up animate-once">
            {translate key="about.aboutContext"}
            <span class="block text-sm text-blue-500 font-normal mt-1">
                {include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}
            </span>
        </div>
        <div class="prose dark:prose-invert dark:prose-a:text-gray-100 prose-img:max-w-full prose-img:h-auto prose-img:rounded-lg prose-img:shadow-md prose-img:transition-all prose-img:duration-300 prose-img:transform prose-img:hover:scale-102 prose-img:m-2 prose-img:inline-block prose-li:m-1 max-w-none">
            {$currentContext->getLocalizedData('about')}
        </div>
    </div>
    {include file="frontend/components/sideRight.tpl"}
</div>
 

 {* <div class="page page_about">
     {include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.aboutContext"}
     <h1>
         {translate key="about.aboutContext"}
     </h1>
 
     {$currentContext->getLocalizedData('about')}
 </div> *}
 
 {include file="frontend/components/footer.tpl"}
 