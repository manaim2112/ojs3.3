{include file="frontend/components/header.tpl" pageTitle="about.submissions"}

<div class="br-page br-page-submissions">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.submissions"}
	<h1 class="br-page-title">
		{translate key="about.submissions"}
	</h1>

	<div class="br-card br-card-notification">
		{if $sections|@count == 0 || $currentContext->getData('disableSubmissions')}
			{translate key="author.submit.notAccepting"}
		{else}
			{if $isUserLoggedIn}
				{capture assign="newSubmission"}<a href="{url page="submission" op="wizard"}">{translate key="about.onlineSubmissions.newSubmission"}</a>{/capture}
				{capture assign="viewSubmissions"}<a href="{url page="submissions"}">{translate key="about.onlineSubmissions.viewSubmissions"}</a>{/capture}
					{translate key="about.onlineSubmissions.submissionActions" newSubmission=$newSubmission viewSubmissions=$viewSubmissions}
			{else}
				{capture assign="login"}<a href="{url page="login"}">{translate key="about.onlineSubmissions.login"}</a>{/capture}
				{capture assign="register"}<a href="{url page="user" op="register"}">{translate key="about.onlineSubmissions.register"}</a>{/capture}
					{translate key="about.onlineSubmissions.registrationRequired" login=$login register=$register}
			{/if}
		{/if}
	</div>

	{if $submissionChecklist}
		<section class="br-submission-section br-card">
			<h2 class="br-section-title">
				{translate key="about.submissionPreparationChecklist"}
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/submissionChecklist" sectionTitleKey="about.submissionPreparationChecklist"}
			</h2>
			<p>{translate key="about.submissionPreparationChecklist.description"}</p>
			<ul class="br-checklist">
				{foreach from=$submissionChecklist item=checklistItem}
					<li class="br-checklist-item">
						<span class="br-checklist-icon" aria-hidden="true"></span>
						{$checklistItem.content|nl2br}
					</li>
				{/foreach}
			</ul>
		</section>
	{/if}

	{if $currentContext->getLocalizedData('authorGuidelines')}
		<section class="br-submission-section br-card" id="authorGuidelines">
			<h2 class="br-section-title">
				{translate key="about.authorGuidelines"}
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/authorGuidelines" sectionTitleKey="about.authorGuidelines"}
			</h2>
			{$currentContext->getLocalizedData('authorGuidelines')}
		</section>
	{/if}

	{foreach from=$sections item="section"}
		{if !$section->getIsInactive() && $section->getLocalizedPolicy()}
			<section class="br-submission-section br-card">
				<h2 class="br-section-title">{$section->getLocalizedTitle()|escape}</h2>
				{$section->getLocalizedPolicy()}
				{if $isUserLoggedIn}
					{capture assign="sectionSubmissionUrl"}{url page="submission" op="wizard" sectionId=$section->getId()}{/capture}
					<p class="br-section-action">
						{translate key="about.onlineSubmissions.submitToSection" name=$section->getLocalizedTitle()|escape url=$sectionSubmissionUrl}
					</p>
				{/if}
			</section>
		{/if}
	{/foreach}

	{if $currentContext->getLocalizedData('copyrightNotice')}
		<section class="br-submission-section br-card">
			<h2 class="br-section-title">
				{translate key="about.copyrightNotice"}
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission/authorGuidelines" sectionTitleKey="about.copyrightNotice"}
			</h2>
			{$currentContext->getLocalizedData('copyrightNotice')}
		</section>
	{/if}

	{if $currentContext->getLocalizedData('privacyStatement')}
		<section class="br-submission-section br-card" id="privacyStatement">
			<h2 class="br-section-title">
				{translate key="about.privacyStatement"}
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="setup/privacy" sectionTitleKey="about.privacyStatement"}
			</h2>
			{$currentContext->getLocalizedData('privacyStatement')}
		</section>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
