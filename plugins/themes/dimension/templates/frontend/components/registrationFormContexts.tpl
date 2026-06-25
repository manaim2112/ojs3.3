{**
 * Display context-specific registration options (journal subscriptions)
 *}
{if !$currentContext && !empty($contexts)}
<fieldset class="border border-gray-200 dark:border-gray-700 rounded-lg p-5 mb-6">
	<legend class="text-xl font-bold text-gray-800 dark:text-gray-100 px-2 mb-4">
		{translate key="user.register.contextsPrompt"}
	</legend>
	<div class="space-y-3">
		{foreach from=$contexts item=context}
			<div class="flex items-start gap-3 p-3 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
				<input type="checkbox" name="registerContext[{$context->getId()}]" id="registerContext-{$context->getId()}" value="1"
					class="mt-1 w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500">
				<label for="registerContext-{$context->getId()}" class="text-sm text-gray-700 dark:text-gray-300">
					{$context->getLocalizedName()|escape}
				</label>
			</div>
		{/foreach}
	</div>
</fieldset>
{/if}
