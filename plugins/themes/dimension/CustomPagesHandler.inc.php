<?php

/**
 * @file plugins/themes/dimension/CustomPagesHandler.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class CustomPagesHandler
 * @ingroup plugins_themes_dimension
 *
 * @brief Handler for custom pages (arsitektur-legal, kepemimpinan)
 */

import('lib.pkp.classes.handler.PKPHandler');

define('HANDLER_CLASS', 'CustomPagesHandler');

class CustomPagesHandler extends PKPHandler {
	function index($args, $request) {
		$templateMgr = TemplateManager::getManager($request);
		$page = $request->getRequestedPage();

		$templates = [
			'arsitektur-legal' => 'frontend/pages/arsitekturLegal.tpl',
			'kepemimpinan' => 'frontend/pages/kepemimpinan.tpl',
		];

		if (isset($templates[$page])) {
			$templateMgr->display($templates[$page]);
		} else {
			$request->redirect(null, 'index');
		}
	}
}
