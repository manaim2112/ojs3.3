<div class="cmp_subscription_contact br-subscription-contact">
	 {if $subscriptionAdditionalInformation}
		<div class="description br-description">
			{$subscriptionAdditionalInformation|strip_unsafe_html}
		</div>
	{/if}

	{if $subscriptionName || $subscriptionPhone || $subscriptionEmail}
		<div class="contact br-contact">
			<h3>
				{translate key="about.subscriptionsContact"}
			</h3>

			{if $subscriptionName}
				<div class="name br-contact-name">
					{$subscriptionName|escape}
				</div>
			{/if}

			{if $subscriptionMailingAddress}
				<div class="address br-contact-address">
					{$subscriptionMailingAddress|nl2br|strip_unsafe_html}
				</div>
			{/if}

			{if $subscriptionPhone}
				<div class="phone br-contact-phone">
					<span class="label br-label">
						{translate key="about.contact.phone"}
					</span>
					<span class="value br-value">
						{$subscriptionPhone|escape}
					</span>
				</div>
			{/if}

			{if $subscriptionEmail}
				<div class="email br-contact-email">
					<a href="mailto:{$subscriptionEmail|escape}">
						{$subscriptionEmail|escape}
					</a>
				</div>
			{/if}
		</div>
	{/if}
 </div>
