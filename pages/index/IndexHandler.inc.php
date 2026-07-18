<?php

/**
 * @file pages/index/IndexHandler.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class IndexHandler
 * @ingroup pages_index
 *
 * @brief Handle site index requests.
 */

import('lib.pkp.pages.index.PKPIndexHandler');
import('lib.pkp.classes.cache.CacheManager');
import('lib.pkp.classes.config.Config');

class IndexHandler extends PKPIndexHandler {
	//
	// Public handler operations
	//
	/**
	 * If no journal is selected, display list of journals.
	 * Otherwise, display the index page for the selected journal.
	 * @param $args array
	 * @param $request Request
	 */
	function index($args, $request) {
		$this->validate(null, $request);
		$journal = $request->getJournal();

		if (!$journal) {
			$hasNoContexts = null; // Avoid scrutinizer warnings
			$journal = $this->getTargetContext($request, $hasNoContexts);
			if ($journal) {
				// There's a target context but no journal in the current request. Redirect.
				$request->redirect($journal->getPath());
			}
			if ($hasNoContexts && Validation::isSiteAdmin()) {
				// No contexts created, and this is the admin.
				$request->redirect(null, 'admin', 'contexts');
			}
		}

		$this->setupTemplate($request);
		$router = $request->getRouter();
		$templateMgr = TemplateManager::getManager($request);
		if ($journal) {
			// Serve a cached, fully-rendered journal landing page for anonymous
			// visitors when enabled. Avoids re-rendering the current-issue TOC
			// and announcements on every request (no cron required; TTL-based).
			$cacheHours = (int) Config::getVar('cache', 'journal_page_cache_hours', 0);
			$user = $request->getUser();
			if ($cacheHours > 0 && !$user && !$journal->getData('restrictSiteAccess')) {
				$locale = AppLocale::getLocale();
				$cache = CacheManager::getManager()->getFileCache('journalpage', $journal->getId() . '-' . $locale, null);
				if ($cache) {
					$cacheTime = $cache->getCacheTime();
					if ($cacheTime !== null && (time() - $cacheTime) < ($cacheHours * 3600)) {
						$cached = $cache->getContents();
						if (isset($cached['html'])) {
							header('X-OJS-Cache: HIT');
							echo $cached['html'];
							return;
						}
					}
				}
			}

			// Assign header and content for home page
			$templateMgr->assign(array(
				'additionalHomeContent' => $journal->getLocalizedData('additionalHomeContent'),
				'homepageImage' => $journal->getLocalizedData('homepageImage'),
				'homepageImageAltText' => $journal->getLocalizedData('homepageImageAltText'),
				'journalDescription' => $journal->getLocalizedData('description'),
			));

			$issueDao = DAORegistry::getDAO('IssueDAO'); /* @var $issueDao IssueDAO */
			$issue = $issueDao->getCurrent($journal->getId(), true);
			if (isset($issue) && $journal->getData('publishingMode') != PUBLISHING_MODE_NONE) {
				import('pages.issue.IssueHandler');
				// The current issue TOC/cover page should be displayed below the custom home page.
				IssueHandler::_setupIssueTemplate($request, $issue);
			}

			$this->_setupAnnouncements($journal, $templateMgr);

			// Allow public caching of the (mostly static) journal landing page
			// so anonymous visitors don't re-render the full current-issue TOC
			// and announcements on every request. Skip when access is restricted.
			if (!$journal->getData('restrictSiteAccess')) {
				$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
			}

			$html = $templateMgr->fetch('frontend/pages/indexJournal.tpl');

			// Store the rendered HTML in the file cache for subsequent requests.
			if ($cacheHours > 0 && !$user && !$journal->getData('restrictSiteAccess') && isset($cache)) {
				$cache->setEntireCache(array('html' => $html));
			}

			echo $html;
		} else {
			$journalDao = DAORegistry::getDAO('JournalDAO'); /* @var $journalDao JournalDAO */
			$site = $request->getSite();

			if ($site->getRedirect() && ($journal = $journalDao->getById($site->getRedirect())) != null) {
				$request->redirect($journal->getPath());
			}

			$templateMgr->assign([
				'pageTitleTranslated' => $site->getLocalizedTitle(),
				'about' => $site->getLocalizedAbout(),
				'journalFilesPath' => $request->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/',
				'journals' => $journalDao->getAll(true)->toArray(),
				'site' => $site,
			]);
			$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
			$templateMgr->display('frontend/pages/indexSite.tpl');
		}
	}
}


