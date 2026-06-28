<?php

/**
 * @defgroup plugins_themes_bootstrap3 Theme plugin for base Bootstrap 3 theme
 */

/**
 * @file plugins/themes/bootstrap3/index.php
 *
 * Copyright (c) 2014-2023 Simon Fraser University Library
 * Copyright (c) 2003-2023 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_themes_bootstrap3
 * @brief Wrapper for Bootstrap 3 theme plugin.
 *
 */

require_once('BootstrapThreeThemePlugin.inc.php');

return new BootstrapThreeThemePlugin();

?>
