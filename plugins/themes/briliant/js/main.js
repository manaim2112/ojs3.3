(function ($) {

	// Mobile nav toggle
	$('.pkp_site_nav_toggle').on('click', function () {
		var nav = document.querySelector('.pkp_site_nav_menu');
		var toggle = document.querySelector('.pkp_site_nav_toggle');
		if (!nav || !toggle) return;
		nav.classList.toggle('open');
		toggle.setAttribute('aria-expanded', nav.classList.contains('open') ? 'true' : 'false');
	});

	// Close nav on outside click
	$(document).on('click', function (e) {
		if (!$(e.target).closest('.pkp_structure_head').length) {
			$('.pkp_site_nav_menu').removeClass('open');
			$('.pkp_site_nav_toggle').attr('aria-expanded', 'false');
		}
	});

})(jQuery);
