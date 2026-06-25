<?php

/**
 * @file plugins/themes/default/DefaultThemePlugin.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class DefaultThemePlugin
 * @ingroup plugins_themes_default
 *
 * @brief Default theme
 */

import('lib.pkp.classes.plugins.ThemePlugin');
import('plugins.themes.dimension.CitationScholarPlugin');


class DimensionThemePlugin extends ThemePlugin {
	/**
	 * @copydoc ThemePlugin::isActive()
	 */
	public function isActive() {
		if (defined('SESSION_DISABLE_INIT')) return true;
		return parent::isActive();
	}

	/**
	 * Initialize the theme's styles, scripts and hooks. This is run on the
	 * currently active theme and it's parent themes.
	 *
	 * @return null
	 */
	public function init() {
		AppLocale::requireComponents(LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_APP_MANAGER);
		
			$this->addOption('index_dimension_url', 'FieldText', [
			'label' => 'Dimension URL',
			'description' => "Please type Dimension URL, eg : https://app.dimensions.ai/discover/publication?search_mode=content&and_facet_source_title=jour.1460704",
		]);
		$this->addOption('index_garuda_url', 'FieldText', [
			'label' => 'Garuda URL',
			'description' => "Please type Dimension URL, eg : https://app.dimensions.ai/discover/publication?search_mode=content&and_facet_source_title=jour.1460704",
		]);
		$this->addOption('index_url', 'FieldText', [
			'label' => 'Indexing and Abtraxing URL',
			'description' => "Please type Page Indexing URL",
		]);

		$this->addOption('contributionLink', 'FieldText', [
			'label' => "Contribution Link FIles",
			'description' => "Fill in the Contribution with google Drive or etc",
			'default' => '',
		]);

		$this->addOption('doiPrefix', 'FieldText', [
			'label' => 'DOI Prefix',
			'description' => "Fill in the DOI Prefix",
			'default' => '',
		]);

		$this->addOption('contactPhone', 'FieldText', [
			'label' => 'Contact Phone',
			'description' => "Fill in the Contact Phone, example: 6283833110417",
			'default' => '',
		]);

		$this->addOption('themesSelection', 'FieldOptions', [
			'type' => 'radio',
			'label' => 'Themes Selected',
			'description' => 'Silahkan dipilih tema yang cocok ingin di gunakan',
			'options' => [
				[
					'value' => 'default',
					'label' => 'Default : Tema standart yang full cepat dan responsive',
				],
				[
					'value' => 'college',
					'label' => 'College : Tema yang cocok untuk university',
				],
				[
					'value' => "pendidikan",
					'label' => 'Pendidikan : Tema konsep pendidikan/penelitian'
				],
				[
					'value' => 'poster',
					'label' => 'Poster : cocok bagi anda yang mau memiliki journal type poster',
				]
			],
			'default' => 'default'
		]);

		$this->addOption('useStatisticsGraph', 'FieldOptions', [
			'type' => 'radio',
			'label' => 'Statistics Views ON side LeftBar',
			'description' => 'Statistics Views ON side',
			'options' => [
				[
					'value' => "IYA",
					'label' => 'Tampilkan Download View',
				],
				[
					'value' => "TIDAK",
					'label' => 'JANGAN Tampilkan Download View',
				],
			]
		]);
		// Register theme options
		$this->addOption('typography', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.default.option.typography.label'),
			'description' => __('plugins.themes.default.option.typography.description'),
			'options' => [
				[
					'value' => 'notoSans',
					'label' => __('plugins.themes.default.option.typography.notoSans'),
				],
				[
					'value' => 'notoSerif',
					'label' => __('plugins.themes.default.option.typography.notoSerif'),
				],
				[
					'value' => 'notoSerif_notoSans',
					'label' => __('plugins.themes.default.option.typography.notoSerif_notoSans'),
				],
				[
					'value' => 'notoSans_notoSerif',
					'label' => __('plugins.themes.default.option.typography.notoSans_notoSerif'),
				],
				[
					'value' => 'lato',
					'label' => __('plugins.themes.default.option.typography.lato'),
				],
				[
					'value' => 'lora',
					'label' => __('plugins.themes.default.option.typography.lora'),
				],
				[
					'value' => 'lora_openSans',
					'label' => __('plugins.themes.default.option.typography.lora_openSans'),
				],
			],
			'default' => 'notoSans',
		]);

		$this->addOption('baseColour', 'FieldColor', [
			'label' => __('plugins.themes.default.option.colour.label'),
			'description' => __('plugins.themes.default.option.colour.description'),
			'default' => '#1E6292',
		]);

		$this->addOption('showDescriptionInJournalIndex', 'FieldOptions', [
			'label' => __('manager.setup.contextSummary'),
				'options' => [
				[
					'value' => true,
					'label' => __('plugins.themes.default.option.showDescriptionInJournalIndex.option'),
				],
			],
			'default' => false,
		]);
		$this->addOption('useHomepageImageAsHeader', 'FieldOptions', [
			'label' => __('plugins.themes.default.option.useHomepageImageAsHeader.label'),
			'description' => __('plugins.themes.default.option.useHomepageImageAsHeader.description'),
				'options' => [
				[
					'value' => true,
					'label' => __('plugins.themes.default.option.useHomepageImageAsHeader.option')
				],
			],
			'default' => false,
		]);

		$this->addOption('useShowViewsAndDownload', 'FieldOptions', [
			'label' => "Views and Download Count",
			'description' => "Plugin ini berada di article, terdapat total abstract views, downloads, Google Citation Index",
			'options' => [
				[
					'value' => 1,
					'label' => "Perlihatkan Views, and Download di sidebar dan list article"
				],
			],
			'default' => false,
		]);

		$this->addOption('useGoogleScholarIndex', 'FieldText', [
			'label' => "Google Scholar User ID",
			'description' => "Masukkan ID user di GoogleScholar Account",
			'default' => "",
		]);

		

		// Load primary stylesheet (pre-built Tailwind v4)
		$this->addStyle('reboot', 'styles/reboot.css');

		// Note: main.css is a PostCSS source (not loaded directly — compiled into reboot.css)
		// $this->addStyle('main', 'styles/main.css');

		if ($this->getOption('typography') === 'notoSerif') {
			$this->addStyle('font', 'styles/fonts/notoSerif.css');
		} elseif (strpos($this->getOption('typography'), 'notoSerif') !== false) {
			$this->addStyle('font', 'styles/fonts/notoSans_notoSerif.css');
		} elseif ($this->getOption('typography') == 'lato') {
			$this->addStyle('font', 'styles/fonts/lato.css');
		} elseif ($this->getOption('typography') == 'lora') {
			$this->addStyle('font', 'styles/fonts/lora.css');
		} elseif ($this->getOption('typography') == 'lora_openSans') {
			$this->addStyle('font', 'styles/fonts/lora_openSans.css');
		} else {
			$this->addStyle('font', 'styles/fonts/notoSans.css');
		}

		// Update base colour via inline style
		$baseColour = $this->getOption('baseColour');
		if ($baseColour && $baseColour !== '#1E6292') {
			$this->addStyle('baseColour',
				':root { --dim-base: ' . $baseColour . '; }',
				['inline' => true]
			);
		}

		$request = Application::get()->getRequest();

		// Assign current user for sidebar profile display
		$templateMgr = TemplateManager::getManager($request);
		$currentUser = $request->getUser();
		if ($currentUser) {
			$templateMgr->assign('currentFrontendUser', $currentUser);
		}

		if($this->getOption('useStatisticsGraph') === 'IYA' && $this->getOption('useGoogleScholarIndex')) {
			$URI = $_SERVER['REQUEST_URI'];
			$splitURI = explode("/", $URI);
			// Get the submission that matches the requested urlPath
			if(sizeof($splitURI) === 6 && $splitURI[4] == "view") {
				$stat = new CitationScholarPlugin($splitURI[2], $this->getOption('useGoogleScholarIndex'));
				$data = $stat->data;
				$TemplateManager = TemplateManager::getManager($request);
				$TemplateManager->getTemplateVars('article');
				$TemplateManager->assign([
					'statistic_scholar' => $data
				]);
			}
		}


		// Get homepage image and use as header background if useAsHeader is true
		$context = Application::get()->getRequest()->getContext();
		
		if ($context && $this->getOption('useHomepageImageAsHeader')) {

			$publicFileManager = new PublicFileManager();
			$publicFilesDir = $request->getBaseUrl() . '/' . $publicFileManager->getContextFilesPath($context->getId());

			$homepageImage = $context->getLocalizedData('homepageImage');

            if($homepageImage && array_key_exists("uploadName", $homepageImage)) {
    			$homepageImageUrl = $publicFilesDir . '/' . $homepageImage['uploadName'];
    			
    			$this->addStyle('homepageImage',
				'.pkp_structure_head { background: center / cover no-repeat url("' . $homepageImageUrl . '");}',
				['inline' => true]
			);
            }
			
		
		}

		// // Load jQuery from a CDN or, if CDNs are disabled, from a local copy.
		$min = Config::getVar('general', 'enable_minified') ? '.min' : '';
		$jquery = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
		// $jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';
		// // Use an empty `baseUrl` argument to prevent the theme from looking for
		// // the files within the theme directory

		// $this->addScript('Tailwindcss', "https://cdn.tailwindcss.com");
		$this->addScript('jQuery', $jquery, array('baseUrl' => ''));
		// $this->addScript('jQueryUI', $jqueryUI, array('baseUrl' => ''));

		// // Load Bootsrap's dropdown
		// $this->addScript('popper', 'js/lib/popper/popper.js');
		// $this->addScript('bsUtil', 'js/lib/bootstrap/util.js');
		// $this->addScript('bsDropdown', 'js/lib/bootstrap/dropdown.js');

		// Load custom JavaScript for this theme
		$this->addScript('dimension', 'js/main.js');

		// Add navigation menu areas for this theme
		$this->addMenuArea(array('primary', 'user'));

		HookRegistry::register("Templates::Article::Main", array($this, 'ShowViewAndDownload'));
	}

	public function ShowViewAndDownload($hookName, $params) {
		$smarty =& $params[1];
		$output =& $params[2];
		$output .= $smarty->fetch($this->getTemplateResource('plugins/useShowViewsAndDownload.tpl'));
	}

	// /**
	//  * Get the name of the settings file to be installed on new journal
	//  * creation.
	//  * @return string
	//  */
	// function getContextSpecificPluginSettingsFile() {
	// 	return $this->getPluginPath() . '/settings.xml';
	// }

	// /**
	//  * Get the name of the settings file to be installed site-wide when
	//  * OJS is installed.
	//  * @return string
	//  */
	// function getInstallSitePluginSettingsFile() {
	// 	return $this->getPluginPath() . '/settings.xml';
	// }

	/**
	 * Retrieve the `allDownloads` dataset from the download stats
	 *
	 * @param $pubObjectId int ID of the object to get stats for
	 * @param $stats array Optionally pass in stats that have already been
	 *   fetched from _getDownloadStats().
	 * @return $allDownloadStats array The `allDownloads` dataset
	 */
	function getAllDownloadsStats($pubObjectId, $stats = array()) {

		if (empty($stats)) {
			$stats = $this->_getDownloadStats($pubObjectId);
		}

		$allDownloadStats = array();
		foreach($stats as $dataset) {
			if (array_key_exists('allDownloads', $dataset)) {
				$allDownloadStats = $dataset['allDownloads'];
			}
		}

		return $allDownloadStats;
	}
	/**
	 * Get prepared download statistics from the DB
	 * @param $pubObjectId integer
	 * @return array
	 */
	function _getDownloadStats($pubObjectId) {
		$cache = CacheManager::getManager()->getCache('downloadStats', $pubObjectId, array($this, '_downloadStatsCacheMiss'));
		if (time() - $cache->getCacheTime() > 60 * 60 * 24) {
			// Cache is older than one day, erase it.
			$cache->flush();
		}
		$statsReports = $cache->get($pubObjectId);

		$currentYear = date("Y");
		$months = range(1, 12);
		$statsByFormat = $statsByMonth = $years = array();
		$totalDownloads = 0;
		foreach ($statsReports as $statsReport) {
			$month = (int) substr($statsReport[STATISTICS_DIMENSION_MONTH], -2);
			$year = (int) substr($statsReport[STATISTICS_DIMENSION_MONTH], 0, 4);
			$metric = $statsReport[STATISTICS_METRIC];

			// Keep track of the years, avoiding duplicates.
			$years[$year] = null;

			$representationId = $statsReport[STATISTICS_DIMENSION_REPRESENTATION_ID];

			// Prepare the stats aggregating by Representation.
			// Create entries for all months, so all representations will have the same entries count.
			if (!array_key_exists($representationId, $statsByFormat)) {
				$representationDao = Application::getRepresentationDAO();
				$representation = $representationDao->getById($representationId);
				if (empty($representation)) {
					continue;
				}
				$statsByFormat[$representationId] = array(
					'data' => array(),
					'label' => $representation->getLocalizedName(),
					'total' => 0);
			}

			// Make sure we have entries for all years with stats.
			if (!array_key_exists($year, $statsByFormat[$representationId]['data'])) {
				$statsByFormat[$representationId]['data'][$year] = array_fill_keys($months, 0);
			}
			$statsByFormat[$representationId]['data'][$year][$month] = $metric;
			$statsByFormat[$representationId]['total'] += $metric;

			// Prepare the stats aggregating only by Month.
			if (!array_key_exists($year, $statsByMonth)) {
				$statsByMonth[$year] = array_fill_keys($months, 0);
			}
			$statsByMonth[$year][$month] += $metric;
			$totalDownloads += $metric;
		}

		if ($statsByMonth) {
			$datasetId = 'allDownloads'; // GraphJS works with datasets.
			$statsByMonth = array($datasetId => array(
				'data' => $statsByMonth,
				'label' => __('common.allDownloads'),
				'total' => $totalDownloads
			));
		}

		return array($statsByFormat, $statsByMonth, array_keys($years));
	}

	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return __('plugins.themes.dimension.name');
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return __('plugins.themes.dimension.description');
	}
}
