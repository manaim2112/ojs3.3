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
		$this->addCheck(new FormValidator($this, 'editorInChiefName', 'optional', 'plugins.generic.loa.editorInChiefName'));
	}

	function initData() {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$this->_data = [
			'editorInChiefName' => $plugin->getSetting($contextId, 'editorInChiefName'),
			'editorInChiefTitle' => $plugin->getSetting($contextId, 'editorInChiefTitle'),
			'signatureImage' => $plugin->getSetting($contextId, 'signatureImage'),
			'stampImage' => $plugin->getSetting($contextId, 'stampImage'),
		];
	}

	function fetch($request, $template = null, $display = false) {
		$templateMgr = TemplateManager::getManager($request);
		$templateMgr->assign('baseUrl', $request->getBaseUrl());
		return parent::fetch($request, $template, $display);
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

		$request = Application::get()->getRequest();
		$user = $request->getUser();

		$this->_handleFileUpload('signatureImage', $user->getId(), $plugin, $contextId);
		$this->_handleFileUpload('stampImage', $user->getId(), $plugin, $contextId);

		parent::execute(...$functionArgs);
	}

	function _handleFileUpload($settingName, $userId, $plugin, $contextId) {
		if (empty($_FILES[$settingName]['name'])) {
			return;
		}

		import('lib.pkp.classes.file.FileManager');
		$fileManager = new FileManager();

		$oldFile = $plugin->getSetting($contextId, $settingName);
		if ($oldFile) {
			$oldPath = realpath(dirname(__FILE__) . '/../../..') . '/' . $oldFile;
			if (file_exists($oldPath)) {
				$fileManager->deleteByPath($oldPath);
			}
		}

		$fileExtension = strtolower(pathinfo($_FILES[$settingName]['name'], PATHINFO_EXTENSION));
		if (!in_array($fileExtension, ['jpg', 'jpeg', 'png', 'gif', 'webp'])) {
			return;
		}

		$newFileName = $settingName . '_' . $contextId . '_' . time() . '.' . $fileExtension;
		$pluginDir = $plugin->getPluginPath() . '/images';
		$basePath = realpath(dirname(__FILE__) . '/../../..') . '/';
		$fullDir = $basePath . $pluginDir;
		if (!file_exists($fullDir)) {
			mkdir($fullDir, 0777, true);
		}

		$destPath = $fullDir . '/' . $newFileName;
		if (move_uploaded_file($_FILES[$settingName]['tmp_name'], $destPath)) {
			$plugin->updateSetting($contextId, $settingName, $pluginDir . '/' . $newFileName, 'string');
		}
	}
}
