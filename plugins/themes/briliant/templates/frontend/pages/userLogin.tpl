{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div class="br-page br-page-login">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login"}
	<h1 class="br-page-title">
		{translate key="user.login"}
	</h1>

	<div class="br-card br-card-login">
		<p class="br-field-hint">
			{translate key="common.requiredField"}
		</p>

		{if $loginMessage}
			<div class="br-notice">
				{translate key=$loginMessage}
			</div>
		{/if}

		<form class="br-form" id="login" method="post" action="{$loginUrl}">
			{csrf}

			{if $error}
				<div class="br-form-error">
					{translate key=$error reason=$reason}
				</div>
			{/if}

			<input type="hidden" name="source" value="{$source|default:""|escape}" />

			<fieldset class="br-fieldset">
				<legend class="br-sr-only">{translate key="user.login"}</legend>
				<div class="br-form-fields">
					<div class="br-field">
						<label for="username">
							<span class="br-label">
								{translate key="user.username"}
								<span class="br-required" aria-hidden="true">*</span>
							</span>
							<input type="text" name="username" id="username" value="{$username|default:""|escape}" maxlength="32" class="br-input" required aria-required="true">
						</label>
					</div>
					<div class="br-field">
						<label for="password">
							<span class="br-label">
								{translate key="user.password"}
								<span class="br-required" aria-hidden="true">*</span>
							</span>
							<input type="password" name="password" id="password" value="{$password|default:""|escape}" class="br-input" password="true" maxlength="32" required aria-required="true">
							<a class="br-forgot-password" href="{url page="login" op="lostPassword"}">
								{translate key="user.login.forgotPassword"}
							</a>
						</label>
					</div>
					<div class="br-field br-field-checkbox">
						<label class="br-checkbox-label">
							<input type="checkbox" name="remember" id="remember" value="1"{if $remember} checked="checked"{/if}>
							<span>{translate key="user.login.rememberUsernameAndPassword"}</span>
						</label>
					</div>
				</div>
			</fieldset>

			<div class="br-form-actions">
				<button class="br-btn br-btn-primary" type="submit">
					{translate key="user.login"}
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
