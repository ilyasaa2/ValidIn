# Software Requirements Specification (SRS) - ValidIn

## 1. Identifikasi Masalah (5 Whys)
- **Gejala:** Mahasiswa bolak-balik ke sekretariat, waktu pengesahan proposal lama (>3 hari), dokumen sering tertumpuk atau hilang.
- **Mengapa 1?** Tanda tangan dan pengesahan harus dilakukan secara fisik oleh Ketua dan Dosen Pembina.
- **Mengapa 2?** Belum ada sistem terpusat yang bisa menampung dokumen digital dan memvalidasi alur persetujuan.
- **Mengapa 3?** Proses administrasi masih menggunakan paradigma berbasis kertas (*paper-based*).
- **Akar Masalah:** Tidak ada platform digital yang memfasilitasi pengunggahan, peninjauan, dan pengesahan dokumen secara terpusat dengan bukti validasi yang dapat dipertanggungjawabkan (QR Code).

---

## 2. Analisis Stakeholder

| Stakeholder | Kategori | Kepentingan Utama |
| :--- | :--- | :--- |
| **Mahasiswa / Organisasi** | Pengguna Primer (Mobile Flutter) | Mengajukan dokumen secara instan, memantau posisi dokumen (*tracking*), mengunduh file sah. |
| **Ketua Organisasi** | Pengguna Primer (Panel Web) | Meninjau antrean proposal, membaca berkas di browser, memberi catatan revisi atau persetujuan tahap 1. |
| **Dosen Pembina** | Pengguna Primer (Panel Web) | Memberikan pengesahan akhir, memastikan kepatuhan aturan, memicu penerbitan QR Code valid. |
| **Bagian Kemahasiswaan & Keamanan** | Pengguna Sekunder (Web Verifikasi) | Memverifikasi keabsahan surat kegiatan/izin secara instan via QR Scanner. |
| **Unit TIK Kampus** | Pendukung Teknis | Pengelolaan server/hosting, keamanan berkas privat, dan integritas data. |

---

## 3. Kebutuhan Fungsional (MoSCoW)

| Kode | Kebutuhan Fungsional | Prioritas |
| :--- | :--- | :--- |
| **KF-01** | Sistem harus menyediakan fitur autentikasi (login & profil) dengan pemisahan peran (Mahasiswa, Ketua, Pembina). | **Must Have** |
| **KF-02** | Sistem harus memungkinkan mahasiswa mengunggah dokumen format PDF (maks. 5MB) beserta metadata (kegiatan, tanggal). | **Must Have** |
| **KF-03** | Sistem harus mencatat dan menampilkan status alur dokumen (`Draft`, `Menunggu_Ketua`, `Menunggu_Pembina`, `Disetujui`, `Revisi`). | **Must Have** |
| **KF-04** | Sistem harus menampilkan daftar antrean dokumen masuk pada panel web khusus untuk Ketua dan Pembina. | **Must Have** |
| **KF-05** | Sistem harus memungkinkan Ketua/Pembina menyetujui atau menolak dokumen disertai catatan revisi yang terarsip. | **Must Have** |
| **KF-06** | Sistem harus otomatis membuat token unik dan QR Code pengesahan saat dokumen disetujui penuh oleh Pembina. | **Should Have** |
| **KF-07** | Sistem harus menyediakan halaman web publik untuk validasi dokumen berdasarkan token/QR Code tanpa harus login. | **Should Have** |
| **KF-08** | Sistem harus menyediakan riwayat notifikasi dokumen (in-app notification / push notification). | **Could Have** |

---

## 4. Kebutuhan Nonfungsional (ISO 25010)

| Kode | Karakteristik | Parameter Pengukuran Terukur |
| :--- | :--- | :--- |
| **KNF-01** | **Keamanan (*Security*)** | Berkas PDF disimpan di penyimpanan privat (bukan folder *public*). Akses unduh divalidasi via *token/middleware policy*. |
| **KNF-02** | **Kinerja (*Performance*)** | Pembuatan token QR Code dan pembaruan status tidak boleh melebihi 3 detik. Waktu respon API rata-rata < 800ms. |
| **KNF-03** | **Kompatibilitas (*Compatibility*)** | Aplikasi mobile berjalan lancar di Android versi 8.0 (Oreo) ke atas. API mengembalikan JSON berstandar RESTful. |
| **KNF-04** | **Kemudahan Penggunaan (*Usability*)** | Mahasiswa dapat menyelesaikan alur pengajuan dokumen baru dalam waktu $\le$ 2 menit sejak login. |
| **KNF-05** | **Keandalan (*Reliability*)** | Sistem menangani kegagalan koneksi saat proses unggah file dengan menampilkan pesan galat yang jelas tanpa *crash*. |

---

## 5. Kriteria Keberhasilan (SMART)

- **Specific:** Memangkas birokrasi dan waktu tunggu pengesahan proposal kegiatan kampus.
- **Measurable:** 100% dokumen yang disetujui memiliki QR Code unik yang terverifikasi saat dipindai.
- **Achievable:** Waktu proses pengesahan dari pengajuan hingga persetujuan Pembina berkurang dari $\approx$ 3 hari menjadi $\le$ 1 hari.
- **Relevant:** Mengurangi penggunaan kertas (*paperless office*) dan meminimalisir risiko dokumen terselip/rusak.
- **Time-bound:** Prototipe aplikasi mobile dan backend web ter-deploy dan diuji coba minimal pada 1 organisasi mahasiswa dalam 1 semester.
