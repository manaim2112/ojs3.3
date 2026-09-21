/**
 * @file plugins/themes/dimension/js/main.js
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Handle JavaScript functionality unique to this theme.
 */
(function($) {

	// Modify the Chart.js display options used by UsageStats plugin
	document.addEventListener('usageStatsChartOptions.pkp', function(e) {
		e.chartOptions.elements.line.backgroundColor = 'rgba(0, 122, 178, 0.6)';
		e.chartOptions.elements.rectangle.backgroundColor = 'rgba(0, 122, 178, 0.6)';
	});

	// Toggle display of consent checkboxes in site-wide registration
	var $contextOptinGroup = $('#contextOptinGroup');
	if ($contextOptinGroup.length) {
		var $roles = $contextOptinGroup.find('.roles :checkbox');
		$roles.change(function() {
			var $thisRoles = $(this).closest('.roles');
			if ($thisRoles.find(':checked').length) {
				$thisRoles.siblings('.context_privacy').addClass('context_privacy_visible');
			} else {
				$thisRoles.siblings('.context_privacy').removeClass('context_privacy_visible');
			}
		});
	}

	// Show or hide the reviewer interests field on the registration form
	// when a user has opted to register as a reviewer.
	function reviewerInterestsToggle() {
		var is_checked = false;
		$('#reviewerOptinGroup').find('input').each(function() {
			if ($(this).is(':checked')) {
				is_checked = true;
				return false;
			}
		});
		if (is_checked) {
			$('#reviewerInterests').addClass('is_visible');
		} else {
			$('#reviewerInterests').removeClass('is_visible');
		}
	}

	reviewerInterestsToggle();
	$('#reviewerOptinGroup input').on('click', reviewerInterestsToggle);

})(jQuery);
