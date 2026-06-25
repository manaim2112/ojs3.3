{**
 * templates/frontend/pages/userLogin.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * User login form.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div class="page page_login">
	<div class="max-w-lg mx-auto my-10">
		{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login"}

		<div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden">
			<div class="bg-gradient-to-r from-blue-600 to-blue-800 dark:from-gray-800 dark:to-gray-900 px-6 py-8 text-center">
				<div class="w-16 h-16 mx-auto mb-4 bg-white/20 rounded-full flex items-center justify-center">
					<svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/></svg>
				</div>
				<h1 class="text-2xl md:text-3xl font-bold text-white mb-2">{translate key="user.login"}</h1>
				<p class="text-blue-100 dark:text-gray-300 text-sm">{translate key="common.requiredField"}</p>
			</div>

			<div class="p-6 md:p-8">
				<form class="cmp_form login" id="login" method="post" action="{$loginUrl}">
					{csrf}

					{if $loginMessage}
						<div class="bg-blue-50 text-blue-700 p-3 rounded-lg mb-4 text-sm">{translate key=$loginMessage}</div>
					{/if}

					{if $error}
						<div class="bg-red-100 text-red-700 p-3 rounded-lg mb-4 text-sm">{translate key=$error reason=$reason}</div>
					{/if}

					<input type="hidden" name="source" value="{$source|default:""|escape}" />

					<div class="mb-5">
						<label for="username" class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
							{translate key="user.username"}
							<span class="required text-red-500" aria-hidden="true">*</span>
							<span class="pkp_screen_reader">{translate key="common.required"}</span>
						</label>
						<div class="relative">
							<svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
							<input type="text" name="username" id="username"
								class="w-full pl-10 pr-4 py-2.5 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow placeholder:text-gray-400"
								placeholder="{translate key="user.username"}" value="{$username|default:""|escape}" maxlength="32" required aria-required="true" />
						</div>
					</div>

					<div class="mb-4">
						<label for="password" class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
							{translate key="user.password"}
							<span class="required text-red-500" aria-hidden="true">*</span>
							<span class="pkp_screen_reader">{translate key="common.required"}</span>
						</label>
						<div class="relative">
							<svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
							<input type="password" name="password" id="password"
								class="w-full pl-10 pr-4 py-2.5 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow placeholder:text-gray-400"
								placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;" value="{$password|default:""|escape}" maxlength="32" required aria-required="true" />
						</div>
						<div class="mt-2 text-right">
							<a class="text-sm text-blue-600 dark:text-blue-400 hover:underline font-medium" href="{url page="login" op="lostPassword"}">
								{translate key="user.login.forgotPassword"}
							</a>
						</div>
					</div>

					<div class="flex items-center mb-6">
						<input name="remember" id="remember" value="1" type="checkbox" {if $remember}checked="checked"{/if}
							class="w-4 h-4 text-blue-600 bg-gray-100 dark:bg-gray-700 border-gray-300 dark:border-gray-600 rounded focus:ring-blue-500">
						<label for="remember" class="ml-2 text-sm font-medium text-gray-700 dark:text-gray-300 cursor-pointer select-none">{translate key="user.login.rememberUsernameAndPassword"}</label>
					</div>

					<div class="flex flex-col sm:flex-row items-center gap-4">
						<button class="inline-flex items-center justify-center gap-2 w-full px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg transition-colors shadow-lg cursor-pointer" type="submit">
							<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/></svg>
							{translate key="user.login"}
						</button>
						{if !$disableUserReg}
							{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
							<a href="{$registerUrl}" class="inline-flex items-center gap-2 text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 font-medium text-sm transition-colors">
								<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
								{translate key="user.login.registerNewAccount"}
							</a>
						{/if}
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
