# Entity Relationship Diagram (ERD) & Skema Database - ValidIn
### Basis Data Pengesahan Dokumen Digital &bull; HIMATIF Fakultas Teknik UNTIDAR

Dokumen ini mendeskripsikan rancangan skema basis data relasional MySQL untuk sistem ValidIn, yang mendukung alur penandatanganan berjenjang 4 pejabat serta catatan disposisi izin fasilitas kampus.

---

## 📊 Diagram Relasi Entitas (Mermaid)

```mermaid
erDiagram
    ORGANIZATIONS ||--o{ USERS : "menaungi"
    ORGANIZATIONS ||--o{ DOCUMENTS : "mengeluarkan"
    USERS ||--o{ DOCUMENTS : "mengajukan"
    DOCUMENTS ||--o{ DOCUMENT_VERSIONS : "memiliki riwayat file"
    DOCUMENTS ||--o{ APPROVAL_LOGS : "mencatat jejak audit"
    DOCUMENTS ||--o| DOCUMENT_VERIFICATIONS : "memiliki token QR sah"
    USERS ||--o{ APPROVAL_LOGS : "memberikan tindakan"
    DOCUMENTS ||--o| DISPOSITION_NOTES : "memiliki instruksi satpam"

    ORGANIZATIONS {
        bigint id PK
        varchar name "HIMATIF UNTIDAR / Fakultas Teknik"
        varchar code "HIMATIF-FT"
        text address "Jl. Kapten Suparman 39 Magelang"
        timestamps timestamps
    }

    USERS {
        bigint id PK
        bigint organization_id FK
        varchar name "Nama Lengkap Pejabat"
        varchar nim_nip UK "NPM Mahasiswa / NIP Dosen"
        varchar email UK "Email resmi UNTIDAR"
        varchar password "Bcrypt hash"
        enum role "sekretaris, ketua_pelaksana, ketua_himatif, wadek, satpam, admin"
        varchar signature_path "File paraf / tanda tangan digital"
        timestamps timestamps
    }

    DOCUMENTS {
        bigint id PK
        bigint organization_id FK
        bigint secretary_id FK "Sekretaris Panitia (Penyusun)"
        bigint pelaksana_id FK "Ketua Pelaksana (Penanggung Jawab)"
        varchar document_number UK "Contoh: 026.a/E/PM/HIMATIF/UNTIDAR/IX/2026"
        varchar title "Perihal surat permohonan"
        varchar event_name "Nama kegiatan ormawa"
        varchar event_date_text "Hari & tanggal pelaksanaan"
        varchar event_time_text "Waktu izin peminjaman"
        varchar location "Lokasi gedung / ruangan"
        text borrowed_items "Rincian ruang kelas / sound system"
        varchar contact_person "WhatsApp panitia (+62 851-8470-9553)"
        enum type "Peminjaman Gedung, Peminjaman Alat, Izin Kegiatan"
        enum current_status "draft, menunggu_sekretaris, menunggu_pelaksana, menunggu_ketua, menunggu_pembina, disetujui, revisi, ditolak"
        timestamps timestamps
    }

    DOCUMENT_VERSIONS {
        bigint id PK
        bigint document_id FK
        int version_number
        varchar file_path
        varchar file_name
        bigint file_size
        varchar file_hash "SHA-256 integritas berkas"
        timestamps timestamps
    }

    APPROVAL_LOGS {
        bigint id PK
        bigint document_id FK
        bigint user_id FK "Pejabat penindak"
        varchar role_at_action "sekretaris / pelaksana / ketua_himatif / wadek"
        enum action "sign_secretary, sign_pelaksana, approve_himatif, approve_wadek, request_revision, reject"
        varchar previous_status
        varchar new_status
        text notes "Catatan review / revisi"
        timestamps timestamps
    }

    DISPOSITION_NOTES {
        bigint id PK
        bigint document_id FK UK
        bigint wadek_id FK "Pejabat pemberi disposisi"
        text instruction_text "Catatan instruksi satpam/sarpras"
        timestamp issued_at
        timestamps timestamps
    }

    DOCUMENT_VERIFICATIONS {
        bigint id PK
        bigint document_id FK UK
        varchar qr_token UK "UUID v4 unik untuk scan satpam"
        varchar hash_sha256 "Sidik jari kriptografis 64-karakter"
        varchar signed_file_path "Path PDF fisik ber-QR"
        timestamp signed_at
        bigint signed_by_wadek_id FK
        timestamps timestamps
    }
```

---

## 📋 Data Dictionary (Tabel Utama)

### 1. `users`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier unik pengguna |
| `organization_id` | `BIGINT UNSIGNED NULLABLE` (FK) | Relasi ke `organizations.id` |
| `name` | `VARCHAR(255)` | Nama lengkap (contoh: *Hanif Abdillah Alatas*, *Dr. Sigit Iswahyudi*) |
| `nim_nip` | `VARCHAR(50) UNIQUE` | Nomor Pokok Mahasiswa / Nomor Induk Pegawai |
| `email` | `VARCHAR(255) UNIQUE` | Email resmi kampus (`@students.untidar.ac.id` / `@untidar.ac.id`) |
| `password` | `VARCHAR(255)` | Hash kata sandi |
| `role` | `ENUM('sekretaris', 'ketua_pelaksana', 'ketua_himatif', 'wadek', 'satpam', 'admin')` | Hak akses otorisasi |

### 2. `documents`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier dokumen |
| `organization_id` | `BIGINT UNSIGNED` (FK) | Relasi ke organisasi HIMATIF UNTIDAR |
| `secretary_id` | `BIGINT UNSIGNED` (FK) | Sekretaris Panitia yang menyusun surat |
| `pelaksana_id` | `BIGINT UNSIGNED` (FK) | Ketua Pelaksana penanggung jawab acara |
| `document_number`| `VARCHAR(100) UNIQUE` | Nomor registrasi surat resmi UNTIDAR |
| `title` | `VARCHAR(255)` | Perihal surat permohonan |
| `event_name` | `VARCHAR(255)` | Nama agenda / kegiatan |
| `event_date_text`| `VARCHAR(255)` | Hari dan tanggal pelaksanaan |
| `event_time_text`| `VARCHAR(100)` | Jam peminjaman ruangan |
| `location` | `VARCHAR(255)` | Lokasi (contoh: *Gedung FT 03 Ruang E.03.3.04 - E.03.3.06*) |
| `borrowed_items` | `TEXT` | Rincian barang / ruangan yang dipinjam |
| `contact_person` | `VARCHAR(100)` | Kontak narahubung panitia (+62 851-8470-9553 Ilyasa) |
| `current_status` | `ENUM('draft', 'menunggu_sekretaris', 'menunggu_pelaksana', 'menunggu_ketua', 'menunggu_pembina', 'disetujui', 'revisi', 'ditolak')` | Status aktif dalam alur persetujuan |

### 3. `disposition_notes`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier catatan disposisi |
| `document_id` | `BIGINT UNSIGNED UNIQUE` (FK) | Relasi 1-to-1 ke surat |
| `wadek_id` | `BIGINT UNSIGNED` (FK) | Pejabat pemberi disposisi (Wakil Dekan FT) |
| `instruction_text`| `TEXT` | Catatan tertulis untuk petugas satpam/sarpras (Contoh: *ACC: Satpam mhn bantuan buka gd & kls*) |
| `issued_at` | `TIMESTAMP` | Waktu penerbitan disposisi |

### 4. `document_verifications`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier verifikasi QR |
| `document_id` | `BIGINT UNSIGNED UNIQUE` (FK) | Dokumen yang disahkan |
| `qr_token` | `VARCHAR(64) UNIQUE` | Token UUID unik pemindaian satpam |
| `hash_sha256` | `VARCHAR(64)` | Digest integritas dokumen |
| `signed_file_path`| `VARCHAR(500)` | Berkas fisik PDF berstempel QR resmi |
| `signed_by_wadek_id` | `BIGINT UNSIGNED` (FK) | Pengesahan akhir oleh Wadek FT |
| `signed_at` | `TIMESTAMP` | Waktu persetujuan final |
