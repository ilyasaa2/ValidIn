# Software Requirements Specification (SRS) - ValidIn
### Sistem Pengesahan & Validasi Dokumen Digital &bull; HIMATIF Fakultas Teknik Universitas Tidar

---

## 1. Identifikasi Masalah (5 Whys)

- **Gejala:** Mahasiswa dan panitia kegiatan bolak-balik ke ruang dosen dan pos satpam, waktu pengesahan surat peminjaman ruang kelas/gedung FT 03 memakan waktu lama (>3 hari), berkas fisik rawan terselip atau rusak.
- **Mengapa 1?** Tanda tangan dan pengesahan dilakukan secara fisik berurutan oleh 4 pejabat berbeda (Sekretaris, Ketua Pelaksana, Ketua Himpunan, dan Wakil Dekan Fakultas).
- **Mengapa 2?** Belum ada sistem digital terpadu yang memfasilitasi persetujuan berjenjang dan mencatat jejak audit (*audit trail*) secara otomatis.
- **Mengapa 3?** Proses perizinan peminjaman fasilitas kampus masih menerapkan paradigma berbasis kertas (*paper-based*).
- **Akar Masalah:** Tidak tersedianya platform digital kampus yang mampu mengotomatisasi penandatanganan berjenjang berstempel resmi, pencatatan disposisi pejabat untuk satpam, dan pembuktian legalitas instan berbasis QR Code.

---

## 2. Analisis Stakeholder & Peran Pengguna

| Stakeholder / Pejabat | Kategori | Hak Akses & Kepentingan Utama |
| :--- | :--- | :--- |
| **Sekretaris Panitia**<br>(Hanif Abdillah Alatas) | Pengguna Primer (Web / Mobile) | Menyusun draf permohonan surat peminjaman, registrasi nomor surat, melampirkan berkas permohonan, dan membubuhi paraf kesekretariatan. |
| **Ketua Pelaksana**<br>(Emannuel Henji Pratama Putra) | Pengguna Primer (Web / Mobile) | Bertindak sebagai penanggung jawab operasional kegiatan, memeriksa draf, menandatangani surat, dan membubuhi Cap Panitia Pelaksana. |
| **Ketua HIMATIF UNTIDAR**<br>(Naufal Miftakhul Siddiq) | Pengguna Primer (Panel Web) | Meninjau kepatuhan kegiatan dengan program kerja ormawa, membubuhi paraf mengetahui, dan membubuhi stempel resmi lingkaran ganda HIMATIF. |
| **Wakil Dekan FT UNTIDAR**<br>(Dr. Sigit Iswahyudi, S.T., M.T.) | Pengguna Primer (Panel Web) | Memberikan catatan disposisi pejabat (instruksi satpam/sarpras), pengesahan tingkat fakultas, cap Dekanat FT, dan menerbitkan QR Code sah. |
| **Petugas Keamanan (Satpam) & Sarpras** | Pengguna Sekunder (Web Verifikasi Publik) | Memindai QR Code di lapangan tanpa login untuk memastikan keabsahan izin gedung/ruangan, waktu kegiatan, dan instruksi Wadek FT. |
| **Unit TIK & Pengelola Kampus** | Pendukung Teknis | Pengelolaan infrastruktur server, integritas berkas privat, dan pemeliharaan basis data. |

---

## 3. Kebutuhan Fungsional (MoSCoW)

| Kode | Kebutuhan Fungsional | Deskripsi Rinci | Prioritas |
| :--- | :--- | :--- | :--- |
| **KF-01** | **Autentikasi & Otoritas 4 Pejabat** | Sistem menyediakan mekanisme autentikasi dengan pemisahan wewenang yang tegas untuk Sekretaris, Ketua Pelaksana, Ketua HIMATIF, dan Wadek FT. | **Must Have** |
| **KF-02** | **Pengajuan Permohonan Peminjaman** | Sistem memungkinkan panitia mengajukan surat peminjaman fasilitas (Gedung FT 03, kelas, sound system) dengan template cepat dan lampiran PDF. | **Must Have** |
| **KF-03** | **Alur Status Berjenjang 5 Tahap** | Sistem mengelola dan mencatat alur status dokumen secara berurutan: `menunggu_sekretaris` &rarr; `menunggu_pelaksana` &rarr; `menunggu_ketua` &rarr; `menunggu_pembina` &rarr; `disetujui` (disertai status `revisi`). | **Must Have** |
| **KF-04** | **Dashboard Adaptif per Pejabat** | Sistem menampilkan statistik KPI terukur, antrean berkas yang memerlukan tindakan, dan penyaringan dinamis sesuai akun pejabat yang aktif. | **Must Have** |
| **KF-05** | **Penandatanganan Digital & Cap Lembaga** | Sistem menyematkan paraf Sekretaris, tanda tangan & Cap Panitia Pelaksana, stempel resmi HIMATIF, serta stempel Dekanat FT pada lembar surat. | **Must Have** |
| **KF-06** | **Catatan Disposisi Resmi Pejabat** | Sistem memungkinkan Wakil Dekan FT menuliskan catatan disposisi resmi (instruksi satpam) yang tampil pada surat fisik dan hasil scan QR. | **Must Have** |
| **KF-07** | **Penerbitan Kriptografis QR Code** | Sistem otomatis membuat token UUID v4 unik dan sidik jari kriptografis SHA-256 saat dokumen disahkan penuh oleh Wakil Dekan FT. | **Must Have** |
| **KF-08** | **Layanan Publik Verifikasi Satpam** | Sistem menyediakan laman web verifikasi publik tanpa login untuk memeriksa status sah, instruksi disposisi, dan kontak panitia (Ilyasa). | **Must Have** |
| **KF-09** | **Buku Register & Ekspor CSV** | Sistem mengarsipkan seluruh riwayat surat resmi dan menyediakan fitur ekspor berkas data CSV terstruktur. | **Should Have** |
| **KF-10** | **Pemberitahuan Status Berkas** | Sistem menampilkan notifikasi toast interaktif dan riwayat alur persetujuan (*stepper audit trail*). | **Should Have** |

---

## 4. Kebutuhan Nonfungsional (ISO 25010)

| Kode | Karakteristik | Parameter Pengukuran Terukur |
| :--- | :--- | :--- |
| **KNF-01** | **Keamanan (*Security*)** | Integritas dokumen divalidasi via hash kriptografis SHA-256. Token QR bersifat acak (UUID v4) dan tidak dapat ditebak. |
| **KNF-02** | **Kinerja (*Performance*)** | Pemuatan halaman surat dan pemindaian token verifikasi QR selesai dalam waktu $\le$ 1 detik pada koneksi internet standar kampus. |
| **KNF-03** | **Kompatibilitas (*Compatibility*)** | Web responsif dan optimal pada resolusi desktop maupun layar seluler (Satpam). Format cetak bersih sesuai standar kertas A4/F4. |
| **KNF-04** | **Kemudahan Penggunaan (*Usability*)** | Pejabat dapat menyelesaikan proses disposisi dan penandatanganan surat dalam $\le$ 3 klik sejak membuka berkas. |
| **KNF-05** | **Keandalan (*Reliability*)** | Sistem menyimpan kondisi alur secara konsisten dengan mekanisme *state machine* yang mencegah lompatan alur persetujuan secara ilegal. |

---

## 5. Kriteria Keberhasilan (SMART)

- **Specific:** Mengotomatisasi alur permohonan peminjaman fasilitas dan izin kegiatan HIMATIF Fakultas Teknik UNTIDAR dari draf panitia hingga verifikasi satpam.
- **Measurable:** 100% surat yang disahkan Wadek FT memiliki token QR terdaftar dan dapat divalidasi oleh Satpam kampus.
- **Achievable:** Mengurangi durasi birokrasi pengesahan berantai dari 3-5 hari kerja menjadi $\le$ 24 jam.
- **Relevant:** Menghilangkan risiko surat izin palsu di pos keamanan serta mendukung inisiatif kampus ramah lingkungan (*paperless*).
- **Time-bound:** Prototipe dan sistem teruji fungsional penuh pada lingkungan HIMATIF UNTIDAR pada semester perkuliahan berjalan.
