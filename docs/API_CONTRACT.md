# REST API Specification - ValidIn
### Kontrak Layanan Backend &bull; HIMATIF Fakultas Teknik Universitas Tidar (UNTIDAR)

Base URL: `http://localhost:8000/api/v1`

Seluruh respons menggunakan format JSON standar:
```json
{
  "success": true,
  "message": "Pesan deskriptif keberhasilan/kegagalan",
  "data": {}
}
```

---

## 1. Autentikasi & Profil Pejabat

### `POST /login`
Masuk ke portal dengan Nomor Pokok Mahasiswa / Nomor Induk Pegawai dan kata sandi SSO.

**Request Body:**
```json
{
  "nim_nip": "2420506041",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Autentikasi pejabat berhasil",
  "data": {
    "token": "1|sanctum_token_untidar_validin_xyz...",
    "user": {
      "id": 1,
      "name": "Hanif Abdillah Alatas",
      "nim_nip": "2420506041",
      "role": "sekretaris",
      "organization": {
        "id": 1,
        "name": "Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)",
        "faculty": "Fakultas Teknik"
      }
    }
  }
}
```

---

## 2. Pengajuan Surat Permohonan Fasilitas

### `POST /documents`
Mengajukan permohonan peminjaman ruangan/alat atau permohonan izin kegiatan resmi.

**Headers:** `Authorization: Bearer {token}`, `Content-Type: multipart/form-data`

**Request Body (Form-Data):**
- `title`: `Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas`
- `event_name`: `Peningkatan Kompetensi Mahasiswa DigitalWave 2026`
- `type`: `Peminjaman Tempat / Gedung`
- `event_date`: `Minggu dan Sabtu, 27 September dan 3 Oktober 2026`
- `event_time`: `06.00 - 16.00 WIB`
- `location`: `Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06`
- `borrowed_items`: `Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06`
- `contact_person`: `+62 851-8470-9553 (Ilyasa)`
- `secretary_name`: `Hanif Abdillah Alatas`
- `secretary_nim`: `2420506041`
- `submitter_name`: `Emannuel Henji Pratama Putra`
- `submitter_nim`: `2505060012`
- `file`: `[File PDF Surat UNTIDAR, maks 5MB]`
- `init_action`: `as_sekretaris` *(pilihan: as_sekretaris | as_pelaksana)*

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Surat permohonan berhasil didaftarkan ke sistem ValidIn UNTIDAR",
  "data": {
    "id": "DOC-UNTIDAR-030A",
    "document_number": "030.a/E/PM/HIMATIF/UNTIDAR/X/2026",
    "title": "Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas",
    "current_status": "menunggu_pelaksana",
    "created_at": "2026-10-30T07:00:00Z"
  }
}
```

---

## 3. Penandatanganan Berjenjang & Keputusan Pejabat

### `PATCH /documents/{id}/signature`
Membubuhi paraf atau tanda tangan digital sesuai hak akses pejabat yang sedang login.

**Headers:** `Authorization: Bearer {token}`

#### Skenario A: Sekretaris Panitia (Paraf Awal)
```json
{
  "action": "sign_secretary"
}
```
*Mengubah status dari `menunggu_sekretaris` menjadi `menunggu_pelaksana`.*

#### Skenario B: Ketua Pelaksana (Tanda Tangan & Cap Panitia)
```json
{
  "action": "sign_pelaksana"
}
```
*Mengubah status dari `menunggu_pelaksana` menjadi `menunggu_ketua`.*

#### Skenario C: Ketua HIMATIF UNTIDAR (Paraf & Cap Resmi Ormawa)
```json
{
  "action": "approve_himatif"
}
```
*Mengubah status dari `menunggu_ketua` menjadi `menunggu_pembina`.*

#### Skenario D: Wakil Dekan FT UNTIDAR (Disposisi Pejabat, Cap Dekanat, & QR Code)
```json
{
  "action": "approve_wadek",
  "disposition_note": "ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks."
}
```
*Mengubah status dari `menunggu_pembina` menjadi `disetujui`, menyematkan catatan disposisi, dan otomatis menerbitkan token QR Code UUID.*

#### Skenario E: Permintaan Revisi (Oleh Pejabat Mana Pun)
```json
{
  "action": "request_revision",
  "notes": "Mohon cantumkan lembar pengantar proposal dan rincian penanggung jawab per ruangan."
}
```
*Mengubah status menjadi `revisi`.*

---

## 4. Verifikasi Publik QR Code (Layanan Khusus Satpam)

### `GET /verify/{token}`
Endpoint publik tanpa autentikasi yang diakses saat Petugas Keamanan memindai kode QR pada lembar surat izin.

**Response (200 OK - Dokumen Sah):**
```json
{
  "success": true,
  "message": "Dokumen resmi terverifikasi sah",
  "data": {
    "status": "VALID",
    "is_approved": true,
    "document_number": "026.a/E/PM/HIMATIF/UNTIDAR/IX/2026",
    "organization": "Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)",
    "faculty": "Fakultas Teknik Universitas Tidar",
    "event_title": "Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas (Peningkatan Kompetensi Mahasiswa DigitalWave 2026)",
    "permitted_rooms": "Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06",
    "permitted_datetime": "Minggu dan Sabtu, 27 September dan 3 Oktober 2026 (06.00 - 16.00 WIB)",
    "disposition_note": "ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.",
    "contact_person": "+62 851-8470-9553 (Ilyasa)",
    "submitter": {
      "name": "Emannuel Henji Pratama Putra",
      "npm": "2505060012",
      "role": "Ketua Pelaksana"
    },
    "secretary": {
      "name": "Hanif Abdillah Alatas",
      "npm": "2420506041"
    },
    "authorized_by": {
      "name": "Dr. Sigit Iswahyudi, S.T., M.T.",
      "nip": "197510302021211005",
      "title": "Wakil Dekan Bidang Akademik dan Kemahasiswaan Fakultas Teknik"
    },
    "signed_at": "2026-09-23T11:15:00Z",
    "qr_token": "7e4b2d19-8663-4871-9f93-c4083a48e89f",
    "hash_sha256": "4d830fba98e104928bfa102934ec784910293847561928374650192837461524"
  }
}
```

---

## 5. Arsip & Ekspor Dokumen

### `GET /documents/archive/export-csv`
Mengunduh seluruh berkas data surat yang terdaftar dalam format file `.csv`.

**Headers:** `Authorization: Bearer {token}`
**Content-Type:** `text/csv`
