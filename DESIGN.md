# DESIGN.md — ValidIn (Academic Notary & Institutional Registry)
### Standar Desain Persuratan & Verifikasi Resmi HIMATIF FT UNTIDAR

> Dokumen ini adalah acuan arah desain (*Direction*) untuk **Anti-Slop Filter**.
> Tujuannya memastikan antarmuka ValidIn terasa **crafted by a designer** dan memiliki otoritas resmi akademik, bukan template generik AI SaaS (hindari gradasi ungu neon, tombol kapsul melayang tanpa batas, dan card mengambang tanpa hierarki).

---

## 🎨 1. Palet Warna (Notary & Academic Registry)
- **Background Utama (Canvas):** `#fbfbfa` (Kertas arsip warm stone, ramah mata dan otentik dokumen fisik).
- **Background Kartu & Panel:** `#ffffff` (Putih bersih dengan hairline border 1px tegas `#e4e4e7`).
- **Tinta Teks Utama (Ink 900):** `#18181b` (Kontras tinggi memenuhi standar WCAG AAA).
- **Tinta Teks Sekunder:** `#52525b` (Zinc 600, terbaca jelas).
- **Warna Otoritas UNTIDAR:** `#0f172a` (Deep Slate / Navy 900) & `#1e3a8a` (UNTIDAR Academic Blue).
- **Segel Status Sah (Verified):** `#15803d` (Deep Notary Emerald) dengan latar `#dcfce7`.
- **Segel Perlu Revisi / Warning:** `#b45309` (Warm Amber) dengan latar `#fef3c7`.
- **Segel Penolakan / Error:** `#b91c1c` (Crimson Red) dengan latar `#fee2e2`.
- **Garis Pembatas:** 1px solid `#e4e4e7` (Tegas dan terstruktur, bukan efek bayangan melayang).

---

## ✍️ 2. Tipografi Resmi
- **Font Antarmuka (UI):** `Plus Jakarta Sans`, `-apple-system`, `sans-serif` (Modern, bersih, geometris institusi akademik).
- **Font Registrasi & Kriptografi:** `JetBrains Mono`, `Consolas`, monospace (Angka tabular presisi untuk nomor surat `026.a/E/PM/...`, NPM/NIP, token UUID, dan digest SHA-256).
- **Font Paraf & Tanda Tangan:** Cursive (`Brush Script MT`, cursive) dengan warna biru tinta basah (`#1e3a8a`).
- **Font Catatan Disposisi:** Handlettered script biru pekat di dalam kotak kuning disposisi (*yellow post-it*) sudut kanan atas berkas.

---

## 🏛️ 3. Elemen Fisik Dokumen UNTIDAR
- **Kop Surat Ganda (*Dual Emblem*):** Logo UNTIDAR di kiri, teks institusi & alamat Jl. Kapten Suparman 39 Magelang di tengah, dan logo HIMATIF di kanan, dipisah oleh garis ganda (*double border*) 3px.
- **Matriks Tanda Tangan 2 Baris:**
  - Baris 1: Ketua Pelaksana (Kiri) & Sekretaris Panitia (Kanan).
  - Baris 2: Mengetahui Ketua HIMATIF UNTIDAR (Kiri) & Mengesahkan Wakil Dekan Bidang Akademik & Kemahasiswaan FT UNTIDAR (Kanan).
- **Catatan Disposisi Dekanat:** Kotak instruksi resmi pejabat dekanat untuk Petugas Satpam & Sarpras.
- **Pass QR Code Kriptografis:** QR Code token UUID v4 dan sidik jari SHA-256 yang divalidasi seketika di pos satpam gerbang FT 03.
