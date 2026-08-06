<?php

class LoATemplate extends DataObject {

	public function getTemplateId() {
		return $this->getData('templateId');
	}

	public function setTemplateId($templateId) {
		$this->setData('templateId', $templateId);
	}

	public function getJournalId() {
		return $this->getData('journalId');
	}

	public function setJournalId($journalId) {
		$this->setData('journalId', $journalId);
	}

	public function getTemplateName() {
		return $this->getData('templateName');
	}

	public function setTemplateName($templateName) {
		$this->setData('templateName', $templateName);
	}

	public function getTemplateContent() {
		return $this->getData('templateContent');
	}

	public function setTemplateContent($templateContent) {
		$this->setData('templateContent', $templateContent);
	}

	public function getIsActive() {
		return $this->getData('isActive');
	}

	public function setIsActive($isActive) {
		$this->setData('isActive', $isActive);
	}

	public function getDateModified() {
		return $this->getData('dateModified');
	}

	public function setDateModified($dateModified) {
		$this->setData('dateModified', $dateModified);
	}
}
