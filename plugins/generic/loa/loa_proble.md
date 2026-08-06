# Review Plugin LoA (plugins/generic/loa)

Tanggal review: 2026-08-06

## Ringkasan
Plugin generasi kode LoA (*Letter of Acceptance*) per artikel: generate/regenerate/revoke,
halaman publik, verifikasi, manajemen, dan popup keamanan. Struktur sudah rapi
(DAO, Form, Handler, template per-jurnal), namun ditemukan masalah keamanan,
logika, dan performa.

## Keamanan (prioritas tinggi)

1. **CSRF tidak dicek pada aksi workflow**
   - Lokasi: `pages/LoAHandler.inc.php:64-128` (`generate`, `regenerate`, `revoke`)
   - Hanya cek `isPost()`, tidak memanggil `checkCSRF()`.
   - Form di `templates/loaTab.tpl:29-38` juga tidak mengirim field `{csrf}`.
   - Kontras: `generateFromManagement`/`revokeFromManagement` sudah cek CSRF
     (`LoAHandler.inc.php:213,245`).

2. **Tidak memvalidasi kepemilikan submission di generate/regenerate/revoke**
   - Lokasi: `pages/LoAHandler.inc.php:75-127`
   - `submissionId` diambil dari user tanpa memastikan
     `submission->getData('contextId') == context->getId()`.
   - Metode management sudah melakukan validasi ini (`:224,256`), workflow belum.

3. **HTML mentah rawan XSS di popup keamanan**
   - Lokasi: `templates/loaSecurityPopup.tpl:165`, `classes/LoASecurityForm.inc.php:58`
   - `loaSecurityContent` disimpan dan dirender tanpa sanitasi (menampilkan HTML mentah).
   - `strip_tags(...,'<img><p>...')` di `LoAPlugin.inc.php:307` hanya untuk cek non-empty,
     bukan untuk sanitasi.

## Fungsional / logika

4. `view()` menampilkan LoA yang sudah revoked dan tetap memicu `markDownloaded`
   (`pages/LoAHandler.inc.php:38`).
5. `date_format` dipakai pada string datetime, bukan objek `DateTime`
   (`templates/journals/rjme/loaView.tpl:170,231`) — tanggal bisa tampil salah.
6. `{translate key="..."|default:"Tutup"}` — modifier `default` menempel ke key literal,
   bukan hasil terjemahan (`templates/loaSecurityPopup.tpl:168`).

## Performa

7. N+1 query di `_fromArticleRow` (`classes/LoADAO.inc.php:105-114`) untuk author + issue
   per baris pada daftar manajemen.
8. `countSql` memakai `$sql` yang mengandung `ORDER BY` untuk query hitung
   (`classes/LoADAO.inc.php:77`).

## Design / kebersihan

9. Hardcoded URL & data jurnal spesifik di `templates/journals/rjme/loaView.tpl`
   (header/indexing image, ISSN, nama universitas).
10. `unique_code` hanya index biasa, bukan unique constraint
    (`LoASchemaMigration.inc.php:22`).

## Rencana Fitur Baru: Template LoA di Database

Ringkasan keputusan (disetujui 2026-08-06):
- **Mesin render:** HTML + placeholder `{{...}}` (bukan Smarty).
- **Scope:** per jurnal (tiap jurnal punya set template sendiri).
- **Edit konten:** rich text editor.
- **Fallback:** bila belum ada template DB aktif, tetap pakai file `.tpl` lama.

Desain konkret:
1. **Tabel baru `loa_templates`**
   - `loa_template_id` (PK, autoIncrement), `journal_id`, `template_name`,
     `template_content` (LONGTEXT), `is_active` (bool), `date_modified`.
   - Satu template aktif per jurnal (dijaga dengan logika + setel `is_active=0` saat aktivasi).
2. **Kolom baru di `article_loa_codes`** (untuk audit loa yang sudah terbit):
   - `template_id` (nullable, FK ke `loa_templates.loa_template_id`).
   - `content_snapshot` (LONGTEXT) — snapshot **HTML hasil render final** saat generate
     (substitusi placeholder sudah dilakukan), dikompresi dengan `gzcompress()` +
     `base64_encode()` untuk hemat ruang karena jumlah LoA bisa banyak.
   - Saat `generate`/`regenerate`, simpan `template_id` aktif + snapshot render saat itu.
   - Setelah terbit, `view()` memakai snapshot (decompress `base64_decode`+`gzinflate`)
     — dokumen lama tidak berubah walau template diedit/dihapus/diganti.
3. **Migration**: tambah buat tabel `loa_templates` + kolom `template_id`,`content_snapshot`
   di `LoASchemaMigration` + panggil di `runMigration()`/`runUpgradeMigration()` dan bump `version.xml`.
4. **DAO baru**: `LoATemplateDAO` — `insert`, `update`, `delete`, `getByJournalId`,
   `getActiveByJournalId`, `activate`. Perluas `LoADAO` untuk kolom template_id/snapshot.
5. **Substitusi placeholder** `{{article_title}}`, `{{authors}}`, `{{journal_name}}`,
   `{{unique_code}}`, `{{date_generated}}`, `{{status}}`, `{{editor_in_chief_name}}`,
   `{{editor_in_chief_title}}`, `{{base_url}}`, `{{current_locale}}`.
6. **Wrapper render baru** `templates/loaDbView.tpl` (full HTML chrome + `@media print`
   + button print) dengan slot `{$templateHtml}`. `LoA::view()` urutan:
   - punya `content_snapshot` → tampilkan snapshot;
   - tidak → template aktif dari DB → substitusi placeholder → render wrapper;
   - tidak ada template aktif → fallback file `.tpl` (per jurnal / default) seperti sekarang.
7. **UI admin**: di `manage()` plugin tambah operasi daftar/tambah/edit/hapus/aktifkan
   template; gunakan rich text editor untuk `template_content`; aktifkan checkbox/radio.
   Batasi peran ke Manager/Admin.
8. **Security**: reuse `sanitizeHtml()` untuk `template_content` saat simpan; verifikasi
   `{{...}}` hanya token yang dikenal.

### Status: RENGGANG — menunggu eksekusi.

## Rencana Eksekusi Terpadu (urutan kerja)

Dependensi: fitur template DB + #4 dikerjakan bersama di `view()`.
Urutan aman:

**Fase 1 — Fondasi data**
- [x] 1. Migration: tabel `loa_templates` + kolom `template_id` & `content_snapshot` di
  `article_loa_codes`; integrasikan di `runMigration()`/`runUpgradeMigration()`.
- [x] 2. `LoATemplate.inc.php` (DataObject) + `LoATemplateDAO.inc.php`
  (insert/update/delete/getByJournalId/getActiveByJournalId/activate).
- [x] 3. Perluas `LoADAO`: insert/update baca kolom `template_id` & `content_snapshot`
  (+ helper kompresi/dekompresi), sertakan di `generateCode`/`regenerateCode`.

**Fase 2 — Render + fitur terkait (#4)**
- [x] 4. Helper substitusi placeholder `{{...}}` (token aman) di plugin/class baru.
- [x] 5. `LoAHandler::view()` ditulis ulang (satu kali):
  - snapshot ada → tampilkan snapshot;
  - tidak → template aktif DB → substitusi → wrapper `loaDbView.tpl`;
  - tidak ada → fallback file `.tpl` (per jurnal / default);
  - **#4 sekaligus**: snapshot/loa revoked → tampilkan penanda revoked & jangan
    `markDownloaded` untuk status revoked.
- [x] 6. Wrapper `templates/loaDbView.tpl` (chrome HTML + `@media print` + button print).

**Fase 3 — UI admin**
- [x] 7. Form + halaman kelola template (`LoATemplateForm`, ops baru di `manage()` /
  halaman backend) — daftar, tambah, edit, hapus, aktifkan; rich text editor.
  (`loa`/`templates`, `loa`/`templateForm`, `loa`/`activateTemplate`, `loa`/`deleteTemplate`
  + menu backend "LoA Templates".)
- [x] 8. Batasi peran Manager/Admin; `sanitizeHtml()` saat simpan (dipusatkan di
  `LoAPlugin::sanitizeHtml`, dipakai juga oleh `LoASecurityForm`).

**Fase 4 — Rapi & verifikasi**
- [x] 9. Bump `version.xml` (1.0.0.1 → 1.0.1.0).
- [x] 10. Lint semua file (`php -l`), cek registrasi DAO & hook, update `loa_proble.md`.

Catatan implementasi tambahan:
- Snapshot dibuat saat generate/regenerate (3 jalur: workflow + management) via
  `LoAPlugin::generateLoAWithSnapshot()` / `regenerateLoAWithSnapshot()`; menyimpan
  `template_id` + HTML ter-render (terkompresi). LoA lama yang belum punya snapshot
  di-backfill pakai template aktif saat generate berikutnya.

**Opsional (independen, kapan saja):**
- [x] #5 perbaiki `date_format` di `templates/journals/rjme/loaView.tpl` (fallback).
  Diubah memakai variabel `loaDateGeneratedFormatted` (format di PHP).
- [x] #6 `default` modifier di `loaSecurityPopup.tpl` (hapus modifier, pakai key saja).
- [x] #7 N+1 query di `_fromArticleRow` → cache per-request untuk issue & authors.
- [x] #8 `countSql` terpisah tanpa ORDER BY (query penghasil baris `SELECT s.submission_id`).
- [x] #9 hardcoded URL/ISSN/univ di `rjme/loaView.tpl` → 4 setting baru plugin
  (`loaHeaderImageUrl`, `loaIndexingImageUrl`, `loaIssn`, `loaUniversityName`).
- [x] #10 unique constraint `unique_code` (fresh: unique; upgrade: drop index lama +
  add unique via try/catch).

## Status Perbaikan
- [x] #1 CSRF workflow (checkCSRF di generate/regenerate/revoke + {csrf} di loaTab.tpl)
- [x] #2 Validasi kepemilikan submission (contextId) di 3 handler workflow
- [x] #3 Sanitasi XSS popup keamanan (sanitizeHtml di LoASecurityForm)
- [x] #4 view() revoked: banner revoked & tidak markDownloaded utk revoked
- [x] #5 date_format salah di template rjme
- [x] #6 default modifier di loaSecurityPopup
- [x] #7 N+1 query di daftar manajemen
- [x] #8 countSql dengan ORDER BY
- [x] #9 hardcoded data jurnal di template rjme
- [x] #10 unique constraint unique_code
