<?php

import('lib.pkp.classes.db.DAO');
import('lib.pkp.classes.submission.PKPSubmission');
import('plugins.generic.loa.classes.LoA');

class LoADAO extends DAO {

	private $_issueCache = [];
	private $_authorsCache = [];

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

	public function getPublishedArticlesByJournalId($journalId, $rangeInfo = null) {
		$sql = 'SELECT
				s.submission_id,
				p.publication_id,
				p.date_published,
				ps_title.setting_value as title,
				ps_issue.setting_value as issue_id,
				alc.loa_id,
				alc.unique_code,
				alc.status as loa_status,
				alc.date_generated,
				alc.date_downloaded,
				alc.generated_by
			FROM submissions s
				JOIN publications p ON s.current_publication_id = p.publication_id AND p.status = ?
				LEFT JOIN publication_settings ps_title ON p.publication_id = ps_title.publication_id
					AND ps_title.setting_name = \'title\'
					AND ps_title.locale = s.locale
				LEFT JOIN publication_settings ps_issue ON p.publication_id = ps_issue.publication_id
					AND ps_issue.setting_name = \'issueId\'
				LEFT JOIN article_loa_codes alc ON s.submission_id = alc.submission_id AND alc.status = \'active\'
			WHERE s.context_id = ? AND s.status = ?
			ORDER BY p.date_published DESC';
		$params = [(int) STATUS_PUBLISHED, (int) $journalId, (int) STATUS_PUBLISHED];
		$countSql = 'SELECT s.submission_id
			FROM submissions s
				JOIN publications p ON s.current_publication_id = p.publication_id AND p.status = ?
			WHERE s.context_id = ? AND s.status = ?';
		$result = $this->retrieveRange($sql, $params, $rangeInfo);
		return new DAOResultFactory($result, $this, '_fromArticleRow', [], $countSql, $params, $rangeInfo);
	}

	public function getIssueData($issueId) {
		$issueId = (int) $issueId;
		if (isset($this->_issueCache[$issueId])) {
			return $this->_issueCache[$issueId];
		}
		$issueDao = DAORegistry::getDAO('IssueDAO');
		$issue = $issueDao->getById($issueId);
		if (!$issue) {
			return $this->_issueCache[$issueId] = null;
		}
		return $this->_issueCache[$issueId] = [
			'id' => $issue->getId(),
			'title' => $issue->getLocalizedTitle(),
			'volume' => $issue->getVolume(),
			'number' => $issue->getNumber(),
			'year' => $issue->getYear(),
		];
	}

	public function getAuthorsByPublicationId($publicationId) {
		$publicationId = (int) $publicationId;
		if (isset($this->_authorsCache[$publicationId])) {
			return $this->_authorsCache[$publicationId];
		}
		$authorDao = DAORegistry::getDAO('AuthorDAO');
		$authors = $authorDao->getByPublicationId($publicationId);
		$names = [];
		foreach ($authors as $author) {
			$names[] = $author->getFullName();
		}
		return $this->_authorsCache[$publicationId] = implode('; ', $names);
	}

	public function _fromArticleRow($row) {
		$row = (array) $row;
		$row['authors'] = $this->getAuthorsByPublicationId($row['publication_id']);
		if (!empty($row['issue_id'])) {
			$row['issue'] = $this->getIssueData($row['issue_id']);
		} else {
			$row['issue'] = null;
		}
		return $row;
	}

	public function insertObject($loa) {
		$this->update(
			'INSERT INTO article_loa_codes (journal_id, submission_id, unique_code, date_generated, date_downloaded, status, generated_by, template_id, content_snapshot)
			 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
			[
				(int) $loa->getJournalId(),
				(int) $loa->getSubmissionId(),
				$loa->getUniqueCode(),
				$loa->getDateGenerated(),
				$loa->getDateDownloaded(),
				$loa->getStatus(),
				$loa->getGeneratedBy() ? (int) $loa->getGeneratedBy() : null,
				$loa->getTemplateId() ? (int) $loa->getTemplateId() : null,
				$loa->getContentSnapshot(),
			]
		);
		$loa->setLoaId($this->getInsertId());
		return $loa;
	}

	public function updateObject($loa) {
		$this->update(
			'UPDATE article_loa_codes
			 SET journal_id = ?, submission_id = ?, unique_code = ?,
			     date_generated = ?, date_downloaded = ?, status = ?, generated_by = ?,
			     template_id = ?, content_snapshot = ?
			 WHERE loa_id = ?',
			[
				(int) $loa->getJournalId(),
				(int) $loa->getSubmissionId(),
				$loa->getUniqueCode(),
				$loa->getDateGenerated(),
				$loa->getDateDownloaded(),
				$loa->getStatus(),
				$loa->getGeneratedBy() ? (int) $loa->getGeneratedBy() : null,
				$loa->getTemplateId() ? (int) $loa->getTemplateId() : null,
				$loa->getContentSnapshot(),
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

	public function generateCode($submissionId, $journalId, $userId = null, $templateId = null, $contentSnapshot = null) {
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
		$loa->setGeneratedBy($userId);
		$loa->setTemplateId($templateId);
		$loa->setContentSnapshot($contentSnapshot);

		return $this->insertObject($loa);
	}

	public function regenerateCode($submissionId, $journalId, $userId = null, $templateId = null, $contentSnapshot = null) {
		$this->revokeBySubmissionId($submissionId);
		return $this->generateCode($submissionId, $journalId, $userId, $templateId, $contentSnapshot);
	}

	public function compressSnapshot($html) {
		if ($html === null || trim($html) === '') {
			return null;
		}
		return base64_encode(gzcompress($html, 9));
	}

	public function decompressSnapshot($compressed) {
		if ($compressed === null || trim($compressed) === '') {
			return null;
		}
		$decoded = base64_decode($compressed);
		if ($decoded === false) {
			return null;
		}
		return gzuncompress($decoded) ?: null;
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
		$loa->setGeneratedBy($row['generated_by'] ?? null);
		$loa->setTemplateId($row['template_id'] ?? null);
		$loa->setContentSnapshot($row['content_snapshot'] ?? null);
		return $loa;
	}
}
