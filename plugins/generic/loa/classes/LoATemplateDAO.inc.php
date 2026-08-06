<?php

import('lib.pkp.classes.db.DAO');
import('plugins.generic.loa.classes.LoATemplate');

class LoATemplateDAO extends DAO {

	public function getById($templateId) {
		$result = $this->retrieve(
			'SELECT * FROM loa_templates WHERE loa_template_id = ?',
			[(int) $templateId]
		);
		$row = $result->current();
		return $row ? $this->_fromRow((array) $row) : null;
	}

	public function getByJournalId($journalId, $rangeInfo = null) {
		$sql = 'SELECT * FROM loa_templates WHERE journal_id = ? ORDER BY loa_template_id DESC';
		$params = [(int) $journalId];
		$result = $this->retrieveRange($sql, $params, $rangeInfo);
		return new DAOResultFactory($result, $this, '_fromRow', [], $sql, $params, $rangeInfo);
	}

	public function getActiveByJournalId($journalId) {
		$result = $this->retrieve(
			'SELECT * FROM loa_templates WHERE journal_id = ? AND is_active = ? ORDER BY loa_template_id DESC LIMIT 1',
			[(int) $journalId, 1]
		);
		$row = $result->current();
		return $row ? $this->_fromRow((array) $row) : null;
	}

	public function activate($templateId, $journalId) {
		$this->update(
			'UPDATE loa_templates SET is_active = ? WHERE journal_id = ?',
			[0, (int) $journalId]
		);
		$this->update(
			'UPDATE loa_templates SET is_active = ? WHERE loa_template_id = ? AND journal_id = ?',
			[1, (int) $templateId, (int) $journalId]
		);
	}

	public function insertObject($template) {
		$this->update(
			'INSERT INTO loa_templates (journal_id, template_name, template_content, is_active, date_modified)
			 VALUES (?, ?, ?, ?, ?)',
			[
				(int) $template->getJournalId(),
				$template->getTemplateName(),
				$template->getTemplateContent(),
				$template->getIsActive() ? 1 : 0,
				$template->getDateModified(),
			]
		);
		$template->setTemplateId($this->getInsertId());
		return $template;
	}

	public function updateObject($template) {
		$this->update(
			'UPDATE loa_templates
			 SET journal_id = ?, template_name = ?, template_content = ?, is_active = ?, date_modified = ?
			 WHERE loa_template_id = ?',
			[
				(int) $template->getJournalId(),
				$template->getTemplateName(),
				$template->getTemplateContent(),
				$template->getIsActive() ? 1 : 0,
				$template->getDateModified(),
				(int) $template->getTemplateId(),
			]
		);
	}

	public function deactivateById($templateId, $journalId) {
		$this->update(
			'UPDATE loa_templates SET is_active = ? WHERE loa_template_id = ? AND journal_id = ?',
			[0, (int) $templateId, (int) $journalId]
		);
	}

	public function deleteById($templateId, $journalId = null) {
		if ($journalId) {
			$this->update(
				'DELETE FROM loa_templates WHERE loa_template_id = ? AND journal_id = ?',
				[(int) $templateId, (int) $journalId]
			);
		} else {
			$this->update(
				'DELETE FROM loa_templates WHERE loa_template_id = ?',
				[(int) $templateId]
			);
		}
	}

	public function newDataObject() {
		return new LoATemplate();
	}

	public function getInsertId() {
		return $this->_getInsertId('loa_templates', 'loa_template_id');
	}

	public function _fromRow($row) {
		$template = $this->newDataObject();
		$template->setTemplateId($row['loa_template_id']);
		$template->setJournalId($row['journal_id']);
		$template->setTemplateName($row['template_name']);
		$template->setTemplateContent($row['template_content']);
		$template->setIsActive((bool) $row['is_active']);
		$template->setDateModified($row['date_modified']);
		return $template;
	}
}
