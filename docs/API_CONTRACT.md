# REST API Specification - ValidIn

Base URL: `http://localhost:8000/api/v1`

Semua respons menggunakan format JSON standar:
```json
{
  "success": true,
  "message": "Pesan deskriptif",
  "data": {}
}
```

---

## 1. Autentikasi

### `POST /login`
Masuk ke sistem dan menerima token bearer (Sanctum).

**Request Body:**
```json
{
  "nim_nip": "220101001",
  "password": "secretpassword"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "token": "1|sanctum_token_string_here...",
    "user": {
      "id": 1,
      "name": "Ahmad Fauzi",
      "nim_nip": "220101001",
      "role": "mahasiswa",
      "organization": {
        "id": 1,
        "name": "Himpunan Mahasiswa Informatika (HMIF)"
      }
    }
  }
}
```

---

## 2. Pengajuan & Manajemen Dokumen

### `POST /documents`
Mengunggah pengajuan dokumen baru (Hanya Mahasiswa).

**Headers:** `Authorization: Bearer {token}`, `Content-Type: multipart/form-data`

**Request Body (Form-Data):**
- `title`: `Proposal Makrab Informatika 2026`
- `event_name`: `Malam Keakraban Mahasiswa 2026`
- `event_date`: `2026-11-20`
- `type`: `proposal`
- `file`: `[File PDF, maks 5MB]`

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Dokumen berhasil diajukan untuk ditinjau Ketua",
  "data": {
    "id": 10,
    "document_number": "DOC/2026/10/HMIF/001",
    "title": "Proposal Makrab Informatika 2026",
    "current_status": "menunggu_ketua",
    "created_at": "2026-10-30T06:00:00Z"
  }
}
```

---

### `GET /documents/me`
Melihat daftar riwayat dokumen yang diajukan oleh pengguna yang sedang login.

**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": 10,
      "document_number": "DOC/2026/10/HMIF/001",
      "title": "Proposal Makrab Informatika 2026",
      "event_name": "Malam Keakraban Mahasiswa 2026",
      "current_status": "menunggu_pembina",
      "latest_version": 1,
      "created_at": "2026-10-30T06:00:00Z"
    }
  ]
}
```

---

### `GET /documents/pending`
Melihat antrean dokumen masuk untuk ditinjau (Peran: Ketua / Pembina).

**Headers:** `Authorization: Bearer {token}`

---

### `PATCH /documents/{id}/status`
Memberikan keputusan (Approve / Request Revision / Reject).

**Headers:** `Authorization: Bearer {token}`

**Request Body:**
```json
{
  "action": "approve", // 'approve' | 'request_revision' | 'reject'
  "notes": "Format anggaran sudah sesuai. Disetujui untuk diteruskan ke Pembina."
}
```

---

### `GET /documents/{id}/download`
Mengunduh berkas PDF yang aman (hanya untuk pengaju bersangkutan dan pihak berwenang).

**Headers:** `Authorization: Bearer {token}`

---

## 3. Verifikasi Publik (Tanpa Autentikasi)

### `GET /verify/{token}`
Verifikasi keabsahan dokumen saat QR Code dipindai oleh pihak luar/keamanan kampus.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Dokumen Asli dan Sah",
  "data": {
    "status": "VALID",
    "document_number": "DOC/2026/10/HMIF/001",
    "title": "Proposal Makrab Informatika 2026",
    "organization": "Himpunan Mahasiswa Informatika (HMIF)",
    "pengaju": "Ahmad Fauzi (220101001)",
    "signed_by": "Dr. Ir. Budi Santoso, M.Kom (Pembina HMIF)",
    "signed_at": "2026-10-30 14:20:00 WIB",
    "verification_url": "https://validin.kampus.ac.id/verify/e8b74c20-..."
  }
}
```
