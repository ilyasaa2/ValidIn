# Entity Relationship Diagram (ERD) & Skema Database - ValidIn

Dokumen ini mendeskripsikan rancangan skema basis data MySQL untuk sistem ValidIn.

---

## 📊 Diagram Relasi Entitas (Mermaid)

```mermaid
erDiagram
    ORGANIZATIONS ||--o{ USERS : "memiliki anggota"
    ORGANIZATIONS ||--o{ DOCUMENTS : "menaungi dokumen"
    USERS ||--o{ DOCUMENTS : "mengajukan"
    DOCUMENTS ||--o{ DOCUMENT_VERSIONS : "memiliki versi"
    DOCUMENTS ||--o{ APPROVAL_LOGS : "mencatat jejak persetujuan"
    DOCUMENTS ||--o| DOCUMENT_VERIFICATIONS : "memiliki token QR pengesahan"
    USERS ||--o{ APPROVAL_LOGS : "memberikan keputusan"

    ORGANIZATIONS {
        bigint id PK
        varchar name
        varchar code
        text description
        timestamps timestamps
    }

    USERS {
        bigint id PK
        bigint organization_id FK
        varchar name
        varchar nim_nip UK
        varchar email UK
        varchar password
        enum role "mahasiswa, ketua, pembina, admin"
        timestamps timestamps
    }

    DOCUMENTS {
        bigint id PK
        bigint organization_id FK
        bigint user_id FK "pengaju"
        varchar document_number UK
        varchar title
        varchar event_name
        date event_date
        enum type "proposal, surat_izin, lpj, lainnya"
        enum current_status "draft, menunggu_ketua, menunggu_pembina, disetujui, revisi, ditolak"
        timestamps timestamps
    }

    DOCUMENT_VERSIONS {
        bigint id PK
        bigint document_id FK
        int version_number
        varchar file_path
        varchar file_name
        bigint file_size
        varchar file_hash "SHA-256 integritas file"
        timestamps timestamps
    }

    APPROVAL_LOGS {
        bigint id PK
        bigint document_id FK
        bigint user_id FK "peninjau"
        enum action "approve, request_revision, reject"
        varchar previous_status
        varchar new_status
        text notes "catatan revisi / alasan penolakan"
        timestamps timestamps
    }

    DOCUMENT_VERIFICATIONS {
        bigint id PK
        bigint document_id FK UK
        varchar qr_token UK "UUID v4 unik untuk URL scan"
        varchar signed_file_path "path PDF dengan stempel QR"
        timestamp signed_at
        bigint signed_by_pembina_id FK
        timestamps timestamps
    }
```

---

## 📋 Data Dictionary (Tabel Utama)

### 1. `users`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier unik pengguna |
| `organization_id` | `BIGINT UNSIGNED NULLABLE` (FK) | Relasi ke organisasi |
| `name` | `VARCHAR(255)` | Nama lengkap |
| `nim_nip` | `VARCHAR(50) UNIQUE` | Nomor Induk Mahasiswa / Dosen |
| `email` | `VARCHAR(255) UNIQUE` | Alamat email resmi kampus |
| `password` | `VARCHAR(255)` | Hash bcrypt kata sandi |
| `role` | `ENUM('mahasiswa', 'ketua', 'pembina', 'admin')` | Peran hak akses |

### 2. `documents`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier unik dokumen |
| `organization_id` | `BIGINT UNSIGNED` (FK) | Organisasi yang mengajukan |
| `user_id` | `BIGINT UNSIGNED` (FK) | Mahasiswa yang mengunggah |
| `document_number` | `VARCHAR(100) UNIQUE` | Nomor registrasi pengajuan dokumen |
| `title` | `VARCHAR(255)` | Judul dokumen |
| `event_name` | `VARCHAR(255)` | Nama kegiatan |
| `event_date` | `DATE` | Waktu pelaksanaan kegiatan |
| `type` | `ENUM('proposal', 'surat_izin', 'lpj')` | Jenis berkas |
| `current_status` | `ENUM('draft', 'menunggu_ketua', 'menunggu_pembina', 'disetujui', 'revisi', 'ditolak')` | Status aktif dalam state machine |

### 3. `document_verifications`
| Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT` (PK) | Identifier entri verifikasi |
| `document_id` | `BIGINT UNSIGNED UNIQUE` (FK) | Relasi 1-to-1 ke dokumen |
| `qr_token` | `VARCHAR(64) UNIQUE` | Token UUID unik untuk URL verifikasi publik |
| `signed_file_path` | `VARCHAR(500)` | Lokasi penyimpanan PDF yang sudah di-stamp QR Code |
| `signed_at` | `TIMESTAMP` | Waktu persetujuan final |
| `signed_by_pembina_id`| `BIGINT UNSIGNED` (FK) | Pembina yang mengesahkan |
