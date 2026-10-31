const express = require('express');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 8002;

let documents = [
  {
    id: 'DOC-UNTIDAR-026A',
    regNumber: '026.a/E/PM/HIMATIF/UNTIDAR/IX/2026',
    title: 'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas',
    type: 'Peminjaman Tempat / Gedung',
    eventName: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026',
    organization: 'HIMATIF Fakultas Teknik UNTIDAR',
    location: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
    eventDate: 'Minggu dan Sabtu, 27 September & 3 Oktober 2026',
    eventTime: '06.00 - 16.00 WIB',
    submitterName: 'Emannuel Henji Pratama Putra',
    contactPerson: '+62 851-8470-9553 (Ilyasa)',
    status: 'disetujui',
    qrToken: '7e4b2d19-8663-4871-9f93-c4083a48e89f',
    dispositionNote: 'ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.',
    secretaryApproval: { by: 'Hanif Abdillah Alatas', npm: '2420506041', at: '9 Sep 2026' },
    pelaksanaApproval: { by: 'Emannuel Henji Pratama Putra', npm: '2505060012', at: '9 Sep 2026' },
    ketuaApproval: { by: 'Naufal Miftakhul Siddiq', npm: '2440506060', at: '10 Sep 2026' },
    pembinaApproval: { by: 'Dr. Sigit Iswahyudi, S.T., M.T.', nip: '197510302021211005', at: '23 Sep 2026' }
  }
];

// Health check
app.get('/health', (req, res) => res.json({ status: 'healthy', service: 'document-service' }));

// Get all documents
app.get('/api/v1/documents', (req, res) => {
  res.json({ status: 'success', data: documents });
});

// Get document by ID
app.get('/api/v1/documents/:id', (req, res) => {
  const doc = documents.find(d => d.id === req.params.id);
  if (!doc) return res.status(404).json({ status: 'error', message: 'Dokumen tidak ditemukan' });
  res.json({ status: 'success', data: doc });
});

// Submit new document (Sekretaris Panitia)
app.post('/api/v1/documents', (req, res) => {
  const newDoc = {
    id: `DOC-UNTIDAR-${Date.now()}`,
    regNumber: `${Math.floor(100 + Math.random() * 900)}/E/PM/HIMATIF/UNTIDAR/X/2026`,
    title: req.body.title || `Surat Permohonan Izin ${req.body.location}`,
    type: req.body.type || 'Peminjaman Fasilitas Kampus',
    eventName: req.body.eventName,
    organization: 'Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)',
    location: req.body.location,
    eventDate: req.body.eventDate,
    eventTime: req.body.eventTime,
    submitterName: 'Emannuel Henji Pratama Putra',
    contactPerson: req.body.contactPerson,
    status: 'menunggu_pelaksana',
    createdAt: new Date().toLocaleDateString('id-ID'),
    qrToken: `uuid-${Date.now()}`,
    dispositionNote: '',
    secretaryApproval: { by: 'Hanif Abdillah Alatas', npm: '2420506041', at: 'Hari ini' }
  };
  documents.unshift(newDoc);
  res.status(201).json({ status: 'success', data: newDoc });
});

// Approve document (State Machine 4 Tahap)
app.post('/api/v1/documents/:id/approve', (req, res) => {
  const doc = documents.find(d => d.id === req.params.id);
  if (!doc) return res.status(404).json({ status: 'error', message: 'Dokumen tidak ditemukan' });

  const { role, dispositionNote } = req.body;
  if (role === 'ketua_pelaksana') {
    doc.pelaksanaApproval = { by: 'Emannuel Henji Pratama Putra', npm: '2505060012', at: 'Hari ini' };
    doc.status = 'menunggu_ketua';
  } else if (role === 'ketua_himatif') {
    doc.ketuaApproval = { by: 'Naufal Miftakhul Siddiq', npm: '2440506060', at: 'Hari ini' };
    doc.status = 'menunggu_pembina';
  } else if (role === 'wadek') {
    doc.pembinaApproval = { by: 'Dr. Sigit Iswahyudi, S.T., M.T.', nip: '197510302021211005', at: 'Hari ini' };
    doc.dispositionNote = dispositionNote || 'ACC: Satpam mhn bantuan u/ buka gedung & kelas.';
    doc.status = 'disetujui';
  }

  res.json({ status: 'success', message: 'Status surat berhasil diperbarui', data: doc });
});

app.listen(PORT, () => {
  console.log(`[Document Service] Running on port ${PORT}`);
});
