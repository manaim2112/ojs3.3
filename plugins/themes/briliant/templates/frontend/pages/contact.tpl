{include file="frontend/components/header.tpl" pageTitle="about.contact"}

<div class="br-page br-page-contact">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.contact"}
	<h1 class="br-page-title">
		{translate key="about.contact"}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="contact" sectionTitleKey="about.contact"}

	<div class="br-contact-grid">

		{if $mailingAddress}
			<div class="br-card br-card-contact br-card-address">
				<h2 class="br-card-title">{translate key="common.mailingAddress"}</h2>
				<div class="br-card-body">
					{$mailingAddress|nl2br|strip_unsafe_html}
				</div>
			</div>
		{/if}

		{if $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail}
			<div class="br-card br-card-contact">
				<h2 class="br-card-title">
					{translate key="about.contact.principalContact"}
				</h2>
				<div class="br-card-body">
					{if $contactName}
						<div class="br-contact-name">{$contactName|escape}</div>
					{/if}
					{if $contactTitle}
						<div class="br-contact-title">{$contactTitle|escape}</div>
					{/if}
					{if $contactAffiliation}
						<div class="br-contact-affiliation">{$contactAffiliation|strip_unsafe_html}</div>
					{/if}
					{if $contactPhone}
						<div class="br-contact-phone">
							<span class="br-contact-label">{translate key="about.contact.phone"}:</span>
							<span>{$contactPhone|escape}</span>
						</div>
					{/if}
					{if $contactEmail}
						<div class="br-contact-email">
							{mailto address=$contactEmail encode='javascript'}
						</div>
					{/if}
				</div>
			</div>
		{/if}

		{if $supportName || $supportPhone || $supportEmail}
			<div class="br-card br-card-contact">
				<h2 class="br-card-title">
					{translate key="about.contact.supportContact"}
				</h2>
				<div class="br-card-body">
					{if $supportName}
						<div class="br-contact-name">{$supportName|escape}</div>
					{/if}
					{if $supportPhone}
						<div class="br-contact-phone">
							<span class="br-contact-label">{translate key="about.contact.phone"}:</span>
							<span>{$supportPhone|escape}</span>
						</div>
					{/if}
					{if $supportEmail}
						<div class="br-contact-email">
							{mailto address=$supportEmail encode='javascript'}
						</div>
					{/if}
				</div>
			</div>
		{/if}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
