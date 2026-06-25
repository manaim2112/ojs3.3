{**
 * templates/frontend/pages/privacy.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the privacy policy.
 *
 * @uses $currentContext Journal|Press The current journal or press
 *}
{include file="frontend/components/header.tpl" pageTitle="manager.setup.privacyStatement"}
{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="manager.setup.privacyStatement"}
<div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto">
	{include file="frontend/components/sideLeft.tpl"}
<div class="page page_privacy order-1 md:order-2 md:col-span-3 lg:col-span-6 xl:col-span-8 shadow-lg bg-white dark:bg-gray-800 rounded-lg p-6 md:p-8">
	<div class="text-3xl md:text-4xl font-bold text-center mb-6">
		{translate key="manager.setup.privacyStatement"}
	</div>
	<div class="prose dark:prose-invert mx-auto text-justify">

	{$privacyStatement}
	</div>
</div><!-- .page -->
{include file="frontend/components/sideRight.tpl"}

</div>

{include file="frontend/components/footer.tpl"}
