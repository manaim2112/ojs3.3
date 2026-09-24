<?php

/**
 * @file plugins/themes/klausula/KlausulaThemePlugin.inc.php
 *
 * @class KlausulaThemePlugin
 * @ingroup plugins_themes_klausula
 *
 * @brief Child theme of the OJS default theme implementing a classic, formal
 *  visual identity for a law journal: serif typography, a red palette on a
 *  white page, engraved rules and an optional seal emblem.
 */

import('lib.pkp.classes.plugins.ThemePlugin');

class KlausulaThemePlugin extends ThemePlugin {

	/**
	 * Request-level memo of computed article stats, keyed by submission id.
	 * @var array
	 */
	private $_articleStatsMemo = [];

	/**
	 * Request-level memo of the context's default metric type.
	 * @var string|null|false False until resolved.
	 */
	private $_metricType = false;

	/**
	 * Initialize the theme.
	 *
	 * Runs on the active theme and on every parent theme.
	 *
	 * @return null
	 */
	public function init() {
		// Inherit styles, scripts, options and templates from the default theme.
		$this->setParent('defaultthemeplugin');

		// The visual identity is fixed by the theme, so the parent's free-form
		// colour and typography pickers are dropped, together with its bundled
		// font files. The serif stack comes from Google Fonts instead.
		$this->removeOption('baseColour');
		$this->removeOption('typography');
		$this->removeStyle('font');

		AppLocale::requireComponents(LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_APP_MANAGER);

		// Typography required by the law-journal identity
		// (Playfair Display / EB Garamond / Roboto Condensed).
		$this->addStyle(
			'klausulaFonts',
			'https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,500;0,600;1,400&family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Roboto+Condensed:wght@400;700&display=swap',
			[
				'baseUrl' => '',
				'priority' => STYLE_SEQUENCE_LATE,
			]
		);

		// Country flag icons for author bylines (flag-icons, SVG via CDN).
		$this->addStyle(
			'klausulaFlags',
			'https://cdn.jsdelivr.net/gh/lipis/flag-icons@7.2.3/css/flag-icons.min.css',
			[
				'baseUrl' => '',
				'priority' => STYLE_SEQUENCE_LATE,
			]
		);

		// Klausula overrides. Registered under a different name than the parent's
		// "stylesheet" so the default theme stylesheet is kept, and with the last
		// sequence so it wins the cascade.
		$this->addStyle('klausulaStyles', 'styles/index.less', [
			'priority' => STYLE_SEQUENCE_LAST,
		]);

		// Colour scheme. The palette is emitted as CSS custom properties
		// (see styles/base.less), so this is applied as a body class and
		// switches instantly without recompiling the stylesheet.
		$this->addOption('colourScheme', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.klausula.option.colourScheme.label'),
			'description' => __('plugins.themes.klausula.option.colourScheme.description'),
			'options' => [
				['value' => 'classic', 'label' => __('plugins.themes.klausula.option.colourScheme.classic')],
				['value' => 'strong', 'label' => __('plugins.themes.klausula.option.colourScheme.strong')],
			],
			'default' => 'classic',
		]);

		// Article metrics (abstract views / file downloads).
		$this->addOption('showStats', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.klausula.option.showStats.label'),
			'description' => __('plugins.themes.klausula.option.showStats.description'),
			'options' => [
				['value' => true, 'label' => __('plugins.themes.klausula.option.showStats.yes')],
				['value' => false, 'label' => __('plugins.themes.klausula.option.showStats.no')],
			],
			'default' => true,
		]);

		// Country flag next to each author name.
		$this->addOption('showFlags', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.klausula.option.showFlags.label'),
			'description' => __('plugins.themes.klausula.option.showFlags.description'),
			'options' => [
				['value' => true, 'label' => __('plugins.themes.klausula.option.showFlags.yes')],
				['value' => false, 'label' => __('plugins.themes.klausula.option.showFlags.no')],
			],
			'default' => true,
		]);

		$this->addOption('emblem', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.klausula.option.emblem.label'),
			'description' => __('plugins.themes.klausula.option.emblem.description'),
			'options' => [
				['value' => 'seal', 'label' => __('plugins.themes.klausula.option.emblem.seal')],
				['value' => 'none', 'label' => __('plugins.themes.klausula.option.emblem.none')],
			],
			'default' => 'seal',
		]);

		$this->addOption('coverFrame', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.klausula.option.coverFrame.label'),
			'description' => __('plugins.themes.klausula.option.coverFrame.description'),
			'options' => [
				['value' => 'ruled', 'label' => __('plugins.themes.klausula.option.coverFrame.ruled')],
				['value' => 'plain', 'label' => __('plugins.themes.klausula.option.coverFrame.plain')],
				['value' => 'none', 'label' => __('plugins.themes.klausula.option.coverFrame.none')],
			],
			'default' => 'ruled',
		]);

		$this->addOption('publisherName', 'FieldText', [
			'label' => __('plugins.themes.klausula.option.publisherName.label'),
			'description' => __('plugins.themes.klausula.option.publisherName.description'),
			'default' => '',
		]);

		$this->addOption('publisherUrl', 'FieldText', [
			'label' => __('plugins.themes.klausula.option.publisherUrl.label'),
			'description' => __('plugins.themes.klausula.option.publisherUrl.description'),
			'default' => '',
		]);

		$this->addOption('publisherPhone', 'FieldText', [
			'label' => __('plugins.themes.klausula.option.publisherPhone.label'),
			'description' => __('plugins.themes.klausula.option.publisherPhone.description'),
			'default' => '',
		]);

		// Optional background image blended with the maroon base colour.
		$this->addOption('headerBgImage', 'FieldText', [
			'label' => __('plugins.themes.klausula.option.headerBgImage.label'),
			'description' => __('plugins.themes.klausula.option.headerBgImage.description'),
			'default' => '',
		]);

		$this->addOption('footerBgImage', 'FieldText', [
			'label' => __('plugins.themes.klausula.option.footerBgImage.label'),
			'description' => __('plugins.themes.klausula.option.footerBgImage.description'),
			'default' => '',
		]);
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
		return __('plugins.themes.klausula.name');
	}

	/**
	 * Get the description of this plugin.
	 *
	 * @return string
	 */
	public function getDescription() {
		return __('plugins.themes.klausula.description');
	}

	/**
	 * Get a background-image option as a value safe to embed in a CSS url().
	 *
	 * The option is a free-text field, so it is validated (absolute http(s) URL
	 * or a site-relative path) and stripped of characters that could break out
	 * of the url() token or the surrounding <style> element.
	 *
	 * @param $option string Option name
	 * @return string Sanitized URL, or '' when unset/invalid
	 */
	public function getBackgroundImageUrl($option) {
		$url = trim((string) $this->getOption($option));
		if ($url === '') {
			return '';
		}

		// Allow absolute http(s) URLs and root-relative paths only.
		if (!preg_match('#^(https?:)?//#i', $url) && strpos($url, '/') !== 0) {
			return '';
		}

		return str_replace(
			["'", '"', '(', ')', '<', '>', '\\', ';', '{', '}', "\r", "\n"],
			'',
			$url
		);
	}

	/**
	 * Get the total abstract views and file downloads for an article.
	 *
	 * Core's $article->getViews() and ArticleGalley::getViews() helpers route
	 * through Application::getMetrics(), which rebuilds the statistics report
	 * context on every call (~40ms each). Rendering a 25-article list therefore
	 * added several seconds to the request. The report plugins merely delegate
	 * to MetricsDAO, so we query it directly and memoize per request.
	 *
	 * Abstract views are recorded against the submission (ASSOC_TYPE_SUBMISSION)
	 * and downloads against each galley's file (ASSOC_TYPE_SUBMISSION_FILE).
	 * Every metrics row also carries the submission id, so both can be summed
	 * in a single grouped query. Supplementary ("counter other") file downloads
	 * are intentionally excluded so the total matches the per-galley counts.
	 *
	 * @param $article Submission
	 * @return array ['views' => int, 'downloads' => int]
	 */
	public function getArticleStats($article) {
		$submissionId = (int) $article->getId();
		if (isset($this->_articleStatsMemo[$submissionId])) {
			return $this->_articleStatsMemo[$submissionId];
		}

		$stats = ['views' => 0, 'downloads' => 0];
		$metricType = $this->_getMetricType($article->getData('contextId'));
		if ($metricType) {
			$metricsDao = DAORegistry::getDAO('MetricsDAO'); /* @var $metricsDao MetricsDAO */
			$rows = $metricsDao->getMetrics(
				$metricType,
				[STATISTICS_DIMENSION_ASSOC_TYPE],
				[
					STATISTICS_DIMENSION_CONTEXT_ID => (int) $article->getData('contextId'),
					STATISTICS_DIMENSION_SUBMISSION_ID => $submissionId,
					STATISTICS_DIMENSION_ASSOC_TYPE => [ASSOC_TYPE_SUBMISSION, ASSOC_TYPE_SUBMISSION_FILE],
				]
			);
			foreach ((array) $rows as $row) {
				if ((int) $row[STATISTICS_DIMENSION_ASSOC_TYPE] === ASSOC_TYPE_SUBMISSION) {
					$stats['views'] = (int) $row[STATISTICS_METRIC];
				} elseif ((int) $row[STATISTICS_DIMENSION_ASSOC_TYPE] === ASSOC_TYPE_SUBMISSION_FILE) {
					$stats['downloads'] = (int) $row[STATISTICS_METRIC];
				}
			}
		}

		return $this->_articleStatsMemo[$submissionId] = $stats;
	}

	/**
	 * Resolve the default metric type for a context, memoized per request.
	 *
	 * @param $contextId int
	 * @return string|null
	 */
	private function _getMetricType($contextId) {
		if ($this->_metricType !== false) {
			return $this->_metricType;
		}

		$this->_metricType = null;
		$contextDao = Application::getContextDAO();
		$context = $contextDao->getById((int) $contextId);
		if ($context) {
			$this->_metricType = $context->getDefaultMetricType();
		}

		return $this->_metricType;
	}
}
