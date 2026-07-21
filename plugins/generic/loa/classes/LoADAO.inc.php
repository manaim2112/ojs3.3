<?php

import('lib.pkp.classes.db.DAO');
import('plugins.generic.loa.classes.LoA');

class LoADAO extends DAO {

	public function getById($loaId) {
		$result = $this->retrieve(
			'SELECT * FROM article_loa_codes WHERE loa_id = ?',
			[(int) $loaId]
		);
		$row = $result->current();
		return $row ? $this->_fromRow((array) $row) : null;
	}

	public function getBySubmissionId($submissionId) {
		$result = $this->retrieve(
			'SELECT * FROM article_loa_codes WHERE submission_id = ? AND status = ?',
			[(int) $submissionId, 'active']
		);
		$row = $result->current();
		return $row ? $this->_fromRow((array) $row) : null;
	}

	public function getByUniqueCode($uniqueCode) {
		$result = $this->retrieve(
			'SELECT * FROM article_loa_codes WHERE unique_code = ?',
			[$uniqueCode]
		);
		$row = $result->current();
		return $row ? $this->_fromRow((array) $row) : null;
	}

	public function getAllBySubmissionId($submissionId) {
		$result = $this->retrieve(
			'SELECT * FROM article_loa_codes WHERE submission_id = ? ORDER BY loa_id DESC',
			[(int) $submissionId]
		);
		return new DAOResultFactory($result, $this, '_fromRow');
	}

	public function getByJournalId($journalId, $rangeInfo = null) {
		$result = $this->retrieveRange(
			'SELECT * FROM article_loa_codes WHERE journal_id = ? ORDER BY date_generated DESC',
			[(int) $journalId],
			$rangeInfo
		);
		return new DAOResultFactory($result, $this, '_fromRow');
	}

	public function insertObject($loa) {
		$this->update(
			'INSERT INTO article_loa_codes (journal_id, submission_id, unique_code, date_generated, date_downloaded, status)
			 VALUES (?, ?, ?, ?, ?, ?)',
			[
				(int) $loa->getJournalId(),
				(int) $loa->getSubmissionId(),
				$loa->getUniqueCode(),
				$loa->getDateGenerated(),
				$loa->getDateDownloaded(),
				$loa->getStatus(),
			]
		);
		$loa->setLoaId($this->getInsertId());
		return $loa;
	}

	public function updateObject($loa) {
		$this->update(
			'UPDATE article_loa_codes
			 SET journal_id = ?, submission_id = ?, unique_code = ?,
			     date_generated = ?, date_downloaded = ?, status = ?
			 WHERE loa_id = ?',
			[
				(int) $loa->getJournalId(),
				(int) $loa->getSubmissionId(),
				$loa->getUniqueCode(),
				$loa->getDateGenerated(),
				$loa->getDateDownloaded(),
				$loa->getStatus(),
				(int) $loa->getLoaId(),
			]
		);
	}

	public function revokeBySubmissionId($submissionId) {
		$this->update(
			'UPDATE article_loa_codes SET status = ? WHERE submission_id = ? AND status = ?',
			['revoked', (int) $submissionId, 'active']
		);
	}

	public function markDownloaded($loaId) {
		$this->update(
			'UPDATE article_loa_codes SET date_downloaded = NOW() WHERE loa_id = ?',
			[(int) $loaId]
		);
	}

	public function generateCode($submissionId, $journalId) {
		$loa = $this->getBySubmissionId($submissionId);
		if ($loa) {
			return $loa;
		}

		$random = substr(md5(uniqid(mt_rand(), true)), 0, 8);
		$uniqueCode = 'LOA-' . $journalId . '-' . $submissionId . '-' . strtoupper($random);

		$loa = $this->newDataObject();
		$loa->setJournalId($journalId);
		$loa->setSubmissionId($submissionId);
		$loa->setUniqueCode($uniqueCode);
		$loa->setDateGenerated(date('Y-m-d H:i:s'));
		$loa->setDateDownloaded(null);
		$loa->setStatus('active');

		return $this->insertObject($loa);
	}

	public function regenerateCode($submissionId, $journalId) {
		$this->revokeBySubmissionId($submissionId);
		return $this->generateCode($submissionId, $journalId);
	}

	public function newDataObject() {
		return new LoA();
	}

	public function getInsertId() {
		return $this->_getInsertId('article_loa_codes', 'loa_id');
	}

	public function _fromRow($row) {
		$loa = $this->newDataObject();
		$loa->setLoaId($row['loa_id']);
		$loa->setJournalId($row['journal_id']);
		$loa->setSubmissionId($row['submission_id']);
		$loa->setUniqueCode($row['unique_code']);
		$loa->setDateGenerated($row['date_generated']);
		$loa->setDateDownloaded($row['date_downloaded']);
		$loa->setStatus($row['status']);
		return $loa;
	}
}
