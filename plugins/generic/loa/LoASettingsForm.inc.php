<?php

import('lib.pkp.classes.form.Form');

class LoASettingsForm extends Form {

	var $_contextId;
	var $_plugin;

	function __construct($plugin, $contextId) {
		$this->_contextId = $contextId;
		$this->_plugin = $plugin;

		parent::__construct($plugin->getTemplateResource('settingsForm.tpl'));

		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidatorCSRF($this));

		$this->setData('pluginName', $plugin->getName());
	}

	function initData() {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$this->_data = [
			'editorInChiefName' => $plugin->getSetting($contextId, 'editorInChiefName'),
			'editorInChiefTitle' => $plugin->getSetting($contextId, 'editorInChiefTitle'),
		];
	}

	function readInputData() {
		$this->readUserVars([
			'editorInChiefName',
			'editorInChiefTitle',
		]);
	}

	function execute(...$functionArgs) {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$plugin->updateSetting($contextId, 'editorInChiefName', $this->getData('editorInChiefName'), 'string');
		$plugin->updateSetting($contextId, 'editorInChiefTitle', $this->getData('editorInChiefTitle'), 'string');

		parent::execute(...$functionArgs);
	}
}
