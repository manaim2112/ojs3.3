{include file="frontend/components/header.tpl" pageTitle="user.register"}

<div class="br-page br-page-register">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.register"}
	<h1 class="br-page-title">
		{translate key="user.register"}
	</h1>

	<div class="br-card br-card-register">
		<p class="br-field-hint">
			{translate key="common.requiredField"}
		</p>

		<form class="br-form" id="register" method="post" action="{url op="register"}">
			{csrf}

			{if $source}
				<input type="hidden" name="source" value="{$source|escape}" />
			{/if}

			{include file="common/formErrors.tpl"}

			{include file="frontend/components/registrationForm.tpl"}

			{if $currentContext}

				<fieldset class="br-fieldset">
					{if $currentContext->getData('privacyStatement')}
						<legend class="br-sr-only">{translate key="user.register.form.privacyConsentLabel"}</legend>
						<div class="br-form-fields">
							<div class="br-field br-field-checkbox">
								<label class="br-checkbox-label">
									<input type="checkbox" name="privacyConsent" value="1"{if $privacyConsent} checked="checked"{/if}>
									{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE page="about" op="privacy"}{/capture}
									<span>{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}</span>
								</label>
							</div>
						</div>
					{/if}
					<div class="br-form-fields">
						<div class="br-field br-field-checkbox">
							<label class="br-checkbox-label">
								<input type="checkbox" name="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}>
								<span>{translate key="user.register.form.emailConsent"}</span>
							</label>
						</div>
					</div>
				</fieldset>

				{assign var=contextId value=$currentContext->getId()}
				{assign var=userCanRegisterReviewer value=0}
				{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
					{if $userGroup->getPermitSelfRegistration()}
						{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
					{/if}
				{/foreach}
				{if $userCanRegisterReviewer}
					<fieldset class="br-fieldset">
						{if $userCanRegisterReviewer > 1}
							<legend class="br-legend">
								{translate key="user.reviewerPrompt"}
							</legend>
							{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
						{else}
							{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
						{/if}
						<div class="br-form-fields">
							<div id="reviewerOptinGroup" class="br-field-group">
								{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
									{if $userGroup->getPermitSelfRegistration()}
										<div class="br-field br-field-checkbox">
											<label class="br-checkbox-label">
												{assign var="userGroupId" value=$userGroup->getId()}
												<input type="checkbox" name="reviewerGroup[{$userGroupId}]" value="1"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
												<span>{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedName()}</span>
											</label>
										</div>
									{/if}
								{/foreach}
							</div>
							<div class="br-field" id="reviewerInterests">
								<label for="interests">
									<span class="br-label">{translate key="user.interests"}</span>
									<input type="text" name="interests" id="interests" value="{$interests|default:""|escape}" class="br-input">
								</label>
							</div>
						</div>
					</fieldset>
				{/if}
			{/if}

			{include file="frontend/components/registrationFormContexts.tpl"}

			{if !$currentContext}
				<div class="br-form-fields">
					<div class="br-field">
						<label for="interests">
							<span class="br-label">{translate key="user.register.noContextReviewerInterests"}</span>
							<input type="text" name="interests" id="interests" value="{$interests|default:""|escape}" class="br-input">
						</label>
					</div>
				</div>

				{if $siteWidePrivacyStatement}
					<div class="br-form-fields">
						<div class="br-field br-field-checkbox">
							<label class="br-checkbox-label">
								<input type="checkbox" name="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" id="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" value="1"{if $privacyConsent[$smarty.const.CONTEXT_ID_NONE]} checked="checked"{/if}>
								{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE page="about" op="privacy"}{/capture}
								<span>{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}</span>
							</label>
						</div>
					</div>
				{/if}

				<div class="br-form-fields">
					<div class="br-field br-field-checkbox">
						<label class="br-checkbox-label">
							<input type="checkbox" name="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}>
							<span>{translate key="user.register.form.emailConsent"}</span>
						</label>
					</div>
				</div>
			{/if}

			{if $reCaptchaHtml}
				<fieldset class="br-fieldset">
					<div class="br-form-fields">
						<div class="br-recaptcha">
							{$reCaptchaHtml}
						</div>
					</div>
				</fieldset>
			{/if}

			<div class="br-form-actions">
				<button class="br-btn br-btn-primary" type="submit">
					{translate key="user.register"}
				</button>
				{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
				<a href="{url page="login" source=$rolesProfileUrl}" class="br-btn br-btn-outline">{translate key="user.login"}</a>
			</div>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
