# Backlink Audit Plugin (OJS 3.3)

Mencatat **siapa** yang memasukkan `<a href>` ke kolom teks kaya (TinyMCE),
di **jurnal apa**, di **field apa**, tautan **apa saja**, lengkap dengan IP
dan user agent — sehingga injeksi backlink spam dapat dilacak ke orangnya.

## Cara kerja (2 lapis)

1. **Presisi** — hook service (`Context::add/edit`, `Site::edit`,
   `Publication::add/edit`): menangkap perubahan settings via REST API dan
   UI, membandingkan link lama vs baru, mencatat +added/-removed.
   Mencakup `pageFooter`, header, custom taxonomy, abstrak, dll.
2. **Jaring luas** — hook router (`LoadHandler` + `LoadComponentHandler`):
   setiap POST halaman/komponen yang mengandung anchor dicatat sebagai
   `attempt`. Mencakup form profil (biografi), custom block, static pages,
   diskusi, dsb. — bahkan yang gagal tersimpan.

Tautan diklasifikasi: `EXTERNAL` (host berbeda dari server OJS) dan
`DANGEROUS` (skema javascript:/vbscript:/data:). Dedup 6 jam mencegah banjir
log dari simpanan berulang.

## Laporan

Akses menu **Backlink Audit** di sidebar backend, atau langsung:

```
/index.php/<journal-path>/securityaudit
```

- Journal Manager melihat entri jurnalnya sendiri.
- Site Admin melihat semua jurnal + tombol **Scan existing data** yang
  memeriksa isi database lama (`journal_settings`, `site_settings`,
  `plugin_settings`, `user_settings.biography`, `publication_settings`)
  untuk backlink yang dimasukkan sebelum plugin terpasang.
- **Export CSV** tersedia sebagai bukti.

## Tabel

`backlink_audit_log` (dibuat otomatis saat plugin diaktifkan).

## Catatan forensik serangan lama

Untuk backlink footer yang sudah terjadi sebelum plugin ini terpasang:
jalankan **Scan existing data** untuk menemukan field mana yang berisi spam,
lalu cocokkan waktunya dengan `event_log` / access log web server untuk
mengidentifikasi akun yang menyimpan.
