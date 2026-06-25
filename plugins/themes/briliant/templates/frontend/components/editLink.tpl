{if in_array(ROLE_ID_MANAGER, (array) $userRoles)}

	{if $sectionTitleKey}
		{capture assign='sectionTitle'}{translate key=$sectionTitleKey}{/capture}
	{/if}

	<a href="{url page=$page op=$op path=$path anchor=$anchor}" class="cmp_edit_link br-edit-link">
		{translate key="common.edit"}

		<span class="pkp_screen_reader br-sr-only">
			{translate key="help.goToEditPage" sectionTitle=$sectionTitle}
		</span>
	</a>
{/if}
