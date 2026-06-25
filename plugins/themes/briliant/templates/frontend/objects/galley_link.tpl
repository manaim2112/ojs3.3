{if $journalOverride}
	{assign var="currentJournal" value=$journalOverride}
{/if}

{if $galley->isPdfGalley()}
	{assign var="type" value="pdf"}
{else}
	{assign var="type" value="file"}
{/if}

{if $parent instanceOf Issue}
	{assign var="page" value="issue"}
	{assign var="parentId" value=$parent->getBestIssueId()}
	{assign var="path" value=$parentId|to_array:$galley->getBestGalleyId()}
{else}
	{assign var="page" value="article"}
	{assign var="parentId" value=$parent->getBestId()}
	{if $publication && $publication->getId() !== $parent->getData('currentPublicationId')}
		{assign var="path" value=$parentId|to_array:"version":$publication->getId():$galley->getBestGalleyId()}
	{else}
		{assign var="path" value=$parentId|to_array:$galley->getBestGalleyId()}
	{/if}
{/if}

{if !$hasAccess}
	{if $restrictOnlyPdf && $type=="pdf"}
		{assign var=restricted value="1"}
	{elseif !$restrictOnlyPdf}
		{assign var=restricted value="1"}
	{/if}
{/if}

<a class="br-galley-link {if $isSupplementary}br-galley-supplementary{/if} br-galley-{$type|escape}{if $restricted} br-restricted{/if}" href="{url page=$page op="view" path=$path}"{if $labelledBy} aria-labelledby={$labelledBy}{/if}>

	{if $restricted}
		<span class="pkp_screen_reader br-sr-only">
			{if $purchaseArticleEnabled}
				{translate key="reader.subscriptionOrFeeAccess"}
			{else}
				{translate key="reader.subscriptionAccess"}
			{/if}
		</span>
	{/if}

	{$galley->getGalleyLabel()|escape}

	{if $restricted && $purchaseFee && $purchaseCurrency}
		<span class="purchase_cost br-purchase-cost">
			{translate key="reader.purchasePrice" price=$purchaseFee currency=$purchaseCurrency}
		</span>
	{/if}
</a>
