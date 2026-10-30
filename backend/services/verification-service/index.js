const express = require('express');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8004;

// Cache map for ultra-fast lookup by security guards
const TOKEN_CACHE = new Map([
  [
    '7e4b2d19-8663-4871-9f93-c4083a48e89f',
    {
      isValid: true,
      regNumber: '026.a/E/PM/HIMATIF/UNTIDAR/IX/2026',
      title: 'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas',
      location: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
      eventDate: 'Minggu dan Sabtu, 27 September & 3 Oktober 2026',
      eventTime: '06.00 - 16.00 WIB',
      submitterName: 'Emannuel Henji Pratama Putra (Ketua Pelaksana)',
      contactPerson: '+62 851-8470-9553 (Ilyasa)',
      verifiedBy: 'Dr. Sigit Iswahyudi, S.T., M.T. (Wakil Dekan I FT UNTIDAR)',
      dispositionNote: 'ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.',
      sha256Digest: '4d830fba98e104928bfa102934ec784910293847561928374650192837461524'
    }
  ]
]);

// Health check
app.get('/health', (req, res) => res.json({ status: 'healthy', service: 'verification-service' }));

// Public Verification Endpoint for Security Guards (<50ms)
app.get('/api/v1/verification/:token', (req, res) => {
  const start = Date.now();
  const token = req.params.token;
  const data = TOKEN_CACHE.get(token);

  if (!data) {
    return res.status(404).json({
      status: 'invalid',
      message: 'Token QR tidak terdaftar atau telah kedaluwarsa.',
      latencyMs: Date.now() - start
    });
  }

  res.json({
    status: 'verified',
    data: data,
    latencyMs: Date.now() - start
  });
});

app.listen(PORT, () => {
  console.log(`[Verification Service - Satpam Gateway] Running on port ${PORT}`);
});
