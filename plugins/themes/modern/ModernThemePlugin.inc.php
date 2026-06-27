<?php

/**
 * @file plugins/themes/modern/ModernThemePlugin.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ModernThemePlugin
 * @ingroup plugins_themes_modern
 *
 * @brief Modern theme — fully colour-customisable.
 */

import('lib.pkp.classes.plugins.ThemePlugin');
import('classes.file.PublicFileManager');

class ModernThemePlugin extends ThemePlugin
{
	/**
	 * Built-in colour presets. Each preset defines the header colour and an
	 * accent colour used for buttons/links. Users can pick a preset OR enable
	 * a custom colour with the "custom" option below.
	 *
	 * @var array
	 */
	protected $colourPresets = [
		'ocean'    => ['label' => 'Ocean Blue (Default)', 'header' => '#1E6292', 'accent' => '#0EA5E9'],
		'midnight' => ['label' => 'Midnight Indigo',      'header' => '#1E1B4B', 'accent' => '#6366F1'],
		'royal'    => ['label' => 'Royal Purple',          'header' => '#581C87', 'accent' => '#A855F7'],
		'rose'     => ['label' => 'Rose Pink',             'header' => '#9F1239', 'accent' => '#F43F5E'],
		'crimson'  => ['label' => 'Crimson Red',           'header' => '#991B1B', 'accent' => '#EF4444'],
		'sunset'   => ['label' => 'Sunset Orange',         'header' => '#9A3412', 'accent' => '#F97316'],
		'amber'    => ['label' => 'Amber Gold',            'header' => '#92400E', 'accent' => '#F59E0B'],
		'gold'     => ['label' => 'Elegant Gold',          'header' => '#854D0E', 'accent' => '#D4AF37'],
		'forest'   => ['label' => 'Forest Green',          'header' => '#14532D', 'accent' => '#10B981'],
		'teal'     => ['label' => 'Tropical Teal',         'header' => '#115E59', 'accent' => '#14B8A6'],
		'slate'    => ['label' => 'Modern Slate',          'header' => '#1F2937', 'accent' => '#3B82F6'],
		'graphite' => ['label' => 'Graphite Dark',         'header' => '#111827', 'accent' => '#FBBF24'],
	];

	/**
	 * @copydoc ThemePlugin::isActive()
	 */
	public function isActive()
	{
		if (defined('SESSION_DISABLE_INIT')) {
			return true;
		}
		return parent::isActive();
	}

	/**
	 * Initialize theme: register options, build LESS variable overrides,
	 * register stylesheets/scripts and other hooks.
	 */
	public function init()
	{
		AppLocale::requireComponents(LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_APP_MANAGER);

		$this->registerOptions();
		$this->registerAssets();
	}

	/**
	 * Theme settings panel options.
	 */
	protected function registerOptions()
	{
		// ---- Analytics ----
		$this->addOption('statCounter_project_id', 'FieldText', [
			'label' => 'StatCounter Project ID',
			'description' => __('plugins.themes.modern.option.statCounter_project_id.description'),
		]);
		$this->addOption('statCounter_security_id', 'FieldText', [
			'label' => 'StatCounter Security ID',
			'description' => __('plugins.themes.modern.option.statCounter_security_id.description'),
		]);

		// ---- Typography ----
		$this->addOption('typography', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.modern.option.typography.label'),
			'description' => __('plugins.themes.modern.option.typography.description'),
			'options' => [
				['value' => 'notoSans',           'label' => __('plugins.themes.modern.option.typography.notoSans')],
				['value' => 'notoSerif',          'label' => __('plugins.themes.modern.option.typography.notoSerif')],
				['value' => 'notoSerif_notoSans', 'label' => __('plugins.themes.modern.option.typography.notoSerif_notoSans')],
				['value' => 'notoSans_notoSerif', 'label' => __('plugins.themes.modern.option.typography.notoSans_notoSerif')],
				['value' => 'lato',               'label' => __('plugins.themes.modern.option.typography.lato')],
				['value' => 'lora',               'label' => __('plugins.themes.modern.option.typography.lora')],
				['value' => 'lora_openSans',      'label' => __('plugins.themes.modern.option.typography.lora_openSans')],
			],
			'default' => 'notoSans',
		]);

		// ---- Colour preset ----
		$presetOptions = [];
		foreach ($this->colourPresets as $value => $preset) {
			$presetOptions[] = ['value' => $value, 'label' => $preset['label']];
		}
		$presetOptions[] = ['value' => 'custom', 'label' => __('plugins.themes.modern.option.colourPreset.custom')];

		$this->addOption('colourPreset', 'FieldOptions', [
			'type'        => 'radio',
			'label'       => __('plugins.themes.modern.option.colour.label'),
			'description' => __('plugins.themes.modern.option.colourPreset.description'),
			'options'     => $presetOptions,
			'default'     => 'ocean',
		]);

		$this->addOption('customHeaderColour', 'FieldColor', [
			'label'       => 'Custom — Header Colour',
			'description' => __('plugins.themes.modern.option.customHeaderColour.description'),
			'default'     => '#1E6292',
		]);

		$this->addOption('customAccentColour', 'FieldColor', [
			'label'       => 'Custom — Accent / Link Colour',
			'description' => __('plugins.themes.modern.option.customAccentColour.description'),
			'default'     => '#0EA5E9',
		]);

		// ---- Header style ----
		$this->addOption('headerStyle', 'FieldOptions', [
			'type'        => 'radio',
			'label'       => 'Header Style',
			'description' => __('plugins.themes.modern.option.headerStyle.description'),
			'options'     => [
				['value' => 'solid',    'label' => __('plugins.themes.modern.option.headerStyle.solid')],
				['value' => 'gradient', 'label' => __('plugins.themes.modern.option.headerStyle.gradient')],
				['value' => 'glass',    'label' => __('plugins.themes.modern.option.headerStyle.glass')],
			],
			'default' => 'gradient',
		]);

		// ---- Border radius / card shape ----
		$this->addOption('borderRadius', 'FieldOptions', [
			'type'        => 'radio',
		'label'       => __('plugins.themes.modern.option.borderRadius.label'),
		'description' => __('plugins.themes.modern.option.borderRadius.description'),
			'options'     => [
			['value' => 'sharp',   'label' => __('plugins.themes.modern.option.borderRadius.sharp')],
			['value' => 'rounded', 'label' => __('plugins.themes.modern.option.borderRadius.rounded')],
			['value' => 'pill',    'label' => __('plugins.themes.modern.option.borderRadius.pill')],
			],
			'default' => 'rounded',
		]);

		// ---- Card style ----
		$this->addOption('cardStyle', 'FieldOptions', [
			'type'        => 'radio',
			'label'       => 'Card Style',
			'description' => __('plugins.themes.modern.option.cardStyle.description'),
			'options'     => [
			['value' => 'flat',     'label' => __('plugins.themes.modern.option.cardStyle.flat')],
			['value' => 'soft',     'label' => __('plugins.themes.modern.option.cardStyle.soft')],
			['value' => 'elevated', 'label' => __('plugins.themes.modern.option.cardStyle.elevated')],
			],
			'default' => 'soft',
		]);

		// ---- Layout toggles ----
		$this->addOption('showDescriptionInJournalIndex', 'FieldOptions', [
			'label'   => __('manager.setup.contextSummary'),
			'options' => [
				['value' => true, 'label' => __('plugins.themes.modern.option.showDescriptionInJournalIndex.option')],
			],
			'default' => false,
		]);

		$this->addOption('useHomepageImageAsHeader', 'FieldOptions', [
			'label'       => __('plugins.themes.modern.option.useHomepageImageAsHeader.label'),
			'description' => __('plugins.themes.modern.option.useHomepageImageAsHeader.description'),
			'options'     => [
				['value' => true, 'label' => __('plugins.themes.modern.option.useHomepageImageAsHeader.option')],
			],
			'default' => false,
		]);

		// ---- Background image URL ----
		$this->addOption('backgroundImageUrl', 'FieldText', [
			'label'       => __('plugins.themes.modern.option.backgroundImageUrl.label'),
			'description' => __('plugins.themes.modern.option.backgroundImageUrl.description'),
		]);

		// ---- Popular articles slide ----
		$this->addOption('showPopularArticles', 'FieldOptions', [
			'label'   => 'Popular Articles Slide',
			'description' => 'Tampilkan 5 artikel terpopuler dalam bentuk slide di bawah header.',
			'options' => [
				['value' => true, 'label' => 'Tampilkan popular articles slide'],
			],
			'default' => false,
		]);
	}

	/**
	 * Register stylesheets, scripts, fonts, and dynamic LESS variables.
	 */
	protected function registerAssets()
	{
		$request = Application::get()->getRequest();

		// 1) Primary stylesheet (compiled by OJS LESS engine).
		$this->addStyle('stylesheet', 'styles/index.less');

		// 2) Modern enhancements layered on top — kept in a separate file so we
		// don't fight with the original variables/index file.
		$this->addStyle('modern-enhancements', 'styles/enhancements.less');

		// 3) Font selection.
		$this->registerFont();

		// 4) Build LESS variable overrides from theme options and inject them.
		$lessVars = $this->buildLessVariables();
		if (!empty($lessVars)) {
			$this->modifyStyle('stylesheet', ['addLessVariables' => implode("\n", $lessVars)]);
			$this->modifyStyle('modern-enhancements', ['addLessVariables' => implode("\n", $lessVars)]);
		}

		// 5) Inline CSS for header background image (optional homepage image).
		$this->registerHomepageImageBackground($request);

		// 5b) Inline CSS for custom background image URL.
		$this->registerBackgroundImageUrl();

		// 6) FontAwesome from PKP shared assets.
		$this->addStyle(
			'fontAwesome',
			$request->getBaseUrl() . '/lib/pkp/styles/fontawesome/fontawesome.css',
			['baseUrl' => '']
		);

		// 7) jQuery (and jQuery UI) — needed by Bootstrap dropdown.
		$min      = Config::getVar('general', 'enable_minified') ? '.min' : '';
		$jquery   = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
		$jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';
		$this->addScript('jQuery', $jquery, ['baseUrl' => '']);
		$this->addScript('jQueryUI', $jqueryUI, ['baseUrl' => '']);

		// 8) Bootstrap dropdowns + theme JS.
		$this->addScript('popper', 'js/lib/popper/popper.js');
		$this->addScript('bsUtil', 'js/lib/bootstrap/util.js');
		$this->addScript('bsDropdown', 'js/lib/bootstrap/dropdown.js');
		$this->addScript('default', 'js/main.js');

		// 9) Menu areas exposed to the navigation manager.
		$this->addMenuArea(['primary', 'user']);

		// 10) Register Smarty function for popular articles
		$smarty = TemplateManager::getManager($request);
		try {
			$smarty->registerPlugin('function', 'modern_popular_articles', [$this, 'smartyPopularArticles']);
		} catch (Exception $e) {
			error_log('ModernTheme: popular articles registration skipped: ' . $e->getMessage());
		}
	}

	/**
	 * Register the typography font file based on selected option.
	 */
	protected function registerFont()
	{
		$typography = $this->getOption('typography');

		switch ($typography) {
			case 'notoSerif':
				$this->addStyle('font', 'styles/fonts/notoSerif.less');
				break;
			case 'notoSerif_notoSans':
			case 'notoSans_notoSerif':
				$this->addStyle('font', 'styles/fonts/notoSans_notoSerif.less');
				break;
			case 'lato':
				$this->addStyle('font', 'styles/fonts/lato.less');
				break;
			case 'lora':
				$this->addStyle('font', 'styles/fonts/lora.less');
				break;
			case 'lora_openSans':
				$this->addStyle('font', 'styles/fonts/lora_openSans.less');
				break;
			case 'notoSans':
			default:
				$this->addStyle('font', 'styles/fonts/notoSans.less');
				break;
		}
	}

	/**
	 * Build a list of LESS variables based on theme options. These are injected
	 * BEFORE the theme stylesheet is compiled, overriding the defaults defined
	 * in styles/variables.less.
	 *
	 * @return array<string>
	 */
	protected function buildLessVariables()
	{
		$vars = [];

		// ---- Resolve colours ----
		[$header, $accent] = $this->resolveColours();

		// Always emit so the user-chosen colour wins over variables.less.
		$vars[] = '@bg-base: ' . $header . ';';
		$vars[] = '@primary: ' . $accent . ';';

		// Auto-adjust readable text colour based on header brightness.
		if (!$this->isColourDark($header)) {
			$vars[] = '@text-bg-base: rgba(0, 0, 0, 0.84);';
			$vars[] = '@bg-base-border-color: rgba(0, 0, 0, 0.18);';
		} else {
			$vars[] = '@text-bg-base: #ffffff;';
			$vars[] = '@bg-base-border-color: rgba(255, 255, 255, 0.14);';
		}

		// Expose secondary tokens for the enhancements stylesheet. We use
		// numeric flags rather than strings so LESS guards always evaluate
		// reliably across less.php versions.
		$headerStyle = $this->getOption('headerStyle') ?: 'gradient';
		$cardStyle   = $this->getOption('cardStyle')   ?: 'soft';

		$vars[] = '@modern-header-gradient: ' . ($headerStyle === 'gradient' ? '1' : '0') . ';';
		$vars[] = '@modern-header-glass: '    . ($headerStyle === 'glass'    ? '1' : '0') . ';';
		$vars[] = '@modern-card-flat: '       . ($cardStyle   === 'flat'     ? '1' : '0') . ';';
		$vars[] = '@modern-card-elevated: '   . ($cardStyle   === 'elevated' ? '1' : '0') . ';';

		// ---- Border radius ----
		$radiusMap = ['sharp' => '2px', 'rounded' => '8px', 'pill' => '16px'];
		$radius = $radiusMap[$this->getOption('borderRadius')] ?? '8px';
		$vars[] = '@border-radius: ' . $radius . ';';
		$vars[] = '@radius: '        . $radius . ';';

		return $vars;
	}

	/**
	 * Resolve the header + accent colour from preset / custom selection.
	 *
	 * @return array{0:string,1:string} [headerColour, accentColour]
	 */
	protected function resolveColours()
	{
		$preset = $this->getOption('colourPreset') ?: 'ocean';

		if ($preset === 'custom') {
			$header = $this->sanitizeHexColour($this->getOption('customHeaderColour') ?: '#1E6292');
			$accent = $this->sanitizeHexColour($this->getOption('customAccentColour') ?: '#0EA5E9');
		} elseif (isset($this->colourPresets[$preset])) {
			$header = $this->colourPresets[$preset]['header'];
			$accent = $this->colourPresets[$preset]['accent'];
		} else {
			// Fallback to default ocean
			$header = $this->colourPresets['ocean']['header'];
			$accent = $this->colourPresets['ocean']['accent'];
		}

		return [$header, $accent];
	}

	/**
	 * Validate a hex colour and fall back to a safe value when malformed.
	 * Prevents any user-supplied string from being injected into LESS verbatim.
	 *
	 * @param string $value
	 * @return string A 7-character #RRGGBB string.
	 */
	protected function sanitizeHexColour($value)
	{
		$value = trim((string) $value);
		if (preg_match('/^#([A-Fa-f0-9]{6})$/', $value)) {
			return $value;
		}
		if (preg_match('/^#([A-Fa-f0-9]{3})$/', $value, $m)) {
			$h = $m[1];
			return '#' . $h[0] . $h[0] . $h[1] . $h[1] . $h[2] . $h[2];
		}
		return '#1E6292';
	}

	/**
	 * Output an inline rule applying the current journal homepage image as a
	 * background for the header. Matches the original behaviour.
	 */
	protected function registerHomepageImageBackground($request)
	{
		if (!$this->getOption('useHomepageImageAsHeader')) {
			return;
		}
		$context = $request->getContext();
		if (!$context) {
			return;
		}
		$homepageImage = $context->getLocalizedData('homepageImage');
		if (!is_array($homepageImage) || empty($homepageImage['uploadName'])) {
			return;
		}

		$publicFileManager = new PublicFileManager();
		$publicFilesDir = $request->getBaseUrl() . '/' . $publicFileManager->getContextFilesPath($context->getId());
		$homepageImageUrl = $publicFilesDir . '/' . rawurlencode($homepageImage['uploadName']);

		$this->addStyle(
			'homepageImage',
			'.pkp_structure_head{background-image:linear-gradient(180deg,rgba(0,0,0,0.55),rgba(0,0,0,0.65)),url("' . $homepageImageUrl . '");background-size:cover;background-position:center;}',
			['inline' => true]
		);
	}

	/**
	 * Output an inline rule applying a custom background image URL to the page.
	 */
	protected function registerBackgroundImageUrl()
	{
		$bgUrl = $this->getOption('backgroundImageUrl');
		if (empty($bgUrl)) {
			return;
		}

		$bgUrl = trim($bgUrl);
		if (!filter_var($bgUrl, FILTER_VALIDATE_URL)) {
			return;
		}

		$css = '.page_index_journal{background-image:url("' . $bgUrl . '");background-size:cover;background-position:center;background-attachment:fixed;background-repeat:no-repeat;}';
		$css .= '.page_index_journal .current_issue,.page_index_journal .homepage_about,.page_index_journal .cmp_announcements,.page_index_journal .additional_content{background:rgba(255,255,255,0.75);backdrop-filter:blur(6px);-webkit-backdrop-filter:blur(6px);border-radius:16px;padding:2rem;margin-bottom:2rem;}';

		$this->addStyle(
			'backgroundImageUrl',
			$css,
			['inline' => true]
		);
	}

	/**
	 * Smarty function: fetch top 5 most-viewed published articles in current journal.
	 * Usage in template: {modern_popular_articles}
	 * Returns HTML for a horizontal slide.
	 */
	public function smartyPopularArticles($params, $smarty)
	{
		try {
			$request = Application::get()->getRequest();
			$context = $request->getContext();
			if (!$context) {
				return '';
			}
			$contextId = (int) $context->getId();

			$submissionDao = DAORegistry::getDAO('SubmissionDAO');

			$result = $submissionDao->retrieve(
				'SELECT submission_id, SUM(metric) AS total_metric
				 FROM metrics
				 WHERE context_id = ? AND submission_id IS NOT NULL AND metric_type = ?
				 GROUP BY submission_id
				 ORDER BY total_metric DESC
				 LIMIT 5',
				[$contextId, METRIC_TYPE_COUNTER]
			);

			$articles = [];
			foreach ($result as $row) {
				$submissionId = (int) $row->submission_id;
				if (!$submissionId) {
					continue;
				}
				$submission = $submissionDao->getById($submissionId);
				if (!$submission) {
					continue;
				}
				$publication = $submission->getCurrentPublication();
				if (!$publication) {
					continue;
				}
				$title = $publication->getLocalizedTitle();
				if (empty($title)) {
					continue;
				}
				$articles[] = [
					'id'       => $submissionId,
					'title'    => $title,
					'authors'  => $submission->getAuthorString(),
					'url'      => $request->getDispatcher()->url($request, ROUTE_PAGE, $context->getPath(), 'article', 'view', $submissionId),
					'views'    => (int) $row->total_metric,
					'coverUrl' => $this->_getArticleCover($publication, $contextId),
				];
			}

			if (empty($articles)) {
				return '';
			}

			$smarty->assign('popularArticles', $articles);
			return $smarty->fetch($this->getTemplateResource('frontend/components/popularArticlesSlide.tpl'));
		} catch (Exception $e) {
			error_log('ModernTheme: smartyPopularArticles error: ' . $e->getMessage());
			return '';
		}
	}

	/**
	 * Helper: get article cover URL if available.
	 */
	protected function _getArticleCover($publication, $contextId)
	{
		return $publication->getLocalizedCoverImageUrl($contextId);
	}

	/**
	 * @return string
	 */
	function getContextSpecificPluginSettingsFile()
	{
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * @return string
	 */
	function getInstallSitePluginSettingsFile()
	{
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * @return string
	 */
	function getDisplayName()
	{
		return __('plugins.themes.modern.name');
	}

	/**
	 * @return string
	 */
	function getDescription()
	{
		return __('plugins.themes.modern.description');
	}
}
