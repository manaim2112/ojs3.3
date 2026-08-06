<?php

import('lib.pkp.classes.form.Form');

class LoASecurityForm extends Form {

	var $_contextId;
	var $_plugin;

	function __construct($plugin, $contextId) {
		$this->_contextId = $contextId;
		$this->_plugin = $plugin;

		parent::__construct($plugin->getTemplateResource('loaSecurityForm.tpl'));

		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidatorCSRF($this));

		$this->setData('pluginName', $plugin->getName());
	}

	function initData() {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$this->_data = [
			'loaSecurityEnabled' => (bool) $plugin->getSetting($contextId, 'loaSecurityEnabled'),
			'loaSecurityTitle' => $plugin->getSetting($contextId, 'loaSecurityTitle'),
			'loaSecurityContent' => $plugin->getSetting($contextId, 'loaSecurityContent'),
		];
	}

	function readInputData() {
		$this->readUserVars([
			'loaSecurityEnabled',
			'loaSecurityTitle',
			'loaSecurityContent',
		]);
	}

	function fetch($request, $template = null, $display = false) {
		$templateMgr = TemplateManager::getManager($request);
		$templateMgr->assign([
			'pluginName' => $this->_plugin->getName(),
			'loaSecurityEnabled' => $this->getData('loaSecurityEnabled'),
			'loaSecurityTitle' => $this->getData('loaSecurityTitle'),
			'loaSecurityContent' => $this->getData('loaSecurityContent'),
		]);
		return parent::fetch($request, $template, $display);
	}

	function execute(...$functionArgs) {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$plugin->updateSetting($contextId, 'loaSecurityEnabled', (bool)$this->getData('loaSecurityEnabled'), 'bool');
		$plugin->updateSetting($contextId, 'loaSecurityTitle', $this->getData('loaSecurityTitle'), 'string');
		$plugin->updateSetting($contextId, 'loaSecurityContent', $plugin->sanitizeHtml($this->getData('loaSecurityContent')), 'string');

		parent::execute(...$functionArgs);
	}
}
