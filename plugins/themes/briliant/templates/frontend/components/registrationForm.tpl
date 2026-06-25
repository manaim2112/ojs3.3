<fieldset class="identity br-fieldset">
	<legend class="br-legend">{translate key="user.profile"}</legend>
	<div class="fields br-form-fields">
		<div class="given_name br-field">
			<label>
				<span class="label br-label">
					{translate key="user.givenName"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<input type="text" name="givenName" autocomplete="given-name" id="givenName" value="{$givenName|default:""|escape}" maxlength="255" required aria-required="true" class="br-input">
			</label>
		</div>
		<div class="family_name br-field">
			<label>
				<span class="label br-label">
					{translate key="user.familyName"}
				</span>
				<input type="text" name="familyName" autocomplete="family-name" id="familyName" value="{$familyName|default:""|escape}" maxlength="255" class="br-input">
			</label>
		</div>
		<div class="affiliation br-field">
			<label>
				<span class="label br-label">
					{translate key="user.affiliation"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<input type="text" name="affiliation" id="affiliation" value="{$affiliation|default:""|escape}" required aria-required="true" class="br-input">
			</label>
		</div>
		<div class="country br-field">
			<label>
				<span class="label br-label">
					{translate key="common.country"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<select name="country" id="country" required aria-required="true" class="br-input br-select">
					<option></option>
					{html_options options=$countries selected=$country}
				</select>
			</label>
		</div>
	</div>
</fieldset>

<fieldset class="login br-fieldset">
	<legend class="br-legend">{translate key="user.login"}</legend>
	<div class="fields br-form-fields">
		<div class="email br-field">
			<label>
				<span class="label br-label">
					{translate key="user.email"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<input type="email" name="email" id="email" value="{$email|default:""|escape}" maxlength="90" required aria-required="true" autocomplete="email" class="br-input">
			</label>
		</div>
		<div class="username br-field">
			<label>
				<span class="label br-label">
					{translate key="user.username"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<input type="text" name="username" id="username" value="{$username|default:""|escape}" maxlength="32" required aria-required="true" autocomplete="username" class="br-input">
			</label>
		</div>
		<div class="password br-field">
			<label>
				<span class="label br-label">
					{translate key="user.password"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<input type="password" name="password" id="password" password="true" maxlength="32" required aria-required="true" class="br-input">
			</label>
		</div>
		<div class="password br-field">
			<label>
				<span class="label br-label">
					{translate key="user.repeatPassword"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader br-sr-only">
						{translate key="common.required"}
					</span>
				</span>
				<input type="password" name="password2" id="password2" password="true" maxlength="32" required aria-required="true" class="br-input">
			</label>
		</div>
	</div>
</fieldset>
