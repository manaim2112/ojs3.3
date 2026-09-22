<?php

/**
 * @file plugins/themes/difusi/DifusiThemePlugin.inc.php
 *
 * @class DifusiThemePlugin
 * @ingroup plugins_themes_difusi
 *
 * @brief Child theme of the OJS default theme implementing the visual identity
 *  described in the "Jurnal Difusi Ipteks Legowo" style guide: dark forest
 *  green curves, halftone dot patterns, a two-tone italic journal title and a
 *  geometric polygon footer.
 */

import('lib.pkp.classes.plugins.ThemePlugin');

class DifusiThemePlugin extends ThemePlugin {

	/**
	 * Initialize the theme.
	 *
	 * Runs on the active theme and on every parent theme.
	 *
	 * @return null
	 */
	public function init() {
		// Inherit styles, scripts, options and templates from the default theme.
		// Everything registered below is loaded on top of it.
		$this->setParent('defaultthemeplugin');

		// The style guide fixes the palette and the type stack, so the parent's
		// free-form colour and typography pickers are dropped to keep every
		// journal on this theme visually consistent. Its bundled font files are
		// dropped too: Inter, Montserrat and Roboto Condensed come from Google
		// Fonts instead.
		$this->removeOption('baseColour');
		$this->removeOption('typography');
		$this->removeStyle('font');

		AppLocale::requireComponents(LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_APP_MANAGER);

		// Typography required by the style guide (Montserrat / Roboto Condensed / Inter).
		$this->addStyle(
			'jdiFonts',
			'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Montserrat:ital,wght@0,600;0,700;0,800;1,700;1,800&family=Roboto+Condensed:wght@400;700&display=swap',
			[
				'baseUrl' => '',
				'priority' => STYLE_SEQUENCE_LATE,
			]
		);

		// JDI overrides. Registered under a different name than the parent's
		// "stylesheet" so the default theme stylesheet is kept, and with the
		// last sequence so it wins the cascade.
		$this->addStyle('jdiStyles', 'styles/index.less', [
			'priority' => STYLE_SEQUENCE_LAST,
		]);

		$this->addOption('coverFrame', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.difusi.option.coverFrame.label'),
			'description' => __('plugins.themes.difusi.option.coverFrame.description'),
			'options' => [
				['value' => 'circle', 'label' => __('plugins.themes.difusi.option.coverFrame.circle')],
				['value' => 'rounded', 'label' => __('plugins.themes.difusi.option.coverFrame.rounded')],
				['value' => 'none', 'label' => __('plugins.themes.difusi.option.coverFrame.none')],
			],
			'default' => 'circle',
		]);

		$this->addOption('publisherName', 'FieldText', [
			'label' => __('plugins.themes.difusi.option.publisherName.label'),
			'description' => __('plugins.themes.difusi.option.publisherName.description'),
			'default' => '',
		]);

		$this->addOption('publisherUrl', 'FieldText', [
			'label' => __('plugins.themes.difusi.option.publisherUrl.label'),
			'description' => __('plugins.themes.difusi.option.publisherUrl.description'),
			'default' => '',
		]);

		$this->addOption('publisherPhone', 'FieldText', [
			'label' => __('plugins.themes.difusi.option.publisherPhone.label'),
			'description' => __('plugins.themes.difusi.option.publisherPhone.description'),
			'default' => '',
		]);
	}

	/**
	 * Split a display title into the two coloured parts used by the header.
	 *
	 * The style guide renders the word "Jurnal" in ocean blue and the rest of
	 * the journal name in vibrant orange. Titles that do not start with
	 * "Jurnal" are returned whole in the orange part.
	 *
	 * @param string $title
	 * @return array ['leading' => string, 'rest' => string]
	 */
	public function getTitleParts($title) {
		$title = trim((string) $title);
		$parts = preg_split('/\s+/', $title, 2);

		if (count($parts) > 1 && strcasecmp($parts[0], 'Jurnal') === 0) {
			return ['leading' => $parts[0], 'rest' => $parts[1]];
		}

		return ['leading' => '', 'rest' => $title];
	}

	/**
	 * Get the name of the settings file to be installed on new journal
	 * creation.
	 *
	 * @return string
	 */
	public function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * Get the name of the settings file to be installed site-wide when
	 * OJS is installed.
	 *
	 * @return string
	 */
	public function getInstallSitePluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * Get the display name of this plugin.
	 *
	 * @return string
	 */
	public function getDisplayName() {
		return __('plugins.themes.difusi.name');
	}

	/**
	 * Get the description of this plugin.
	 *
	 * @return string
	 */
	public function getDescription() {
		return __('plugins.themes.difusi.description');
	}
}
