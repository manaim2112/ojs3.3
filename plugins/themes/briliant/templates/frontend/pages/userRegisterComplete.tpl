{include file="frontend/components/header.tpl"}

<div class="br-page br-page-register-complete">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey=$pageTitle}
	<h1 class="br-page-title">
		{translate key=$pageTitle}
	</h1>

	<div class="br-card br-card-register-complete">
		<p class="br-success-message">
			{translate key="user.login.registrationComplete.instructions"}
		</p>
		<div class="br-action-grid">
			{if array_intersect(array(ROLE_ID_MANAGER, ROLE_ID_SUB_EDITOR, ROLE_ID_ASSISTANT, ROLE_ID_REVIEWER), (array)$userRoles)}
				<a href="{url page="submissions"}" class="br-btn br-btn-primary">
					{translate key="user.login.registrationComplete.manageSubmissions"}
				</a>
			{/if}
			{if $currentContext}
				<a href="{url page="submission" op="wizard"}" class="br-btn br-btn-primary">
					{translate key="user.login.registrationComplete.newSubmission"}
				</a>
			{/if}
			<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="profile"}" class="br-btn br-btn-outline">
				{translate key="user.editMyProfile"}
			</a>
			<a href="{url page="index"}" class="br-btn br-btn-outline">
				{translate key="user.login.registrationComplete.continueBrowsing"}
			</a>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
