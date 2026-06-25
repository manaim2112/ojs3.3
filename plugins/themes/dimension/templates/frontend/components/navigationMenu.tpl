{**
 * templates/frontend/components/navigationMenu.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Primary navigation menu list for OJS
 *
 * @uses navigationMenu array Hierarchical array of navigation menu item assignments
 * @uses id string Element ID to assign the outer <ul>
 * @uses ulClass string Class name(s) to assign the outer <ul>
 * @uses liClass string Class name(s) to assign all <li> elements
 *}
{if $navigationMenu}
	{* === User Menu / Profile Dropdown === *}
	{if $liClass == "profile"}
		<div class="relative inline-block" id="userMenuContainer">
			<button id="userMenuButton" class="flex items-center gap-2 text-white hover:text-blue-200 transition-colors p-1 rounded-full hover:bg-white/10" aria-label="User menu" aria-haspopup="true" aria-expanded="false">
				{if $currentFrontendUser}
					<img src="https://www.gravatar.com/avatar/{$currentFrontendUser->getEmail()|lower|md5}?s=80&d=mp"
						alt="" class="w-8 h-8 rounded-full border-2 border-white"
						onerror="this.onerror=null;this.src='https://placehold.co/80x80/1e40af/white?text={$currentFrontendUser->getFullName()|truncate:1:''|escape:url}'">
					<span class="hidden md:inline text-sm font-medium max-w-[100px] truncate">{$currentFrontendUser->getFullName()|escape}</span>
				{else}
					<svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A9 9 0 0112 15a9 9 0 016.879 2.804M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
					<span class="hidden md:inline text-sm font-medium">{translate key="user.login"}</span>
				{/if}
				<svg class="w-4 h-4 transition-transform duration-200" id="userMenuChevron" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
			</button>

			<div id="userMenuDropdown"
				class="absolute hidden bg-white dark:bg-gray-700 shadow-xl rounded-lg mt-2 right-0 w-56 animate-fade-in-up-dropdown overflow-hidden z-50">
				<ul id="{$id|escape}" class="{$ulClass|escape} text-sm text-gray-800 dark:text-gray-200 py-2">
					{if $currentFrontendUser}
						<li class="px-4 py-3 border-b border-gray-100 dark:border-gray-600">
							<p class="font-semibold truncate">{$currentFrontendUser->getFullName()|escape}</p>
							<p class="text-xs text-gray-500 dark:text-gray-400 truncate">{$currentFrontendUser->getEmail()|escape}</p>
						</li>
					{/if}
					{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
						{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
							{continue}
						{/if}
						<li class="px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 cursor-pointer transition-colors duration-200">
							<a class="block w-full" href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}">
								{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
							</a>
						</li>
					{/foreach}
					{if $currentFrontendUser}
						<li class="border-t border-gray-100 dark:border-gray-600">
							<a href="{url page="login" op="signOut"}" class="block px-4 py-2 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
								{translate key="user.logOut"}
							</a>
						</li>
					{/if}
				</ul>
			</div>
		</div>

		<script>
		(function() {
			var container = document.getElementById('userMenuContainer');
			var button = document.getElementById('userMenuButton');
			var dropdown = document.getElementById('userMenuDropdown');
			var chevron = document.getElementById('userMenuChevron');
			if (!button || !dropdown) return;

			function toggle(e) {
				e.stopPropagation();
				var isOpen = !dropdown.classList.contains('hidden');
				dropdown.classList.toggle('hidden');
				button.setAttribute('aria-expanded', !isOpen);
				if (chevron) chevron.classList.toggle('rotate-180');
			}

			button.addEventListener('click', toggle);

			document.addEventListener('click', function(e) {
				if (!container.contains(e.target) && !dropdown.classList.contains('hidden')) {
					dropdown.classList.add('hidden');
					button.setAttribute('aria-expanded', 'false');
					if (chevron) chevron.classList.remove('rotate-180');
				}
			});

			document.addEventListener('keydown', function(e) {
				if (e.key === 'Escape' && !dropdown.classList.contains('hidden')) {
					dropdown.classList.add('hidden');
					button.setAttribute('aria-expanded', 'false');
					if (chevron) chevron.classList.remove('rotate-180');
					button.focus();
				}
			});
		})();
		</script>
	{else}
		{* === Primary Menu (Desktop & Mobile) === *}

		{* Desktop Menu (hanya tampil di md: ke atas) *}
		<ul id="{$id|escape}" class="{$ulClass|escape} text-white">
			{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
				{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
					{continue}
				{/if}
				<li class="relative group px-2 py-1">
					<a class="px-4 py-2 block hover:bg-blue-700 rounded-full transition-colors duration-200 animate-slide-in-nav-item"
						href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}">
						{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
					</a>
					{if $navigationMenuItemAssignment->navigationMenuItem->getIsChildVisible()}
						<ul
							class="absolute left-0 hidden group-hover:block bg-white dark:bg-gray-700 rounded-lg text-gray-800 dark:text-gray-200 shadow-xl min-w-[200px] z-50 animate-fade-in-up-dropdown overflow-hidden">
							{foreach key=childField item=childNavigationMenuItemAssignment from=$navigationMenuItemAssignment->children}
								{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
									<li class="py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors duration-200">
										<a class="block w-full text-sm"
											href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}">
											{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
										</a>
									</li>
								{/if}
							{/foreach}
						</ul>
					{/if}
				</li>
			{/foreach}
		</ul>
	{/if}
{/if}

<script>
	// Submenu Toggle for Mobile Menu Items (header.tpl handles open/close/ESC/resize)
	document.querySelectorAll('#mobileMenu .mobile-menu-item').forEach(item => {
		var submenu = item.querySelector('ul');
		if (submenu) {
			var link = item.querySelector('a');
			var toggleButton = document.createElement('button');
			toggleButton.innerHTML = '&#9660;';
			toggleButton.classList.add('absolute', 'right-4', 'top-2', 'p-1', 'text-gray-500',
				'hover:text-gray-800', 'transition-colors');
			item.insertBefore(toggleButton, submenu);

			toggleButton.addEventListener('click', function(e) {
				e.stopPropagation();
				submenu.classList.toggle('hidden');
				toggleButton.innerHTML = submenu.classList.contains('hidden') ? '&#9660;' : '&#9650;';
			});

			submenu.classList.add('hidden');
		}
	});
</script>

<style>
	/* Custom Keyframes */
	@keyframes fade-in-down {
		0% {
			opacity: 0;
			transform: translateY(-10px);
		}

		100% {
			opacity: 1;
			transform: translateY(0);
		}
	}

	@keyframes fade-in-scale {
		0% {
			opacity: 0;
			transform: scale(0.9);
		}

		100% {
			opacity: 1;
			transform: scale(1);
		}
	}

	@keyframes fade-in-up-dropdown {
		0% {
			opacity: 0;
			transform: translateY(5px);
		}

		100% {
			opacity: 1;
			transform: translateY(0);
		}
	}

	@keyframes slide-in-nav-item {
		0% {
			opacity: 0;
			transform: translateX(-10px);
		}

		100% {
			opacity: 1;
			transform: translateX(0);
		}
	}

	/* Custom Animation Classes */
	.animate-fade-in-down {
		animation: fade-in-down 0.5s ease-out forwards;
	}

	.animate-fade-in-scale {
		animation: fade-in-scale 0.4s ease-out forwards;
	}

	.animate-fade-in-up-dropdown {
		animation: fade-in-up-dropdown 0.3s ease-out forwards;
	}

	.animate-slide-in-nav-item {
		animation: slide-in-nav-item 0.4s ease-out forwards;
	}

	/* Add delay for each nav item */
	.pkp_navigation_primary li:nth-child(1) .animate-slide-in-nav-item {
		animation-delay: 0.1s;
	}

	.pkp_navigation_primary li:nth-child(2) .animate-slide-in-nav-item {
		animation-delay: 0.15s;
	}

	.pkp_navigation_primary li:nth-child(3) .animate-slide-in-nav-item {
		animation-delay: 0.2s;
	}

	.pkp_navigation_primary li:nth-child(4) .animate-slide-in-nav-item {
		animation-delay: 0.25s;
	}

	/* ... tambahkan jika ada lebih banyak item */


	/* Global Body Overflow for Mobile Menu */
	body.overflow-hidden {
		overflow: hidden;
	}

	/* Ensure mobile menu starts fully off-screen */
	#mobileMenu.translate-x-full {
		transform: translateX(100%);
	}

	#mobileMenu:not(.translate-x-full) {
		transform: translateX(0);
	}

	/* Optional: Overlay background color for mobile menu backdrop */
	#mobileMenuBackdrop {
		background-color: rgba(0, 0, 0, 0.7);
	}
</style>