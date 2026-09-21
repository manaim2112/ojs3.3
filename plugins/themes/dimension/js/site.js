/**
 * Shared behaviour for the standalone site pages:
 *   - frontend/pages/indexSite.tpl
 *   - frontend/pages/arsitekturLegal.tpl
 *   - frontend/pages/kepemimpinan.tpl
 *
 * Motion & interaction layer (no dependencies):
 *   [data-reveal]   — IntersectionObserver scroll reveal (see .js-reveal in site.css)
 *   [data-counter]  — count-up numbers, `data-suffix` supported
 *   [data-tilt]     — pointer-driven 3D tilt for cards
 *   [data-parallax] — scroll parallax (value = speed factor, e.g. "0.2")
 *   [data-accordion]— animating FAQ accordion (.dim-acc)
 *   [data-spy]      — nav scrollspy (toggles .dim-nav-active)
 *   #dimProgressBar — top scroll progress bar
 *
 * The `#pageHeader` scrolled state (glass header on scroll) is also
 * handled here so every standalone page shares one script.
 * Reduced-motion users and no-JS visitors get static, fully visible
 * content (guarded via prefers-reduced-motion and the .js-reveal
 * opt-in class added below).
 */
(function () {
  'use strict';

  var reduceMotion = window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // ============================================================
  // Sticky header state (kept from the previous revision)
  // ============================================================
  var pageHeader = document.getElementById('pageHeader');
  var SCROLLED_CLASSES = [
    'glass',
    'shadow-[0_8px_30px_rgb(0_0_0/0.04)]',
    'border-b',
    'border-slate-200/50'
  ];

  function syncHeaderState() {
    if (!pageHeader) return;
    var scrolled = window.scrollY > 20;
    for (var i = 0; i < SCROLLED_CLASSES.length; i++) {
      pageHeader.classList.toggle(SCROLLED_CLASSES[i], scrolled);
    }
    pageHeader.classList.toggle('bg-transparent', !scrolled);
  }

  // ============================================================
  // Scroll progress bar
  // ============================================================
  var progressBar = document.getElementById('dimProgressBar');

  function syncProgressBar() {
    if (!progressBar) return;
    var doc = document.documentElement;
    var max = doc.scrollHeight - window.innerHeight;
    var ratio = max > 0 ? Math.min(1, window.scrollY / max) : 0;
    progressBar.style.transform = 'scaleX(' + ratio + ')';
  }

  function onScroll() {
    syncHeaderState();
    syncProgressBar();
  }

  // ============================================================
  // Scroll reveal
  // ============================================================
  function initReveal() {
    var items = document.querySelectorAll('[data-reveal]');
    if (!items.length) return;

    if (reduceMotion || !('IntersectionObserver' in window)) {
      for (var i = 0; i < items.length; i++) {
        items[i].classList.add('is-visible');
      }
      return;
    }

    document.documentElement.classList.add('js-reveal');

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });

    for (var j = 0; j < items.length; j++) {
      observer.observe(items[j]);
    }
  }

  // ============================================================
  // Count-up numbers
  // ============================================================
  function initCounters() {
    var items = document.querySelectorAll('[data-counter]');
    if (!items.length) return;

    function formatValue(value) {
      return Math.round(value).toLocaleString('id-ID');
    }

    function animate(el) {
      var target = parseFloat(el.getAttribute('data-counter')) || 0;
      var suffix = el.getAttribute('data-suffix') || '';
      if (reduceMotion) {
        el.textContent = formatValue(target) + suffix;
        return;
      }
      var duration = 1600;
      var start = null;

      function step(ts) {
        if (start === null) start = ts;
        var p = Math.min(1, (ts - start) / duration);
        var eased = 1 - Math.pow(1 - p, 3);
        el.textContent = formatValue(target * eased) + suffix;
        if (p < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
    }

    if (!('IntersectionObserver' in window)) {
      for (var i = 0; i < items.length; i++) animate(items[i]);
      return;
    }

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          animate(entry.target);
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.4 });

    for (var j = 0; j < items.length; j++) {
      observer.observe(items[j]);
    }
  }

  // ============================================================
  // Pointer tilt
  // ============================================================
  function initTilt() {
    var items = document.querySelectorAll('[data-tilt]');
    if (!items.length || reduceMotion) return;
    var fine = window.matchMedia && window.matchMedia('(pointer: fine)').matches;
    if (!fine) return;

    for (var i = 0; i < items.length; i++) (function (el) {
      var max = parseFloat(el.getAttribute('data-tilt')) || 6;
      var raf = null;

      el.addEventListener('pointermove', function (e) {
        var rect = el.getBoundingClientRect();
        var px = (e.clientX - rect.left) / rect.width - 0.5;
        var py = (e.clientY - rect.top) / rect.height - 0.5;
        if (raf) cancelAnimationFrame(raf);
        raf = requestAnimationFrame(function () {
          el.style.transform =
            'perspective(900px) rotateX(' + (-py * max).toFixed(2) + 'deg) rotateY(' + (px * max).toFixed(2) + 'deg)';
        });
      });

      el.addEventListener('pointerleave', function () {
        if (raf) cancelAnimationFrame(raf);
        el.style.transform = '';
      });
    })(items[i]);
  }

  // ============================================================
  // Scroll parallax
  // ============================================================
  function initParallax() {
    var items = document.querySelectorAll('[data-parallax]');
    if (!items.length || reduceMotion) return;

    var ticking = false;

    function update() {
      ticking = false;
      var vh = window.innerHeight;
      for (var i = 0; i < items.length; i++) {
        var el = items[i];
        var speed = parseFloat(el.getAttribute('data-parallax')) || 0.2;
        var parent = el.closest('section') || el.parentElement || document.body;
        var rect = parent.getBoundingClientRect();
        var offset = (rect.top + rect.height / 2 - vh / 2) * -speed;
        el.style.transform = 'translate3d(0,' + offset.toFixed(1) + 'px,0)';
      }
    }

    function onScrollParallax() {
      if (!ticking) {
        ticking = true;
        requestAnimationFrame(update);
      }
    }

    window.addEventListener('scroll', onScrollParallax, { passive: true });
    window.addEventListener('resize', onScrollParallax, { passive: true });
    update();
  }

  // ============================================================
  // FAQ accordion
  // ============================================================
  function initAccordion() {
    var groups = document.querySelectorAll('[data-accordion]');
    if (!groups.length) return;

    for (var i = 0; i < groups.length; i++) (function (group) {
      var items = group.querySelectorAll('.dim-acc');
      for (var j = 0; j < items.length; j++) {
        (function (item) {
          var head = item.querySelector('.dim-acc-head');
          if (!head) return;
          head.setAttribute('aria-expanded', 'false');
          head.addEventListener('click', function () {
            var isOpen = item.classList.contains('open');
            for (var k = 0; k < items.length; k++) {
              items[k].classList.remove('open');
              var otherHead = items[k].querySelector('.dim-acc-head');
              if (otherHead) otherHead.setAttribute('aria-expanded', 'false');
            }
            if (!isOpen) {
              item.classList.add('open');
              head.setAttribute('aria-expanded', 'true');
            }
          });
        })(items[j]);
      }
    })(groups[i]);
  }

  // ============================================================
  // Nav scrollspy
  // ============================================================
  function initScrollSpy() {
    var links = document.querySelectorAll('a[data-spy]');
    if (!links.length || !('IntersectionObserver' in window)) return;

    var map = {};
    for (var i = 0; i < links.length; i++) {
      var href = links[i].getAttribute('href') || '';
      if (href.charAt(0) !== '#') continue;
      var section = document.getElementById(href.slice(1));
      if (section) map[href.slice(1)] = links[i];
    }
    if (!Object.keys(map).length) return;

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        var link = map[entry.target.id];
        if (!link) return;
        if (entry.isIntersecting) {
          for (var key in map) {
            if (map[key] !== link) map[key].classList.remove('dim-nav-active');
          }
          link.classList.add('dim-nav-active');
        }
      });
    }, { rootMargin: '-30% 0px -60% 0px' });

    Object.keys(map).forEach(function (id) {
      observer.observe(document.getElementById(id));
    });
  }

  // ============================================================
  // Boot
  // ============================================================
  if (reduceMotion) {
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  } else {
    initReveal();
    initCounters();
    initTilt();
    initParallax();
    initAccordion();
    initScrollSpy();
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }
})();
