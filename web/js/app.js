// ValidIn Interactive Prototype State & Controller

const APP_STATE = {
  currentRole: 'ketua', // 'ketua' | 'pembina' | 'admin'
  currentView: 'dashboard',
  selectedDocId: 'DOC-2026-001',
  theme: 'light',
  
  // Real academic campus documents mock data
  documents: [
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
  ]
};

// Initialize Application
document.addEventListener('DOMContentLoaded', () => {
  setupNavigation();
  setupRoleSwitcher();
  setupModals();
  setupVerificationSearch();
  setupThemeToggle();
  renderDashboard();
});

// Navigation Controller
function setupNavigation() {
  const navButtons = document.querySelectorAll('[data-target-view]');
  navButtons.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const targetView = btn.getAttribute('data-target-view');
      navigateToView(targetView);

      // Close mobile menu if open
      const sidebar = document.getElementById('sidebar');
      if (sidebar && sidebar.classList.contains('open')) {
        sidebar.classList.remove('open');
      }
    });
  });

  const mobileToggle = document.getElementById('mobileMenuToggle');
  if (mobileToggle) {
    mobileToggle.addEventListener('click', () => {
      const sidebar = document.getElementById('sidebar');
      sidebar.classList.toggle('open');
    });
  }
}

function navigateToView(viewId) {
  APP_STATE.currentView = viewId;

  // Update view sections visibility
  document.querySelectorAll('.view-section').forEach(section => {
    section.classList.remove('active');
  });

  const targetSection = document.getElementById(`view-${viewId}`);
  if (targetSection) {
    targetSection.classList.add('active');
  }

  // Update nav item active states
  document.querySelectorAll('.nav-item').forEach(item => {
    if (item.getAttribute('data-target-view') === viewId) {
      item.classList.add('active');
    } else {
      item.classList.remove('active');
    }
  });

  // Dynamic header titles
  const pageTitleElem = document.getElementById('headerPageTitle');
  if (pageTitleElem) {
    const titles = {
      dashboard: 'Antrean Dokumen Masuk',
      review: 'Tinjau & Validasi Dokumen',
      verify: 'Verifikasi Keaslian Dokumen (Publik)',
      archive: 'Arsip & Riwayat Dokumen',
      profile: 'Profil & Pengaturan Organisasi',
      login: 'Masuk ke Sistem ValidIn'
    };
    pageTitleElem.textContent = titles[viewId] || 'ValidIn';
  }

  // View specific render hooks
  if (viewId === 'dashboard') {
    renderDashboard();
  } else if (viewId === 'review') {
    renderReviewView(APP_STATE.selectedDocId);
  } else if (viewId === 'archive') {
    renderArchiveTable();
  }
}

// Role Switcher
function setupRoleSwitcher() {
  const roleSelect = document.getElementById('roleSelect');
  const userRoleBadge = document.getElementById('sidebarUserRole');
  const userNameElem = document.getElementById('sidebarUserName');

  if (roleSelect) {
    roleSelect.value = APP_STATE.currentRole;
    roleSelect.addEventListener('change', (e) => {
      switchRole(e.target.value);
    });
  }

  // Quick buttons on login page
  const demoRoleBtns = document.querySelectorAll('[data-demo-role]');
  demoRoleBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const role = btn.getAttribute('data-demo-role');
      switchRole(role);
      navigateToView('dashboard');
      showToast(`Berhasil masuk sebagai ${getRoleLabel(role)}`);
    });
  });
}

function switchRole(newRole) {
  APP_STATE.currentRole = newRole;
  const roleSelect = document.getElementById('roleSelect');
  if (roleSelect) roleSelect.value = newRole;

  const roleBadge = document.getElementById('sidebarUserRole');
  const userName = document.getElementById('sidebarUserName');

  if (newRole === 'ketua') {
    if (roleBadge) roleBadge.textContent = 'Ketua Organisasi';
    if (userName) userName.textContent = 'M. Hafiz, S.Kom';
  } else if (newRole === 'pembina') {
    if (roleBadge) roleBadge.textContent = 'Dosen Pembina';
    if (userName) userName.textContent = 'Dr. Ir. Budi Santoso, M.Kom';
  } else {
    if (roleBadge) roleBadge.textContent = 'Administrator';
    if (userName) userName.textContent = 'Staf Kemahasiswaan';
  }

  renderDashboard();
  if (APP_STATE.currentView === 'review') {
    renderReviewView(APP_STATE.selectedDocId);
  }
}

function getRoleLabel(role) {
  if (role === 'ketua') return 'Ketua Organisasi';
  if (role === 'pembina') return 'Dosen Pembina';
  return 'Administrator';
}

// Dashboard Rendering
function renderDashboard() {
  const tableBody = document.getElementById('documentsTableBody');
  if (!tableBody) return;

  const docs = APP_STATE.documents;

  // Calculate statistics
  const pendingKetua = docs.filter(d => d.status === 'menunggu_ketua').length;
  const pendingPembina = docs.filter(d => d.status === 'menunggu_pembina').length;
  const approvedCount = docs.filter(d => d.status === 'disetujui').length;
  const revisionCount = docs.filter(d => d.status === 'revisi').length;

  // Update stat cards
  const statPending = document.getElementById('statPendingCount');
  const statApproved = document.getElementById('statApprovedCount');
  const statRevision = document.getElementById('statRevisionCount');
  const statTotal = document.getElementById('statTotalCount');

  if (statPending) statPending.textContent = APP_STATE.currentRole === 'pembina' ? pendingPembina : pendingKetua;
  if (statApproved) statApproved.textContent = approvedCount;
  if (statRevision) statRevision.textContent = revisionCount;
  if (statTotal) statTotal.textContent = docs.length;

  // Filter based on user role and search query
  const searchInput = document.getElementById('tableSearchInput');
  const query = searchInput ? searchInput.value.toLowerCase() : '';
  const typeFilter = document.getElementById('typeFilterSelect');
  const selectedType = typeFilter ? typeFilter.value : 'all';

  const filteredDocs = docs.filter(doc => {
    const matchesQuery = doc.title.toLowerCase().includes(query) ||
                         doc.regNumber.toLowerCase().includes(query) ||
                         doc.organization.toLowerCase().includes(query) ||
                         doc.submitterName.toLowerCase().includes(query);
    const matchesType = (selectedType === 'all') || (doc.type === selectedType);
    return matchesQuery && matchesType;
  });

  tableBody.innerHTML = '';

  if (filteredDocs.length === 0) {
    tableBody.innerHTML = `
      <tr>
        <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-subtle);">
          Tidak ada dokumen yang sesuai dengan kriteria filter.
        </td>
      </tr>
    `;
    return;
  }

  filteredDocs.forEach(doc => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>
        <div class="doc-info">
          <span class="doc-number">${doc.regNumber}</span>
          <a href="#" class="doc-title" data-doc-id="${doc.id}">${doc.title}</a>
          <span style="font-size: 0.75rem; color: var(--text-subtle);">${doc.organization}</span>
        </div>
      </td>
      <td><span class="badge badge-type">${doc.type}</span></td>
      <td>
        <div style="font-size: 0.82rem;">
          <strong>${doc.submitterName}</strong>
          <div style="color: var(--text-subtle); font-size: 0.75rem;">NIM: ${doc.submitterNim}</div>
        </div>
      </td>
      <td>${getStatusBadge(doc.status)}</td>
      <td style="font-size: 0.78rem; color: var(--text-subtle);">${doc.createdAt}</td>
      <td style="text-align: right;">
        <button class="btn btn-outline btn-sm action-review-btn" data-doc-id="${doc.id}">
          <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
          </svg>
          Tinjau
        </button>
      </td>
    `;
    tableBody.appendChild(tr);
  });

  // Bind click listeners
  document.querySelectorAll('.action-review-btn, .doc-title').forEach(elem => {
    elem.addEventListener('click', (e) => {
      e.preventDefault();
      const docId = elem.getAttribute('data-doc-id');
      APP_STATE.selectedDocId = docId;
      navigateToView('review');
    });
  });
}

function getStatusBadge(status) {
  switch (status) {
    case 'menunggu_ketua':
      return `<span class="badge badge-pending">Menunggu Persetujuan Ketua</span>`;
    case 'menunggu_pembina':
      return `<span class="badge badge-pending" style="color: #7c3aed; background: #ede9fe; border-color: #ddd6fe;">Menunggu Pembina</span>`;
    case 'disetujui':
      return `<span class="badge badge-approved">Disetujui & Tervalidasi</span>`;
    case 'revisi':
      return `<span class="badge badge-revision">Perlu Revisi</span>`;
    default:
      return `<span class="badge badge-type">${status}</span>`;
  }
}

// Document Review View Controller
function renderReviewView(docId) {
  const doc = APP_STATE.documents.find(d => d.id === docId);
  if (!doc) return;

  // Update Paper Elements
  document.getElementById('paperUnivOrg').textContent = doc.organization;
  document.getElementById('paperDocTitle').textContent = doc.title;
  document.getElementById('paperDocReg').textContent = `Nomor Registrasi: ${doc.regNumber}`;
  document.getElementById('paperEventName').textContent = doc.title;
  document.getElementById('paperSubmitter').textContent = `${doc.submitterName} (NIM: ${doc.submitterNim})`;
  document.getElementById('paperDate').textContent = doc.eventDate;
  document.getElementById('paperLocation').textContent = doc.location;
  document.getElementById('paperBudget').textContent = doc.budget;
  document.getElementById('paperSignSubmitter').textContent = doc.submitterName;

  // Stamping and QR Code display
  const qrStampArea = document.getElementById('paperQrStampArea');
  const signKetuaArea = document.getElementById('paperSignKetuaArea');
  const signPembinaArea = document.getElementById('paperSignPembinaArea');

  // Ketua sign area
  if (doc.status === 'menunggu_pembina' || doc.status === 'disetujui') {
    signKetuaArea.innerHTML = `
      <div style="color: #059669; font-size: 0.75rem; font-weight: 700;">[PARAF DIGITAL SAH]</div>
      <div style="font-size: 0.65rem; color: #555;">${doc.ketuaApproval ? doc.ketuaApproval.at : 'Disetujui'}</div>
    `;
  } else {
    signKetuaArea.innerHTML = `<span style="color: #94a3b8; font-style: italic;">Menunggu pengesahan</span>`;
  }

  // Pembina sign & QR Area
  if (doc.status === 'disetujui') {
    signPembinaArea.innerHTML = `
      <div style="color: #059669; font-size: 0.75rem; font-weight: 700;">[DISAHKAN OLEH PEMBINA]</div>
      <div style="font-size: 0.65rem; color: #555;">${doc.pembinaApproval ? doc.pembinaApproval.at : '26 Okt 2026'}</div>
    `;

    qrStampArea.style.display = 'flex';
    qrStampArea.innerHTML = `
      <div class="qr-stamp-box">
        <div class="qr-matrix-mock"></div>
        <div class="qr-caption">TERVALIDASI RESMI</div>
        <div style="font-size: 0.58rem; color: #555; font-family: monospace;">Token: ${doc.qrToken.substring(0, 8)}...</div>
      </div>
    `;
  } else {
    signPembinaArea.innerHTML = `<span style="color: #94a3b8; font-style: italic;">Menunggu pengesahan</span>`;
    qrStampArea.style.display = 'none';
  }

  // Update Action Panel Meta
  document.getElementById('reviewDocNumber').textContent = doc.regNumber;
  document.getElementById('reviewDocStatus').innerHTML = getStatusBadge(doc.status);

  // Update Timeline Steps
  renderTimeline(doc);

  // Update Buttons according to Role & Status
  renderActionButtons(doc);
}

function renderTimeline(doc) {
  const tracker = document.getElementById('reviewTimelineTracker');
  if (!tracker) return;

  const isKetuaDone = doc.status === 'menunggu_pembina' || doc.status === 'disetujui';
  const isPembinaDone = doc.status === 'disetujui';
  const isRevision = doc.status === 'revisi';

  tracker.innerHTML = `
    <div class="timeline-step completed">
      <div class="step-marker">✓</div>
      <div class="step-content">
        <div class="step-label">Diajukan Mahasiswa</div>
        <div class="step-sub">${doc.submitterName} - ${doc.createdAt}</div>
      </div>
    </div>

    <div class="timeline-step ${isKetuaDone ? 'completed' : (doc.status === 'menunggu_ketua' ? 'current' : (isRevision ? 'revision' : ''))}">
      <div class="step-marker">${isKetuaDone ? '✓' : '2'}</div>
      <div class="step-content">
        <div class="step-label">Persetujuan Ketua Organisasi</div>
        <div class="step-sub">${doc.ketuaApproval ? `${doc.ketuaApproval.by} (${doc.ketuaApproval.at})` : (doc.status === 'menunggu_ketua' ? 'Sedang Ditinjau' : 'Belum Ditinjau')}</div>
      </div>
    </div>

    <div class="timeline-step ${isPembinaDone ? 'completed' : (doc.status === 'menunggu_pembina' ? 'current' : '')}">
      <div class="step-marker">${isPembinaDone ? '✓' : '3'}</div>
      <div class="step-content">
        <div class="step-label">Pengesahan Akhir Dosen Pembina</div>
        <div class="step-sub">${doc.pembinaApproval ? `${doc.pembinaApproval.by} (${doc.pembinaApproval.at})` : (doc.status === 'menunggu_pembina' ? 'Menunggu Konfirmasi' : 'Antrean')}</div>
      </div>
    </div>

    <div class="timeline-step ${isPembinaDone ? 'completed' : ''}">
      <div class="step-marker">${isPembinaDone ? '★' : '4'}</div>
      <div class="step-content">
        <div class="step-label">Penerbitan QR Code Validasi</div>
        <div class="step-sub">${isPembinaDone ? 'Dokumen Sah & Siap Diverifikasi Publik' : 'Diterbitkan otomatis saat disetujui Pembina'}</div>
      </div>
    </div>
  `;
}

function renderActionButtons(doc) {
  const container = document.getElementById('reviewActionButtons');
  if (!container) return;

  container.innerHTML = '';

  const canKetuaAct = (APP_STATE.currentRole === 'ketua' || APP_STATE.currentRole === 'admin') && doc.status === 'menunggu_ketua';
  const canPembinaAct = (APP_STATE.currentRole === 'pembina' || APP_STATE.currentRole === 'admin') && doc.status === 'menunggu_pembina';

  if (canKetuaAct) {
    container.innerHTML = `
      <button class="btn btn-success" id="btnApproveKetua">
        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        Setujui & Teruskan ke Pembina
      </button>
      <button class="btn btn-danger" id="btnRequestRevision">
        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
        Minta Revisi
      </button>
    `;
  } else if (canPembinaAct) {
    container.innerHTML = `
      <button class="btn btn-success" id="btnApprovePembina">
        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
        Sahkan Dokumen & Terbitkan QR Code
      </button>
      <button class="btn btn-danger" id="btnRequestRevision">
        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        Kembalikan untuk Revisi
      </button>
    `;
  } else if (doc.status === 'disetujui') {
    container.innerHTML = `
      <button class="btn btn-primary" id="btnViewVerificationPage">
        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/></svg>
        Buka Halaman Verifikasi Publik
      </button>
      <button class="btn btn-outline" onclick="showToast('Dokumen PDF berstempel QR berhasil diunduh.')">
        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/></svg>
        Unduh Dokumen Berstempel QR
      </button>
    `;
  } else {
    container.innerHTML = `
      <div style="font-size: 0.82rem; color: var(--text-muted); background: var(--bg-app); padding: 12px; border-radius: var(--radius-sm); border: 1px solid var(--border-light);">
        Dokumen saat ini sedang dalam status <strong>${doc.status.replace('_', ' ')}</strong>. Tidak ada aksi yang diperlukan untuk peran Anda saat ini.
      </div>
    `;
  }

  // Bind approval events
  const btnApproveKetua = document.getElementById('btnApproveKetua');
  if (btnApproveKetua) {
    btnApproveKetua.addEventListener('click', () => {
      doc.status = 'menunggu_pembina';
      doc.ketuaApproval = { by: 'M. Hafiz (Ketua BEM)', at: '30 Okt 2026, 09:15 WIB' };
      renderReviewView(doc.id);
      showToast('Dokumen disetujui Ketua dan diteruskan ke Dosen Pembina!');
    });
  }

  const btnApprovePembina = document.getElementById('btnApprovePembina');
  if (btnApprovePembina) {
    btnApprovePembina.addEventListener('click', () => {
      doc.status = 'disetujui';
      doc.pembinaApproval = { by: 'Dr. Ir. Budi Santoso, M.Kom', at: '30 Okt 2026, 09:20 WIB' };
      renderReviewView(doc.id);
      showToast('Dokumen resmi disahkan! QR Code Validasi otomatis diterbitkan.');
    });
  }

  const btnRevision = document.getElementById('btnRequestRevision');
  if (btnRevision) {
    btnRevision.addEventListener('click', () => {
      openRevisionModal(doc);
    });
  }

  const btnViewVerify = document.getElementById('btnViewVerificationPage');
  if (btnViewVerify) {
    btnViewVerify.addEventListener('click', () => {
      loadPublicVerification(doc.qrToken);
      navigateToView('verify');
    });
  }
}

// Archive Table Rendering
function renderArchiveTable() {
  const tableBody = document.getElementById('archiveTableBody');
  if (!tableBody) return;

  tableBody.innerHTML = '';
  APP_STATE.documents.forEach(doc => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><span class="doc-number">${doc.regNumber}</span></td>
      <td><strong>${doc.title}</strong><div style="font-size: 0.75rem; color: var(--text-subtle);">${doc.organization}</div></td>
      <td>${doc.type}</td>
      <td>${getStatusBadge(doc.status)}</td>
      <td><code style="font-size: 0.75rem; background: var(--bg-app); padding: 2px 6px; border-radius: 4px;">${doc.qrToken.substring(0, 13)}...</code></td>
      <td style="text-align: right;">
        <button class="btn btn-outline btn-sm" onclick="loadPublicVerification('${doc.qrToken}'); navigateToView('verify');">
          Cek QR
        </button>
      </td>
    `;
    tableBody.appendChild(tr);
  });
}

// Public Verification Page Logic
function setupVerificationSearch() {
  const verifyBtn = document.getElementById('btnSearchToken');
  const tokenInput = document.getElementById('tokenInput');

  if (verifyBtn && tokenInput) {
    verifyBtn.addEventListener('click', () => {
      const token = tokenInput.value.trim();
      if (!token) {
        showToast('Masukkan kode token terlebih dahulu.');
        return;
      }
      loadPublicVerification(token);
    });
  }
}

function loadPublicVerification(token) {
  const tokenInput = document.getElementById('tokenInput');
  if (tokenInput) tokenInput.value = token;

  const doc = APP_STATE.documents.find(d => d.qrToken === token);
  const resultCard = document.getElementById('verificationResultCard');
  const notFoundCard = document.getElementById('verificationNotFoundCard');

  if (doc && doc.status === 'disetujui') {
    resultCard.style.display = 'block';
    notFoundCard.style.display = 'none';

    document.getElementById('verifyResultRegNumber').textContent = doc.regNumber;
    document.getElementById('verifyResultTitle').textContent = doc.title;
    document.getElementById('verifyResultOrg').textContent = doc.organization;
    document.getElementById('verifyResultSubmitter').textContent = `${doc.submitterName} (NIM: ${doc.submitterNim})`;
    document.getElementById('verifyResultSignatory').textContent = doc.pembinaApproval ? doc.pembinaApproval.by : 'Dosen Pembina';
    document.getElementById('verifyResultDate').textContent = doc.pembinaApproval ? doc.pembinaApproval.at : '26 Okt 2026';
    document.getElementById('verifyResultToken').textContent = doc.qrToken;
    document.getElementById('verifyResultHash').textContent = doc.hashSha256;
  } else {
    resultCard.style.display = 'none';
    notFoundCard.style.display = 'block';
  }
}

// Modal Controller
function setupModals() {
  const closeBtns = document.querySelectorAll('.modal-close-btn, [data-modal-close]');
  closeBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.modal-overlay').forEach(modal => modal.classList.remove('active'));
    });
  });

  // Close modal on escape
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      document.querySelectorAll('.modal-overlay').forEach(modal => modal.classList.remove('active'));
    }
  });

  const confirmRevisionBtn = document.getElementById('btnConfirmRevision');
  if (confirmRevisionBtn) {
    confirmRevisionBtn.addEventListener('click', () => {
      const doc = APP_STATE.documents.find(d => d.id === APP_STATE.selectedDocId);
      const noteInput = document.getElementById('revisionNoteTextarea');
      if (doc && noteInput) {
        doc.status = 'revisi';
        doc.revisionNotes = noteInput.value || 'Catatan perbaikan telah dikirim ke pengaju.';
        document.getElementById('revisionModal').classList.remove('active');
        renderReviewView(doc.id);
        showToast('Catatan revisi berhasil disimpan dan dikirimkan ke mahasiswa.');
      }
    });
  }
}

function openRevisionModal(doc) {
  const modal = document.getElementById('revisionModal');
  const docTitleElem = document.getElementById('revisionModalDocTitle');
  if (docTitleElem) docTitleElem.textContent = doc.title;
  if (modal) modal.classList.add('active');
}

// Theme Toggle
function setupThemeToggle() {
  const toggleBtn = document.getElementById('themeToggleBtn');
  if (toggleBtn) {
    toggleBtn.addEventListener('click', () => {
      const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
      if (isDark) {
        document.documentElement.removeAttribute('data-theme');
        APP_STATE.theme = 'light';
        showToast('Tema terang diaktifkan');
      } else {
        document.documentElement.setAttribute('data-theme', 'dark');
        APP_STATE.theme = 'dark';
        showToast('Tema gelap diaktifkan');
      }
    });
  }
}

// Toast System
function showToast(message) {
  const container = document.getElementById('toastContainer');
  if (!container) return;

  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.innerHTML = `
    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
    </svg>
    <span>${message}</span>
  `;

  container.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(10px)';
    toast.style.transition = 'all 0.2s ease-out';
    setTimeout(() => toast.remove(), 200);
  }, 3500);
}
