# Pembagian Tugas & Tanggung Jawab Tim (4 Anggota) - ValidIn

Dokumen ini mengatur pembagian tugas, peran, tanggung jawab, dan hasil kerja (*deliverables*) untuk tim pengembang proyek **ValidIn** (4 Anggota) dalam mata kuliah Sistem Web dan Seluler Lanjut.

---

## 👥 Matriks Peran & Tanggung Jawab

| No | Peran Anggota | Fokus Utama | Deliverables (Hasil Kerja) |
| :-: | :--- | :--- | :--- |
| **1** | **Ketua Kelompok & System Analyst** | • Manajemen proyek dan *timeline* (Gantt Chart).<br>• Analisis kebutuhan (5 Whys, SRS, MoSCoW, ISO 25010).<br>• Desain alur sistem (*State Machine*, *Use Case*, *Activity Diagram*).<br>• Perancangan *wireframe* & desain UI/UX di Figma (Mobile & Web).<br>• Memimpin koordinasi rapat mingguan dan presentasi di depan dosen. | • Gantt Chart Proyek<br>• Dokumen SRS & Use Case<br>• Mockup Desain UI/UX Figma<br>• Slide Presentasi & Pengawalan Demo |
| **2** | **Backend Developer (Laravel & Database)** | • Perancangan basis data (ERD, Migrations, Seeders MySQL).<br>• Membangun RESTful API dengan Laravel 11 & Laravel Sanctum.<br>• Mengembangkan alur logika persetujuan (*document state machine*).<br>• Mengimplementasikan generator QR Code unik dan penyematan (*stamping*) ke berkas PDF.<br>• Mengembangkan panel web dashboard untuk Ketua Organisasi & Dosen Pembina (Blade/Livewire). | • Source code Laravel API & Web Panel<br>• Skema Database & Migrations<br>• Modul QR Code Generator & PDF Stamping<br>• Endpoint Verifikasi Publik |
| **3** | **Mobile Developer (Flutter Specialist)** | • Inisialisasi arsitektur proyek Flutter (Android target).<br>• Mengimplementasikan antarmuka mahasiswa (*slicing* UI dari desain Figma).<br>• Integrasi REST API (Login, Unggah PDF multipart, Riwayat dokumen).<br>• Membuat komponen visual pelacakan status (*stepper timeline tracking*).<br>• Mengintegrasikan *in-app PDF Viewer* dan fitur unduh dokumen sah.<br>• Mengompilasi dan menguji file rilis APK di perangkat Android fisik. | • Source code aplikasi Flutter<br>• Berkas rilis APK Android siap install<br>• Komponen interaktif *status tracking* |
| **4** | **QA Tester & Technical Writer (Notulis)** | • Menyusun laporan akhir proyek secara bertahap (Bab 1 s/d Bab 5).<br>• Merancang dokumen skenario pengujian (*Test Cases Black Box Testing*).<br>• Membuat dokumentasi dan koleksi API (Postman Collection / Swagger).<br>• Melakukan pengujian fungsional aplikasi (API, Web Dashboard, Mobile, dan Pemindaian QR).<br>• Mencatat notulensi evaluasi progres mingguan dan masukan dosen pembimbing. | • Laporan Akhir Proyek Lengkap (Bab 1-5)<br>• Dokumen *Test Cases* & Laporan Hasil Pengujian (UAT)<br>• Koleksi Postman API (+ Environment)<br>• Notulensi Bimbingan Dosen |

---

## 🔄 Matriks RACI (Responsible, Accountable, Consulted, Informed)

- **R (Responsible):** Pelaksana tugas utama.
- **A (Accountable):** Penanggung jawab akhir keberhasilan tugas.
- **C (Consulted):** Pihak yang diajak berdiskusi/memberi masukan.
- **I (Informed):** Pihak yang menerima pembaruan hasil kerja.

| Aktivitas Proyek | Ketua / Analis | Backend Dev | Mobile Dev | QA / Tech Writer |
| :--- | :---: | :---: | :---: | :---: |
| Analisis Masalah & Kebutuhan (SRS) | **A / R** | C | C | R |
| Desain Wireframe & Mockup UI/UX | **A / R** | I | C | I |
| Perancangan Skema Database (ERD) | C | **A / R** | I | I |
| Pembuatan REST API & State Machine | I | **A / R** | C | C |
| Pembuatan QR Code & PDF Stamping | I | **A / R** | I | C |
| Pembuatan Web Dashboard Panel | C | **A / R** | I | I |
| Pembuatan Aplikasi Mobile (Flutter) | C | C | **A / R** | I |
| Integrasi API ke Mobile | A | R | **R** | I |
| Pengujian Fungsional (Black Box / UAT) | C | C | C | **A / R** |
| Penyusunan Laporan Akhir Bab 1-5 | C | I | I | **A / R** |
| Deployment & Kompilasi APK Demo | **A / R** | R | R | I |

---

## 📅 Rencana Kerja Mingguan (Milestone 1 Semester)

```mermaid
gantt
    title Jadwal Kerja Proyek ValidIn (4 Anggota)
    dateFormat  YYYY-MM-DD
    section Fase 1: Perencanaan
    Analisis Kebutuhan & SRS        :a1, 2026-11-01, 7d
    Desain UI/UX & ERD Database     :a2, after a1, 7d
    section Fase 2: Pengembangan
    Setup Backend & Migrations      :b1, after a2, 7d
    Implementasi REST API & Panel   :b2, after b1, 14d
    Slicing UI & Logika Flutter     :b3, after b1, 14d
    Integrasi API ke Mobile         :b4, after b2, 7d
    Fitur QR Generator & PDF Stamp  :b5, after b2, 7d
    section Fase 3: Pengujian & Laporan
    Black Box Testing & UAT         :c1, after b4, 7d
    Penyempurnaan Laporan Bab 1-5   :c2, after a2, 35d
    Deployment, Build APK, & Demo   :c3, after c1, 7d
```
