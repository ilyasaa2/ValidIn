# ValidIn - Sistem Pengesahan & Validasi Dokumen Digital Organisasi Kampus

![Status](https://img.shields.io/badge/Status-Development-blue)
![Laravel](https://img.shields.io/badge/Backend-Laravel_11-red)
![Flutter](https://img.shields.io/badge/Mobile-Flutter-blue)
![Database](https://img.shields.io/badge/Database-MySQL-orange)

ValidIn adalah platform manajemen pengesahan dokumen kegiatan (proposal, surat izin kegiatan, laporan pertanggungjawaban/LPJ) di lingkungan organisasi kampus berbasis aplikasi mobile (Flutter) dan panel web (Laravel). Dilengkapi dengan **Auto-generate QR Code Stamping** untuk verifikasi keaslian dokumen secara instan tanpa perlu login.

---

## 📌 Latar Belakang & Masalah (5 Whys)

1. **Gejala:** Mahasiswa bolak-balik ke sekretariat kampus, pengesahan proposal memakan waktu lama (rata-rata >3 hari), dan berkas fisik rawan terselip atau rusak.
2. **Mengapa 1?** Tanda tangan dan paraf pengesahan masih dilakukan secara fisik oleh Ketua Organisasi dan Dosen Pembina.
3. **Mengapa 2?** Belum ada sistem terpusat yang menampung berkas digital dan memvalidasi alur persetujuan.
4. **Mengapa 3?** Proses administrasi masih menerapkan paradigma kertas (*paper-based*).
5. **Akar Masalah:** Ketiadaan platform terpadu yang memfasilitasi pengunggahan, peninjauan berjenjang, dan pembuktian validasi dokumen yang dapat dipertanggungjawabkan (via QR Code).

---

## 👥 Peran Pengguna & Platform

| Peran | Platform | Fitur Utama |
| :--- | :--- | :--- |
| **Mahasiswa / Pengaju** | Mobile (Flutter) | Unggah PDF proposal/surat izin, lacak progres persetujuan (*stepper timeline*), dan unduh dokumen terverifikasi. |
| **Ketua Organisasi** | Web (Laravel Blade/Livewire) | Tinjau berkas via *inline PDF preview*, setujui / tolak dengan catatan revisi tahap 1. |
| **Dosen Pembina** | Web (Laravel Blade/Livewire) | Tinjau berkas yang disetujui Ketua, berikan persetujuan akhir (otomatis generate token & QR Code). |
| **Pihak Keamanan / Publik** | Web Publik | Pindai QR Code pada dokumen fisik/digital untuk memvalidasi keaslian berkas tanpa perlu login. |

---

## 🏛️ Arsitektur Sistem

```
+-----------------------------------+       +-----------------------------------+
|      Mahasiswa / Pengaju          |       |     Ketua / Dosen Pembina         |
|        (Flutter Mobile)           |       |   (Laravel Blade / Livewire)      |
+-----------------+-----------------+       +-----------------+-----------------+
                  |                                           |
                  | HTTPS / REST API                          | Web Session
                  v                                           v
+-------------------------------------------------------------------------------+
|                             Laravel Backend Service                           |
|  - Auth & Role Management (Sanctum)                                           |
|  - Document State Machine (Draft -> Menunggu_Ketua -> Menunggu_Pembina -> ...) |
|  - Storage Engine (Private PDF Storage)                                       |
|  - QR Code Generator & PDF Stamping Engine (FPDI / Endroid QR)                |
+---------------------------------------+---------------------------------------+
                                        |
                                        v
                            +-----------------------+
                            |     MySQL Database    |
                            +-----------------------+
```

---

## 🔄 Alur Status Dokumen (*State Machine*)

```
[Mahasiswa Unggah PDF]
         │
         ▼
[Menunggu_Ketua] ──(Revisi/Tolak)──► [Revisi] ──(Upload Perbaikan)──► [Menunggu_Ketua]
         │
    (Disetujui)
         │
         ▼
[Menunggu_Pembina] ──(Revisi/Tolak)──► [Revisi]
         │
    (Disetujui)
         │
         ▼
[Disetujui] ──► (Sistem menempelkan QR Code unik ke PDF)
         │
         ▼
[Publik Scan QR] ──► Mengarah ke `/verify/{token}` (Status: Valid)
```

---

## 📂 Struktur Repositori Monorepo

```
ValidIn/
├── docs/                        # Dokumentasi spesifikasi, ERD, dan kontrak API
│   ├── SRS.md                   # Software Requirements Specification (MoSCoW & ISO 25010)
│   ├── ERD.md                   # Entity Relationship Diagram & Data Dictionary
│   ├── API_CONTRACT.md          # Spesifikasi Endpoint REST API
│   └── TEAM_RESPONSIBILITIES.md # Pembagian Tugas & Tanggung Jawab Tim (4 Anggota)
├── backend/                     # Laravel REST API & Web Panel Dashboard
└── mobile/                      # Flutter Application (Android Target)
```

---

## 🛠️ Rencana Teknologi

- **Backend:** PHP 8.2+, Laravel 11.x, Laravel Sanctum, Livewire / Blade.
- **Mobile:** Flutter 3.x (Dart), `flutter_pdfview`, `dio` / `http`.
- **Database:** MySQL 8.x.
- **Validasi Dokumen:** QR Code Tokenization (UUID v4 / SHA-256 Hash) & PDF Watermark Stamp.

---

## 👨‍💻 Tim Pengembang 

Detail pembagian tugas, matriks RACI, dan deliverable dapat dilihat pada [docs/TEAM_RESPONSIBILITIES.md](docs/TEAM_RESPONSIBILITIES.md).

1. **Ketua Kelompok & System Analyst:** (Manajemen Proyek, Desain UI/UX Figma, & Analisis Sistem)
2. **Backend Developer:** (REST API Laravel 11, Database MySQL, QR Stamping, & Web Panel)
3. **Mobile Developer:** (Aplikasi Flutter Android, Integrasi API, & In-App PDF Preview)
4. **QA Tester & Technical Writer:** (Black Box Testing, Postman Collection, & Laporan Akhir)
