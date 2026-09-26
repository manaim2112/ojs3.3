<?php

/**
 * @file plugins/generic/backlinkAudit/classes/BacklinkAuditNotifier.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditNotifier
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Emails site administrators when privilege or account changes are
 * detected.
 *
 * The email is the durable copy of a detection. Everything else this plugin
 * writes lives in the same database as the thing being watched, so an
 * attacker with write access can erase it. A message that has already left
 * the server cannot be taken back.
 */

import('lib.pkp.classes.mail.Mail');

class BacklinkAuditNotifier {

	/** @var BacklinkAuditPlugin */
	var $_plugin;

	function __construct($plugin) {
		$this->_plugin = $plugin;
	}

	/**
	 * Send one batched alert covering every change found in this run.
	 *
	 * @param $changes array List of change summaries (see the plugin's
	 *   diffSnapshots()); each has action, username, userId, contextPath,
	 *   added, removed, accountChanges and unexplained.
	 * @return bool
	 */
	function notify($changes) {
		if (empty($changes)) return false;

		$recipients = $this->_getSiteAdminRecipients();
		if (empty($recipients)) {
			error_log('BacklinkAudit: privilege changes detected but no site admin recipient could be resolved.');
			return false;
		}

		try {
			$mail = new Mail();
			$from = $this->_getFromAddress();
			$mail->setFrom($from['email'], $from['name']);
			foreach ($recipients as $recipient) {
				$mail->addRecipient($recipient['email'], $recipient['name']);
			}
			$mail->setSubject(__('plugins.generic.backlinkAudit.alert.subject', ['count' => count($changes)]));
			$mail->setBody($this->_buildBody($changes));
			return $mail->send();
		} catch (\Throwable $e) {
			// PHPMailer is synchronous and can throw on a bad SMTP config.
			// The log row is already written by the time we get here, so a
			// mail failure must never take down the request.
			error_log('BacklinkAuditNotifier::notify failed: ' . $e->getMessage());
			return false;
		}
	}

	/**
	 * Site administrators, resolved from the site-level admin user group.
	 * @return array List of ['email' =>, 'name' =>]
	 */
	function _getSiteAdminRecipients() {
		$recipients = [];
		try {
			$roleDao = DAORegistry::getDAO('RoleDAO');
			$users = $roleDao->getUsersByRoleId(ROLE_ID_SITE_ADMIN, CONTEXT_SITE);
			if ($users) {
				while ($user = $users->next()) {
					$email = $user->getEmail();
					if (!$email || $user->getDisabled()) continue;
					$recipients[] = ['email' => $email, 'name' => $user->getFullName()];
				}
			}
		} catch (\Throwable $e) {
			error_log('BacklinkAuditNotifier::_getSiteAdminRecipients failed: ' . $e->getMessage());
		}
		return $recipients;
	}

	/**
	 * Site contact address, falling back to the first site admin so the
	 * message is never rejected for an empty envelope sender.
	 * @return array ['email' =>, 'name' =>]
	 */
	function _getFromAddress() {
		$request = Application::get()->getRequest();
		try {
			$site = $request ? $request->getSite() : null;
			if ($site) {
				$email = $site->getLocalizedContactEmail();
				if ($email) {
					return ['email' => $email, 'name' => $site->getLocalizedContactName()];
				}
			}
		} catch (\Throwable $e) {
			// fall through to the site admin
		}

		$admins = $this->_getSiteAdminRecipients();
		if (!empty($admins)) return $admins[0];

		return ['email' => 'noreply@localhost', 'name' => 'OJS'];
	}

	/**
	 * @param $changes array
	 * @return string HTML
	 */
	function _buildBody($changes) {
		$html = '<p>' . htmlspecialchars(__('plugins.generic.backlinkAudit.alert.intro'), ENT_QUOTES, 'UTF-8') . '</p>';
		$html .= '<table cellpadding="6" cellspacing="0" border="1" style="border-collapse:collapse;font-family:sans-serif;font-size:13px;">';
		$html .= '<tr style="background:#f3f4f6;">'
			. '<th align="left">' . htmlspecialchars(__('plugins.generic.backlinkAudit.col.date'), ENT_QUOTES, 'UTF-8') . '</th>'
			. '<th align="left">' . htmlspecialchars(__('plugins.generic.backlinkAudit.alert.col.actor'), ENT_QUOTES, 'UTF-8') . '</th>'
			. '<th align="left">' . htmlspecialchars(__('plugins.generic.backlinkAudit.alert.col.account'), ENT_QUOTES, 'UTF-8') . '</th>'
			. '<th align="left">' . htmlspecialchars(__('plugins.generic.backlinkAudit.alert.col.change'), ENT_QUOTES, 'UTF-8') . '</th>'
			. '</tr>';

		foreach ($changes as $change) {
			$actor = htmlspecialchars($change['actor'] ?: '-', ENT_QUOTES, 'UTF-8');
			if (!empty($change['unexplained'])) {
				$actor .= '<br><strong style="color:#b91c1c;">'
					. htmlspecialchars(__('plugins.generic.backlinkAudit.alert.unexplained'), ENT_QUOTES, 'UTF-8')
					. '</strong>';
			}

			$account = '#' . (int) $change['userId'] . ' ' . htmlspecialchars((string) $change['username'], ENT_QUOTES, 'UTF-8');
			if (!empty($change['contextPath'])) {
				$account .= '<br><small>' . htmlspecialchars($change['contextPath'], ENT_QUOTES, 'UTF-8') . '</small>';
			}

			$detail = [];
			foreach ($change['added'] as $label) {
				$detail[] = '<span style="color:#16a34a;">+' . htmlspecialchars($label, ENT_QUOTES, 'UTF-8') . '</span>';
			}
			foreach ($change['removed'] as $label) {
				$detail[] = '<span style="color:#dc2626;">-' . htmlspecialchars($label, ENT_QUOTES, 'UTF-8') . '</span>';
			}
			foreach ($change['accountChanges'] as $label) {
				$detail[] = '<span style="color:#b45309;">' . htmlspecialchars($label, ENT_QUOTES, 'UTF-8') . '</span>';
			}

			$html .= '<tr>'
				. '<td valign="top" style="white-space:nowrap;">' . htmlspecialchars($change['createdAt'], ENT_QUOTES, 'UTF-8') . '</td>'
				. '<td valign="top">' . $actor . '</td>'
				. '<td valign="top">' . $account . '</td>'
				. '<td valign="top">' . implode('<br>', $detail) . '</td>'
				. '</tr>';
		}
		$html .= '</table>';

		$html .= '<p style="font-family:sans-serif;font-size:12px;color:#555;">'
			. htmlspecialchars(__('plugins.generic.backlinkAudit.alert.footer'), ENT_QUOTES, 'UTF-8')
			. '</p>';

		return $html;
	}
}
