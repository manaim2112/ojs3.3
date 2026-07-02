{literal}
<!DOCTYPE html>
<html lang="id" class="scroll-smooth">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#1e3a8a">

  <meta name="description"
    content="Unit Akademik & Publikasi Resmi PT Brilliant Eduriset Global. Layanan kredibel OJS Jurnal Ilmiah (KBLI 58130 & 72209) dan Penerbitan Buku ISBN (KBLI 58110 & 18111) terintegrasi.">
  <meta name="keywords"
    content="Assyfa Journal, Assyfa Press, PT Brilliant Eduriset Global, Jurnal OJS, Penerbitan ISBN, KBLI 58130, KBLI 72209, KBLI 58110, KBLI 18111, publikasi dosen, sinta, scopus, monograf">
  <meta property="og:title" content="Unit Akademik &amp; Publikasi Ilmiah · PT Brilliant Eduriset Global">
  <meta property="og:description"
    content="Ekosistem hulu-ke-hilir publikasi ilmiah, riset soshum, penerbitan buku monograf ber-ISBN di bawah payung hukum PT Brilliant Eduriset Global.">
  <meta property="og:type" content="website">

  <title>Unit Akademik &amp; Publikasi Ilmiah · PT Brilliant Eduriset Global</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.bunny.net">
  <link
    href="https://fonts.bunny.net/css?family=instrument-sans:400,500,600,700|playfair-display:400,600,700,900|inter:300,400,500,600,700,800&amp;display=swap"
    rel="stylesheet">

  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    referrerpolicy="no-referrer">

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                        serif: ['Playfair Display', 'serif'],
                    },
                    colors: {
                        brand: {
                            50: '#eef2ff',
                            100: '#e0e7ff',
                            500: '#6366f1',
                            600: '#4f46e5',
                            700: '#4338ca',
                        }
                    }
                }
            }
        }
  </script>

  <!-- Custom Premium Styles -->
  <style>
    .grid-pattern {
      background-image:
        linear-gradient(to right, rgba(255, 255, 255, 0.05) 1px, transparent 1px),
        linear-gradient(to bottom, rgba(255, 255, 255, 0.05) 1px, transparent 1px);
      background-size: 40px 40px;
    }

    .glass {
      background: rgba(255, 255, 255, 0.85);
      backdrop-filter: saturate(180%) blur(16px);
      -webkit-backdrop-filter: saturate(180%) blur(16px);
    }

    .glass-dark {
      background: rgba(15, 23, 42, 0.75);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
    }

    .gradient-brand {
      background: linear-gradient(135deg, #1e3a8a 0%, #4f46e5 50%, #0d9488 100%);
    }

    .gradient-aurora {
      background:
        radial-gradient(60% 80% at 20% 20%, rgba(30, 58, 138, 0.5), transparent 60%),
        radial-gradient(50% 60% at 80% 30%, rgba(79, 70, 229, 0.4), transparent 60%),
        radial-gradient(60% 80% at 60% 90%, rgba(13, 148, 136, 0.4), transparent 60%),
        #070a13;
    }

    .gradient-text {
      background: linear-gradient(135deg, #1e3a8a 0%, #4f46e5 50%, #0d9488 100%);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }

    .ring-soft {
      box-shadow: 0 1px 0 0 rgba(255, 255, 255, 0.6) inset, 0 8px 24px -10px rgba(15, 23, 42, 0.12);
    }

    .blob {
      filter: blur(80px);
      opacity: 0.35;
    }

    @keyframes float-y {

      0%,
      100% {
        transform: translateY(0);
      }

      50% {
        transform: translateY(-12px);
      }
    }

    .floating {
      animation: float-y 6s ease-in-out infinite;
    }

    .marquee {
      display: flex;
      gap: 2.5rem;
      width: max-content;
      animation: marquee 35s linear infinite;
    }

    @keyframes marquee {
      from {
        transform: translateX(0);
      }

      to {
        transform: translateX(-50%);
      }
    }

    /* 3D Journal Interaction */
    .journal-container {
      perspective: 1200px;
      display: flex;
      flex-direction: column;
      height: 100%;
    }

    .journal-card {
      transition: transform 0.6s cubic-bezier(0.2, 0.8, 0.2, 1);
      transform-style: preserve-3d;
      display: flex;
      flex-direction: column;
      height: 100%;
    }

    .journal-container:hover .journal-card {
      transform: rotateY(-12deg) rotateX(4deg) translateY(-10px);
    }

    /* Standard Journal Ratio 3:4 Layout */
    .journal-cover {
      aspect-ratio: 3/4;
      width: 100%;
      border-radius: 4px 14px 14px 4px;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
      position: relative;
      overflow: hidden;
      background: #ffffff;
      border: 1px solid rgba(0, 0, 0, 0.06);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .journal-cover img {
      width: 100%;
      height: 100%;
      object-fit: fill;
      display: block;
    }

    .spine-effect {
      width: 14px;
      height: 100%;
      background: linear-gradient(to right, rgba(0, 0, 0, 0.18) 0%, rgba(0, 0, 0, 0.02) 50%, rgba(255, 255, 255, 0.05) 100%);
      position: absolute;
      left: 0;
      top: 0;
      z-index: 20;
    }

    .cover-gloss {
      position: absolute;
      inset: 0;
      background: linear-gradient(115deg, rgba(255, 255, 255, 0.15) 0%, rgba(255, 255, 255, 0) 40%, rgba(0, 0, 0, 0.03) 100%);
      pointer-events: none;
      z-index: 21;
    }

    .director-frame {
      position: relative;
      padding: 12px;
    }

    .director-frame::before {
      content: '';
      position: absolute;
      inset: 0;
      border: 2px solid #0d9488;
      border-radius: 2rem;
      transform: translate(-18px, -18px);
      z-index: -1;
      opacity: 0.4;
    }

    .hidden-el { display: none !important; }

    .no-scrollbar::-webkit-scrollbar {
      display: none;
    }
  </style>
</head>

<body class="antialiased text-slate-900 bg-[#fbfbfd]">

  <!-- Top Info Bar -->
  <div class="hidden lg:block bg-slate-950 text-slate-300 relative z-50">
    <div class="max-w-7xl mx-auto px-6 h-10 flex items-center justify-between text-xs font-medium">
      <div class="flex items-center gap-5">
        <span class="inline-flex items-center gap-2">
                    <span class="w-2 h-2 rounded-full bg-cyan-400 animate-pulse"></span>
        Call for Papers Jurnal Issue Vol. 4 No. 2 (2026) dibuka untuk Dosen &amp; Peneliti nasional
        </span>
        <span class="text-slate-500">|</span>
        <span class="inline-flex items-center gap-2">
                    <i class="far fa-building text-indigo-400"></i> Unit Akademik &amp; Litbang Resmi PT
                </span>
      </div>
      <div class="flex items-center gap-6">
        <a href="mailto:academic@assyfa.com" class="hover:text-white inline-flex items-center gap-2 transition">
          <i class="fas fa-envelope text-indigo-400"></i> academic@assyfa.com
        </a>
        <a href="tel:6289679670318" class="hover:text-white inline-flex items-center gap-2 transition">
          <i class="fas fa-phone-alt text-indigo-400"></i> +62 896-7967-0318
        </a>
      </div>
    </div>
  </div>

  <!-- Header Navigation -->
  <header id="pageHeader" class="sticky top-0 z-40 transition-all duration-300 w-full bg-transparent">
    <div class="h-1 gradient-brand"></div>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-20">

        <!-- Logo Brand -->
        <a href="https://assyfa.com/" class="flex items-center gap-3 group">
          <div
            class="w-10 h-10 rounded-xl bg-white overflow-hidden flex items-center justify-center shadow-md group-hover:scale-105 transition-transform duration-300">
            <img src="https://assyfa.com/storage/uploads/1/SWMgigsbuTMZLB9n8zJzhifJyeWrR43pJ3vFuLkY.jpg" alt="PB Logo" class="h-8 w-auto object-contain">
          </div>
          <div class="leading-tight">
            <p class="text-md sm:text-lg font-extrabold tracking-tight text-slate-950">PT Brilliant Eduriset
              Global</p>
            <p class="text-[9px] uppercase tracking-[0.2em] text-indigo-600 font-extrabold">ASSYFA GROUP
              EKOSISTEM</p>
          </div>
        </a>

        <!-- Desktop Nav Menu -->
        <nav class="hidden lg:flex items-center gap-2">
          <a href="https://assyfa.com/"
            class="px-4 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:text-indigo-600 hover:bg-indigo-50/50 transition-all">Beranda</a>
          <a href="/index.php/index/arsitektur-legal"
            class="px-4 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:text-indigo-600 hover:bg-indigo-50/50 transition-all">Arsitektur
            Legal</a>
          <a href="/index.php/index/kepemimpinan"
            class="px-4 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:text-indigo-600 hover:bg-indigo-50/50 transition-all">Kepemimpinan</a>
          <a href="#calculator-section"
            class="px-4 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:text-indigo-600 hover:bg-indigo-50/50 transition-all">Kalkulator</a>
        </nav>

        <!-- Action Utilities -->
        <div class="hidden lg:flex items-center gap-3">
          <button type="button" onclick="toggleSearchModal()" class="w-10 h-10 rounded-xl grid place-items-center text-slate-600 hover:text-indigo-600 hover:bg-indigo-50 transition-all">
                        <i class="fas fa-search"></i>
                    </button>

          <!-- Auth Section -->
          <div id="authSection" class="flex items-center gap-2">
            <div id="authLoggedOut" class="hidden-el flex items-center gap-2">
              <a href="javascript:void(0)" onclick="window.location.href=window._loginUrl" class="px-4 py-2.5 rounded-xl text-sm font-semibold text-slate-700 hover:text-indigo-600 hover:bg-indigo-50/50 transition-all">Masuk</a>
              <a href="javascript:void(0)" onclick="window.location.href=window._registerUrl" class="px-5 py-2.5 rounded-xl gradient-brand text-white text-sm font-semibold shadow-lg shadow-indigo-500/20 hover:shadow-xl hover:-translate-y-0.5 transition-all duration-300">Daftar</a>
            </div>
            <div id="authLoggedIn" class="hidden-el relative">
              <button id="authUserButton" class="flex items-center gap-2 px-3 py-1.5 rounded-xl hover:bg-indigo-50/50 transition-all" onclick="toggleAuthDropdown(event)">
                <img id="authAvatar" src="" alt="" class="w-8 h-8 rounded-full border-2 border-indigo-200">
                <span id="authUserName" class="text-sm font-semibold text-slate-700 max-w-[100px] truncate hidden md:inline"></span>
                <i id="authChevron" class="fas fa-chevron-down text-[10px] text-slate-500 transition-transform duration-200"></i>
              </button>
              <div id="authDropdown" class="hidden-el absolute right-0 top-full pt-2 w-56 z-50">
                <div class="rounded-2xl bg-white border border-slate-200 shadow-2xl p-2">
                  <div class="px-3 py-3 border-b border-slate-100 mb-1">
                    <p id="authDropdownName" class="font-semibold text-sm text-slate-900 truncate"></p>
                    <p id="authDropdownEmail" class="text-xs text-slate-500 truncate"></p>
                  </div>
                  <a href="javascript:void(0)" onclick="window.location.href=window._profileUrl" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm text-slate-700 hover:bg-indigo-50/50 transition">
                    <i class="fas fa-user-cog w-4 text-indigo-500"></i> Profil
                  </a>
                  <a href="javascript:void(0)" onclick="window.location.href=window._dashboardUrl" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm text-slate-700 hover:bg-indigo-50/50 transition">
                    <i class="fas fa-layer-group w-4 text-indigo-500"></i> Dashboard
                  </a>
                  <div class="border-t border-slate-100 mt-1 pt-1">
                    <a href="javascript:void(0)" onclick="window.location.href=window._logoutUrl" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm text-red-600 hover:bg-red-50/50 transition">
                      <i class="fas fa-sign-out-alt w-4"></i> Keluar
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Mobile Action Utilities -->
        <div class="lg:hidden flex items-center gap-2">
          <button type="button" onclick="toggleSearchModal()" class="w-10 h-10 rounded-xl grid place-items-center text-slate-700 bg-slate-100/80 hover:bg-slate-100">
                        <i class="fas fa-search"></i>
                    </button>
          <button type="button" onclick="openMobileMenu()" class="w-10 h-10 rounded-xl grid place-items-center text-slate-700 bg-slate-100/80 hover:bg-slate-100">
                        <i class="fas fa-bars text-lg"></i>
                    </button>
        </div>
      </div>
    </div>
  </header>

  <!-- Mobile Navigation Menu (Drawer) -->
  <div id="mobileMenuOverlay" class="hidden-el fixed inset-0 z-50 lg:hidden" role="dialog" aria-modal="true">
    <div id="mobileMenuBackdrop" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm"></div>

    <aside id="mobileMenuDrawer"
      class="fixed inset-y-0 right-0 h-full w-[88%] max-w-sm bg-white shadow-2xl flex flex-col z-50 transform transition duration-300 ease-in-out translate-x-full">
      <div class="flex items-center justify-between px-5 h-20 border-b border-slate-100 shrink-0">
        <a href="https://assyfa.com/" class="flex items-center gap-3">
          <img src="https://assyfa.com/storage/uploads/1/SWMgigsbuTMZLB9n8zJzhifJyeWrR43pJ3vFuLkY.jpg" alt="Logo" class="h-8 w-auto">
          <span class="font-bold tracking-tight text-slate-900 text-sm">Brilliant Eduriset Global</span>
        </a>
        <button onclick="closeMobileMenu()" class="w-10 h-10 rounded-xl grid place-items-center text-slate-500 hover:bg-slate-100 transition-all">
                    <i class="fas fa-times"></i>
                </button>
      </div>

      <div class="flex-1 overflow-y-auto px-3 py-4 space-y-4">
        <ul class="space-y-1">
          <li><a href="https://assyfa.com/" onclick="closeMobileMenu()"
              class="block px-3 py-3 rounded-xl text-sm font-semibold text-slate-800 hover:bg-slate-50">Beranda</a>
          </li>
          <li><a href="/index.php/index/arsitektur-legal" onclick="closeMobileMenu()"
              class="block px-3 py-3 rounded-xl text-sm font-semibold text-slate-800 hover:bg-slate-50">Arsitektur
              Legal</a></li>
          <li><a href="/index.php/index/kepemimpinan" onclick="closeMobileMenu()"
              class="block px-3 py-3 rounded-xl text-sm font-semibold text-slate-800 hover:bg-slate-50">Kepemimpinan</a>
          </li>
          <li><a href="#calculator-section" onclick="closeMobileMenu()"
              class="block px-3 py-3 rounded-xl text-sm font-semibold text-slate-800 hover:bg-slate-50">Kalkulator
              Buku</a></li>
        </ul>

        <div id="mobileAuthLoggedOut" class="pt-4 border-t border-slate-100 space-y-2">
          <p class="text-[11px] uppercase tracking-widest text-slate-400 font-bold px-3 mb-1">Akun</p>
          <a href="javascript:void(0)" onclick="closeMobileMenu(); window.location.href=window._loginUrl"
            class="flex items-center gap-3 w-full px-4 py-3 rounded-xl border border-slate-200 text-sm font-semibold text-slate-700 hover:bg-indigo-50 transition-all">
            <span class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 grid place-items-center shrink-0"><i class="fas fa-sign-in-alt text-xs"></i></span>
            <span><span class="block">Masuk</span><span class="block text-[11px] font-normal text-slate-500">Login ke akun Anda</span></span>
          </a>
          <a href="javascript:void(0)" onclick="closeMobileMenu(); window.location.href=window._registerUrl"
            class="flex items-center gap-3 w-full px-4 py-3 rounded-xl border border-slate-200 text-sm font-semibold text-slate-700 hover:bg-indigo-50 transition-all">
            <span class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 grid place-items-center shrink-0"><i class="fas fa-user-plus text-xs"></i></span>
            <span><span class="block">Daftar</span><span class="block text-[11px] font-normal text-slate-500">Buat akun baru</span></span>
          </a>
        </div>
        <div id="mobileAuthLoggedIn" class="hidden-el pt-4 border-t border-slate-100 space-y-2">
          <div class="flex items-center gap-3 px-3 mb-3">
            <img id="mobileAuthAvatar" src="" alt="" class="w-10 h-10 rounded-full border-2 border-indigo-200">
            <div>
              <p id="mobileAuthName" class="font-semibold text-sm text-slate-900"></p>
              <p id="mobileAuthEmail" class="text-xs text-slate-500"></p>
            </div>
          </div>
          <a href="javascript:void(0)" onclick="closeMobileMenu(); window.location.href=window._profileUrl"
            class="flex items-center gap-3 w-full px-4 py-3 rounded-xl border border-slate-200 text-sm font-semibold text-slate-700 hover:bg-indigo-50 transition-all">
            <span class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 grid place-items-center shrink-0"><i class="fas fa-user-cog text-xs"></i></span>
            <span><span class="block">Profil</span><span class="block text-[11px] font-normal text-slate-500">Pengaturan akun</span></span>
          </a>
          <a href="javascript:void(0)" onclick="closeMobileMenu(); window.location.href=window._dashboardUrl"
            class="flex items-center gap-3 w-full px-4 py-3 rounded-xl border border-slate-200 text-sm font-semibold text-slate-700 hover:bg-indigo-50 transition-all">
            <span class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 grid place-items-center shrink-0"><i class="fas fa-layer-group text-xs"></i></span>
            <span><span class="block">Dashboard</span><span class="block text-[11px] font-normal text-slate-500">Kelola publikasi</span></span>
          </a>
          <a href="javascript:void(0)" onclick="closeMobileMenu(); window.location.href=window._logoutUrl"
            class="flex items-center gap-3 w-full px-4 py-3 rounded-xl border border-red-200 text-sm font-semibold text-red-600 hover:bg-red-50 transition-all">
            <span class="w-8 h-8 rounded-lg bg-red-50 text-red-500 grid place-items-center shrink-0"><i class="fas fa-sign-out-alt text-xs"></i></span>
            <span><span class="block">Keluar</span><span class="block text-[11px] font-normal text-slate-500">Logout dari sistem</span></span>
          </a>
        </div>
      </div>

      <div class="px-5 py-5 border-t border-slate-100 shrink-0 bg-slate-50">
        <a href="https://wa.me/6289679670318" target="_blank"
          class="w-full inline-flex items-center justify-center gap-2 py-3 px-4 rounded-xl bg-emerald-500 text-white text-xs font-bold shadow-lg hover:bg-emerald-600 transition">
          <i class="fab fa-whatsapp text-md"></i>
          Hubungi Tim Litbang (WhatsApp)
        </a>
      </div>
    </aside>
  </div>

  <!-- Search Modal -->
  <div id="searchModalOverlay" class="hidden-el fixed inset-0 z-50" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeSearchModal()"></div>
    <div class="fixed inset-0 flex items-start justify-center pt-[15vh]">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg mx-4 overflow-hidden" onclick="event.stopPropagation()">
        <div class="p-4 border-b border-slate-100">
          <input id="searchModalInput" type="text" placeholder="Cari layanan akademik..." autocomplete="off"
            class="w-full text-lg font-semibold text-slate-900 outline-none placeholder:text-slate-400" oninput="filterSearchItems()">
        </div>
        <div id="searchResults" class="max-h-80 overflow-y-auto p-2 space-y-1"></div>
        <div class="p-3 border-t border-slate-100 text-[10px] text-slate-400 text-center">
          Tekan <kbd class="px-1.5 py-0.5 bg-slate-100 rounded font-mono font-bold text-slate-600">ESC</kbd> untuk tutup
        </div>
      </div>
    </div>
  </div>

  <!-- Main Content -->
  <main class="relative overflow-hidden">

    <!-- Hero Section -->
    <section class="relative overflow-hidden gradient-aurora text-white">
      <div class="absolute inset-0 grid-pattern opacity-35 mix-blend-overlay"></div>

      <div class="absolute -top-40 -left-40 w-[28rem] h-[28rem] rounded-full bg-indigo-900/60 blob"></div>
      <div class="absolute -bottom-40 -right-40 w-[32rem] h-[32rem] rounded-full bg-cyan-900/50 blob"></div>

      <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-16 pb-28 lg:pt-24 lg:pb-36">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">

          <!-- Hero Content Left -->
          <div class="lg:col-span-7 space-y-8">
            <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/10 border border-white/15 text-xs font-semibold tracking-wide">
                            <span class="w-2.5 h-2.5 rounded-full bg-cyan-400 animate-pulse"></span>
            PT Brilliant Eduriset Global - SK Kemenkumham RI 2025
            </span>

            <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold leading-[1.08] tracking-tight">
              Ekosistem Integrasi
              <span class="block mt-2">
                                <span class="bg-gradient-to-r from-cyan-300 via-indigo-200 to-teal-300 bg-clip-text text-transparent">
                                    Diseminasi Riset &amp; Buku ISBN.
                                </span>
              </span>
            </h1>

            <p class="text-md sm:text-lg text-indigo-100/90 max-w-xl leading-relaxed">
              Memfasilitasi publikasi ilmiah dosen dan peneliti nasional secara tepercaya lewat
              pengelolaan sistem OJS multidisiplin serta penerbitan karya ilmiah terdaftar ISBN resmi
              Perpustakaan Nasional RI.
            </p>

            <!-- Highlight KBLI Boxes -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 max-w-xl">
              <div class="p-3 bg-white/5 border border-white/10 rounded-xl flex items-center gap-3">
                <span class="w-8 h-8 rounded-lg bg-indigo-500/25 text-indigo-300 flex items-center justify-center font-bold text-xs">OJS</span>
                <div class="text-xs">
                  <p class="font-extrabold text-white">Assyfa Journal</p>
                  <p class="text-slate-400 text-[10px]">KBLI 58130 &amp; 72209 (Litbang Soshum)</p>
                </div>
              </div>
              <div class="p-3 bg-white/5 border border-white/10 rounded-xl flex items-center gap-3">
                <span class="w-8 h-8 rounded-lg bg-teal-500/25 text-teal-300 flex items-center justify-center font-bold text-xs">ISBN</span>
                <div class="text-xs">
                  <p class="font-extrabold text-white">Assyfa Press</p>
                  <p class="text-slate-400 text-[10px]">KBLI 58110 &amp; 18111 (Cetak Umum)</p>
                </div>
              </div>
            </div>

            <div class="flex flex-col sm:flex-row gap-4">
              <a href="#journal"
                class="inline-flex items-center justify-center gap-2 px-8 py-4 rounded-2xl bg-white text-slate-950 font-bold shadow-lg shadow-black/20 hover:-translate-y-0.5 transition-all duration-300 text-sm">
                Jelajahi Katalog Jurnal
                <i class="fas fa-arrow-right text-xs"></i>
              </a>
              <a href="https://wa.me/6282245549135" target="_blank"
                class="inline-flex items-center justify-center gap-2 px-8 py-4 rounded-2xl border border-white/30 hover:bg-white/10 font-bold transition-all duration-300 text-sm">
                <i class="fab fa-whatsapp text-emerald-300 text-lg"></i>
                Submit Manuskrip Jurnal
              </a>
            </div>
          </div>

          <!-- Hero Visual Widget Right (Dashboard Preview) -->
          <div class="lg:col-span-5">
            <div class="relative">
              <div
                class="absolute inset-0 -m-6 rounded-[2.5rem] bg-gradient-to-br from-indigo-500/10 to-transparent blur-2xl">
              </div>

              <div class="relative rounded-[2.5rem] glass-dark border border-white/10 p-6 shadow-2xl space-y-6">
                <div class="flex items-center justify-between text-xs text-indigo-200/80">
                  <div class="flex gap-1.5">
                    <span class="w-2.5 h-2.5 rounded-full bg-rose-400"></span>
                    <span class="w-2.5 h-2.5 rounded-full bg-amber-400"></span>
                    <span class="w-2.5 h-2.5 rounded-full bg-emerald-400"></span>
                  </div>
                  <span class="font-mono bg-white/10 px-2 py-0.5 rounded text-[10px]">Portal Aktivitas Aktif</span>
                </div>

                <div class="space-y-4 text-xs">
                  <div class="p-4 bg-slate-900 rounded-xl border border-slate-800 space-y-2">
                    <div class="flex justify-between items-center">
                      <span class="text-indigo-400 font-extrabold uppercase text-[10px]">Indeksasi Global</span>
                      <span class="bg-emerald-500/20 text-emerald-400 text-[9px] px-1.5 py-0.5 rounded font-mono font-bold">Metadata Aktif</span>
                    </div>
                    <p class="text-white font-semibold">Integrasi Crossref DOI &amp; Google Scholar
                    </p>
                    <div class="flex gap-2 pt-1 text-[10px] text-slate-400 font-mono">
                      <span>$h\text{-index} \ge 12$</span>
                      <span>•</span>
                      <span>$i10\text{-index} \ge 24$</span>
                    </div>
                  </div>

                  <!-- Live Activity Feed -->
                  <div class="p-3 bg-slate-900/50 rounded-xl border border-slate-800 flex items-center gap-3">
                    <div class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></div>
                    <div class="flex-1">
                      <p class="text-[10px] text-slate-400 font-semibold">Status ISBN Terbaru
                        Perpustakaan Nasional</p>
                      <p class="text-white font-bold text-[11px]">Buku Monograf &quot;Metode
                        Soshum Pascasarjana&quot; Terbit</p>
                    </div>
                  </div>
                </div>

                <div class="rounded-xl bg-white/10 border border-white/10 p-4 flex items-center gap-4">
                  <div
                    class="w-10 h-10 rounded-lg bg-cyan-500/20 text-cyan-300 flex items-center justify-center text-lg">
                    <i class="fas fa-shield-halved"></i>
                  </div>
                  <div class="flex-1 text-xs">
                    <p class="font-extrabold text-white">Publikasi Sesuai Regulasi DIKTI</p>
                    <p class="text-indigo-200/80">Sertifikat Hak Cipta, Peer-Review Ganda, dan Bebas
                      Plagiarisme.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Stats Overlay Banner -->
      <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-12 -mt-12">
        <div
          class="rounded-3xl glass border border-slate-200/50 p-6 grid grid-cols-2 md:grid-cols-4 gap-6 shadow-xl text-slate-900">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-indigo-50 text-indigo-600 grid place-items-center font-bold shadow-sm">
              <i class="fas fa-file-invoice text-md"></i>
            </div>
            <div>
              <p class="text-xl sm:text-2xl font-extrabold text-slate-950"><span id="statArticles">2,400</span>+</p>
              <p class="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Artikel Jurnal
                Terbit</p>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-cyan-50 text-cyan-600 grid place-items-center font-bold shadow-sm">
              <i class="fas fa-user-tie text-md"></i>
            </div>
            <div>
              <p class="text-xl sm:text-2xl font-extrabold text-slate-950"><span id="statReviewerEditor">120</span>+</p>
              <p class="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Reviewer &amp;
                Editor</p>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 grid place-items-center font-bold shadow-sm">
              <i class="fas fa-book-bookmark text-md"></i>
            </div>
            <div>
              <p class="text-xl sm:text-2xl font-extrabold text-slate-950">450+</p>
              <p class="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Buku Ber-ISBN Resmi
              </p>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <div
              class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 grid place-items-center font-bold shadow-sm">
              <i class="fas fa-certificate text-md"></i>
            </div>
            <div>
              <p class="text-xl sm:text-2xl font-extrabold text-slate-950">100%</p>
              <p class="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Kepatuhan KBLI
                &amp; HKI</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Partner Banner Marquee -->
    <section class="py-10 bg-white border-y border-slate-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6">
        <p class="text-center text-xs uppercase tracking-[0.25em] font-bold text-slate-400 mb-6">Mitra Integrasi
          Metadata &amp; Kampus Riset</p>
        <div class="overflow-hidden w-full relative">
          <div class="marquee py-2">
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-book-atlas text-indigo-500"></i> Perpustakaan Nasional RI
            </div>
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-magnifying-glass text-violet-500"></i> Crossref Metadata Search
            </div>
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-graduation-cap text-cyan-500"></i> Google Scholar Index
            </div>
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-building-columns text-amber-500"></i> LPPM Universitas Negeri
            </div>
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-circle-nodes text-rose-500"></i> ORCID ID Connected
            </div>

            <!-- Duplicated for Infinite Loop -->
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-book-atlas text-indigo-500"></i> Perpustakaan Nasional RI
            </div>
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-magnifying-glass text-violet-500"></i> Crossref Metadata Search
            </div>
            <div
              class="shrink-0 px-6 py-3 rounded-xl bg-slate-50 border border-slate-100 text-slate-600 font-bold text-sm tracking-wide flex items-center gap-2">
              <i class="fas fa-graduation-cap text-cyan-500"></i> Google Scholar Index
            </div>
          </div>
        </div>
      </div>
    </section>

{/literal}
<script>window._journalsData = {journals_json};</script>
<script>window._authData = {auth_data_json}; window._loginUrl = "{url page='login'}"; window._registerUrl = "{url page='user' op='register'}"; window._logoutUrl = "{url page='login' op='signOut'}"; window._profileUrl = "{url page='user' op='profile'}"; window._dashboardUrl = "{url page='submissions'}";</script>
<script>window._siteStats = {site_stats_json};</script>
{literal}
    <!-- Dynamic Journal Catalogue -->
    <section id="journal" class="py-24 lg:py-32 bg-white relative border-t border-slate-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

        <!-- Section Header -->
        <div class="flex flex-col lg:flex-row lg:items-end justify-between mb-16 gap-6">
          <div class="max-w-2xl space-y-4">
            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold uppercase tracking-wider">
                            Verified Journal Directory
                        </span>
            <h2 class="text-3xl sm:text-4xl font-extrabold tracking-tight text-slate-900 leading-tight">
              Katalog Jurnal Internasional Resmi &amp; Terpercaya
            </h2>
            <p class="text-slate-600 text-sm sm:text-base leading-relaxed">
              Cari dan jelajahi daftar dewan jurnal ilmiah OJS kami. Kami menyediakan saluran rujukan
              berskala global bagi hasil pengkajian penelitian dosen, mahasiswa pascasarjana, dan
              institusi.
            </p>
          </div>
          <!-- View All Jurnal Selengkapnya -->
          <div class="shrink-0 flex flex-wrap gap-3">
            <a href="https://assyfa.com/journal-assyfa-international" target="_blank"
              class="inline-flex items-center gap-2 px-6 py-4 rounded-xl border-2 border-indigo-600 text-indigo-600 hover:bg-indigo-50 font-bold transition text-xs uppercase tracking-widest">
              <span>Lihat Semua Jurnal Selengkapnya</span>
              <i class="fas fa-arrow-up-right-from-square"></i>
            </a>
          </div>
        </div>

        <!-- Interactive Filters & Search Box -->
        <div class="bg-slate-50 border border-slate-200 rounded-[2rem] p-6 mb-16 space-y-6">
          <div class="relative w-full">
            <span class="absolute inset-y-0 left-0 pl-6 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-search text-lg"></i>
                        </span>
            <input id="journalSearchInput" type="text" oninput="filterJournals()" placeholder="Cari jurnal berdasarkan judul, akronim, atau fokus riset..."
                               class="block w-full pl-16 pr-8 py-5 bg-white border border-slate-200 rounded-2xl text-sm focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 outline-none transition-all shadow-inner font-medium">
          </div>

          <!-- Category Chips -->
          <div class="flex items-center gap-2 overflow-x-auto pb-2 no-scrollbar">
            <button id="filter-all" onclick="setJournalFilter('all')" class="filter-chip px-6 py-3.5 rounded-full text-[10px] font-black border uppercase tracking-widest transition-all">ALL ITEMS</button>
            <button id="filter-premium" onclick="setJournalFilter('premium')" class="filter-chip px-6 py-3.5 rounded-full text-[10px] font-black border uppercase tracking-widest transition-all">HIGH IMPACT</button>
            <button id="filter-engineering" onclick="setJournalFilter('engineering')" class="filter-chip px-6 py-3.5 rounded-full text-[10px] font-black border uppercase tracking-widest transition-all">ENGINEERING</button>
            <button id="filter-education" onclick="setJournalFilter('education')" class="filter-chip px-6 py-3.5 rounded-full text-[10px] font-black border uppercase tracking-widest transition-all">EDUCATION</button>
            <button id="filter-social" onclick="setJournalFilter('social')" class="filter-chip px-6 py-3.5 rounded-full text-[10px] font-black border uppercase tracking-widest transition-all">SOCIAL &amp; CULTURE</button>
          </div>
        </div>

        <!-- 3D Journal Grid -->
        <div id="journalGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-12 gap-y-24"></div>

        <!-- Empty State -->
        <div id="journalEmpty" class="hidden-el text-center py-20 bg-slate-50 rounded-3xl border border-dashed border-slate-200">
          <i class="far fa-face-frown text-slate-400 text-3xl mb-3 block"></i>
          <h3 class="text-lg font-black text-slate-600 mb-1">No matching academic records found</h3>
          <p class="text-slate-400 text-xs font-semibold">Silakan perkecil pencarian atau ubah filter chip di
            atas.</p>
        </div>

      </div>
    </section>

    <!-- Assyfa Press Section -->
    <section id="press" class="py-20 bg-white border-t border-slate-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
          <div class="lg:col-span-5 space-y-6">
            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-cyan-50 text-cyan-700 text-xs font-bold uppercase tracking-wider">
                            Assyfa Press (ISBN)
                        </span>
            <h2 class="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight leading-tight">
              Penerbitan Monograf, Buku Referensi, &amp; Buku Ajar ISBN Resmi Perpusnas
            </h2>
            <p class="text-slate-600 text-sm sm:text-base leading-relaxed">
              Wujudkan hasil penelitian hibah riset, disertasi, tesis, atau diktat perkuliahan Anda
              menjadi buku berkualitas profesional. Kami mendampingi dari penyesuaian gaya selingkung,
              perancangan layout standar Perpustakaan Nasional RI, hingga pencetakan fisik buku secara
              premium.
            </p>
            <div class="grid grid-cols-2 gap-4 pt-4 pb-4">
              <div class="flex items-center gap-2 text-xs font-bold text-slate-700">
                <i class="fas fa-barcode text-indigo-500 text-lg"></i> ISBN Resmi Perpustakaan Nasional
              </div>
              <div class="flex items-center gap-2 text-xs font-bold text-slate-700">
                <i class="fas fa-palette text-indigo-500 text-lg"></i> Jasa Desain Cover Premium
              </div>
              <div class="flex items-center gap-2 text-xs font-bold text-slate-700">
                <i class="fas fa-book-open-reader text-indigo-500 text-lg"></i> Format Monograf DIKTI
              </div>
              <div class="flex items-center gap-2 text-xs font-bold text-slate-700">
                <i class="fas fa-cloud-arrow-down text-indigo-500 text-lg"></i> eBook PDF Ber-ISBN
              </div>
            </div>

            <!-- Selengkapnya untuk Press -->
            <div class="pt-4 flex flex-wrap gap-3">
              <a href="https://press.assyfa.com/" target="_blank"
                class="inline-flex items-center gap-2 px-6 py-4 rounded-xl bg-cyan-600 text-white hover:bg-cyan-500 font-bold transition text-xs uppercase tracking-widest shadow-lg shadow-cyan-600/20">
                <span>Kunjungi Portal Assyfa Press Selengkapnya</span>
                <i class="fas fa-chevron-right text-xs"></i>
              </a>
            </div>
          </div>

          <div class="lg:col-span-7 bg-slate-50 border border-slate-200 rounded-[2.5rem] p-8 space-y-6">
            <h3 class="text-xl font-extrabold text-slate-950">Alur Penerbitan Assyfa Press</h3>

            <div class="space-y-4">
              <!-- Step 1 -->
              <div class="flex gap-4">
                <div
                  class="w-8 h-8 rounded-lg bg-indigo-600 text-white flex items-center justify-center font-bold text-xs shrink-0">
                  1</div>
                <div>
                  <h4 class="font-bold text-slate-900 text-sm">Konsultasi &amp; Pengiriman Manuskrip
                  </h4>
                  <p class="text-xs text-slate-500 mt-1">Unggah naskah kasar (monograf/referensi/buku
                    ajar) hasil riset LPPM atau hasil tesis Anda.</p>
                </div>
              </div>
              <!-- Step 2 -->
              <div class="flex gap-4">
                <div
                  class="w-8 h-8 rounded-lg bg-indigo-600 text-white flex items-center justify-center font-bold text-xs shrink-0">
                  2</div>
                <div>
                  <h4 class="font-bold text-slate-900 text-sm">Proses Penyuntingan, Desain Cover,
                    &amp; Layout</h4>
                  <p class="text-xs text-slate-500 mt-1">Tim desainer dan penyunting professional
                    Assyfa merancang jilid buku sesuai kaidah ilmiah Perpustakaan Nasional RI.</p>
                </div>
              </div>
              <!-- Step 3 -->
              <div class="flex gap-4">
                <div
                  class="w-8 h-8 rounded-lg bg-indigo-600 text-white flex items-center justify-center font-bold text-xs shrink-0">
                  3</div>
                <div>
                  <h4 class="font-bold text-slate-900 text-sm">Registrasi ISBN Perpustakaan Nasional
                    RI</h4>
                  <p class="text-xs text-slate-500 mt-1">Kami mengurus pendaftaran barcode ISBN resmi
                    atas nama korporasi CV. Bimbingan Belajar Assyfa (KBLI 58110).</p>
                </div>
              </div>
              <!-- Step 4 -->
              <div class="flex gap-4">
                <div
                  class="w-8 h-8 rounded-lg bg-indigo-600 text-white flex items-center justify-center font-bold text-xs shrink-0">
                  4</div>
                <div>
                  <h4 class="font-bold text-slate-900 text-sm">Cetak Bukti Terbit &amp; Pengiriman
                  </h4>
                  <p class="text-xs text-slate-500 mt-1">Produksi cetak fisik premium (soft cover/hard
                    cover) dan penyerahan karya terbit ke Perpusnas sesuai undang-undang.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Dynamic Portal Simulator & Cost Calculator (Interactive Sandbox) -->
    <section id="calculator-section" class="py-20 lg:py-28 bg-slate-950 text-white relative">
      <div class="absolute inset-0 grid-pattern opacity-10"></div>
      <div
        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 rounded-full bg-indigo-500/20 blob">
      </div>

      <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center max-w-3xl mx-auto mb-16">
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 text-indigo-300 text-xs font-bold uppercase tracking-wider">
                        Interactive Academic Console
                    </span>
          <h2 class="mt-4 text-3xl sm:text-4xl font-extrabold tracking-tight">
            Simulasikan Riset &amp; Kalkulasikan
            <span class="bg-gradient-to-r from-indigo-300 via-purple-200 to-cyan-300 bg-clip-text text-transparent">Biaya Penerbitan Buku</span>
          </h2>
          <p class="mt-3 text-slate-400 text-sm sm:text-base">
            Gunakan konsol interaktif di bawah ini untuk menguji kemiripan karya ilmiah Anda atau
            mengestimasikan investasi cetak buku ber-ISBN secara real-time.
          </p>
        </div>

        <!-- Simulator Console Wrapper -->
        <div id="consoleWrapper" class="bg-slate-900 border border-slate-800 rounded-3xl shadow-2xl p-4 sm:p-8 max-w-4xl mx-auto">

          <!-- Tab Selector -->
          <div class="flex flex-wrap gap-2 border-b border-slate-800 pb-6 mb-6">
            <button id="tab-jurnal" onclick="setActivePortal('jurnal')"
                                class="console-tab flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all bg-indigo-600 text-white">
                            <i class="fas fa-file-shield"></i> Simulator Peer-Review Jurnal
                        </button>
            <button id="tab-press" onclick="setActivePortal('press')"
                                class="console-tab flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all bg-slate-800 text-slate-400 hover:bg-slate-700/80">
                            <i class="fas fa-calculator"></i> Estimator Cetak Buku Monograf
                        </button>
          </div>

          <!-- Screen Content 1: Journal Simulator -->
          <div id="screen-jurnal" class="space-y-6">
            <div class="flex justify-between items-center">
              <div>
                <h4 class="text-md sm:text-lg font-bold">Simulator Evaluasi Manuskrip Ilmiah</h4>
                <p class="text-[11px] text-slate-400">Verifikasi Keselarasan Format Jurnal OJS &amp;
                  Ambang Turnitin Similiarity</p>
              </div>
              <span class="px-3 py-1 rounded-full text-[10px] bg-indigo-500/20 text-indigo-300 font-bold border border-indigo-500/30">OJS Suite 3.4</span>
            </div>

            <div id="simulator-idle" class="space-y-4">
              <div class="space-y-2">
                <label class="block text-xs font-bold text-slate-400">Judul Karya Tulis Ilmiah (KTI)</label>
                <input id="paperTitle" type="text" oninput="updateSimButton()" placeholder="Contoh: Model Evaluasi Sosial-Kultural Pasca-Bencana Sesuai KBLI 72209..."
                                       class="w-full bg-slate-950/60 border border-slate-800 rounded-xl p-3 text-sm text-white focus:border-indigo-500 outline-none">
              </div>
              <div class="space-y-2">
                <label class="block text-xs font-bold text-slate-400">Abstrak (Bahasa Indonesia / Inggris)</label>
                <textarea id="paperAbstract" oninput="updateSimButton()" rows="3" placeholder="Tuliskan latar belakang, metode penelitian, hasil, dan simpulan riset Anda..."
                                          class="w-full bg-slate-950/60 border border-slate-800 rounded-xl p-3 text-sm text-white focus:border-indigo-500 outline-none"></textarea>
              </div>

              <button id="simStartBtn" onclick="startSimulation()"
                                    class="w-full bg-indigo-600 hover:bg-indigo-500 disabled:bg-slate-800 disabled:text-slate-500 text-white font-bold p-3 rounded-xl text-sm transition-all">
                                Simulasikan Tinjauan Editor &amp; Turnitin Plagiarism
                            </button>
            </div>

            <!-- Simulation Loading State -->
            <div id="simulator-processing" class="hidden-el py-12 text-center space-y-4">
              <i class="fas fa-spinner animate-spin text-3xl text-indigo-500"></i>
              <p class="text-sm font-semibold text-slate-300">Menjalankan simulasi Turnitin API &amp;
                Pemetaan Keyword Bidang Penelitian...</p>
            </div>

            <!-- Simulation Finished State -->
            <div id="simulator-completed" class="hidden-el bg-slate-950/50 border border-slate-800 p-5 rounded-2xl space-y-4">
              <div class="flex items-center justify-between border-b border-slate-800 pb-3">
                <span class="text-xs font-bold text-emerald-400"><i class="fas fa-circle-check"></i> Simulasi Selesai</span>
                <button onclick="resetSimulation()" class="text-xs bg-slate-800 hover:bg-slate-700 px-3 py-1 rounded text-slate-300">Coba Naskah Lain</button>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="p-4 bg-slate-900 rounded-xl border border-slate-800 space-y-1">
                  <p class="text-[10px] text-slate-400 font-bold uppercase">Skor Kemiripan
                    (Similarity)</p>
                  <div class="flex items-baseline gap-2">
                    <span id="similarityScore" class="text-2xl font-extrabold text-emerald-400"></span>
                    <span class="text-[10px] text-slate-400">(Ambang Batas Maksimal $20\%$)</span>
                  </div>
                  <p id="similarityPass" class="text-[10px] text-emerald-300 font-semibold">✓ Lolos Turnitin check</p>
                  <p id="similarityFail" class="text-[10px] text-amber-300 font-semibold hidden-el">! Disarankan parafrase bagian abstrak</p>
                </div>

                <div class="p-4 bg-slate-900 rounded-xl border border-slate-800 space-y-1">
                  <p class="text-[10px] text-slate-400 font-bold uppercase">Rekomendasi Publikasi</p>
                  <p id="suggestedJournal" class="text-xs font-bold text-white mt-1">Assyfa Multi-disciplinary Science Journal (ASJ)</p>
                  <p class="text-[9px] text-indigo-300">Cocok dengan KBLI 72209 (Sosial Humaniora)</p>
                </div>
              </div>

              <div class="pt-2 text-xs flex gap-3 text-slate-300 leading-relaxed">
                <i class="fas fa-info-circle text-indigo-400 mt-1"></i>
                <span>Hasil simulasi menunjukkan naskah Anda berpotensi besar diterbitkan secara cepat (Fast LoA). Ajukan naskah asli Anda ke editor resmi via WhatsApp untuk mendapatkan Letter of Acceptance dalam 2x24 jam kerja.</span>
              </div>

              <a id="waJournalLink" href="https://wa.me/6282245549135?text=Halo%20Assyfa%20Academic,%20saya%20ingin%20mengajukan%20artikel%20jurnal%20dengan%20judul:" target="_blank"
                class="block w-full bg-indigo-600 hover:bg-indigo-500 text-white font-bold p-3 rounded-xl text-center text-xs transition duration-300">
                Ajukan Publikasi Jurnal via WhatsApp
              </a>
            </div>
          </div>

          <!-- Screen Content 2: Press Calculator -->
          <div id="screen-press" class="hidden-el space-y-6">
            <div class="flex justify-between items-center">
              <div>
                <h4 class="text-md sm:text-lg font-bold">Kalkulator Estimasi Penerbitan &amp; ISBN</h4>
                <p class="text-[11px] text-slate-400">Penerbitan Buku Sesuai Regulasi KBLI 58110 &amp;
                  Cetak 18111</p>
              </div>
              <span class="px-3 py-1 rounded-full text-[10px] bg-cyan-500/20 text-cyan-300 font-bold border border-cyan-500/30">Assyfa Press RI</span>
            </div>

            <div
              class="grid grid-cols-1 md:grid-cols-2 gap-6 bg-slate-950/40 p-5 rounded-2xl border border-slate-800/80">
              <div class="space-y-4">
                <!-- Type of Book -->
                <div class="space-y-2">
                  <span class="block text-xs font-bold text-slate-400">Kategori Jenis Buku</span>
                  <div class="grid grid-cols-2 gap-2">
                    <button id="bookType-monograf" onclick="setBookType('monograf')"
                                                class="book-type-btn p-2 border rounded-xl text-xs font-bold transition bg-cyan-500/20 border-cyan-500 text-cyan-300">Monograf DIKTI</button>
                    <button id="bookType-referensi" onclick="setBookType('referensi')"
                                                class="book-type-btn p-2 border rounded-xl text-xs font-bold transition bg-slate-800/40 border-slate-700 text-slate-400">Buku Referensi / Ajar</button>
                  </div>
                </div>

                <!-- Pages Slider -->
                <div class="space-y-2">
                  <div class="flex justify-between text-xs">
                    <span class="text-slate-400 font-bold">Jumlah Halaman Manuskrip</span>
                    <span id="pageCountLabel" class="text-cyan-400 font-bold">120 Halaman</span>
                  </div>
                  <input id="pageCountSlider" type="range" min="50" max="450" step="10" oninput="updateCalculator()"
                                           class="w-full accent-cyan-500 bg-slate-800 h-1.5 rounded-lg appearance-none cursor-pointer">
                </div>

                <!-- Cover Option -->
                <div class="space-y-2">
                  <span class="block text-xs font-bold text-slate-400">Bahan Sampul (Cover Type)</span>
                  <div class="grid grid-cols-2 gap-2">
                    <button id="coverStyle-soft" onclick="setCoverStyle('soft')"
                                                class="cover-style-btn p-2 border rounded-xl text-xs font-bold transition bg-cyan-500/20 border-cyan-500 text-cyan-300">Soft Cover Premium</button>
                    <button id="coverStyle-hard" onclick="setCoverStyle('hard')"
                                                class="cover-style-btn p-2 border rounded-xl text-xs font-bold transition bg-slate-800/40 border-slate-700 text-slate-400">Hard Cover Jilid</button>
                  </div>
                </div>

                <!-- Quantity Slider -->
                <div class="space-y-2">
                  <div class="flex justify-between text-xs">
                    <span class="text-slate-400 font-bold">Volume / Jumlah Cetak Fisik</span>
                    <span id="copiesCountLabel" class="text-cyan-400 font-bold">50 Eksemplar</span>
                  </div>
                  <input id="copiesCountSlider" type="range" min="10" max="300" step="10" oninput="updateCalculator()"
                                           class="w-full accent-cyan-500 bg-slate-800 h-1.5 rounded-lg appearance-none cursor-pointer">
                </div>
              </div>

              <!-- Cost Output Card -->
              <div class="bg-cyan-500/10 border border-cyan-500/30 rounded-xl p-5 flex flex-col justify-between">
                <div class="space-y-3">
                  <span class="text-[10px] font-bold uppercase tracking-widest text-cyan-300 block">Investasi Penerbitan Lengkap</span>
                  <div class="text-3xl font-extrabold text-white">
                    Rp <span id="computedPrice">0</span>
                  </div>
                  <div class="text-[11px] text-slate-400 space-y-1.5 leading-relaxed">
                    <p class="font-bold text-slate-300">Paket Investasi Sudah Termasuk:</p>
                    <p>✓ Registrasi Barcode ISBN Perpustakaan Nasional</p>
                    <p>✓ Layout Standar Jurnal &amp; Monograf DIKTI</p>
                    <p>✓ Jasa Desain Cover Kustom &amp; Penyuntingan Ejaan</p>
                    <p>✓ Penyerahan Karya Terbit Fisik ke Deposito Perpusnas</p>
                  </div>
                </div>
                <a id="waPressLink" href="https://wa.me/6289679670318?text=Halo%20Assyfa%20Academic,%20saya%20tertarik%20penerbitan%20buku%20ISBN" target="_blank"
                  class="w-full bg-cyan-600 hover:bg-cyan-500 text-slate-950 font-extrabold p-3 rounded-xl text-center text-xs transition duration-300 block mt-4 text-white">
                  Ajukan Penerbitan ISBN via WhatsApp
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Why Choose Us -->
    <section class="py-20 lg:py-28 bg-[#f8fafc]">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center max-w-2xl mx-auto mb-16">
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-cyan-50 text-cyan-700 text-xs font-bold tracking-wide uppercase">
                        Keunggulan Mutu Akademik
                    </span>
          <h2 class="mt-4 text-3xl sm:text-4xl font-extrabold tracking-tight text-slate-900">
            Dirancang untuk Menunjang <span class="gradient-text">Karir Akademis Dosen &amp; Peneliti</span>
          </h2>
          <p class="mt-3 text-slate-600">
            Menyelaraskan regulasi terbaru Perpustakaan Nasional RI dan sistem pengolahan angka kredit
            ristekdikti secara presisi.
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            class="rounded-2xl bg-white border border-slate-200 p-6 hover:border-indigo-500/30 hover:shadow-xl transition duration-300">
            <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 grid place-items-center mb-4 text-lg">
              <i class="fas fa-barcode"></i>
            </div>
            <h3 class="font-extrabold text-slate-900 text-lg">ISBN Resmi Terlacak</h3>
            <p class="mt-2 text-sm text-slate-600 leading-relaxed">Pengurusan barcode ISBN dari Perpustakaan
              Nasional RI legal dan terdaftar di database penelusuran nasional.</p>
          </div>

          <div
            class="rounded-2xl bg-white border border-slate-200 p-6 hover:border-indigo-500/30 hover:shadow-xl transition duration-300">
            <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 grid place-items-center mb-4 text-lg">
              <i class="fas fa-shield-halved"></i>
            </div>
            <h3 class="font-extrabold text-slate-900 text-lg">Bebas Plagiasi Check</h3>
            <p class="mt-2 text-sm text-slate-600 leading-relaxed">Setiap naskah buku dan jurnal dikawal
              ketat menggunakan Turnitin premium guna menjamin keaslian orisinalitas riset.</p>
          </div>

          <div
            class="rounded-2xl bg-white border border-slate-200 p-6 hover:border-indigo-500/30 hover:shadow-xl transition duration-300">
            <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 grid place-items-center mb-4 text-lg">
              <i class="fas fa-microscope"></i>
            </div>
            <h3 class="font-extrabold text-slate-900 text-lg">Validasi Monograf DIKTI</h3>
            <p class="mt-2 text-sm text-slate-600 leading-relaxed">Perancangan tata letak layout disesuaikan
              secara presisi demi terpenuhinya rubrik penilaian angka kredit buku pegangan dosen.</p>
          </div>

          <div
            class="rounded-2xl bg-white border border-slate-200 p-6 hover:border-indigo-500/30 hover:shadow-xl transition duration-300">
            <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 grid place-items-center mb-4 text-lg">
              <i class="fas fa-share-nodes"></i>
            </div>
            <h3 class="font-extrabold text-slate-900 text-lg">Crossref Metadata Hub</h3>
            <p class="mt-2 text-sm text-slate-600 leading-relaxed">Pengelolaan penomoran DOI resmi Crossref,
              mempercepat pendeteksian sitasi dari berbagai belahan dunia digital.</p>
          </div>

          <div
            class="rounded-2xl bg-white border border-slate-200 p-6 hover:border-indigo-500/30 hover:shadow-xl transition duration-300">
            <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 grid place-items-center mb-4 text-lg">
              <i class="fas fa-award"></i>
            </div>
            <h3 class="font-extrabold text-slate-900 text-lg">Tim Editor Tersertifikasi</h3>
            <p class="mt-2 text-sm text-slate-600 leading-relaxed">Didukung editor handal, bersertifikat
              dalam penyuntingan naskah ilmiah berbahasa Indonesia &amp; Inggris.</p>
          </div>
        </div>
      </div>
    </section>
  </main>
  <div class="pkp_structure_main page_content" style="display:none"></div>
{/literal}

<script>
(function() {
  'use strict';

  // ===== STATE =====
  var journals = window._journalsData || [];
  var journalFilter = 'all';
  var activePortal = 'jurnal';

  // Calculator state
  var calcState = {
    pageCount: 120,
    coverStyle: 'soft',
    copiesCount: 50,
    bookType: 'monograf'
  };

  // ===== HEADER SCROLL EFFECT =====
  var pageHeader = document.getElementById('pageHeader');
  if (pageHeader) {
    window.addEventListener('scroll', function() {
      if (window.scrollY > 20) {
        pageHeader.classList.add('glass', 'shadow-[0_8px_30px_rgb(0_0_0/0.04)]', 'border-b', 'border-slate-200/50');
        pageHeader.classList.remove('bg-transparent');
      } else {
        pageHeader.classList.remove('glass', 'shadow-[0_8px_30px_rgb(0_0_0/0.04)]', 'border-b', 'border-slate-200/50');
        pageHeader.classList.add('bg-transparent');
      }
    }, { passive: true });
  }

  // ===== AUTH STATE =====
  (function() {
    var authData = window._authData;
    if (!authData) return;

    var loggedOut = document.getElementById('authLoggedOut');
    var loggedIn = document.getElementById('authLoggedIn');

    if (authData.user) {
      if (loggedOut) loggedOut.classList.add('hidden-el');
      if (loggedIn) loggedIn.classList.remove('hidden-el');

      var avatar = document.getElementById('authAvatar');
      var userName = document.getElementById('authUserName');
      var dropdownName = document.getElementById('authDropdownName');
      var dropdownEmail = document.getElementById('authDropdownEmail');
      if (avatar) avatar.src = authData.user.avatar;
      if (userName) userName.textContent = authData.user.fullName;
      if (dropdownName) dropdownName.textContent = authData.user.fullName;
      if (dropdownEmail) dropdownEmail.textContent = authData.user.email;

      var mobileAvatar = document.getElementById('mobileAuthAvatar');
      var mobileName = document.getElementById('mobileAuthName');
      var mobileEmail = document.getElementById('mobileAuthEmail');
      var mobileLoggedOut = document.getElementById('mobileAuthLoggedOut');
      var mobileLoggedIn = document.getElementById('mobileAuthLoggedIn');
      if (mobileAvatar) mobileAvatar.src = authData.user.avatar;
      if (mobileName) mobileName.textContent = authData.user.fullName;
      if (mobileEmail) mobileEmail.textContent = authData.user.email;
      if (mobileLoggedOut) mobileLoggedOut.classList.add('hidden-el');
      if (mobileLoggedIn) mobileLoggedIn.classList.remove('hidden-el');
    } else {
      if (loggedOut) loggedOut.classList.remove('hidden-el');
      if (loggedIn) loggedIn.classList.add('hidden-el');
    }
  })();

  document.addEventListener('click', function(e) {
    var dropdown = document.getElementById('authDropdown');
    var button = document.getElementById('authUserButton');
    if (!dropdown || !button) return;
    if (!button.contains(e.target) && !dropdown.classList.contains('hidden-el')) {
      dropdown.classList.add('hidden-el');
      var chevron = document.getElementById('authChevron');
      if (chevron) chevron.classList.remove('rotate-180');
    }
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      var dropdown = document.getElementById('authDropdown');
      if (dropdown && !dropdown.classList.contains('hidden-el')) {
        dropdown.classList.add('hidden-el');
        var chevron = document.getElementById('authChevron');
        if (chevron) chevron.classList.remove('rotate-180');
      }
    }
  });

  function toggleAuthDropdown(e) {
    if (e) e.stopPropagation();
    var dropdown = document.getElementById('authDropdown');
    var chevron = document.getElementById('authChevron');
    if (!dropdown) return;
    dropdown.classList.toggle('hidden-el');
    if (chevron) chevron.classList.toggle('rotate-180');
  }
  window.toggleAuthDropdown = toggleAuthDropdown;

  // ===== SITE STATS =====
  (function() {
    var stats = window._siteStats;
    if (!stats) return;
    var articleEl = document.getElementById('statArticles');
    var reviewerEl = document.getElementById('statReviewerEditor');
    if (articleEl && stats.articles) articleEl.textContent = stats.articles.toLocaleString();
    if (reviewerEl && stats.reviewerEditor) reviewerEl.textContent = stats.reviewerEditor.toLocaleString();
  })();

  // ===== MOBILE MENU =====
  var mobileOverlay = document.getElementById('mobileMenuOverlay');
  var mobileDrawer = document.getElementById('mobileMenuDrawer');
  var mobileBackdrop = document.getElementById('mobileMenuBackdrop');

  function openMobileMenu() {
    if (!mobileOverlay) return;
    mobileOverlay.classList.remove('hidden-el');
    setTimeout(function() {
      if (mobileDrawer) mobileDrawer.classList.remove('translate-x-full');
    }, 10);
    document.body.style.overflow = 'hidden';
  }

  function closeMobileMenu() {
    if (!mobileOverlay) return;
    if (mobileDrawer) mobileDrawer.classList.add('translate-x-full');
    setTimeout(function() {
      mobileOverlay.classList.add('hidden-el');
    }, 300);
    document.body.style.overflow = '';
  }

  if (mobileBackdrop) {
    mobileBackdrop.addEventListener('click', closeMobileMenu);
  }
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && mobileOverlay && !mobileOverlay.classList.contains('hidden-el')) {
      closeMobileMenu();
    }
  });

  window.openMobileMenu = openMobileMenu;
  window.closeMobileMenu = closeMobileMenu;

  // ===== SEARCH MODAL =====
  var searchOverlay = document.getElementById('searchModalOverlay');
  var searchInput = document.getElementById('searchModalInput');
  var searchResults = document.getElementById('searchResults');

  var searchItems = [
    { name: 'Submission Jurnal OJS Pascasarjana', cat: 'Assyfa Journal', href: '#journal' },
    { name: 'KBLI 58130 & KBLI 72209 Penulisan Riset', cat: 'Legalitas', href: '/index.php/index/arsitektur-legal' },
    { name: 'Penerbitan Monograf & Referensi ISBN', cat: 'Assyfa Press', href: '#press' },
    { name: 'Kalkulator Simulasi Biaya Cetak Umum', cat: 'Assyfa Press', href: '#calculator-section' },
    { name: 'Call For Papers & Konferensi Nasional 2026', cat: 'Events', href: '#conference' },
    { name: 'Sertifikat LoA & Layanan DOI Registered', cat: 'OJS Publishing', href: '#journal' },
    { name: 'Editor & Penelaah Sejawat Eksternal', cat: 'Litbang', href: '#journal' },
    { name: 'Jasa Cetak Umum KBLI 18111', cat: 'Cetak Umum', href: '/index.php/index/arsitektur-legal' }
  ];

  function toggleSearchModal() {
    if (!searchOverlay) return;
    var isHidden = searchOverlay.classList.contains('hidden-el');
    if (isHidden) {
      searchOverlay.classList.remove('hidden-el');
      if (searchInput) { searchInput.value = ''; searchInput.focus(); }
      filterSearchItems();
      document.body.style.overflow = 'hidden';
    } else {
      closeSearchModal();
    }
  }

  function closeSearchModal() {
    if (!searchOverlay) return;
    searchOverlay.classList.add('hidden-el');
    document.body.style.overflow = '';
  }

  function filterSearchItems() {
    if (!searchInput || !searchResults) return;
    var q = searchInput.value.toLowerCase().trim();
    var filtered = q ? searchItems.filter(function(i) { return i.name.toLowerCase().includes(q); }) : [];
    if (filtered.length === 0) {
      searchResults.innerHTML = '<div class="p-4 text-sm text-slate-400 text-center">Tidak ada hasil</div>';
      return;
    }
    var html = '';
    for (var i = 0; i < filtered.length; i++) {
      html += '<a href="' + filtered[i].href + '" onclick="closeSearchModal()" class="block p-3 rounded-xl hover:bg-slate-50 transition">'
        + '<span class="block text-sm font-bold text-slate-900">' + filtered[i].name + '</span>'
        + '<span class="block text-[10px] font-semibold text-indigo-600 uppercase tracking-wider">' + filtered[i].cat + '</span>'
        + '</a>';
    }
    searchResults.innerHTML = html;
  }

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && searchOverlay && !searchOverlay.classList.contains('hidden-el')) {
      closeSearchModal();
    }
  });

  window.toggleSearchModal = toggleSearchModal;
  window.closeSearchModal = closeSearchModal;
  window.filterSearchItems = filterSearchItems;

  // ===== JOURNAL CATALOGUE =====
  var journalGrid = document.getElementById('journalGrid');
  var journalEmpty = document.getElementById('journalEmpty');
  var journalSearchInput = document.getElementById('journalSearchInput');

  var chipDefaultClass = 'bg-white text-slate-700 hover:bg-slate-100 border-slate-200';
  var chipActiveClass = 'bg-indigo-600 text-white shadow-lg shadow-indigo-500/25 border-indigo-600';
  var chipBaseClass = 'px-6 py-3.5 rounded-full text-[10px] font-black border uppercase tracking-widest transition-all';

  function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
  }

  function renderJournals() {
    if (!journalGrid) return;
    var q = journalSearchInput ? journalSearchInput.value.toLowerCase().trim() : '';
    var filtered = [];
    for (var i = 0; i < journals.length; i++) {
      var pub = journals[i];
      var matchesFilter = journalFilter === 'all' || (pub.tag && pub.tag.indexOf(journalFilter) !== -1);
      var matchesSearch = q === '' || (pub.title && pub.title.toLowerCase().indexOf(q) !== -1) || (pub.abbr && pub.abbr.toLowerCase().indexOf(q) !== -1);
      if (matchesFilter && matchesSearch) {
        filtered.push(pub);
      }
    }

    if (filtered.length === 0) {
      journalGrid.innerHTML = '';
      if (journalEmpty) journalEmpty.classList.remove('hidden-el');
      return;
    }
    if (journalEmpty) journalEmpty.classList.add('hidden-el');

    var html = '';
    for (var j = 0; j < filtered.length; j++) {
      var p = filtered[j];
      var abbrSafe = p.abbr ? p.abbr.toLowerCase() : '';
      var url = 'https://journal.assyfa.com/index.php/' + encodeURIComponent(abbrSafe);
      var bgColor = p.color || '#1e3a8a';
      var theme = escapeHtml(p.theme || 'SCIENCE');
      var title = escapeHtml(p.title || '');
      var abbr = escapeHtml(p.abbr || '');
      var desc = escapeHtml(p.desc || '');
      var coverUrl = escapeHtml(p.coverUrl || '');
      html += '<div class="journal-container">'
        + '<div class="journal-card group">'
        + '<a href="' + url + '" target="_blank" class="block">'
        + '<div class="journal-cover shadow-2xl relative">'
        + '<div class="spine-effect"></div>'
        + '<div class="cover-gloss"></div>'
        + (coverUrl
          ? '<img src="' + coverUrl + '" alt="' + title + '" loading="lazy">'
          : '<div class="w-full h-full flex flex-col justify-between p-6 relative select-none text-left" style="background-color:' + bgColor + '">'
            + '<div class="relative z-10">'
            + '<div class="flex items-center gap-2 mb-4">'
            + '<span class="w-1.5 h-1.5 rounded-full bg-white"></span>'
            + '<span class="text-[9px] font-black text-white/80 uppercase tracking-widest">' + theme + '</span>'
            + '</div>'
            + '<h3 class="font-serif text-sm font-bold text-white leading-tight uppercase line-clamp-3">' + title + '</h3>'
            + '</div>'
            + '<div class="z-10 border-t border-white/20 pt-4">'
            + '<p class="text-[8px] opacity-60 font-black tracking-widest uppercase mb-0.5">Global Nexus</p>'
            + '<p class="text-[11px] font-extrabold text-white">' + abbr + ' / SER. 2026</p>'
            + '</div>'
            + '</div>')
        + '</div></a>'
        + '<div class="mt-8 px-2 space-y-3">'
        + '<div class="flex items-center gap-2">'
        + '<span class="w-2 h-2 rounded-full bg-teal-500 shadow-[0_0_10px_rgba(20,184,166,0.6)]"></span>'
        + '<span class="text-[9px] font-black text-slate-500 uppercase tracking-widest">Verified International Journal</span>'
        + '</div>'
        + '<h4 class="font-black text-md text-slate-950 group-hover:text-indigo-600 transition-all leading-snug line-clamp-2 uppercase">' + title + '</h4>'
        + '<p class="text-xs text-slate-500 leading-relaxed italic">'
        + '<span class="text-indigo-950 font-bold uppercase text-[9px] not-italic block mb-0.5">Focus &amp; Scope:</span>'
        + desc + '</p>'
        + '<div class="flex items-center justify-between border-t border-slate-100 pt-4">'
        + '<span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Released Quarterly</span>'
        + '<a href="' + url + '" target="_blank" class="text-xs font-black text-teal-600 hover:text-teal-700 underline underline-offset-4 decoration-2 transition-all">Explore Journal →</a>'
        + '</div></div></div></div>';
    }
    journalGrid.innerHTML = html;
  }

  function setJournalFilter(f) {
    journalFilter = f;
    var chips = document.querySelectorAll('.filter-chip');
    for (var i = 0; i < chips.length; i++) {
      chips[i].className = chipBaseClass + ' ' + chipDefaultClass;
    }
    var activeChip = document.getElementById('filter-' + f);
    if (activeChip) activeChip.className = chipBaseClass + ' ' + chipActiveClass;
    renderJournals();
  }

  function filterJournals() {
    renderJournals();
  }

  window.setJournalFilter = setJournalFilter;
  window.filterJournals = filterJournals;

  // Init journal filter
  setJournalFilter('all');

  // ===== CALCULATOR / SIMULATOR =====
  function setActivePortal(p) {
    activePortal = p;
    var screenJurnal = document.getElementById('screen-jurnal');
    var screenPress = document.getElementById('screen-press');
    var tabJurnal = document.getElementById('tab-jurnal');
    var tabPress = document.getElementById('tab-press');

    if (p === 'jurnal') {
      if (screenJurnal) screenJurnal.classList.remove('hidden-el');
      if (screenPress) screenPress.classList.add('hidden-el');
      if (tabJurnal) {
        tabJurnal.className = 'console-tab flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all bg-indigo-600 text-white';
        tabJurnal.classList.add('bg-indigo-600', 'text-white');
        tabJurnal.classList.remove('bg-slate-800', 'text-slate-400', 'hover:bg-slate-700/80');
      }
      if (tabPress) {
        tabPress.className = 'console-tab flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all bg-slate-800 text-slate-400 hover:bg-slate-700/80';
        tabPress.classList.add('bg-slate-800', 'text-slate-400');
        tabPress.classList.remove('bg-cyan-600', 'text-white');
      }
    } else {
      if (screenJurnal) screenJurnal.classList.add('hidden-el');
      if (screenPress) screenPress.classList.remove('hidden-el');
      if (tabPress) {
        tabPress.className = 'console-tab flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all bg-cyan-600 text-white';
        tabPress.classList.add('bg-cyan-600', 'text-white');
        tabPress.classList.remove('bg-slate-800', 'text-slate-400', 'hover:bg-slate-700/80');
      }
      if (tabJurnal) {
        tabJurnal.className = 'console-tab flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs sm:text-sm font-bold transition-all bg-slate-800 text-slate-400 hover:bg-slate-700/80';
        tabJurnal.classList.add('bg-slate-800', 'text-slate-400');
        tabJurnal.classList.remove('bg-indigo-600', 'text-white');
      }
    }
  }

  function startSimulation() {
    var titleInput = document.getElementById('paperTitle');
    var abstractInput = document.getElementById('paperAbstract');
    if (!titleInput || !abstractInput) return;
    if (!titleInput.value.trim() || !abstractInput.value.trim()) return;

    document.getElementById('simulator-idle').classList.add('hidden-el');
    document.getElementById('simulator-processing').classList.remove('hidden-el');
    document.getElementById('simulator-completed').classList.add('hidden-el');

    setTimeout(function() {
      var score = Math.floor(Math.random() * (22 - 8) + 8);
      document.getElementById('simulator-idle').classList.add('hidden-el');
      document.getElementById('simulator-processing').classList.add('hidden-el');
      document.getElementById('simulator-completed').classList.remove('hidden-el');

      var scoreEl = document.getElementById('similarityScore');
      if (scoreEl) {
        scoreEl.textContent = score + '%';
        scoreEl.className = 'text-2xl font-extrabold ' + (score <= 20 ? 'text-emerald-400' : 'text-amber-400');
      }
      var passEl = document.getElementById('similarityPass');
      var failEl = document.getElementById('similarityFail');
      if (passEl) passEl.classList.toggle('hidden-el', score > 20);
      if (failEl) failEl.classList.toggle('hidden-el', score <= 20);

      var waLink = document.getElementById('waJournalLink');
      if (waLink) {
        waLink.href = 'https://wa.me/6282245549135?text=Halo%20Assyfa%20Academic,%20saya%20ingin%20mengajukan%20artikel%20jurnal%20dengan%20judul:%20' + encodeURIComponent(titleInput.value);
      }
    }, 2500);
  }

  function resetSimulation() {
    document.getElementById('simulator-idle').classList.remove('hidden-el');
    document.getElementById('simulator-processing').classList.add('hidden-el');
    document.getElementById('simulator-completed').classList.add('hidden-el');
    var titleInput = document.getElementById('paperTitle');
    var abstractInput = document.getElementById('paperAbstract');
    if (titleInput) titleInput.value = '';
    if (abstractInput) abstractInput.value = '';
    updateSimButton();
  }

  function updateSimButton() {
    var titleInput = document.getElementById('paperTitle');
    var abstractInput = document.getElementById('paperAbstract');
    var btn = document.getElementById('simStartBtn');
    if (!btn || !titleInput || !abstractInput) return;
    if (titleInput.value.trim() && abstractInput.value.trim()) {
      btn.disabled = false;
      btn.classList.remove('bg-slate-800', 'text-slate-500');
    } else {
      btn.disabled = true;
      btn.classList.add('bg-slate-800', 'text-slate-500');
    }
  }

  // ===== CALCULATOR =====
  function updateCalculator() {
    var pageSlider = document.getElementById('pageCountSlider');
    var copiesSlider = document.getElementById('copiesCountSlider');
    calcState.pageCount = pageSlider ? parseInt(pageSlider.value, 10) : calcState.pageCount;
    calcState.copiesCount = copiesSlider ? parseInt(copiesSlider.value, 10) : calcState.copiesCount;

    var pageLabel = document.getElementById('pageCountLabel');
    var copiesLabel = document.getElementById('copiesCountLabel');
    if (pageLabel) pageLabel.textContent = calcState.pageCount + ' Halaman';
    if (copiesLabel) copiesLabel.textContent = calcState.copiesCount + ' Eksemplar';

    var basePageCost = calcState.pageCount * 110;
    var coverCost = calcState.coverStyle === 'hard' ? 30000 : 12000;
    var baseKBLI = calcState.bookType === 'monograf' ? 750000 : 500000;
    var total = (basePageCost + coverCost) * calcState.copiesCount + baseKBLI;

    var priceEl = document.getElementById('computedPrice');
    if (priceEl) priceEl.textContent = total.toLocaleString('id-ID');

    var waLink = document.getElementById('waPressLink');
    if (waLink) {
      waLink.href = 'https://wa.me/6289679670318?text=Halo%20Assyfa%20Academic,%20saya%20tertarik%20penerbitan%20buku%20ISBN%20dengan%20rincian:%20' + calcState.bookType + '%20' + calcState.pageCount + '%20halaman,%20' + calcState.coverStyle + '%20cover,%20sebanyak%20' + calcState.copiesCount + '%20eksemplar';
    }
  }

  function setBookType(type) {
    calcState.bookType = type;
    var btns = document.querySelectorAll('.book-type-btn');
    for (var i = 0; i < btns.length; i++) {
      btns[i].className = 'book-type-btn p-2 border rounded-xl text-xs font-bold transition bg-slate-800/40 border-slate-700 text-slate-400';
    }
    var activeBtn = document.getElementById('bookType-' + type);
    if (activeBtn) activeBtn.className = 'book-type-btn p-2 border rounded-xl text-xs font-bold transition bg-cyan-500/20 border-cyan-500 text-cyan-300';
    updateCalculator();
  }

  function setCoverStyle(style) {
    calcState.coverStyle = style;
    var btns = document.querySelectorAll('.cover-style-btn');
    for (var i = 0; i < btns.length; i++) {
      btns[i].className = 'cover-style-btn p-2 border rounded-xl text-xs font-bold transition bg-slate-800/40 border-slate-700 text-slate-400';
    }
    var activeBtn = document.getElementById('coverStyle-' + style);
    if (activeBtn) activeBtn.className = 'cover-style-btn p-2 border rounded-xl text-xs font-bold transition bg-cyan-500/20 border-cyan-500 text-cyan-300';
    updateCalculator();
  }

  window.setActivePortal = setActivePortal;
  window.startSimulation = startSimulation;
  window.resetSimulation = resetSimulation;
  window.updateSimButton = updateSimButton;
  window.updateCalculator = updateCalculator;
  window.setBookType = setBookType;
  window.setCoverStyle = setCoverStyle;

  // Init calculator
  updateCalculator();

})();
</script>

{include file="frontend/components/footer.tpl"}
