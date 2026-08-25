<?php

/**
 * @file plugins/generic/backlinkAudit/index.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Wrapper for backlink audit plugin.
 */

require_once(dirname(__FILE__) . '/BacklinkAuditPlugin.inc.php');

return new BacklinkAuditPlugin();
