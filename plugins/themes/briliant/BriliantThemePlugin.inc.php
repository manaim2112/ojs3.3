<?php
import('lib.pkp.classes.plugins.ThemePlugin');
class BriliantThemePlugin extends ThemePlugin {

	public function init() {
		AppLocale::requireComponents(LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_APP_MANAGER);

		// Theme variant
		$this->addOption('themeVariant', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.briliant.option.variant.label'),
			'description' => __('plugins.themes.briliant.option.variant.description'),
			'options' => [
				['value' => 'default', 'label' => __('plugins.themes.briliant.option.variant.default')],
				['value' => 'sport', 'label' => __('plugins.themes.briliant.option.variant.sport')],
				['value' => 'biology', 'label' => __('plugins.themes.briliant.option.variant.biology')],
				['value' => 'plant', 'label' => __('plugins.themes.briliant.option.variant.plant')],
				['value' => 'psychic', 'label' => __('plugins.themes.briliant.option.variant.psychic')],
			],
			'default' => 'default',
		]);

		// Font choice
		$this->addOption('typography', 'FieldOptions', [
			'type' => 'radio',
			'label' => __('plugins.themes.briliant.option.typography.label'),
			'description' => __('plugins.themes.briliant.option.typography.description'),
			'options' => [
				['value' => 'inter', 'label' => __('plugins.themes.briliant.option.typography.inter')],
				['value' => 'dmSans', 'label' => __('plugins.themes.briliant.option.typography.dmSans')],
				['value' => 'jakarta', 'label' => __('plugins.themes.briliant.option.typography.jakarta')],
				['value' => 'notoSans', 'label' => __('plugins.themes.briliant.option.typography.notoSans')],
				['value' => 'geist', 'label' => __('plugins.themes.briliant.option.typography.geist')],
			],
			'default' => 'inter',
		]);

		$this->addOption('statCounter_project_id', 'FieldText', [
			'label' => 'StatCounter Project ID',
			'description' => 'pada saat instalasi di statcounter, nanti ada project id nya, eg : 13121706'
		]);
		$this->addOption('statCounter_security_id', 'FieldText', [
			'label' => 'StatCounter Security ID',
			'description' => 'pada saat instalasi di statcounter, nanti ada Security id nya, eg : 13121706'
		]);

		$this->addOption('baseColour', 'FieldColor', [
			'label' => __('plugins.themes.briliant.option.colour.label'),
			'description' => __('plugins.themes.briliant.option.colour.description'),
			'default' => '#1E6292',
		]);

		$this->addStyle('stylesheet', 'styles/index.less');

		$additionalLessVariables = [];

		// Theme variant
		$variant = $this->getOption('themeVariant');
		if ($variant && $variant !== 'default') {
			$additionalLessVariables[] = '@theme-variant: ' . $variant . ';';
			switch ($variant) {
				case 'sport':
					$additionalLessVariables[] = '@bg-base: #D4380D;';
					$additionalLessVariables[] = '@primary: #B22222;';
					$additionalLessVariables[] = '@accent: #FF8C00;';
					break;
				case 'biology':
					$additionalLessVariables[] = '@bg-base: #2E7D32;';
					$additionalLessVariables[] = '@primary: #1B5E20;';
					$additionalLessVariables[] = '@accent: #00BFA5;';
					break;
				case 'plant':
					$additionalLessVariables[] = '@bg-base: #4CAF50;';
					$additionalLessVariables[] = '@primary: #388E3C;';
					$additionalLessVariables[] = '@accent: #FF6F00;';
					break;
				case 'psychic':
					$additionalLessVariables[] = '@bg-base: #7B1FA2;';
					$additionalLessVariables[] = '@primary: #6A1B9A;';
					$additionalLessVariables[] = '@accent: #E040FB;';
					break;
			}
			$additionalLessVariables[] = '@text-bg-base: #ffffff;';
		}

		// Typography
		$font = $this->getOption('typography');
		switch ($font) {
			case 'dmSans':
				$additionalLessVariables[] = '@font: "DM Sans", sans-serif;';
				$additionalLessVariables[] = '@font-heading: "DM Sans", sans-serif;';
				break;
			case 'jakarta':
				$additionalLessVariables[] = '@font: "Plus Jakarta Sans", sans-serif;';
				$additionalLessVariables[] = '@font-heading: "Plus Jakarta Sans", sans-serif;';
				break;
			case 'geist':
				$additionalLessVariables[] = '@font: "Geist", -apple-system, sans-serif;';
				$additionalLessVariables[] = '@font-heading: "Geist", -apple-system, sans-serif;';
				break;
			case 'notoSans':
				$additionalLessVariables[] = '@font: "Noto Sans", sans-serif;';
				break;
			default: // inter
				$additionalLessVariables[] = '@font: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;';
				$additionalLessVariables[] = '@font-heading: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;';
				break;
		}

		$baseColour = $this->getOption('baseColour');
		if ($baseColour && $baseColour !== '#1E6292') {
			if (!preg_match('/^#[0-9a-fA-F]{1,6}$/', $baseColour)) $baseColour = '#1E6292';
			$additionalLessVariables[] = '@bg-base:' . $baseColour . ';';
			if (!$this->isColourDark($baseColour)) {
				$additionalLessVariables[] = '@text-bg-base:rgba(0,0,0,0.84);';
				$additionalLessVariables[] = '@bg-base-border-color:rgba(0,0,0,0.2);';
			}
		}

		if (!empty($additionalLessVariables)) {
			$this->modifyStyle('stylesheet', ['addLessVariables' => implode("\n", $additionalLessVariables)]);
		}

		$request = Application::get()->getRequest();

		$this->addStyle(
			'fontAwesome',
			$request->getBaseUrl() . '/lib/pkp/styles/fontawesome/fontawesome.css',
			['baseUrl' => '']
		);

		$min = Config::getVar('general', 'enable_minified') ? '.min' : '';
		$jquery = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
		$jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';
		$this->addScript('jQuery', $jquery, ['baseUrl' => '']);
		$this->addScript('jQueryUI', $jqueryUI, ['baseUrl' => '']);
		$this->addScript('briliant', 'js/main.js');

		$this->addMenuArea(['primary', 'user']);
	}

	function getDisplayName() {
		return __('plugins.themes.briliant.name');
	}

	function getDescription() {
		return __('plugins.themes.briliant.description');
	}

	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	function getInstallSitePluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}
}
