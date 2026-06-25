{include file="frontend/components/header.tpl" pageTitle="user.register"}

<div class="page page_register">
	<div class="max-w-3xl mx-auto">
		{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.register"}

		<div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden mb-8">
			<div class="bg-gradient-to-r from-blue-600 to-blue-800 dark:from-gray-800 dark:to-gray-900 px-6 py-8 text-center">
				<div class="w-16 h-16 mx-auto mb-4 bg-white/20 rounded-full flex items-center justify-center">
					<svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
				</div>
				<h1 class="text-2xl md:text-3xl font-bold text-white mb-2">{translate key="user.register"}</h1>
				<p class="text-blue-100 dark:text-gray-300 text-sm">{translate key="common.requiredField"}</p>
			</div>

			<div class="p-6 md:p-8">
				<form class="cmp_form register" id="register" method="post" action="{url op="register"}">
					{csrf}

					{if $source}
						<input type="hidden" name="source" value="{$source|escape}" />
					{/if}

					<div class="mb-4">
						{include file="common/formErrors.tpl"}
					</div>

					{include file="frontend/components/registrationForm.tpl"}

					{* When a user is registering with a specific journal *}
					{if $currentContext}

						<div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl border border-gray-200 dark:border-gray-600 p-6 space-y-4 mb-6">
							{if $currentContext->getData('privacyStatement')}
								<label class="flex items-start gap-3 cursor-pointer group">
									<input type="checkbox" name="privacyConsent" value="1"{if $privacyConsent} checked="checked"{/if}
										class="mt-0.5 w-4 h-4 text-blue-600 bg-white border-gray-300 rounded focus:ring-blue-500">
									<span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-gray-100 transition-colors">
										{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE page="about" op="privacy"}{/capture}
										{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
									</span>
								</label>
							{/if}
							<label class="flex items-start gap-3 cursor-pointer group">
								<input type="checkbox" name="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}
									class="mt-0.5 w-4 h-4 text-blue-600 bg-white border-gray-300 rounded focus:ring-blue-500">
								<span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-gray-100 transition-colors">
									{translate key="user.register.form.emailConsent"}
								</span>
							</label>
						</div>

						{* Allow the user to sign up as a reviewer *}
						{assign var=contextId value=$currentContext->getId()}
						{assign var=userCanRegisterReviewer value=0}
						{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
							{if $userGroup->getPermitSelfRegistration()}
								{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
							{/if}
						{/foreach}
						{if $userCanRegisterReviewer}
							<div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden mb-6">
								<div class="bg-gradient-to-r from-green-50 to-emerald-50 dark:from-gray-700 dark:to-gray-700 px-6 py-4 border-b border-gray-200 dark:border-gray-600">
									<h3 class="font-semibold text-gray-800 dark:text-gray-100 flex items-center gap-2">
										<svg class="w-5 h-5 text-green-600 dark:text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
										{translate key="user.reviewerPrompt"}
									</h3>
								</div>
								<div class="p-6 space-y-4">
									{if $userCanRegisterReviewer > 1}
										{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
									{else}
										{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
									{/if}
									<div id="reviewerOptinGroup" class="space-y-3">
										{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
											{if $userGroup->getPermitSelfRegistration()}
												{assign var="userGroupId" value=$userGroup->getId()}
												<label class="flex items-start gap-3 cursor-pointer group">
													<input type="checkbox" name="reviewerGroup[{$userGroupId}]" value="1"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}
														class="mt-0.5 w-4 h-4 text-green-600 bg-white border-gray-300 rounded focus:ring-green-500">
													<span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-gray-100 transition-colors">
														{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedName()}
													</span>
												</label>
											{/if}
										{/foreach}
									</div>
									<div id="reviewerInterests">
										<label class="block mb-1.5 text-sm font-medium text-gray-700 dark:text-gray-300">
											{translate key="user.interests"}
										</label>
										<input type="text" name="interests" id="interests" value="{$interests|default:""|escape}" placeholder="{translate key="user.interests"}"
											class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow placeholder:text-gray-400">
									</div>
								</div>
							</div>
						{/if}
					{/if}

					{include file="frontend/components/registrationFormContexts.tpl"}

					{* When a user is registering for no specific journal *}
					{if !$currentContext}
						<div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden mb-6">
							<div class="p-6 space-y-4">
								<div>
									<label class="block mb-1.5 text-sm font-medium text-gray-700 dark:text-gray-300">
										{translate key="user.register.noContextReviewerInterests"}
									</label>
									<input type="text" name="interests" id="interests" value="{$interests|default:""|escape}" placeholder="{translate key="user.interests"}"
										class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow">
								</div>
								{if $siteWidePrivacyStatement}
									<label class="flex items-start gap-3 cursor-pointer group">
										<input type="checkbox" name="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" id="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" value="1"{if $privacyConsent[$smarty.const.CONTEXT_ID_NONE]} checked="checked"{/if}
											class="mt-0.5 w-4 h-4 text-blue-600 bg-white border-gray-300 rounded focus:ring-blue-500">
										<span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-gray-100 transition-colors">
											{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE page="about" op="privacy"}{/capture}
											{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
										</span>
									</label>
								{/if}
								<label class="flex items-start gap-3 cursor-pointer group">
									<input type="checkbox" name="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}
										class="mt-0.5 w-4 h-4 text-blue-600 bg-white border-gray-300 rounded focus:ring-blue-500">
									<span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-gray-100 transition-colors">
										{translate key="user.register.form.emailConsent"}
									</span>
								</label>
							</div>
						</div>
					{/if}

					{* recaptcha spam blocker *}
					{if $reCaptchaHtml}
						<div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden mb-6">
							<div class="p-6 flex justify-center">
								{$reCaptchaHtml}
							</div>
						</div>
					{/if}

					<div class="flex flex-col sm:flex-row items-center gap-4 pt-2">
						<button type="submit" class="inline-flex items-center justify-center gap-2 w-full sm:w-auto px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg transition-colors shadow-lg cursor-pointer">
							<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
							{translate key="user.register"}
						</button>
						{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
						<a href="{url page="login" source=$rolesProfileUrl}" class="inline-flex items-center gap-2 text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 font-medium text-sm transition-colors">
							<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/></svg>
							{translate key="user.login"}
						</a>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}