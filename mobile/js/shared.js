// ValidIn Shared State & Component Controller (UNTIDAR HIMATIF Edition - 4 Official Roles)

const DEFAULT_UNTIDAR_DOCUMENTS = [
  {
    id: 'DOC-UNTIDAR-026A',
    regNumber: '026.a/E/PM/HIMATIF/UNTIDAR/IX/2026',
    title: 'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas',
    type: 'Peminjaman Tempat / Gedung',
    eventName: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026',
    organization: 'Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)',
    destination: 'Yth. Dekan Fakultas Teknik di Universitas Tidar',
    submitterName: 'Emannuel Henji Pratama Putra',
    submitterNim: '2505060012',
    submitterRole: 'Ketua Pelaksana',
    secretaryName: 'Hanif Abdillah Alatas',
    secretaryNim: '2420506041',
    eventDate: 'Minggu dan Sabtu, 27 September dan 3 Oktober 2026',
    eventTime: '06.00 - 16.00 WIB',
    location: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
    borrowedItems: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
    contactPerson: '+62 851-8470-9553 (Ilyasa)',
    status: 'disetujui',
    createdAt: '9 September 2026',
    secretaryApproval: {
      by: 'Hanif Abdillah Alatas',
      npm: '2420506041',
      at: '9 September 2026'
    },
    pelaksanaApproval: {
      by: 'Emannuel Henji Pratama Putra',
      npm: '2505060012',
      at: '9 September 2026'
    },
    ketuaApproval: { 
      by: 'Naufal Miftakhul Siddiq', 
      npm: '2440506060', 
      role: 'Ketua HIMATIF UNTIDAR', 
      at: '10 September 2026' 
    },
    pembinaApproval: { 
      by: 'Dr. Sigit Iswahyudi, S.T., M.T.', 
      nip: '197510302021211005', 
      role: 'Wakil Dekan Bidang Akademik dan Kemahasiswaan Fakultas Teknik', 
      at: '23 September 2026' 
    },
    dispositionNote: 'ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.',
    revisionNotes: '',
    qrToken: '7e4b2d19-8663-4871-9f93-c4083a48e89f',
    hashSha256: '4d830fba98e104928bfa102934ec784910293847561928374650192837461524'
  },
  {
    id: 'DOC-UNTIDAR-026B',
    regNumber: '026.b/E/PM/HIMATIF/UNTIDAR/IX/2026',
    title: 'Surat Permohonan Peminjaman Sound dan 2 Buah Mikrofon',
    type: 'Peminjaman Fasilitas / Alat',
    eventName: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026',
    organization: 'Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)',
    destination: 'Yth. Dekan Fakultas Teknik di Universitas Tidar',
    submitterName: 'Emannuel Henji Pratama Putra',
    submitterNim: '2505060012',
    submitterRole: 'Ketua Pelaksana',
    secretaryName: 'Hanif Abdillah Alatas',
    secretaryNim: '2420506041',
    eventDate: 'Minggu dan Sabtu, 27 September dan 3 Oktober 2026',
    eventTime: '06.00 - 16.00 WIB',
    location: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
    borrowedItems: 'Sound system dan 2 buah mikrofon kabel',
    contactPerson: '+62 851-8470-9553 (Ilyasa)',
    status: 'menunggu_pembina',
    createdAt: '18 September 2026',
    secretaryApproval: {
      by: 'Hanif Abdillah Alatas',
      npm: '2420506041',
      at: '18 September 2026'
    },
    pelaksanaApproval: {
      by: 'Emannuel Henji Pratama Putra',
      npm: '2505060012',
      at: '18 September 2026'
    },
    ketuaApproval: { 
      by: 'Naufal Miftakhul Siddiq', 
      npm: '2440506060', 
      role: 'Ketua HIMATIF UNTIDAR', 
      at: '19 September 2026' 
    },
    pembinaApproval: null,
    dispositionNote: '',
    revisionNotes: '',
    qrToken: '3c71a99b-f722-4882-a901-b208941bc391',
    hashSha256: 'a12bc4439df68903e1074a9840291dfce847291048201fa849204bca091834ef'
  },
  {
    id: 'DOC-UNTIDAR-027A',
    regNumber: '027.a/E/PH/HIMATIF/UNTIDAR/IX/2026',
    title: 'Surat Permohonan Izin Kegiatan DigitalWave 2026',
    type: 'Permohonan Izin Kegiatan',
    eventName: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026',
    organization: 'Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)',
    destination: 'Yth. Wakil Rektor Bidang Kemahasiswaan dan Alumni di Universitas Tidar',
    submitterName: 'Emannuel Henji Pratama Putra',
    submitterNim: '2505060012',
    submitterRole: 'Ketua Pelaksana',
    secretaryName: 'Hanif Abdillah Alatas',
    secretaryNim: '2420506041',
    eventDate: 'Minggu dan Sabtu, 27 September dan 3 Oktober 2026',
    eventTime: '06.00 - 13.00 WIB',
    location: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
    borrowedItems: 'Izin kegiatan dan permohonan keamanan kampus',
    contactPerson: '+62 851-8470-9553 (Ilyasa)',
    status: 'menunggu_ketua',
    createdAt: '24 September 2026',
    secretaryApproval: {
      by: 'Hanif Abdillah Alatas',
      npm: '2420506041',
      at: '24 September 2026'
    },
    pelaksanaApproval: {
      by: 'Emannuel Henji Pratama Putra',
      npm: '2505060012',
      at: '24 September 2026'
    },
    ketuaApproval: null,
    pembinaApproval: null,
    dispositionNote: '',
    revisionNotes: '',
    qrToken: 'f1029384-a829-4109-8472-918237465019',
    hashSha256: 'b381029384756102938475610293847561029384756102938475610293847561'
  },
  {
    id: 'DOC-UNTIDAR-028A',
    regNumber: '028.a/E/PM/HIMATIF/UNTIDAR/X/2026',
    title: 'Surat Permohonan Peminjaman Ruang Rapat E.03.2.02',
    type: 'Peminjaman Tempat / Gedung',
    eventName: 'Rapat Pleno Koordinasi Panitia DigitalWave 2026',
    organization: 'Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)',
    destination: 'Yth. Dekan Fakultas Teknik di Universitas Tidar',
    submitterName: 'Emannuel Henji Pratama Putra',
    submitterNim: '2505060012',
    submitterRole: 'Ketua Pelaksana',
    secretaryName: 'Hanif Abdillah Alatas',
    secretaryNim: '2420506041',
    eventDate: 'Kamis, 15 Oktober 2026',
    eventTime: '15.30 - 18.00 WIB',
    location: 'Gedung FT 03 Lantai 2 Ruang E.03.2.02',
    borrowedItems: 'Ruang Rapat E.03.2.02 dan Proyektor',
    contactPerson: '+62 851-8470-9553 (Ilyasa)',
    status: 'menunggu_pelaksana',
    createdAt: '12 Oktober 2026',
    secretaryApproval: {
      by: 'Hanif Abdillah Alatas',
      npm: '2420506041',
      at: '12 Oktober 2026'
    },
    pelaksanaApproval: null,
    ketuaApproval: null,
    pembinaApproval: null,
    dispositionNote: '',
    revisionNotes: '',
    qrToken: '4b928172-1928-4820-b839-a10293847162',
    hashSha256: 'c901827364510293847561029384756102938475610293847561029384756102'
  },
  {
    id: 'DOC-UNTIDAR-029A',
    regNumber: '029.a/E/PM/HIMATIF/UNTIDAR/X/2026',
    title: 'Surat Permohonan Pemasangan Spanduk & Baliho Promosi',
    type: 'Permohonan Izin Kegiatan',
    eventName: 'Sosialisasi DigitalWave 2026 di Selasar FT',
    organization: 'Himpunan Mahasiswa Teknologi Informasi (HIMATIF UNTIDAR)',
    destination: 'Yth. Wakil Dekan Bidang Umum dan Keuangan Fakultas Teknik',
    submitterName: 'Emannuel Henji Pratama Putra',
    submitterNim: '2505060012',
    submitterRole: 'Ketua Pelaksana',
    secretaryName: 'Hanif Abdillah Alatas',
    secretaryNim: '2420506041',
    eventDate: 'Senin - Sabtu, 19 - 24 Oktober 2026',
    eventTime: '07.00 - 17.00 WIB',
    location: 'Selasar Gedung FT 01 dan FT 03',
    borrowedItems: 'Izin pasang 2 unit spanduk promosi ormawa',
    contactPerson: '+62 851-8470-9553 (Ilyasa)',
    status: 'menunggu_sekretaris',
    createdAt: '18 Oktober 2026',
    secretaryApproval: null,
    pelaksanaApproval: null,
    ketuaApproval: null,
    pembinaApproval: null,
    dispositionNote: '',
    revisionNotes: '',
    qrToken: '8a726152-9281-4819-a928-102938475610',
    hashSha256: 'd819283746501928374650192837465019283746501928374650192837465019'
  }
];

const STORAGE_KEY = 'validin_untidar_docs_v3';
const ROLE_KEY = 'validin_active_role_untidar_v3';

// Initialize storage cleanly
function initStorage() {
  if (!localStorage.getItem(STORAGE_KEY)) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(DEFAULT_UNTIDAR_DOCUMENTS));
  }
  if (!localStorage.getItem(ROLE_KEY)) {
    localStorage.setItem(ROLE_KEY, 'sekretaris');
  }
}

function getDocs() {
  initStorage();
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed) && parsed.length > 0) {
      return parsed;
    }
    return DEFAULT_UNTIDAR_DOCUMENTS;
  } catch (e) {
    return DEFAULT_UNTIDAR_DOCUMENTS;
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

// Reset docs to clean initial demo state if needed
function resetDemoData() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(DEFAULT_UNTIDAR_DOCUMENTS));
  showToast('Data percontohan UNTIDAR berhasil dimuat ulang!');
  setTimeout(() => window.location.reload(), 400);
}

// Normalize role names to the 4 official UNTIDAR officers
function getCurrentRole() {
  initStorage();
  const r = localStorage.getItem(ROLE_KEY) || 'sekretaris';
  if (r === 'mahasiswa') return 'ketua_pelaksana';
  if (r === 'ketua') return 'ketua_himatif';
  if (r === 'pembina') return 'wadek';
  return r;
}

function setCurrentRole(role) {
  localStorage.setItem(ROLE_KEY, role);
}

// Complete metadata for each of the 4 Official Officers
function getUserProfileByRole(role) {
  const r = role || getCurrentRole();
  switch (r) {
    case 'sekretaris':
      return {
        roleKey: 'sekretaris',
        roleLabel: 'Sekretaris Panitia',
        name: 'Hanif Abdillah Alatas',
        idNum: 'NPM. 2420506041',
        title: 'Sekretaris Panitia DigitalWave 2026',
        org: 'HIMATIF UNTIDAR',
        dept: 'Fakultas Teknik Universitas Tidar',
        email: 'hanif.abdillah@students.untidar.ac.id',
        signatureText: 'Hanif Abdillah A.',
        initials: 'HA',
        stampName: 'PARAF KESEKRETARIATAN PANITIA',
        stampColor: '#0284c7',
        dutyDesc: 'Penyusunan format surat, verifikasi draf nomor registrasi, dan paraf awal berkas permohonan.'
      };
    case 'ketua_pelaksana':
    case 'mahasiswa':
      return {
        roleKey: 'ketua_pelaksana',
        roleLabel: 'Ketua Pelaksana',
        name: 'Emannuel Henji Pratama Putra',
        idNum: 'NPM. 2505060012',
        title: 'Ketua Pelaksana DigitalWave 2026',
        org: 'HIMATIF UNTIDAR',
        dept: 'Fakultas Teknik Universitas Tidar',
        email: 'henji.pratama@students.untidar.ac.id',
        signatureText: 'Henji Pratama P.',
        initials: 'EH',
        stampName: 'CAP PANITIA PELAKSANA DIGITALWAVE',
        stampColor: '#2563eb',
        dutyDesc: 'Penanggung jawab kegiatan, penandatanganan surat permohonan, dan pembubuhan cap panitia.'
      };
    case 'ketua_himatif':
    case 'ketua':
      return {
        roleKey: 'ketua_himatif',
        roleLabel: 'Ketua HIMATIF UNTIDAR',
        name: 'Naufal Miftakhul Siddiq',
        idNum: 'NPM. 2440506060',
        title: 'Ketua Himpunan Mahasiswa Teknologi Informasi 2026/2027',
        org: 'HIMATIF UNTIDAR',
        dept: 'Fakultas Teknik Universitas Tidar',
        email: 'untidarhimatif@gmail.com',
        signatureText: 'Naufal Miftakhul S.',
        initials: 'NM',
        stampName: 'CAP RESMI LINGKARAN HIMATIF UNTIDAR',
        stampColor: '#1d4ed8',
        dutyDesc: 'Peninjauan kelayakan kegiatan ormawa, paraf mengetahui, dan pembubuhan stempel resmi himpunan.'
      };
    case 'wadek':
    case 'pembina':
      return {
        roleKey: 'wadek',
        roleLabel: 'Wakil Dekan FT / Pejabat Fakultas',
        name: 'Dr. Sigit Iswahyudi, S.T., M.T.',
        idNum: 'NIP. 197510302021211005',
        title: 'Wakil Dekan Bidang Akademik dan Kemahasiswaan Fakultas Teknik',
        org: 'Fakultas Teknik Universitas Tidar',
        dept: 'Dekanat Fakultas Teknik UNTIDAR',
        email: 'sigit.iswahyudi@untidar.ac.id',
        signatureText: 'Dr. Sigit Iswahyudi',
        initials: 'SI',
        stampName: 'CAP RESMI DEKANAT FAKULTAS TEKNIK UNTIDAR',
        stampColor: '#dc2626',
        dutyDesc: 'Otoritas perizinan fasilitas kampus, penulisan catatan disposisi Satpam, pengesahan akhir, dan penerbitan QR Code.'
      };
    default:
      return {
        roleKey: 'sekretaris',
        roleLabel: 'Sekretaris Panitia',
        name: 'Hanif Abdillah Alatas',
        idNum: 'NPM. 2420506041',
        title: 'Sekretaris Panitia DigitalWave',
        org: 'HIMATIF UNTIDAR',
        dept: 'Fakultas Teknik Universitas Tidar',
        email: 'hanif.abdillah@students.untidar.ac.id',
        signatureText: 'Hanif Abdillah A.',
        initials: 'HA',
        stampName: 'PARAF KESEKRETARIATAN PANITIA',
        stampColor: '#0284c7',
        dutyDesc: 'Penyusunan format surat dan paraf awal.'
      };
  }
}

// Master Header Generator with Authentic Account Badge & Switcher
function renderHeader(activePage = 'dashboard') {
  const currentRole = getCurrentRole();
  const profile = getUserProfileByRole(currentRole);
  const headerElem = document.getElementById('siteHeader');
  if (!headerElem) return;

  // Nav items per role
  let navItems = '';
  if (currentRole === 'sekretaris') {
    navItems = `
      <a href="index.html" class="nav-link ${activePage === 'dashboard' ? 'active' : ''}">Draf & Surat Panitia</a>
      <a href="submit.html" class="nav-link ${activePage === 'submit' ? 'active' : ''}">+ Buat Surat Baru</a>
      <a href="archive.html" class="nav-link ${activePage === 'archive' ? 'active' : ''}">Arsip Surat</a>
      <a href="profile.html" class="nav-link ${activePage === 'profile' ? 'active' : ''}">Profil & Paraf</a>
      <a href="verify.html" class="nav-link ${activePage === 'verify' ? 'active' : ''}">Cek QR Validasi</a>
    `;
  } else if (currentRole === 'ketua_pelaksana') {
    navItems = `
      <a href="index.html" class="nav-link ${activePage === 'dashboard' ? 'active' : ''}">Persetujuan Pelaksana</a>
      <a href="archive.html" class="nav-link ${activePage === 'archive' ? 'active' : ''}">Arsip Surat Panitia</a>
      <a href="profile.html" class="nav-link ${activePage === 'profile' ? 'active' : ''}">Profil & Cap Panitia</a>
      <a href="verify.html" class="nav-link ${activePage === 'verify' ? 'active' : ''}">Cek QR Validasi</a>
    `;
  } else if (currentRole === 'ketua_himatif') {
    navItems = `
      <a href="index.html" class="nav-link ${activePage === 'dashboard' ? 'active' : ''}">Antrean Surat HIMATIF</a>
      <a href="archive.html" class="nav-link ${activePage === 'archive' ? 'active' : ''}">Arsip Surat Ormawa</a>
      <a href="profile.html" class="nav-link ${activePage === 'profile' ? 'active' : ''}">Profil & Cap HIMATIF</a>
      <a href="verify.html" class="nav-link ${activePage === 'verify' ? 'active' : ''}">Cek QR Validasi</a>
    `;
  } else if (currentRole === 'wadek') {
    navItems = `
      <a href="index.html" class="nav-link ${activePage === 'dashboard' ? 'active' : ''}">Meja Disposisi Wadek FT</a>
      <a href="archive.html" class="nav-link ${activePage === 'archive' ? 'active' : ''}">Arsip Fakultas Teknik</a>
      <a href="profile.html" class="nav-link ${activePage === 'profile' ? 'active' : ''}">Segel & Otoritas Wadek</a>
      <a href="verify.html" class="nav-link ${activePage === 'verify' ? 'active' : ''}">Cek QR Validasi</a>
    `;
  }

  headerElem.innerHTML = `
    <div class="gov-ribbon">
      <div>SISTEM PENGESAHAN SURAT KEGIATAN & PEMINJAMAN <strong>UNIVERSITAS TIDAR (UNTIDAR)</strong></div>
      <div style="font-family: var(--font-mono); font-size: 0.7rem;">HIMATIF &bull; FAKULTAS TEKNIK</div>
    </div>
    <div class="header-container">
      <a href="index.html" class="header-brand">
        <img src="assets/img/logo_untidar.png" alt="Logo UNTIDAR" style="width: 34px; height: 34px; object-fit: contain;">
        <div class="brand-text">
          <span class="brand-title">ValidIn UNTIDAR</span>
          <span class="brand-subtitle">${profile.roleLabel}</span>
        </div>
      </a>

      <nav class="header-nav">
        ${navItems}
      </nav>

      <div class="header-actions">
        <!-- Authentic User Account Switcher (No simulation text!) -->
        <div class="user-account-chip" title="Klik untuk beralih akun pejabat/pengguna resmi UNTIDAR">
          <div class="user-chip-avatar">${profile.initials}</div>
          <div class="user-chip-meta">
            <div class="user-chip-name">${profile.name}</div>
            <div class="user-chip-role">${profile.roleLabel} &#9662;</div>
          </div>
          <select id="headerUserSwitcher" class="user-chip-select" aria-label="Ganti Akun Pengguna">
            <option value="sekretaris" ${currentRole === 'sekretaris' ? 'selected' : ''}>Hanif Abdillah Alatas &bull; Sekretaris Panitia (NPM. 2420506041)</option>
            <option value="ketua_pelaksana" ${currentRole === 'ketua_pelaksana' ? 'selected' : ''}>Emannuel Henji Pratama Putra &bull; Ketua Pelaksana (NPM. 2505060012)</option>
            <option value="ketua_himatif" ${currentRole === 'ketua_himatif' ? 'selected' : ''}>Naufal Miftakhul Siddiq &bull; Ketua HIMATIF (NPM. 2440506060)</option>
            <option value="wadek" ${currentRole === 'wadek' ? 'selected' : ''}>Dr. Sigit Iswahyudi, S.T., M.T. &bull; Wakil Dekan FT (NIP. 197510302021211005)</option>
          </select>
        </div>
      </div>
    </div>
  `;

  // Bind account switcher with clean reload
  const switcher = document.getElementById('headerUserSwitcher');
  if (switcher) {
    switcher.addEventListener('change', (e) => {
      const selected = e.target.value;
      setCurrentRole(selected);
      const newProf = getUserProfileByRole(selected);
      showToast(`Beralih ke akun resmi: ${newProf.name} (${newProf.roleLabel})`);
      setTimeout(() => window.location.reload(), 250);
    });
  }
}

// Master Footer
function renderFooter() {
  const footerElem = document.getElementById('siteFooter');
  if (!footerElem) return;

  footerElem.innerHTML = `
    <div class="footer-content">
      <div>
        <strong>ValidIn UNTIDAR</strong> &bull; Sistem Pengesahan Dokumen Digital Himpunan Mahasiswa Teknologi Informasi.
      </div>
      <div>
        Fakultas Teknik Universitas Tidar &bull; Jl. Kapten Suparman 39 Magelang 56116
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
  toast.innerHTML = `
    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <span>${message}</span>
  `;
  toastContainer.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(8px)';
    toast.style.transition = 'all 0.25s ease';
    setTimeout(() => toast.remove(), 250);
  }, 3200);
}

// Status Badge Markup with 5-stage workflow
function getStatusBadgeMarkup(status) {
  switch (status) {
    case 'menunggu_sekretaris':
      return `<span class="badge-status badge-pending" style="color: #0284c7; background: #f0f9ff; border-color: #bae6fd;">Menunggu Paraf Sekretaris</span>`;
    case 'menunggu_pelaksana':
      return `<span class="badge-status badge-pending" style="color: #2563eb; background: #eff6ff; border-color: #bfdbfe;">Menunggu Tanda Tangan Pelaksana</span>`;
    case 'menunggu_ketua':
      return `<span class="badge-status badge-pending">Menunggu Ketua HIMATIF</span>`;
    case 'menunggu_pembina':
      return `<span class="badge-status badge-pending" style="color: #4338ca; background: #e0e7ff; border-color: #c7d2fe;">Menunggu Disposisi Wadek FT</span>`;
    case 'disetujui':
      return `<span class="badge-status badge-approved">Telah Disahkan (QR Terbit)</span>`;
    case 'revisi':
      return `<span class="badge-status badge-revision">Perlu Perbaikan / Revisi</span>`;
    default:
      return `<span class="badge-status badge-type">${status}</span>`;
  }
}
