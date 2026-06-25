{**
 * templates/frontend/pages/userLostPassword.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Password reset form.
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

<div class="grid grid-cols-1 md:grid-cols-5 lg:grid-cols-8 xl:grid-cols-12 gap-8 container mx-auto my-10">
	<div class="md:col-span-3 lg:col-span-6 xl:col-span-8 md:col-start-2 lg:col-start-2 xl:col-start-3">
		<div class="page page_lost_password bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 md:p-8">
			{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login.resetPassword"}
			<h1 class="text-3xl md:text-4xl font-bold mb-6">
				{translate key="user.login.resetPassword"}
			</h1>

			<p class="mb-6 text-gray-600 dark:text-gray-300">{translate key="user.login.resetPasswordInstructions"}</p>

			<form class="cmp_form lost_password bg-white dark:bg-gray-700 rounded-lg shadow-md p-6 border border-gray-200 dark:border-gray-600 max-w-md" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post">
				{csrf}
				{if $error}
					<div class="bg-red-100 text-red-700 p-3 rounded-lg mb-3">
						{translate key=$error reason=$reason}
					</div>
				{/if}

				<div class="fields">
					<div class="mb-4">
						<label for="email" class="block mb-2 text-sm font-medium text-gray-900 dark:text-gray-100">
							{translate key="user.login.registeredEmail"}
							<span class="required" aria-hidden="true">*</span>
							<span class="pkp_screen_reader">
								{translate key="common.required"}
							</span>
						</label>
						<input type="email" name="email" id="email" 
							class="bg-gray-50 dark:bg-gray-800 border border-gray-300 dark:border-gray-500 text-gray-900 dark:text-gray-100 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
							value="{$email|escape}" required aria-required="true">
					</div>
					<div class="flex gap-3 mt-6">
						<button class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 cursor-pointer font-medium" type="submit">
							{translate key="user.login.resetPassword"}
						</button>

						{if !$disableUserReg}
							{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
							<a href="{$registerUrl}" class="bg-gray-200 dark:bg-gray-600 text-gray-800 dark:text-gray-100 px-6 py-2 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-500 cursor-pointer font-medium">
								{translate key="user.login.registerNewAccount"}
							</a>
						{/if}
					</div>
				</div>

			</form>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
