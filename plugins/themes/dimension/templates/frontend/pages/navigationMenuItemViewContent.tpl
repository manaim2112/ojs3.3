{**
 * frontend/pages/navigationMenuItemViewContent.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Display NavigationMenuItem content
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$title}

{include file="frontend/components/breadcrumbs.tpl" currentTitle=$title}

<div class="container mx-auto px-6 py-8">
    <div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8">

	{include file="frontend/components/sideLeft.tpl"}
       

        <div class="col-span-full md:col-span-3 lg:col-span-6 xl:col-span-8 order-1 md:order-2">
            <div class="bg-white dark:bg-gray-800 shadow-xl rounded-lg overflow-hidden animate-fade-in-up">
                <div class="p-6 lg:p-8">
                    <h1 class="text-4xl lg:text-5xl font-extrabold text-center mb-6 text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-blue-900 dark:from-blue-400 dark:to-blue-600 animate-slide-in-heading">
                        {$title|escape}
                    </h1>

                    <div class="prose dark:prose-invert dark:prose-a:text-gray-100 prose-img:max-w-full prose-img:h-auto prose-img:rounded-lg prose-img:shadow-md prose-img:transition-all prose-img:duration-300 prose-img:transform prose-img:hover:scale-102 prose-img:m-2 prose-img:inline-block prose-li:m-1 max-w-none">
                        {$content}
                    </div>
                </div>
            </div>
        </div>

            {include file="frontend/components/sideRight.tpl"}

    </div>
</div>



{include file="frontend/components/footer.tpl"}
