{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

<div class="br-page br-page-lost-password">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login.resetPassword"}
	<h1 class="br-page-title">
		{translate key="user.login.resetPassword"}
	</h1>

	<div class="br-card br-card-lost-password">
		<p class="br-field-hint">{translate key="user.login.resetPasswordInstructions"}</p>

		<form class="br-form" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post">
			{csrf}
			{if $error}
				<div class="br-form-error">
					{translate key=$error reason=$reason}
				</div>
			{/if}

			<div class="br-form-fields">
				<div class="br-field">
					<label for="email">
						<span class="br-label">
							{translate key="user.login.registeredEmail"}
							<span class="br-required" aria-hidden="true">*</span>
						</span>
						<input type="email" name="email" id="email" value="{$email|escape}" class="br-input" required aria-required="true">
					</label>
				</div>
			</div>

			<div class="br-form-actions">
				<button class="br-btn br-btn-primary" type="submit">
					{translate key="user.login.resetPassword"}
				</button>
				{if !$disableUserReg}
					{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
					<a href="{$registerUrl}" class="br-btn br-btn-outline">
						{translate key="user.login.registerNewAccount"}
					</a>
				{/if}
			</div>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
