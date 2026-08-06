<?php

import('lib.pkp.classes.plugins.GenericPlugin');
import('classes.i18n.AppLocale');
import('plugins.generic.loa.classes.LoADAO');
import('plugins.generic.loa.classes.LoATemplateDAO');

use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;

class LoAPlugin extends GenericPlugin {

	public function register($category, $path, $mainContextId = null) {
		$success = parent::register($category, $path, $mainContextId);

		if (!Config::getVar('general', 'installed') || defined('RUNNING_UPGRADE')) {
			return true;
		}

		if ($success && $this->getEnabled($mainContextId)) {
			$this->runMigration();
			$loaDao = new LoADAO();
			DAORegistry::registerDAO('LoADAO', $loaDao);
			$loaTemplateDao = new LoATemplateDAO();
			DAORegistry::registerDAO('LoATemplateDAO', $loaTemplateDao);

			HookRegistry::register('LoadHandler', [$this, 'callbackHandleContent']);
			HookRegistry::register('Template::Workflow::Publication', [$this, 'addToWorkflow']);
			HookRegistry::register('Templates::Article::Details', [$this, 'addToArticleDetails']);
			HookRegistry::register('TemplateManager::setupBackendPage', [$this, 'addToBackendMenu']);
			HookRegistry::register('Template::Settings::distribution', [$this, 'callbackShowDistributionTabs']);
			HookRegistry::register('Templates::Index::journal', [$this, 'callbackShowSecurityPopup']);
		}

		return $success;
	}

	public function setEnabled($enabled) {
		parent::setEnabled($enabled);
		if ($enabled) {
			$this->runUpgradeMigration();
		}
	}

	private function runMigration() {
		try {
			$migration = $this->getInstallMigration();
			$migration->up();
		} catch (\Throwable $e) {
			error_log('LoA runMigration() FAILED: ' . get_class($e) . ': ' . $e->getMessage());
		}
	}

	private function runUpgradeMigration() {
		$this->runMigration();
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return;
		}
		try {
			Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
				$table->dropUnique('article_loa_codes_submission_status');
			});
		} catch (\Exception $e) {
		}
	}

	public function getActions($request, $verb) {
		$router = $request->getRouter();
		import('lib.pkp.classes.linkAction.request.AjaxModal');
		return array_merge(
			$this->getEnabled() ? [
				new LinkAction(
					'settings',
					new AjaxModal(
						$router->url($request, null, null, 'manage', null, ['verb' => 'settings', 'plugin' => $this->getName(), 'category' => $this->getCategory()]),
						$this->getDisplayName()
					),
					__('plugins.generic.loa.settings'),
					null
				),
			] : [],
			parent::getActions($request, $verb)
		);
	}

	public function manage($args, $request) {
		$context = $request->getContext();
		switch ($request->getUserVar('verb')) {
			case 'settings':
				$this->import('LoASettingsForm');
				$form = new LoASettingsForm($this, $context->getId());
				if ($request->getUserVar('save')) {
					$form->readInputData();
					if ($form->validate()) {
						$form->execute();
						return new JSONMessage(true, __('plugins.generic.loa.settingsSaved'));
					}
				} else {
					$form->initData();
				}
				return new JSONMessage(true, $form->fetch($request));

			case 'saveSecuritySettings':
				$this->import('classes.LoASecurityForm');
				$form = new LoASecurityForm($this, $context->getId());
				if ($request->getUserVar('save')) {
					$form->readInputData();
					if ($form->validate()) {
						$form->execute();
						return new JSONMessage(true, __('plugins.generic.loa.securitySaved'));
					}
				} else {
					$form->initData();
				}
				return new JSONMessage(true, $form->fetch($request));
		}
		return parent::manage($args, $request);
	}

	public function getDisplayName() {
		return __('plugins.generic.loa.displayName');
	}

	public function getDescription() {
		return __('plugins.generic.loa.description');
	}

	public function getInstallMigration() {
		$this->import('LoASchemaMigration');
		return new LoASchemaMigration();
	}

	public function callbackHandleContent($hookName, $args) {
		$page =& $args[0];
		$op =& $args[1];

		if ($page === 'loa') {
			define('HANDLER_CLASS', 'LoAHandler');
			$this->import('pages.LoAHandler');
			LoAHandler::setPlugin($this);
			return true;
		}
		return false;
	}

	public function addToWorkflow($hookName, $params) {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return false;
		}

		$smarty = &$params[1];
		$output = &$params[2];
		$submission = $smarty->get_template_vars('submission');

		if (!$submission) {
			return false;
		}

		$request = Application::get()->getRequest();
		$context = $request->getContext();
		$dispatcher = $request->getDispatcher();

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->getBySubmissionId($submission->getId());

		$generatedByUser = null;
		if ($loa && $loa->getGeneratedBy()) {
			$userDao = DAORegistry::getDAO('UserDAO');
			$generatedByUser = $userDao->getById($loa->getGeneratedBy());
		}

		$user = $request->getUser();
		$canManage = $user && $user->hasRole([ROLE_ID_MANAGER, ROLE_ID_SITE_ADMIN, ROLE_ID_SUB_EDITOR], $context->getId());

		$smarty->assign([
			'loa' => $loa,
			'submissionId' => $submission->getId(),
			'generatedByUser' => $generatedByUser,
			'canManage' => $canManage,
			'loaGenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'generate'),
			'loaRegenerateUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'regenerate'),
			'loaRevokeUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'revoke'),
			'loaViewUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view'),
		]);

		$output .= sprintf(
			'<tab id="loa" label="%s">%s</tab>',
			__('plugins.generic.loa.displayName'),
			$smarty->fetch($this->getTemplateResource('loaTab.tpl'))
		);

		return false;
	}

	public function addToBackendMenu($hookName, $args) {
		$request = Application::get()->getRequest();
		$templateMgr = TemplateManager::getManager($request);
		$context = $request->getContext();
		$user = $request->getUser();

		if (!$context || !$user) {
			return false;
		}

		$router = $request->getRouter();
		$handler = $router->getHandler();
		$userRoles = (array) $handler->getAuthorizedContextObject(ASSOC_TYPE_USER_ROLES);

		if (!in_array(ROLE_ID_MANAGER, $userRoles) && !in_array(ROLE_ID_SITE_ADMIN, $userRoles)) {
			return false;
		}

		$menu = (array) $templateMgr->getState('menu');

		$loaLink = [
			'name' => __('plugins.generic.loa.management'),
			'url' => $router->url($request, $context->getPath(), 'loa', 'management'),
			'isCurrent' => $request->getRequestedPage() === 'loa' && $request->getRequestedOp() === 'management',
		];

		$loaTemplatesLink = [
			'name' => __('plugins.generic.loa.templates'),
			'url' => $router->url($request, $context->getPath(), 'loa', 'templates'),
			'isCurrent' => $request->getRequestedPage() === 'loa' && $request->getRequestedOp() === 'templates',
		];

		$index = array_search('issues', array_keys($menu));
		if ($index === false) {
			$index = array_search('submissions', array_keys($menu));
		}
		if ($index === false || count($menu) <= ($index + 1)) {
			$menu['loa'] = $loaLink;
			$menu['loaTemplates'] = $loaTemplatesLink;
		} else {
			$menu = array_slice($menu, 0, $index + 1, true) +
					['loa' => $loaLink, 'loaTemplates' => $loaTemplatesLink] +
					array_slice($menu, $index + 1, null, true);
		}

		$templateMgr->setState(['menu' => $menu]);

		return false;
	}

	public function addToArticleDetails($hookName, $params) {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			return false;
		}

		$smarty = &$params[1];
		$output = &$params[2];

		$submission = $smarty->get_template_vars('article');
		if (!$submission) {
			$submission = $smarty->get_template_vars('submission');
		}
		if (!$submission) {
			return false;
		}

		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->getBySubmissionId($submission->getId());

		if (!$loa) {
			return false;
		}

		$request = Application::get()->getRequest();
		$context = $request->getContext();
		$dispatcher = $request->getDispatcher();

		$smarty->assign([
			'loaDownloadUrl' => $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view', [$loa->getUniqueCode()]),
			'loaUniqueCode' => $loa->getUniqueCode(),
		]);

		$output .= $smarty->fetch($this->getTemplateResource('loaDownloadLink.tpl'));

		return false;
	}

	public function callbackShowDistributionTabs($hookName, $args) {
		$templateMgr = $args[1];
		$output =& $args[2];
		$request = Application::get()->getRequest();
		$context = $request->getContext();

		if (!$context) {
			return false;
		}

		$this->import('classes.LoASecurityForm');
		$form = new LoASecurityForm($this, $context->getId());
		$form->initData();

		$templateMgr->assign([
			'loaSecurityFormContent' => $form->fetch($request),
		]);

		$output .= $templateMgr->fetch($this->getTemplateResource('loaSecurityTab.tpl'));
		return false;
	}

	public function callbackShowSecurityPopup($hookName, $args) {
		$request = Application::get()->getRequest();
		$context = $request->getContext();

		if (!$context) {
			return false;
		}

		$enabled = $this->getSetting($context->getId(), 'loaSecurityEnabled');
		$content = $this->getSetting($context->getId(), 'loaSecurityContent');
		$title = $this->getSetting($context->getId(), 'loaSecurityTitle');

		if ($enabled && !empty(trim(strip_tags($content, '<img><p><br><div><span><a><b><i><strong><em><ul><ol><li>')))) {
			$smarty = &$args[1];
			$output = &$args[2];

			$smarty->assign([
				'loaSecurityTitle' => !empty($title) ? $title : __('plugins.generic.loa.securityModalTitle'),
				'loaSecurityContent' => $content,
			]);

			$output .= $smarty->fetch($this->getTemplateResource('loaSecurityPopup.tpl'));
		}

		return false;
	}

	public function getLoATemplateTokens($loa, $submission, $publication, $context, $request) {
		$authorNames = '';
		if ($publication) {
			$authors = $publication->getData('authors');
			if ($authors) {
				$names = [];
				foreach ($authors as $author) {
					$names[] = $author->getFullName();
				}
				$authorNames = implode(', ', $names);
			}
		}

		$validationUrl = '';
		if ($context && $request && $loa) {
			$dispatcher = $request->getDispatcher();
			$validationUrl = $dispatcher->url($request, ROUTE_PAGE, $context->getPath(), 'loa', 'view', [$loa->getUniqueCode()]);
		}

		return [
			'[[article_title]]' => $publication ? $publication->getLocalizedTitle() : '',
			'[[authors]]' => $authorNames,
			'[[journal_name]]' => $context ? $context->getLocalizedData('name') : '',
			'[[e_issn]]' => $context ? (string) $context->getData('onlineIssn') : '',
			'[[p_issn]]' => $context ? (string) $context->getData('printIssn') : '',
			'[[unique_code]]' => $loa ? $loa->getUniqueCode() : '',
			'[[date_generated]]' => $loa ? $loa->getDateGenerated() : '',
			'[[status]]' => $loa ? $loa->getStatus() : '',
			'[[editor_in_chief_name]]' => $context ? (string) $this->getSetting($context->getId(), 'editorInChiefName') : '',
			'[[editor_in_chief_title]]' => $context ? (string) $this->getSetting($context->getId(), 'editorInChiefTitle') : '',
			'[[base_url]]' => $request ? $request->getBaseUrl() : '',
			'[[current_locale]]' => AppLocale::getLocale(),
			'[[validation_url]]' => $validationUrl,
			'[[qr_code]]' => $validationUrl !== '' ? '<img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=' . urlencode($validationUrl) . '" alt="QR Code" />' : '',
		];
	}

	public function substituteLoATemplateTokens($templateContent, array $tokens) {
		foreach ($tokens as $token => $value) {
			$templateContent = str_replace($token, $value, $templateContent);
		}
		return $templateContent;
	}

	/**
	 * Extract a renderable fragment from a (possibly full) HTML document.
	 * Returns ['style' => combined <style> blocks, 'html' => <body> content
	 * (or the whole input minus document scaffolding when no <body>)].
	 */
	public function extractTemplateFragment($html) {
		if ($html === null || trim($html) === '') {
			return ['style' => '', 'html' => ''];
		}

		$styleBlocks = [];

		if (preg_match('/<body[^>]*>(.*)<\/body>/is', $html, $matches)) {
			$body = $matches[1];
			if (preg_match_all('/<style[^>]*>(.*?)<\/style>/is', $html, $matches)) {
				foreach ($matches[1] as $block) {
					if (trim($block) !== '') {
						$styleBlocks[] = trim($block);
					}
				}
			}
		} else {
			$body = $html;
			$body = preg_replace('/<!DOCTYPE[^>]*>/i', '', $body);
			$body = preg_replace('/<\/?(html|head)[^>]*>/i', '', $body);

			$body = preg_replace_callback('/<style[^>]*>(.*?)<\/style>/is', function ($matches) use (&$styleBlocks) {
				if (trim($matches[1]) !== '') {
					$styleBlocks[] = trim($matches[1]);
				}
				return '';
			}, $body);

			if (preg_match('/<([a-z][a-z0-9]*)[^>]*>/is', $body, $m, PREG_OFFSET_CAPTURE)) {
				$pos = $m[0][1];
				$headRaw = trim(substr($body, 0, $pos));
				$body = substr($body, $pos);
				if ($headRaw !== '') {
					$styleBlocks[] = $headRaw;
				}
			}
		}

		$style = $styleBlocks ? '<style>' . implode("\n", $styleBlocks) . '</style>' : '';

		return ['style' => trim($style), 'html' => trim($body)];
	}

	public function generateLoAWithSnapshot($submissionId, $context, $userId, $request) {
		$loaDao = DAORegistry::getDAO('LoADAO');
		$loa = $loaDao->generateCode($submissionId, $context->getId(), $userId);

		if ($loa && $loa->getContentSnapshot() === null) {
			$loaTemplateDao = DAORegistry::getDAO('LoATemplateDAO');
			$activeTemplate = $loaTemplateDao->getActiveByJournalId($context->getId());
			if ($activeTemplate) {
				$submissionDao = DAORegistry::getDAO('SubmissionDAO');
				$submission = $submissionDao->getById($submissionId);
				$publication = $submission ? $submission->getCurrentPublication() : null;
				$tokens = $this->getLoATemplateTokens($loa, $submission, $publication, $context, $request);
				$html = $this->substituteLoATemplateTokens($activeTemplate->getTemplateContent(), $tokens);
				$frag = $this->extractTemplateFragment($html);
				$loa->setTemplateId($activeTemplate->getTemplateId());
				$loa->setContentSnapshot($loaDao->compressSnapshot($frag['style'] . "\n" . $frag['html']));
				$loaDao->updateObject($loa);
			}
		}

		return $loa;
	}

	public function regenerateLoAWithSnapshot($submissionId, $context, $userId, $request) {
		$loaDao = DAORegistry::getDAO('LoADAO');
		$loaDao->revokeBySubmissionId($submissionId);
		return $this->generateLoAWithSnapshot($submissionId, $context, $userId, $request);
	}

	public function sanitizeHtml($html) {
		if ($html === null || trim($html) === '') {
			return '';
		}

		$html = preg_replace('/\son[a-z]+\s*=\s*("[^"]*"|\'[^\']*\'|[^\s>]+)/i', '', $html);
		$html = preg_replace_callback('/\bstyle\s*=\s*(["\'])(.*?)\1/i', function ($m) {
			$value = $m[2];
			$value = preg_replace('/expression\s*\(/i', '', $value);
			$value = preg_replace('/\bjavascript\s*:/i', '', $value);
			$value = preg_replace('/\bbase64\s*:/i', '', $value);
			return 'style="' . $value . '"';
		}, $html);
		$html = preg_replace('/<(a|img)[^>]*\b(href|src)\s*=\s*(["\'])\s*(javascript|data):[^"\']*\3[^>]*>/i', '<$1>', $html);

		return $html;
	}
}

