# Design System & Referensi UI ValidIn (Institutional Academic Minimalism)
### Standar Desain Persuratan Resmi &bull; HIMATIF Fakultas Teknik Universitas Tidar

Dokumen ini mendefinisikan panduan visual sistem ValidIn untuk menghindari pola *generic AI SaaS* (gradasi ungu, kapsul berlebihan, tampilan melayang tanpa konteks). Desain ValidIn mengadopsi estetika **Official Campus Registrar & Legal Notary**: terstruktur, bersih, tipografi presisi, dan memiliki kesan dokumen fisik yang otentik sesuai standar Universitas Tidar.

---

## 🎨 Palet Warna (Notary & Academic Registry)

Bukan gradasi ungu/neon AI, melainkan palet resmi perguruan tinggi:

- **Background Utama:** `#fbfbfa` (Kertas arsip gading/warm stone, ramah mata)
- **Background Kartu & Lembar Kerja:** `#ffffff` (Putih murni dengan garis batas tegas)
- **Warna Tinta Utama (Text Primary):** `#18181b` (Zinc/Ink 900, kontras tinggi WCAG AAA)
- **Warna Tinta Sekunder (Text Secondary):** `#52525b` (Zinc 600)
- **Warna Identitas Resmi (Primary Authority):** `#0f172a` (Deep Slate / Academic Navy) & `#1e3a8a` (UNTIDAR Academic Blue)
- **Segel Pengesahan Sah (Official Seal / Verified):** `#15803d` (Deep Notary Emerald)
- **Segel Perlu Revisi / Peringatan:** `#b45309` (Warm Amber)
- **Segel Penolakan / Galat:** `#b91c1c` (Crimson Red)
- **Garis Batas (Hairline Dividers):** `#e4e4e7` (Batas tegas 1px, bukan bayangan tebal melayang)

---

## ✍️ Tipografi & Tinta Digital

- **Font Utama Antarmuka:** `Plus Jakarta Sans` (Font geometris modern standar sistem institusi akademik modern Indonesia).
- **Font Kode / Registrasi / Hash:** `JetBrains Mono` (Angka tabular yang presisi untuk nomor registrasi, NPM/NIP, token UUID, dan sidik jari SHA-256).
- **Font Paraf & Tanda Tangan:** Cursive / Script (`Brush Script MT`, cursive) dengan warna tinta biru pekat (`#1e3a8a`), merepresentasikan goresan pena basah otentik.
- **Font Catatan Disposisi:** Handlettered styling dengan warna biru dokumen (`#1e3a8a`), ditempatkan pada kotak kuning bergaris putus-putus (*yellow disposition post-it*) di sudut kanan atas surat.

---

## 🏛️ Format Kop Surat & Matriks Tanda Tangan UNTIDAR

Mengacu pada berkas surat permohonan asli HIMATIF Fakultas Teknik UNTIDAR:

### 1. Kop Surat Resmi Ganda (Dual Emblem)
- **Sisi Kiri:** Lambang Universitas Tidar (UNTIDAR Magelang) berlatar biru dengan aksen kuning.
- **Tengah:**
  - `HIMPUNAN MAHASISWA TEKNOLOGI INFORMASI` (Uppercase, tebal)
  - `UNIVERSITAS TIDAR` (Uppercase, biru UNTIDAR)
  - Alamat: Jalan Kapten Suparman 39 Magelang 56116 &bull; ft.untidar.ac.id
- **Sisi Kanan:** Lambang Resmi HIMATIF FT UNTIDAR berlatar gelap aksen biru muda.
- **Garis Pembatas:** Garis ganda tebal tipis (*double border*) 3px.

### 2. Matriks 2 Baris Tanda Tangan Berjenjang
- **Baris 1 (*Hormat kami*):**
  - Kiri: **Ketua Pelaksana** (Emannuel Henji Pratama Putra - NPM. 2505060012) dengan stempel Panitia Pelaksana.
  - Kanan: **Sekretaris Panitia** (Hanif Abdillah Alatas - NPM. 2420506041) dengan paraf kesekretariatan.
- **Baris 2 (*Mengetahui*):**
  - Kiri: **Ketua HIMATIF UNTIDAR** (Naufal Miftakhul Siddiq - NPM. 2440506060) dengan stempel resmi lingkaran biru HIMATIF.
  - Kanan: **Wakil Dekan Bid. Akademik & Kemahasiswaan FT** (Dr. Sigit Iswahyudi, S.T., M.T. - NIP. 197510302021211005) dengan stempel resmi lingkaran merah Dekanat Fakultas Teknik.

### 3. Kotak Disposisi Pejabat (Instruksi Satpam / Sarpras)
- Diletakkan di pojok kanan atas lembar surat fisik dengan latar `#fefce8` dan garis putus-putus kuning `#ca8a04`.
- Memuat instruksi pembukaan gedung/kelas dan arahan ketertiban yang dapat divalidasi langsung oleh Satpam kampus saat memindai QR Code.

---

## 🗂️ Struktur Halaman Terpisah (Modular Multi-Page)

Setiap fungsi memiliki berkas HTML mandiri dengan sinkronisasi data terpusat (`localStorage` di `shared.js`):

1. [`web/index.html`](file:///c:/ValidIn/web/index.html) - Dashboard utama adaptif sesuai 4 pejabat (KPI statistik clickable, filter, penanda highlight aksi).
2. [`web/submit.html`](file:///c:/ValidIn/web/submit.html) - Formulir pengajuan surat dengan 3 template cepat (Gedung FT 03, Sound System, Izin Kegiatan).
3. [`web/review.html`](file:///c:/ValidIn/web/review.html) - Meja periksa split-screen dengan lembar fisik surat, matriks tanda tangan interaktif, dan modal disposisi Wadek FT.
4. [`web/verify.html`](file:///c:/ValidIn/web/verify.html) - Layanan publik verifikasi QR tanpa login untuk Petugas Keamanan (Satpam) kampus.
5. [`web/archive.html`](file:///c:/ValidIn/web/archive.html) - Buku register digital, tab filter dinamis, dan unduh data rekap CSV.
6. [`web/profile.html`](file:///c:/ValidIn/web/profile.html) - Profil kredensial 4 pejabat resmi, tugas pokok wewenang, dan pratinjau stempel lembaga.
7. [`web/login.html`](file:///c:/ValidIn/web/login.html) - Portal masuk dengan pemilih cepat akun 4 pejabat UNTIDAR.
