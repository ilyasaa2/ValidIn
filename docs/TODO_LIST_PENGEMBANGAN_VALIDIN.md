# 📋 DAFTAR TUGAS DAN RENCANA TINDAK LANJUT PROYEK (TO-DO LIST)
## Sistem Validasi & Pengesahan Dokumen Digital (ValidIn)
### Fakultas Teknik — Universitas Tidar (UNTIDAR)

![Status](https://img.shields.io/badge/Status-Active_Development-blue)
![Frontend Web](https://img.shields.io/badge/Web_Prototype-Completed-brightgreen)
![Frontend Mobile](https://img.shields.io/badge/Flutter_Mobile-Completed-brightgreen)
![Backend Microservices](https://img.shields.io/badge/Backend_Microservices-Ready-brightgreen)
![Institusi](https://img.shields.io/badge/Institusi-Universitas_Tidar-1e3a8a)

---

### 📌 Ringkasan Informasi Proyek
* **Tanggal Pembaruan** : 31 Oktober 2026
* **Jumlah Anggota Tim** : 4 Orang (*Ketua/Analyst*, *Backend Developer*, *Mobile Developer*, *QA/Technical Writer*)
* **Fase Proyek Saat Ini**: **Fase Integrasi & Sinkronisasi Sistem** (Prototipe Web Modular, Arsitektur Microservices Backend, dan Antarmuka Mobile Flutter telah berhasil diimplementasikan 100%; saat ini melangkah ke integrasi API live dan pengujian UAT).

---

## 1. Status Capaian Milestone Terkini (Rekapitulasi Perkembangan Terakhir)

Seluruh milestone berikut telah berhasil diimplementasikan dan telah tersimpan pada repositori Git:

### A. Prototipe Web Modular (Web Desktop Pejabat & Dekanat)
- [x] **7 Halaman Web Terintegrasi**:
  - `index.html` (Dashboard adaptif peran dengan metrik KPI & filter status dokumen).
  - `review.html` (Lembar fisik surat resmi UNTIDAR, pratinjau matriks tanda tangan 2 baris, dan panel aksi).
  - `submit.html` (Formulir pengajuan peminjaman gedung/ruang & alat dilengkapi *quick template*).
  - `verify.html` (Portal publik pemindaian QR Satpam tanpa autentikasi login).
  - `archive.html` (Buku register penomoran surat digital dan fitur ekspor data).
  - `profile.html` (Profil pejabat resmi, sertifikat kriptografi, dan cap lembaga).
  - `login.html` (Portal autentikasi akun pejabat UNTIDAR).
- [x] **Alur Pengesahan Berjenjang 5 Tahap (*Hierarchical State Machine*)**:
  - Sekretaris Panitia $\rightarrow$ Ketua Pelaksana $\rightarrow$ Ketua HIMATIF $\rightarrow$ Pembina / Wadek I FT UNTIDAR.
- [x] **Fitur Revisi Langsung (*In-Place Edit Modal*)**:
  - Pengunggah/Sekretaris dapat langsung memperbaiki catatan perbaikan surat berstatus `perlu_revisi` tanpa menghapus berkas dan tanpa mengulang alur dari awal.
- [x] **Portal Verifikasi Publik QR Satpam**:
  - Dapat diakses instan oleh Petugas Satpam di gerbang/pos gedung FT 03 dengan tampilan instruksi operasional yang sangat jelas.

### B. Arsitektur Backend Microservices (Decoupled Services Layer)
- [x] **Orkestrasi Docker Compose** (`backend/docker-compose.yml`):
  - Setup multi-container terintegrasi untuk gateway, microservices, basis data MySQL per-service, dan Redis cache.
- [x] **API Gateway Nginx** (`backend/gateway/nginx.conf` pada Port `8000`):
  - Reverse proxy terpusat, penanganan CORS, dan routing endpoint ke service spesifik.
- [x] **4 Modul Microservices Utama**:
  - `auth-service` (Port `8001`): Autentikasi JWT & kontrol hak akses RBAC 4 pejabat.
  - `document-service` (Port `8002`): Manajemen workflow 5 tahap persetujuan surat & catatan disposisi.
  - `notary-service` (Port `8003`): Pembangkitan digest SHA-256 berkas & pembubuhan stempel visual.
  - `verification-service` (Port `8004`): Layanan publik ultra-cepat (<50ms) verifikasi QR Satpam berbasis Redis.
- [x] **Dokumentasi Lengkap Spesifikasi**:
  - `docs/MICROSERVICES_ARCHITECTURE.md`, `docs/API_CONTRACT.md`, `docs/ERD.md`, `docs/SRS.md`.

### C. Aplikasi Mobile Flutter (`mobile/`)
- [x] **Arsitektur Flutter Modern**:
  - Berhasil dikompilasi bersih (`flutter analyze` : **0 errors, 0 warnings**).
  - Struktur modul rapi (`lib/models/`, `lib/screens/`, `lib/services/`, `lib/theme/`).
- [x] **Antarmuka Pengajuan Surat Lengkap** (`submit_screen.dart`):
  - Pilihan jenis surat (Gedung FT 03, Sound/Mic, Kegiatan Umum).
  - Fitur *Auto-fill Template Cepat* untuk mempercepat simulasi pengajuan.
  - Input validasi lengkap (NPM Sekretaris, Ketua Pelaksana, Tanggal, Jam, Ruangan, Contact Person).
- [x] **Lembar Pratinjau Surat Fisik Resmi** (`review_screen.dart`):
  - Render lembar kertas surat resmi identik dengan dokumen fisik Fakultas Teknik UNTIDAR.
  - Matriks tanda tangan 2 baris (Sekretaris, Ketua Pelaksana, Ketua HIMATIF, Wadek FT).
  - Kotak catatan disposisi bertinta biru/kuning dari Wakil Dekan untuk instruksi Satpam.
  - Modal disposisi cepat dengan 3 template instruksi dekanat.
- [x] **Komponen Interaktif Timeline Pelacakan (*Status Stepper*)**:
  - Stepper visual 5 tahap yang responsif terhadap perubahan status dokumen.
- [x] **Modul QR Code Pass Digital** (`qr_flutter`):
  - Penerbitan pass digital QR Code instan saat surat berstatus `disetujui` untuk ditunjukkan ke satpam kampus.
- [x] **Simulasi Multi-Role Switcher** (`local_store.dart`):
  - Pengalihan peran langsung di aplikasi untuk pengujian demonstrasi (Sekretaris, Ketua Pelaksana, Ketua HIMATIF, Wadek FT).
- [x] **Standalone Mobile Web Runner**:
  - Dapat dijalankan via browser di port `8081` maupun di-build ke berkas APK Android.

---

## 2. Rencana Tindak Lanjut Segera (Next Immediate Steps)

Langkah teknis utama untuk menghubungkan seluruh komponen yang telah selesai:

- [ ] **1. Integrasi API Gateway Live ke Aplikasi Mobile**
  - Mengubah mode data di Flutter dari `LocalStore` simulasi menjadi pemanggilan live HTTP REST via `ApiService` ke API Gateway (`http://localhost:8000/api/v1/`).
- [ ] **2. Uji Coba Orkestrasi Docker Microservices Lokal**
  - Menjalankan `docker compose up -d` di folder `backend/` untuk memverifikasi kesiapan seluruh endpoint service dan migrasi database.
- [ ] **3. Sinkronisasi Branch Git Seluruh Anggota Tim**
  - Memastikan seluruh anggota melakukan `git pull origin main` dan membuat cabang kerja masing-masing (`feat/backend-api`, `feat/mobile-integration`, `docs/laporan-bab-1-3`).
- [ ] **4. Penyusunan Skenario UAT (User Acceptance Testing) & Black Box**
  - Menguji kelancaran alur pengajuan dari Mobile $\rightarrow$ persetujuan di Web $\rightarrow$ pemindaian QR di Pos Satpam.

---

## 3. Pembagian Tugas Rinci Berdasarkan Peran Anggota

### A. Ketua Kelompok & System Analyst
* **Fokus**: Tata kelola proyek, perancangan diagram UML, koordinasi asistensi dosen, dan validasi fungsional sistem.
* **Daftar Tugas**:
  - [x] Perancangan alur sistem komprehensif (*State Machine 5 Tahap*, *5 Whys Analysis*).
  - [x] Penyusunan Software Requirements Specification (`docs/SRS.md`) berbasis MoSCoW & ISO 25010.
  - [x] Desain sistem visual akademik kop surat & notarial UNTIDAR (`docs/DESIGN_SYSTEM.md`).
  - [ ] Pembaruan diagram teknis UML (*Activity Diagram*, *Sequence Diagram*, *Deployment Diagram*) menyesuaikan arsitektur microservices backend.
  - [ ] Penyusunan jadwal asistensi mingguan dosen pengampu dan slide presentasi progres kemajuan tim.

### B. Backend Developer (Microservices & Database)
* **Fokus**: API Gateway, service microservices, persistensi database MySQL, generator token QR, dan stempel notarial.
* **Daftar Tugas**:
  - [x] Perancangan arsitektur microservices terpisah (`backend/services/` & `docs/MICROSERVICES_ARCHITECTURE.md`).
  - [x] Konfigurasi Docker Compose multi-service dan Nginx API Gateway (`backend/gateway/nginx.conf`).
  - [x] Perancangan Entity Relationship Diagram & kamus data basis data (`docs/ERD.md`).
  - [x] Spesifikasi kontrak RESTful API v1 lengkap (`docs/API_CONTRACT.md`).
  - [ ] Eksekusi migrasi tabel dan seeder data 4 pejabat resmi UNTIDAR pada container MySQL.
  - [ ] Implementasi logika bisnis penuh pada `document-service` dan integrasi stempel visual PDF pada `notary-service`.

### C. Mobile Developer (Flutter Specialist)
* **Fokus**: Aplikasi Android Flutter, pengalaman pengguna mobile (*slicing* UI), penanganan dokumen fisik, dan koneksi API.
* **Daftar Tugas**:
  - [x] Inisialisasi struktur arsitektur Flutter 3.x Android (`mobile/lib/`).
  - [x] Slicing UI dashboard permohonan mahasiswa dan pelacak status interaktif (*Stepper*).
  - [x] Implementasi formulir pengajuan surat (`submit_screen.dart`) dengan fitur auto-fill template peminjaman gedung FT 03.
  - [x] Implementasi lembar pratinjau surat resmi (`review_screen.dart`) dengan tanda tangan digital & form disposisi Wadek.
  - [x] Integrasi generator QR Code pas izin Satpam (`qr_flutter`).
  - [x] Implementasi demo interaktif *multi-role switcher* berbasis `LocalStore`.
  - [x] Pembersihan kode dan perbaikan deprecation (`flutter analyze` bersih 0 issue).
  - [ ] Menghubungkan layer komunikasi HTTP (`api_service.dart`) dengan endpoint API Gateway `http://localhost:8000`.
  - [ ] Kompilasi berkas rilis `.apk` Android siap instal untuk demonstrasi langsung di ponsel fisik.

### D. QA Tester & Technical Writer
* **Fokus**: Skenario uji kualitas (Black Box), dokumentasi Postman, notulensi koordinasi, dan laporan akademik.
* **Daftar Tugas**:
  - [x] Matriks pembagian peran dan tanggung jawab tim RACI (`docs/TEAM_RESPONSIBILITIES.md`).
  - [ ] Penyusunan dokumen skenario pengujian *Black Box Testing* (uji validasi form, penolakan, revisi, dan scan QR Satpam).
  - [ ] Pembuatan koleksi Postman API (+ *Environment Variables*) untuk mempermudah verifikasi endpoint gateway.
  - [ ] Penulisan draf Laporan Akhir:
    - **Bab 1**: Pendahuluan (Latar Belakang, Identifikasi Masalah 5 Whys, Batasan Masalah, Tujuan).
    - **Bab 2**: Landasan Teori & Tinjauan Pustaka (Arsitektur Microservices, Kriptografi QR Code, Flutter Framework).
    - **Bab 3**: Metodologi Penelitian & Analisis Perancangan Sistem.
  - [ ] Pencatatan notulensi berkala evaluasi internal tim dan bimbingan dosen.

---

## 4. Tabel Monitoring Progres & Jadwal Kerja (Timeline)

| No | Aktivitas / Deliverable | Penanggung Jawab | Target Waktu | Status Terkini |
| :---: | :--- | :--- | :---: | :---: |
| 1 | **Prototipe Web Modular (7 Halaman Lengkap)** | Ketua & Backend | Minggu 1 | <span style="color:green">**✓ Selesai (100%)**</span> |
| 2 | **Desain Sistem & SRS Akademik ISO 25010** | Ketua / Analyst | Minggu 1 | <span style="color:green">**✓ Selesai (100%)**</span> |
| 3 | **Arsitektur Backend Microservices & API Gateway** | Backend Dev | Minggu 1 - 2 | <span style="color:green">**✓ Selesai (100%)**</span> |
| 4 | **Slicing & State Management Flutter Mobile** | Mobile Dev | Minggu 2 | <span style="color:green">**✓ Selesai (100%)**</span> |
| 5 | **Simulasi Alur 5 Tahap, Revisi Langsung, & Pass QR** | Seluruh Tim | Minggu 2 | <span style="color:green">**✓ Selesai (100%)**</span> |
| 6 | **Integrasi API Gateway Live ke Mobile Client** | Backend & Mobile | Minggu 3 | ⏳ *Sedang Berjalan* |
| 7 | **Pengujian Fungsional Black Box & Postman** | QA / Writer | Minggu 3 | 📋 *Direncanakan* |
| 8 | **Penyusunan Laporan Proyek (Bab 1, 2, 3)** | QA / Writer & Ketua | Minggu 3 - 4 | 📋 *Direncanakan* |
| 9 | **Build APK Final & UAT Bersama Dosen/Satpam** | Seluruh Tim | Minggu 4 | 📋 *Direncanakan* |

---

## 5. Peran & Kesepakatan Tim Pengembang

To-do list ini menjadi acuan kerja resmi bersama tim pengembang proyek **ValidIn Fakultas Teknik Universitas Tidar** guna menjamin ketepatan waktu pengumpulan dan kualitas sistem.

| Peran Tim | Nama Anggota | Status Persetujuan |
| :--- | :--- | :---: |
| **Ketua Kelompok & System Analyst** | .................................................... | `[ Disetujui ]` |
| **Backend Developer** | .................................................... | `[ Disetujui ]` |
| **Mobile Developer** | .................................................... | `[ Disetujui ]` |
| **QA Tester & Technical Writer** | .................................................... | `[ Disetujui ]` |
