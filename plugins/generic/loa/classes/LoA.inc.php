<?php

class LoA extends DataObject {

	public function getLoaId() {
		return $this->getData('loaId');
	}

	public function setLoaId($loaId) {
		$this->setData('loaId', $loaId);
	}

	public function getJournalId() {
		return $this->getData('journalId');
	}

	public function setJournalId($journalId) {
		$this->setData('journalId', $journalId);
	}

	public function getSubmissionId() {
		return $this->getData('submissionId');
	}

	public function setSubmissionId($submissionId) {
		$this->setData('submissionId', $submissionId);
	}

	public function getUniqueCode() {
		return $this->getData('uniqueCode');
	}

	public function setUniqueCode($uniqueCode) {
		$this->setData('uniqueCode', $uniqueCode);
	}

	public function getDateGenerated() {
		return $this->getData('dateGenerated');
	}

	public function setDateGenerated($dateGenerated) {
		$this->setData('dateGenerated', $dateGenerated);
	}

	public function getDateDownloaded() {
		return $this->getData('dateDownloaded');
	}

	public function setDateDownloaded($dateDownloaded) {
		$this->setData('dateDownloaded', $dateDownloaded);
	}

	public function getStatus() {
		return $this->getData('status');
	}

	public function setStatus($status) {
		$this->setData('status', $status);
	}

	public function getGeneratedBy() {
		return $this->getData('generatedBy');
	}

	public function setGeneratedBy($generatedBy) {
		$this->setData('generatedBy', $generatedBy);
	}

	public function getTemplateId() {
		return $this->getData('templateId');
	}

	public function setTemplateId($templateId) {
		$this->setData('templateId', $templateId);
	}

	public function getContentSnapshot() {
		return $this->getData('contentSnapshot');
	}

	public function setContentSnapshot($contentSnapshot) {
		$this->setData('contentSnapshot', $contentSnapshot);
	}
}
