/**
 * @file plugins/themes/modern/js/main.js
 *
 * Modern theme — Premium JavaScript interactions.
 * Includes scroll reveal, smooth transitions, and enhanced navigation.
 */
(function($) {

	// Initialize dropdown navigation menus on large screens
	if (typeof $.fn.dropdown !== 'undefined') {
		var $nav = $('#navigationPrimary, #navigationUser'),
		$submenus = $('ul', $nav);
		function toggleDropdowns() {
			if (window.innerWidth > 992) {
				$submenus.each(function(i) {
					var id = 'pkpDropdown' + i;
					$(this)
						.addClass('dropdown-menu')
						.attr('aria-labelledby', id);
					$(this).siblings('a')
						.attr('data-toggle', 'dropdown')
						.attr('aria-haspopup', true)
						.attr('aria-expanded', false)
						.attr('id', id)
						.attr('href', '#');
				});
				$('[data-toggle="dropdown"]').dropdown();

			} else {
				$('[data-toggle="dropdown"]').dropdown('dispose');
				$submenus.each(function(i) {
					$(this)
						.removeClass('dropdown-menu')
						.removeAttr('aria-labelledby');
					$(this).siblings('a')
						.removeAttr('data-toggle')
						.removeAttr('aria-haspopup')
						.removeAttr('aria-expanded',)
						.removeAttr('id')
						.attr('href', '#');
				});
			}
		}
		window.onresize = toggleDropdowns;
		$().ready(function() {
			toggleDropdowns();
		});
	}

	// Toggle nav menu on small screens — premium morph animation
	$('.pkp_site_nav_toggle').click(function(e) {
		$('.pkp_site_nav_menu').toggleClass('pkp_site_nav_menu--isOpen');
		$('.pkp_site_nav_toggle').toggleClass('pkp_site_nav_toggle--transform');
	});

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

	// =====================================================
	// Premium Scroll Reveal — IntersectionObserver
	// =====================================================
	function initScrollReveal() {
		// Auto-mark elements for reveal
		$('.obj_article_summary, .obj_issue_summary, .obj_announcement_summary, .pkp_block, .sis_journal').each(function(index) {
			if (!$(this).attr('data-reveal')) {
				$(this).attr('data-reveal', '');
				$(this).attr('data-reveal-delay', Math.min(index % 4 + 1, 4));
			}
		});

		var revealElements = document.querySelectorAll('[data-reveal]');
		if (!revealElements.length) return;

		// Use IntersectionObserver for GPU-friendly scroll detection
		if ('IntersectionObserver' in window) {
			var observer = new IntersectionObserver(function(entries) {
				entries.forEach(function(entry) {
					if (entry.isIntersecting) {
						entry.target.classList.add('is-visible');
						observer.unobserve(entry.target);
					}
				});
			}, {
				threshold: 0.1,
				rootMargin: '0px 0px -40px 0px'
			});

			revealElements.forEach(function(el) {
				observer.observe(el);
			});
		} else {
			// Fallback: show all elements immediately
			revealElements.forEach(function(el) {
				el.classList.add('is-visible');
			});
		}
	}

	// =====================================================
	// Smooth header shadow on scroll
	// =====================================================
	function initHeaderScroll() {
		var header = document.querySelector('.pkp_structure_head');
		if (!header) return;

		var lastScroll = 0;
		var ticking = false;

		window.addEventListener('scroll', function() {
			lastScroll = window.scrollY;
			if (!ticking) {
				window.requestAnimationFrame(function() {
					if (lastScroll > 10) {
						header.classList.add('pkp_structure_head--scrolled');
					} else {
						header.classList.remove('pkp_structure_head--scrolled');
					}
					ticking = false;
				});
				ticking = true;
			}
		});
	}

	// =====================================================
	// Magnetic button hover effect
	// =====================================================
	function initMagneticButtons() {
		$('.cmp_button, .cmp_button_wire').each(function() {
			var $btn = $(this);

			$btn.on('mouseenter', function(e) {
				var rect = this.getBoundingClientRect();
				var x = e.clientX - rect.left - rect.width / 2;
				var y = e.clientY - rect.top - rect.height / 2;

				$(this).css('transform', 'translateY(-2px) scale(1.02)');
			});

			$btn.on('mouseleave', function() {
				$(this).css('transform', '');
			});
		});
	}

	// =====================================================
	// Initialize all premium features
	// =====================================================
	$(document).ready(function() {
		initScrollReveal();
		initHeaderScroll();
		initMagneticButtons();
	});

})(jQuery);
