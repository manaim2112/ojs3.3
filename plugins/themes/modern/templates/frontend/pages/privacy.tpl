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

<div class="page page_privacy prose dark:prose-invert dark:prose-a:text-gray-100 prose-img:max-w-full prose-img:h-auto prose-img:rounded-lg prose-img:shadow-md prose-img:transition-all prose-img:duration-300 prose-img:transform prose-img:hover:scale-102 prose-img:m-2 prose-img:inline-block prose-li:m-1 max-w-none">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="manager.setup.privacyStatement"}
	<h1>
		{translate key="manager.setup.privacyStatement"}
	</h1>
	{$privacyStatement}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
