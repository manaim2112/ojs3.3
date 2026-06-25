<div class="order-2 md:order-1 md:col-span-1 lg:col-span-1 xl:col-span-2 lg:sticky lg:top-0">


		<div class="mt-3">
			<span class="font-semibold text-gray-700 dark:text-gray-300">{$currentJournal->getLocalizedName()} {translate key="common.indexing"}</span>

			{if $activeTheme->getOption('index_dimension_url')}
				<div class="my-2">
					<a href="{$activeTheme->getOption('index_dimension_url')}" target="_blank" class="inline-flex items-center gap-2 bg-blue-50 dark:bg-gray-800 text-blue-700 dark:text-blue-300 text-sm font-medium rounded-lg px-4 py-2 hover:bg-blue-100 dark:hover:bg-gray-700 transition-colors">
						<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
						Dimension
					</a>
				</div>	
			{/if}

			{if $activeTheme->getOption('index_garuda_url')}
				<div class="my-2">
					<a href="{$activeTheme->getOption('index_garuda_url')}" target="_blank" class="inline-flex items-center gap-2 bg-blue-50 dark:bg-gray-800 text-blue-700 dark:text-blue-300 text-sm font-medium rounded-lg px-4 py-2 hover:bg-blue-100 dark:hover:bg-gray-700 transition-colors">
						<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
						Garuda
					</a>
				</div>
			{/if}

			{if $activeTheme->getOption('index_url')}
				<a href="{$activeTheme->getOption('index_url')}" class="text-lg font-bold text-blue-700 hover:underline">
					Check All Indexing
				</a>
			{/if}



		</div>
		
		{if $activeTheme->getOption('contributionLink')}
			<div class="my-2">
				<a href="{$activeTheme->getOption('contributionLink')}" target="_blank" class="inline-flex items-center gap-2 bg-green-50 dark:bg-gray-800 text-green-700 dark:text-green-300 text-sm font-medium rounded-lg px-4 py-2 hover:bg-green-100 dark:hover:bg-gray-700 transition-colors w-full">
					<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
					{translate key="common.downloadFiles"}
				</a>
			</div>
		{/if}

		{assign var="phonecall" value=$activeTheme->getOption('contactPhone')}
		<div class="mt-3">
		<a class="bg-green-500 hover:bg-green-600 shadow-lg inline-flex items-center gap-2 font-bold text-white rounded-lg py-2 px-4 transition-colors" href="https://api.whatsapp.com/send/?phone={$phonecall}&text=Hello&type=phone_number" target="_blank" rel="noopener noreferrer">
			<svg class="w-6 h-6" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
			{translate key="common.chatViaWhatsapp"}
		</a>
		</div>

		<div class="mt-3">
		{if $currentFrontendUser}
			<div class="bg-white dark:bg-gray-800 rounded-lg shadow-xs p-5">
				<div class="flex items-center gap-3 mb-3">
					<img src="https://www.gravatar.com/avatar/{$currentFrontendUser->getEmail()|lower|md5}?s=80&d=mp"
						alt="" class="w-10 h-10 rounded-full border-2 border-blue-200 dark:border-gray-600"
						onerror="this.onerror=null;this.src='https://placehold.co/80x80/1e40af/white?text={$currentFrontendUser->getFullName()|truncate:1:''|escape:url}'">
					<div class="min-w-0">
						<p class="font-semibold text-gray-800 dark:text-gray-100 text-sm truncate">{$currentFrontendUser->getFullName()|escape}</p>
						<p class="text-xs text-gray-500 dark:text-gray-400 truncate">{$currentFrontendUser->getEmail()|escape}</p>
					</div>
				</div>
				<div class="space-y-2">
					<a href="{url page="submission" op="wizard"}"
						class="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-lg px-4 py-2 transition-colors">
						<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
						{translate key="about.onlineSubmissions.newSubmission"}
					</a>
					<a href="{url page="login" op="signOut"}"
						class="flex items-center gap-2 text-gray-600 dark:text-gray-300 hover:text-red-600 dark:hover:text-red-400 text-xs transition-colors">
						<svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
						{translate key="user.logOut"}
					</a>
				</div>
			</div>
		{else}
			{assign var="loginUrl" value=implode("/", ["/index.php", $currentJournal->getData('urlPath'), "login/signIn"])}
			<form class="bg-white dark:bg-gray-800 rounded-lg shadow-xs p-5" method="post" action="{$loginUrl}">
				{csrf}
				{if $error}
					<div class="text-red-500 text-sm mb-3">{translate key=$error reason=$reason}</div>
				{/if}
				<input type="hidden" name="source" value="{$source|default:""|escape}" />
				<div class="mb-3">
					<label for="side-username" class="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">{translate key="user.username"}</label>
					<input type="text" name="username" id="side-username"
						class="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
						placeholder="{translate key="user.username"}" value="{$username|default:""|escape}" maxlength="32" required />
				</div>
				<div class="mb-3">
					<label for="side-password" class="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">{translate key="user.password"}</label>
					<input type="password" name="password" id="side-password"
						class="bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
						placeholder="*****" maxlength="32" required />
				</div>
				<div class="flex items-center justify-between mb-4">
					<label class="flex items-center gap-2 text-xs text-gray-600 dark:text-gray-400">
						<input name="remember" type="checkbox" value="1" class="rounded-xs" />
						{translate key="user.login.rememberUsernameAndPassword"}
					</label>
					<a href="{url page="login" op="lostPassword"}" class="text-xs text-blue-600 dark:text-blue-400 hover:underline">{translate key="user.login.forgotPassword"}</a>
				</div>
				<button class="bg-blue-600 hover:bg-blue-700 text-white w-full py-2 rounded-lg text-sm font-medium transition-colors cursor-pointer" type="submit">
					{translate key="user.login"}
				</button>
				<div class="mt-3 space-y-2">
					<a href="{url page="user" op="register"}"
						class="flex items-center justify-center gap-2 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 text-sm font-medium rounded-lg px-4 py-2 transition-colors">
						<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
						{translate key="user.register"}
					</a>
					<a href="{url page="submission" op="wizard"}"
						class="flex items-center justify-center gap-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-lg px-4 py-2 transition-colors">
						<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
						{translate key="about.onlineSubmissions.newSubmission"}
					</a>
				</div>
			</form>
		{/if}
		</div>
	</div>  