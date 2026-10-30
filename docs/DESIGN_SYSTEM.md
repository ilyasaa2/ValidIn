# Design System & Referensi UI ValidIn (Institutional Academic Minimalism)

Dokumen ini mendefinisikan panduan visual sistem ValidIn untuk menghindari pola *generic AI SaaS* (gradasi ungu, kapsul berlebihan, tampilan melayang tanpa konteks). Desain ValidIn mengadopsi estetika **Official Campus Registrar & Legal Notary**: terstruktur, bersih, tipografi presisi, dan memiliki kesan dokumen fisik yang otentik.

---

## 🎨 Palet Warna (Notary & Academic Registry)

Bukan gradasi ungu/neon AI, melainkan palet resmi perguruan tinggi:

- **Background Utama:** `#fbfbfa` (Kertas arsip gading/warm stone, ramah mata)
- **Background Kartu & Lembar Kerja:** `#ffffff` (Putih murni dengan garis batas tegas)
- **Warna Tinta Utama (Text Primary):** `#18181b` (Zinc/Ink 900, kontras tinggi WCAG AAA)
- **Warna Tinta Sekunder (Text Secondary):** `#52525b` (Zinc 600)
- **Warna Identitas Resmi (Primary Authority):** `#0f172a` (Deep Slate / Academic Navy) & `#1e40af` (Classic Cobalt)
- **Segel Pengesahan Sah (Official Seal / Verified):** `#15803d` (Deep Notary Emerald)
- **Segel Perlu Revisi / Peringatan:** `#b45309` (Warm Amber)
- **Segel Penolakan / Galat:** `#b91c1c` (Crimson Red)
- **Garis Batas (Hairline Dividers):** `#e4e4e7` (Batas tegas 1px, bukan bayangan tebal melayang)

---

## ✍️ Tipografi

- **Font Utama Antarmuka:** `Plus Jakarta Sans` (Font geometris modern yang banyak digunakan pada sistem universitas dan layanan publik modern di Indonesia).
- **Font Kode / Registrasi / Hash:** `JetBrains Mono` (Angka tabular yang presisi untuk nomor surat, NIM/NIP, token UUID, dan checksum SHA-256).

---

## 🗂️ Struktur Halaman Terpisah (Modular / Multi-Page)

Setiap fungsi kini memiliki berkas HTML mandiri dengan penyimpanan data tersinkronisasi (`localStorage`):

1. [`web/index.html`](file:///c:/ValidIn/web/index.html) - Dashboard Utama & Antrean Dokumen Masuk
2. [`web/submit.html`](file:///c:/ValidIn/web/submit.html) - Halaman Pengajuan Berkas Baru (Unggah PDF & Metadata oleh Mahasiswa)
3. [`web/review.html`](file:///c:/ValidIn/web/review.html) - Meja Tinjauan Berkas & Penandatanganan Digital (Split-screen)
4. [`web/verify.html`](file:///c:/ValidIn/web/verify.html) - Portal Publik Verifikasi Keaslian Dokumen (Scan QR)
5. [`web/archive.html`](file:///c:/ValidIn/web/archive.html) - Arsip & Riwayat Lengkap
6. [`web/profile.html`](file:///c:/ValidIn/web/profile.html) - Profil Pejabat Pengesah & Pratinjau Segel
7. [`web/login.html`](file:///c:/ValidIn/web/login.html) - Portal Masuk Sistem
