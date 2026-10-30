// ValidIn Shared State & Component Controller (LocalStorage Sync)

const DEFAULT_DOCUMENTS = [
  {
    id: 'DOC-2026-001',
    regNumber: 'DOC/2026/10/HMIF/001',
    title: 'Proposal Malam Keakraban Mahasiswa Informatika 2026',
    type: 'Proposal Kegiatan',
    organization: 'Himpunan Mahasiswa Informatika (HMIF)',
    submitterName: 'Ahmad Fauzi',
    submitterNim: '220101001',
    eventDate: '2026-11-20',
    location: 'Villa Bukit Pinus, Bogor',
    budget: 'Rp 14.500.000',
    status: 'menunggu_ketua', // 'menunggu_ketua' | 'menunggu_pembina' | 'disetujui' | 'revisi'
    createdAt: '30 Okt 2026, 08:30 WIB',
    ketuaApproval: null,
    pembinaApproval: null,
    revisionNotes: '',
    qrToken: 'e8b74c20-4a81-432d-98e3-51da665d9101',
    hashSha256: '9f83a48e89f81a179e0a8b9f1d014bc0892015df3146d9a0d8e2a3c749021b14'
  },
  {
    id: 'DOC-2026-002',
    regNumber: 'DOC/2026/10/BEM/014',
    title: 'Surat Permohonan Izin Penggunaan Aula Utama Kampus',
    type: 'Surat Izin',
    organization: 'Badan Eksekutif Mahasiswa (BEM)',
    submitterName: 'Rian Syahputra',
    submitterNim: '210102045',
    eventDate: '2026-11-15',
    location: 'Auditorium Gedung Rektorat Lt. 3',
    budget: 'Rp 0 (Peminjaman Fasilitas)',
    status: 'menunggu_pembina',
    createdAt: '29 Okt 2026, 14:15 WIB',
    ketuaApproval: { by: 'M. Hafiz (Ketua BEM)', at: '29 Okt 2026, 16:40 WIB' },
    pembinaApproval: null,
    revisionNotes: '',
    qrToken: '3c71a99b-f722-4882-a901-b208941bc391',
    hashSha256: 'a12bc4439df68903e1074a9840291dfce847291048201fa849204bca091834ef'
  },
  {
    id: 'DOC-2026-003',
    regNumber: 'DOC/2026/10/ROBOTIK/005',
    title: 'Laporan Pertanggungjawaban (LPJ) Workshop IoT dan Robotika',
    type: 'LPJ',
    organization: 'Unit Kegiatan Mahasiswa Robotika',
    submitterName: 'Dewi Lestari',
    submitterNim: '220104012',
    eventDate: '2026-10-18',
    location: 'Lab Komputasi Terapan',
    budget: 'Rp 6.200.000',
    status: 'disetujui',
    createdAt: '25 Okt 2026, 10:00 WIB',
    ketuaApproval: { by: 'Bagas Pratama (Ketua UKM)', at: '25 Okt 2026, 13:00 WIB' },
    pembinaApproval: { by: 'Dr. Ir. Budi Santoso, M.Kom', at: '26 Okt 2026, 09:20 WIB' },
    revisionNotes: '',
    qrToken: '7e4b2d19-8663-4871-9f93-c4083a48e89f',
    hashSha256: '4d830fba98e104928bfa102934ec784910293847561928374650192837461524'
  },
  {
    id: 'DOC-2026-004',
    regNumber: 'DOC/2026/10/HMIF/002',
    title: 'Proposal Lomba Koding Nasional IFest 2026',
    type: 'Proposal Kegiatan',
    organization: 'Himpunan Mahasiswa Informatika (HMIF)',
    submitterName: 'Siti Nurhaliza',
    submitterNim: '220101089',
    eventDate: '2026-12-05',
    location: 'Daring & Gedung Serbaguna',
    budget: 'Rp 28.000.000',
    status: 'revisi',
    createdAt: '28 Okt 2026, 11:20 WIB',
    ketuaApproval: null,
    pembinaApproval: null,
    revisionNotes: 'Mohon perbaiki rincian honor juri eksternal dan lampirkan jadwal rundown terperinci.',
    qrToken: 'f1029384-a829-4109-8472-918237465019',
    hashSha256: 'b381029384756102938475610293847561029384756102938475610293847561'
  }
];

const STORAGE_KEY = 'validin_db_documents';
const ROLE_KEY = 'validin_active_role';

// Initialize LocalStorage Data
function initStorage() {
  if (!localStorage.getItem(STORAGE_KEY)) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(DEFAULT_DOCUMENTS));
  }
  if (!localStorage.getItem(ROLE_KEY)) {
    localStorage.setItem(ROLE_KEY, 'ketua');
  }
}

function getDocs() {
  initStorage();
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY)) || DEFAULT_DOCUMENTS;
  } catch (e) {
    return DEFAULT_DOCUMENTS;
  }
}

function getDocById(id) {
  const docs = getDocs();
  return docs.find(d => d.id === id);
}

function saveDoc(updatedDoc) {
  const docs = getDocs();
  const index = docs.findIndex(d => d.id === updatedDoc.id);
  if (index !== -1) {
    docs[index] = updatedDoc;
    localStorage.setItem(STORAGE_KEY, JSON.stringify(docs));
  }
}

function addDoc(newDoc) {
  const docs = getDocs();
  docs.unshift(newDoc);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(docs));
}

function getCurrentRole() {
  return localStorage.getItem(ROLE_KEY) || 'ketua';
}

function setCurrentRole(role) {
  localStorage.setItem(ROLE_KEY, role);
}

// Render Master Navigation Header
function renderHeader(activePage = 'dashboard') {
  const currentRole = getCurrentRole();
  const headerElem = document.getElementById('siteHeader');
  if (!headerElem) return;

  const roleLabels = {
    ketua: 'Ketua Organisasi',
    pembina: 'Dosen Pembina',
    mahasiswa: 'Mahasiswa (Pengaju)',
    admin: 'Administrator'
  };

  headerElem.innerHTML = `
    <div class="gov-ribbon">
      <div>Sistem Pengesahan Dokumen Digital Resmi <strong>ValidIn</strong></div>
      <div style="font-family: var(--font-mono);">KEMENDIKBUDRISTEK KAMPUS TERPADU</div>
    </div>
    <div class="header-container">
      <a href="index.html" class="header-brand">
        <div class="brand-symbol">V</div>
        <div class="brand-text">
          <span class="brand-title">ValidIn</span>
          <span class="brand-subtitle">Portal Validasi Dokumen</span>
        </div>
      </a>

      <nav class="header-nav">
        <a href="index.html" class="nav-link ${activePage === 'dashboard' ? 'active' : ''}">Antrean</a>
        <a href="submit.html" class="nav-link ${activePage === 'submit' ? 'active' : ''}">+ Ajukan Berkas</a>
        <a href="archive.html" class="nav-link ${activePage === 'archive' ? 'active' : ''}">Arsip Dokumen</a>
        <a href="verify.html" class="nav-link ${activePage === 'verify' ? 'active' : ''}">Cek QR Validitas</a>
        <a href="profile.html" class="nav-link ${activePage === 'profile' ? 'active' : ''}">Profil & Segel</a>
      </nav>

      <div class="header-actions">
        <div class="role-badge-box">
          <span style="font-size: 0.72rem; color: var(--text-tertiary); text-transform: uppercase;">Peran:</span>
          <select id="headerRoleSwitcher">
            <option value="ketua" ${currentRole === 'ketua' ? 'selected' : ''}>Ketua Organisasi</option>
            <option value="pembina" ${currentRole === 'pembina' ? 'selected' : ''}>Dosen Pembina</option>
            <option value="mahasiswa" ${currentRole === 'mahasiswa' ? 'selected' : ''}>Mahasiswa (Pengaju)</option>
            <option value="admin" ${currentRole === 'admin' ? 'selected' : ''}>Admin Kemahasiswaan</option>
          </select>
        </div>
        <a href="login.html" class="btn btn-outline btn-sm">Keluar</a>
      </div>
    </div>
  `;

  // Bind role switcher change
  const roleSelect = document.getElementById('headerRoleSwitcher');
  if (roleSelect) {
    roleSelect.addEventListener('change', (e) => {
      setCurrentRole(e.target.value);
      showToast(`Beralih ke peran: ${roleLabels[e.target.value]}`);
      setTimeout(() => window.location.reload(), 400);
    });
  }
}

// Render Master Footer
function renderFooter() {
  const footerElem = document.getElementById('siteFooter');
  if (!footerElem) return;

  footerElem.innerHTML = `
    <div class="footer-content">
      <div>
        <strong>ValidIn</strong> - Sistem Pengesahan & Validasi Dokumen Kampus Berbasis QR Code.
      </div>
      <div>
        Mata Kuliah: Sistem Web dan Seluler Lanjut (2026)
      </div>
    </div>
  `;
}

// Global Toast System
function showToast(message) {
  let toastContainer = document.getElementById('toastContainer');
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.id = 'toastContainer';
    document.body.appendChild(toastContainer);
  }

  const toast = document.createElement('div');
  toast.className = 'toast-box';
  toast.innerHTML = `<span>${message}</span>`;
  toastContainer.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity 0.2s';
    setTimeout(() => toast.remove(), 200);
  }, 3200);
}

// Get Badge Markup
function getStatusBadgeMarkup(status) {
  switch (status) {
    case 'menunggu_ketua':
      return `<span class="badge-status badge-pending">Menunggu Persetujuan Ketua</span>`;
    case 'menunggu_pembina':
      return `<span class="badge-status badge-pending" style="color: #4338ca; background: #e0e7ff; border-color: #c7d2fe;">Menunggu Dosen Pembina</span>`;
    case 'disetujui':
      return `<span class="badge-status badge-approved">Telah Disahkan & Sah</span>`;
    case 'revisi':
      return `<span class="badge-status badge-revision">Perlu Revisi</span>`;
    default:
      return `<span class="badge-status badge-type">${status}</span>`;
  }
}
