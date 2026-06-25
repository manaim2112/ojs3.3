{if !$currentContext}

	<fieldset name="contexts" class="br-fieldset">
		<legend class="br-legend">
			{translate key="user.register.contextsPrompt"}
		</legend>
		<div class="fields br-form-fields">
			<div id="contextOptinGroup" class="context_optin">
				<ul class="contexts br-contexts-list">
					{foreach from=$contexts item=context}
						{assign var=contextId value=$context->getId()}
						{assign var=isSelected value=false}
						<li class="context br-context-item">
							<div class="name br-context-name">
								{$context->getLocalizedName()}
							</div>
							<fieldset class="roles br-fieldset">
								<legend class="br-legend">
									{translate key="user.register.otherContextRoles"}
								</legend>
								{foreach from=$readerUserGroups[$contextId] item=userGroup}
									{if $userGroup->getPermitSelfRegistration()}
										{assign var="userGroupId" value=$userGroup->getId()}
										<label class="br-checkbox-label">
											<input type="checkbox" name="readerGroup[{$userGroupId}]"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
											{$userGroup->getLocalizedName()}
										</label>
										{if in_array($userGroupId, $userGroupIds)}
											{assign var=isSelected value=true}
										{/if}
									{/if}
								{/foreach}
								{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
									{if $userGroup->getPermitSelfRegistration()}
										{assign var="userGroupId" value=$userGroup->getId()}
										<label class="br-checkbox-label">
											<input type="checkbox" name="reviewerGroup[{$userGroupId}]"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
											{$userGroup->getLocalizedName()}
										</label>
										{if in_array($userGroupId, $userGroupIds)}
											{assign var=isSelected value=true}
										{/if}
									{/if}
								{/foreach}
							</fieldset>
							{if !$enableSiteWidePrivacyStatement && $context->getData('privacyStatement')}
								<div class="context_privacy br-context-privacy {if $isSelected}context_privacy_visible{/if}">
									<label class="br-checkbox-label">
										<input type="checkbox" name="privacyConsent[{$contextId}]" id="privacyConsent[{$contextId}]" value="1"{if $privacyConsent[$contextId]} checked="checked"{/if}>
										{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE context=$context->getPath() page="about" op="privacy"}{/capture}
										{translate key="user.register.form.privacyConsentThisContext" privacyUrl=$privacyUrl}
									</label>
								</div>
							{/if}
						</li>
					{/foreach}
				</ul>
			</div>
		</div>
	</fieldset>
{/if}
