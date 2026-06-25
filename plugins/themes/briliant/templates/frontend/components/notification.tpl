<div class="cmp_notification br-notification {$type|escape|replace:' ':'_'}">
	{if $messageKey}
		{translate key=$messageKey}
	{else}
		{$message}
	{/if}
</div>
