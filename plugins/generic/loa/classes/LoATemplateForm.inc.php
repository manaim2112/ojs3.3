<?php

import('lib.pkp.classes.form.Form');

class LoATemplateForm extends Form {

	var $_contextId;
	var $_plugin;
	var $_templateId;

	function __construct($plugin, $contextId, $templateId = null) {
		$this->_contextId = $contextId;
		$this->_plugin = $plugin;
		$this->_templateId = $templateId;

		parent::__construct($plugin->getTemplateResource('loaTemplateForm.tpl'));

		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidatorCSRF($this));
		$this->addCheck(new FormValidator($this, 'templateName', FORM_VALIDATOR_REQUIRED_VALUE, 'plugins.generic.loa.templateNameRequired'));

		$request = Application::get()->getRequest();
		$dispatcher = $request->getDispatcher();
		$context = $request->getContext();
		$saveUrl = $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'templateForm', $templateId ? [$templateId] : null);

		$this->setData('templateId', $templateId);
		$this->setData('saveUrl', $saveUrl);
		$this->setData('availableTokens', [
			'[[article_title]]' => 'plugins.generic.loa.tokenArticleTitle',
			'[[authors]]' => 'plugins.generic.loa.tokenAuthors',
			'[[journal_name]]' => 'plugins.generic.loa.tokenJournalName',
			'[[e_issn]]' => 'plugins.generic.loa.tokenEIssn',
			'[[p_issn]]' => 'plugins.generic.loa.tokenPIssn',
			'[[unique_code]]' => 'plugins.generic.loa.tokenUniqueCode',
			'[[date_generated]]' => 'plugins.generic.loa.tokenDateGenerated',
			'[[status]]' => 'plugins.generic.loa.tokenStatus',
			'[[editor_in_chief_name]]' => 'plugins.generic.loa.tokenEditorInChiefName',
			'[[editor_in_chief_title]]' => 'plugins.generic.loa.tokenEditorInChiefTitle',
			'[[base_url]]' => 'plugins.generic.loa.tokenBaseUrl',
			'[[current_locale]]' => 'plugins.generic.loa.tokenCurrentLocale',
			'[[validation_url]]' => 'plugins.generic.loa.tokenValidationUrl',
			'[[qr_code]]' => 'plugins.generic.loa.tokenQrCode',
		]);
	}

	function initData() {
		if ($this->_templateId) {
			$templateDao = DAORegistry::getDAO('LoATemplateDAO');
			$template = $templateDao->getById($this->_templateId);
			if ($template && $template->getJournalId() == $this->_contextId) {
				$this->_data = [
					'templateId' => $template->getTemplateId(),
					'templateName' => $template->getTemplateName(),
					'templateContent' => $template->getTemplateContent(),
					'isActive' => $template->getIsActive(),
				];
			}
		}
	}

	function readInputData() {
		$this->readUserVars([
			'templateName',
			'templateContent',
			'isActive',
		]);
	}

	function execute(...$functionArgs) {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$templateDao = DAORegistry::getDAO('LoATemplateDAO');
		if ($this->_templateId) {
			$template = $templateDao->getById($this->_templateId);
			if (!$template || $template->getJournalId() != $contextId) {
				return;
			}
		} else {
			$template = $templateDao->newDataObject();
		}

		$template->setJournalId($contextId);
		$template->setTemplateName($this->getData('templateName'));
		$template->setTemplateContent($plugin->sanitizeHtml($this->getData('templateContent')));
		$template->setDateModified(date('Y-m-d H:i:s'));

		if ($this->_templateId) {
			$templateDao->updateObject($template);
		} else {
			$templateDao->insertObject($template);
		}

		if ($this->getData('isActive')) {
			$templateDao->activate($template->getTemplateId(), $contextId);
		} elseif ($this->_templateId) {
			$templateDao->deactivateById($template->getTemplateId(), $contextId);
		}

		parent::execute(...$functionArgs);
	}
}
