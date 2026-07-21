# Plugin LoA (Letter of Authorization) — OJS 3.3

## Struktur File

```
plugins/generic/loa/
├── index.php                                    # [DONE] Entry point
├── LoAPlugin.inc.php                            # [DONE] Main plugin class
├── LoASchemaMigration.inc.php                   # [DONE] DB migration
├── version.xml                                  # [DONE] Version metadata
├── classes/
│   ├── LoA.inc.php                              # [DONE] Data Object
│   └── LoADAO.inc.php                           # [DONE] Data Access Object
├── pages/
│   └── LoAHandler.inc.php                       # [DONE] Handler view & verification
├── locale/
│   ├── en_US/locale.po                          # [DONE] English
│   └── id_ID/locale.po                          # [DONE] Indonesian
└── templates/
    ├── loaTab.tpl                               # [DONE] Tab di workflow publication
    ├── loaView.tpl                              # [DONE] View LoA public
    └── loaVerification.tpl                      # [DONE] Verification form
```

## Database Table: `article_loa_codes`

| Column | Type | Keterangan |
|---|---|---|
| `loa_id` | BIGINT PK AUTO_INCREMENT | ID unik |
| `journal_id` | BIGINT NOT NULL | FK ke `journals` |
| `submission_id` | BIGINT NOT NULL UNIQUE | FK ke `submissions` |
| `unique_code` | VARCHAR(100) UNIQUE | Format: `LOA-{journal_id}-{submission_id}-{8random}` |
| `date_generated` | DATETIME | Waktu generate |
| `date_downloaded` | DATETIME NULL | Waktu terakhir di-download |
| `status` | VARCHAR(20) DEFAULT 'active' | `active`, `revoked` |

## Status Mekanisme

| Aksi | Status Lama | Status Baru |
|---|---|---|
| Generate baru | — | `active` |
| Regenerate | `active` → `revoked` | Insert baru `active` |
| Regenerate | `revoked` → tetap `revoked` | Insert baru `active` |

## Fitur & Hook

### 1. Workflow Tab (`Template::Workflow::Publication`)
- Tab "LoA" di panel Publication
- Tombol **Generate LoA Code** (jika blm ada)
- Tampilkan unique code + status (jika sudah ada)
- Tombol **Download LoA**
- Tombol **Regenerate** (konfirmasi)
- Tombol **Revoke** (non-aktifkan)

### 2. Public Article Detail (`Templates::Article::Details`)
- Icon/link download LoA
- Hanya muncul jika LoA status = `active`

### 3. View LoA (`/loa/view/{unique_code}`)
- Halaman publik menampilkan LoA
- Info artikel, kode unik, status
- Siap print

### 4. Verifikasi LoA (`/loa/verification`)
- GET: Form input kode
- POST: Validasi, tampilkan hasil

### 5. Install/Enable
- Cek table `article_loa_codes` → CREATE jika blm ada
- Register DAO & hooks
