(function ($) {

	// Mobile nav toggle
	$('.pkp_site_nav_toggle').on('click', function () {
		$('.pkp_site_nav_menu').toggleClass('open');
	});

	// Close nav on outside click
	$(document).on('click', function (e) {
		if (!$(e.target).closest('.pkp_structure_head').length) {
			$('.pkp_site_nav_menu').removeClass('open');
		}
	});

})(jQuery);
