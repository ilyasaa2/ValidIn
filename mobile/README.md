# ValidIn Mobile - Android Application (Flutter)
### Modul Aplikasi Seluler Pengajuan & Digital Pass Satpam FT UNTIDAR

Modul ini sepenuhnya terpisah (*decoupled*) dari portal web desktop pejabat, dirancang khusus untuk mahasiswa, pengurus ormawa (HIMATIF), dan petugas lapangan menggunakan arsitektur **Clean Minimalist Architecture**.

---

## 📱 Fitur Utama Aplikasi Mobile

1. **Dashboard & Status Stepper 4 Tahap:**
   - Memantau alur pengesahan surat berjenjang secara transparan (Sekretaris $\rightarrow$ Ketua Pelaksana $\rightarrow$ Ketum HIMATIF $\rightarrow$ Wadek I FT).
2. **Pengajuan Izin Fasilitas Ringkas:**
   - Formulir cepat dengan 3 template siap pakai (*Gedung FT 03*, *Sound & Mic*, *Ruang Rapat*).
3. **Digital Pass Satpam (QR Code Sah):**
   - Kartu pass resmi gerbang FT 03 dengan QR Code beresolusi tinggi, nomor registrasi surat, dan **Catatan Disposisi Wadek I FT** untuk dibaca petugas satpam di pos jaga.
4. **Pemindai Kamera QR Terintegrasi:**
   - Menggunakan `mobile_scanner` untuk memvalidasi keaslian surat langsung di lapangan.

---

## 🛠️ Cara Menjalankan Aplikasi Mobile

### 1. Menjalankan di Emulator / Device Android Fisik (Flutter):
Pastikan Flutter SDK telah terpasang di komputer Anda:

```bash
cd mobile
flutter pub get
flutter run
```

### 2. Kompilasi Menjadi APK Rilis Siap Pasang:
```bash
flutter build apk --release
```
Berkas APK akan tersedia di: `build/app/outputs/flutter-apk/app-release.apk`.

### 3. Menjalankan Versi Web Mobile Preview Secara Terpisah:
Anda juga dapat menjalankan antarmuka mobile ini secara independen melalui browser:
```bash
# Jalankan web server di port 8081
cd mobile
python -m http.server 8081
# Buka di browser: http://localhost:8081
```

---

## 🔌 Koneksi ke Microservices API Gateway
Aplikasi mobile berkomunikasi dengan backend melalui **API Gateway** pada endpoint:
- **Base URL:** `http://localhost:8000/api/v1` (atau `http://10.0.2.2:8000/api/v1` untuk Android Emulator)
- `/documents` $\rightarrow$ Document Service
- `/verification/{token}` $\rightarrow$ Verification Service
- `/auth` $\rightarrow$ Auth Service
