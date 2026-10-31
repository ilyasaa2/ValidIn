import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'theme/app_theme.dart';
import 'models/letter_document.dart';
import 'services/local_store.dart';
import 'screens/review_screen.dart';

void main() {
  runApp(const ValidInMobileApp());
}

class ValidInMobileApp extends StatelessWidget {
  const ValidInMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValidIn Mobile – Layanan Surat & Izin FT UNTIDAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}

// ── Main Shell ───────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tabIndex = 0;
  bool _showRoleSelector = false;
  final LocalStore _store = LocalStore();

  void _switchTab(int i) => setState(() {
        _tabIndex = i;
        _showRoleSelector = false;
      });

  void _switchRole(String role) {
    setState(() {
      _store.setRole(role);
      _showRoleSelector = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _store.getProfile(_store.currentRole);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/img/logo_untidar.png',
              width: 26,
              height: 26,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.school, size: 24, color: Colors.amber),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ValidIn Mobile',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                Text(
                  'FAKULTAS TEKNIK UNTIDAR',
                  style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => setState(() => _showRoleSelector = !_showRoleSelector),
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.roleLabel.split(' ').first,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.arrow_drop_down,
                      size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Role Selector Drawer ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildRoleSelector(),
            crossFadeState: _showRoleSelector
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                HomeTab(store: _store, onNavigate: _switchTab),
                AjukanTab(store: _store, onNavigate: _switchTab),
                PassQrTab(store: _store),
                ScanTab(store: _store),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: _switchTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Surat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Ajukan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield),
            label: 'Pass QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            activeIcon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    const roles = {
      'sekretaris': 'Hanif Abdillah Alatas (Sekretaris Panitia)',
      'ketua_pelaksana': 'Emannuel Henji Pratama (Ketua Pelaksana)',
      'ketua_himatif': 'Naufal Miftakhul Siddiq (Ketua HIMATIF)',
      'wadek': 'Dr. Sigit Iswahyudi, S.T., M.T. (Wakil Dekan I FT)',
    };
    return Container(
      color: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PILIH AKUN SIMULASI:',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF475569),
                  letterSpacing: 0.5)),
          const SizedBox(height: 6),
          ...roles.entries.map((e) => _roleTile(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _roleTile(String role, String label) {
    final isActive = _store.currentRole == role;
    return GestureDetector(
      onTap: () => _switchRole(role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.navy900 : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: isActive ? AppTheme.navy900 : AppTheme.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ── TAB 1: HOME (Daftar Surat & Tracking) ───────────────────────────────────

class HomeTab extends StatefulWidget {
  final LocalStore store;
  final void Function(int) onNavigate;
  const HomeTab({super.key, required this.store, required this.onNavigate});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _filter = 'all';

  List<LetterDocument> get _filtered {
    final docs = widget.store.getDocs().toList();
    if (_filter == 'active') {
      return docs
          .where((d) => d.status != 'disetujui' && d.status != 'ditolak')
          .toList();
    } else if (_filter == 'approved') {
      return docs.where((d) => d.status == 'disetujui').toList();
    }
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    final all = widget.store.getDocs();
    final countAll = all.length;
    final countActive = all
        .where((d) => d.status != 'disetujui' && d.status != 'ditolak')
        .length;
    final countApproved = all.where((d) => d.status == 'disetujui').length;
    final profile = widget.store.getProfile(widget.store.currentRole);

    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 84),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Permohonan Surat',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.navy900)),
                    Text('${profile.name} (${profile.roleLabel})',
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => widget.onNavigate(1),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Ajukan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy900,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip('all', 'Semua ($countAll)'),
                const SizedBox(width: 6),
                _chip('active', 'Berjalan ($countActive)'),
                const SizedBox(width: 6),
                _chip('approved', 'Disetujui ($countApproved)'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_filtered.isEmpty)
            _emptyState()
          else
            ..._filtered.map((doc) => _LetterCard(
                  doc: doc,
                  onOpenPass: () => widget.onNavigate(2),
                )),
        ],
      ),
    );
  }

  Widget _chip(String filter, String label) {
    final active = _filter == filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppTheme.navy900 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: active ? AppTheme.navy900 : AppTheme.borderLight),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppTheme.textSecondary,
            )),
      ),
    );
  }

  Widget _emptyState() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Text('📭', style: TextStyle(fontSize: 32)),
            SizedBox(height: 8),
            Text('Tidak ada dokumen dalam kategori ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textTertiary)),
          ],
        ),
      ),
    );
  }
}

// ── Letter Card ──────────────────────────────────────────────────────────────

class _LetterCard extends StatelessWidget {
  final LetterDocument doc;
  final VoidCallback onOpenPass;
  const _LetterCard({required this.doc, required this.onOpenPass});

  @override
  Widget build(BuildContext context) {
    final s1 = doc.secretaryApproval != null ? 'done' : 'waiting';
    final s2 = doc.pelaksanaApproval != null
        ? 'done'
        : (doc.secretaryApproval != null ? 'active' : 'waiting');
    final s3 = doc.ketuaApproval != null
        ? 'done'
        : (doc.pelaksanaApproval != null ? 'active' : 'waiting');
    final s4 = doc.pembinaApproval != null
        ? 'done'
        : (doc.ketuaApproval != null ? 'active' : 'waiting');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.regNumber,
                          style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: AppTheme.textTertiary)),
                      const SizedBox(height: 3),
                      Text(doc.title,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.navy900)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(doc.status),
              ],
            ),
            const SizedBox(height: 10),
            _metaRow(Icons.apartment, 'Lokasi: ${doc.location}'),
            const SizedBox(height: 3),
            _metaRow(Icons.calendar_today,
                'Waktu: ${doc.eventDate} (${doc.eventTime})'),
            const SizedBox(height: 10),
            _Stepper(
              stages: [
                _StepData(
                    label: 'Sekretaris Panitia',
                    state: s1,
                    sub: doc.secretaryApproval != null
                        ? '(${doc.secretaryApproval!.by})'
                        : ''),
                _StepData(
                    label: 'Ketua Pelaksana',
                    state: s2,
                    sub: doc.pelaksanaApproval != null
                        ? '(${doc.pelaksanaApproval!.by})'
                        : ''),
                _StepData(
                    label: 'Ketua HIMATIF',
                    state: s3,
                    sub: doc.ketuaApproval != null
                        ? '(${doc.ketuaApproval!.by})'
                        : ''),
                _StepData(
                    label: 'Wakil Dekan I FT',
                    state: s4,
                    sub: doc.pembinaApproval != null
                        ? '(Dr. Sigit Iswahyudi)'
                        : ''),
              ],
              isComplete: doc.isApproved,
            ),
            if (doc.dispositionNote.isNotEmpty) ...[
              const SizedBox(height: 10),
              _DispositionCard(doc.dispositionNote),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewScreen(
                          doc: doc,
                          store: LocalStore(),
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: AppTheme.borderStrong),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Lihat Berkas',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: doc.isApproved
                      ? ElevatedButton.icon(
                          onPressed: onOpenPass,
                          icon: const Icon(Icons.shield, size: 14),
                          label: const Text('Pass QR',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.navy900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.navy900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Periksa Alur',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppTheme.textSecondary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(text,
              style:
                  const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ),
      ],
    );
  }
}

// ── Stepper ──────────────────────────────────────────────────────────────────

class _StepData {
  final String label;
  final String state;
  final String sub;
  const _StepData(
      {required this.label, required this.state, required this.sub});
}

class _Stepper extends StatelessWidget {
  final List<_StepData> stages;
  final bool isComplete;
  const _Stepper({required this.stages, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ALUR PENGESAHAN BERJENJANG',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textTertiary,
                      letterSpacing: 0.5)),
              Text(isComplete ? 'Selesai 4/4' : 'Proses',
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textTertiary)),
            ],
          ),
          const SizedBox(height: 8),
          ...stages
              .asMap()
              .entries
              .map((e) => _StepRow(index: e.key + 1, data: e.value)),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int index;
  final _StepData data;
  const _StepRow({required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    Color bgColor, borderColor, textColor;
    String indicator;

    switch (data.state) {
      case 'done':
        bgColor = const Color(0xFFECFDF5);
        borderColor = const Color(0xFF15803D);
        textColor = const Color(0xFF15803D);
        indicator = '✓';
        break;
      case 'active':
        bgColor = const Color(0xFFEFF6FF);
        borderColor = const Color(0xFF2563EB);
        textColor = const Color(0xFF2563EB);
        indicator = '$index';
        break;
      case 'rejected':
        bgColor = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFB91C1C);
        textColor = const Color(0xFFB91C1C);
        indicator = '✕';
        break;
      default:
        bgColor = const Color(0xFFF4F4F5);
        borderColor = const Color(0xFFD4D4D8);
        textColor = const Color(0xFFA1A1AA);
        indicator = '$index';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(indicator,
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: textColor)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: data.label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary),
                children: data.sub.isNotEmpty
                    ? [
                        TextSpan(
                            text: ' ${data.sub}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.textTertiary))
                      ]
                    : [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Disposition Card ─────────────────────────────────────────────────────────

class _DispositionCard extends StatelessWidget {
  final String text;
  const _DispositionCard(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCA8A04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📌 DISPOSISI RESMI PEJABAT:',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF854D0E),
                  letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text('"$text"',
              style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF713F12),
                  height: 1.4)),
        ],
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    if (status == 'disetujui') {
      return _badge('✓ Disahkan Wadek', AppTheme.sealGreen,
          AppTheme.sealGreenBg, AppTheme.sealGreenBorder);
    } else if (status == 'perlu_revisi') {
      return _badge('⚠ Perlu Revisi', AppTheme.sealAmber, AppTheme.sealAmberBg,
          AppTheme.sealAmberBorder);
    }
    return _badge('● Menunggu', const Color(0xFF2563EB),
        const Color(0xFFEFF6FF), const Color(0xFFBFDBFE));
  }

  Widget _badge(String label, Color text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: text)),
    );
  }
}

// ── TAB 2: AJUKAN ────────────────────────────────────────────────────────────

class AjukanTab extends StatefulWidget {
  final LocalStore store;
  final void Function(int) onNavigate;
  const AjukanTab({super.key, required this.store, required this.onNavigate});

  @override
  State<AjukanTab> createState() => _AjukanTabState();
}

class _AjukanTabState extends State<AjukanTab> {
  final _formKey = GlobalKey<FormState>();
  final _eventCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  void _applyTemplate(String type) {
    setState(() {
      if (type == 'gedung') {
        _eventCtrl.text = 'Pengenalan Informatika Mahasiswa Baru 2026';
        _locationCtrl.text = 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06';
        _dateCtrl.text = 'Sabtu, 24 Oktober 2026';
        _timeCtrl.text = '08.00 - 16.00 WIB';
        _contactCtrl.text = '+62 851-8470-9553 (Ilyasa)';
      } else if (type == 'sound') {
        _eventCtrl.text = 'Seminar Nasional Teknologi Informasi FT';
        _locationCtrl.text = 'Auditorium Gedung FT 03 Lt. 3 & 2 Mic Wireless';
        _dateCtrl.text = 'Kamis, 5 November 2026';
        _timeCtrl.text = '07.30 - 13.00 WIB';
        _contactCtrl.text = '+62 851-8470-9553 (Ilyasa)';
      } else if (type == 'rapat') {
        _eventCtrl.text = 'Rapat Pleno Pengurus HIMATIF UNTIDAR';
        _locationCtrl.text = 'Gedung FT 03 Ruang Rapat E.03.2.02';
        _dateCtrl.text = 'Jumat, 16 Oktober 2026';
        _timeCtrl.text = '15.30 - 18.00 WIB';
        _contactCtrl.text = '+62 851-8470-9553 (Ilyasa)';
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final rnd = Random();
    final uuid =
        'f${rnd.nextInt(9999999).toRadixString(36)}-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
    final doc = LetterDocument(
      id: 'DOC-M-${DateTime.now().millisecondsSinceEpoch}',
      regNumber: '${100 + rnd.nextInt(800)}/E/PM/HIMATIF/UNTIDAR/X/2026',
      title: 'Surat Permohonan Izin ${_locationCtrl.text}',
      type: 'Peminjaman Fasilitas Kampus',
      eventName: _eventCtrl.text,
      location: _locationCtrl.text,
      eventDate: _dateCtrl.text,
      eventTime: _timeCtrl.text,
      submitterName: 'Emannuel Henji Pratama Putra',
      contactPerson: _contactCtrl.text,
      status: 'menunggu_pelaksana',
      qrToken: uuid,
      dispositionNote: '',
      secretaryApproval: ApprovalStage(
          by: 'Hanif Abdillah Alatas', npmOrNip: '2420506041', at: 'Hari ini'),
    );

    widget.store.addDoc(doc);

    _eventCtrl.clear();
    _locationCtrl.clear();
    _dateCtrl.clear();
    _timeCtrl.clear();
    _contactCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Surat permohonan berhasil dibuat dan masuk antrean!')),
    );
    widget.onNavigate(0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pengajuan Izin Fasilitas',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy900)),
          const SizedBox(height: 2),
          const Text(
              'Format resmi permohonan peminjaman HIMATIF Fakultas Teknik UNTIDAR.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 14),
          const Text('PILIH TEMPLATE CEPAT:',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textTertiary,
                  letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _templateChip('🏛️ Gedung FT 03', 'gedung'),
              _templateChip('🔊 Sound & Mic', 'sound'),
              _templateChip('📋 Ruang Rapat', 'rapat'),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(_eventCtrl, 'Nama Kegiatan *',
                        'Contoh: Pengenalan Informatika 2026'),
                    const SizedBox(height: 12),
                    _field(_locationCtrl, 'Fasilitas / Ruangan *',
                        'Contoh: Gedung FT 03 Lt. 2'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _field(
                                _dateCtrl, 'Tanggal *', '14 November 2026')),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _field(
                                _timeCtrl, 'Waktu *', '08.00 - 15.00 WIB')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _field(_contactCtrl, 'Kontak WhatsApp *',
                        '+62 851-8470-9553 (Nama)'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.navy900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Kirimkan Surat Permohonan',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _templateChip(String label, String type) {
    return GestureDetector(
      onTap: () => _applyTemplate(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.borderStrong),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, String hint) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: const TextStyle(fontSize: 13),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
    );
  }
}

// ── TAB 3: PASS QR ───────────────────────────────────────────────────────────

class PassQrTab extends StatelessWidget {
  final LocalStore store;
  const PassQrTab({super.key, required this.store});

  LetterDocument _emptyDoc() => LetterDocument(
        id: 'empty',
        regNumber: '-',
        title: 'Tidak ada dokumen',
        type: '',
        eventName: '',
        location: '-',
        eventDate: '-',
        eventTime: '-',
        submitterName: '-',
        contactPerson: '-',
        status: 'menunggu_pelaksana',
        qrToken: 'no-data',
        dispositionNote: '',
      );

  @override
  Widget build(BuildContext context) {
    final docs = store.getDocs();
    final approved = docs.firstWhere((d) => d.isApproved,
        orElse: () => docs.isNotEmpty ? docs.first : _emptyDoc());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Pass Izin Resmi Satpam',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.navy900)),
        const SizedBox(height: 2),
        const Text(
            'Tunjukkan layar ini langsung di depan petugas Satpam di pos jaga gedung FT 03.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 14),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppTheme.navy900, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/logo_untidar.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.school, size: 18)),
                    const SizedBox(width: 6),
                    const Text('FAKULTAS TEKNIK UNIVERSITAS TIDAR',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(approved.regNumber,
                    style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: AppTheme.textTertiary)),
                const SizedBox(height: 8),
                Text(approved.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy900)),
                const SizedBox(height: 10),
                if (approved.isApproved)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.sealGreenBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.sealGreenBorder),
                    ),
                    child: const Text('✓ TERVERIFIKASI SAH DEKANAT FT',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.sealGreen)),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.sealAmberBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.sealAmberBorder),
                    ),
                    child: const Text('⚠ Belum Disahkan Lengkap',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.sealAmber)),
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _showQrModal(context, approved),
                  child: Container(
                    width: 180,
                    height: 180,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: QrImageView(
                      data: approved.qrToken,
                      version: QrVersions.auto,
                      size: 160,
                      embeddedImage:
                          const AssetImage('assets/img/logo_untidar.png'),
                      embeddedImageStyle:
                          const QrEmbeddedImageStyle(size: Size(28, 28)),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                    'Token: ${approved.qrToken.length > 16 ? approved.qrToken.substring(0, 16) : approved.qrToken}...',
                    style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: AppTheme.textTertiary)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🏢 Izin Ruang: ${approved.location}',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                          '⏰ Waktu Izin: ${approved.eventDate} (${approved.eventTime})',
                          style: const TextStyle(fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                          '👤 Pemohon: ${approved.submitterName} (Ketua Pelaksana)',
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                if (approved.dispositionNote.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFCE8),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCA8A04)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📝 INSTRUKSI RESMI UNTUK SATPAM:',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF854D0E),
                                letterSpacing: 0.5)),
                        const SizedBox(height: 3),
                        Text('"${approved.dispositionNote}"',
                            style: const TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF713F12),
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showQrModal(context, approved),
                    icon: const Icon(Icons.zoom_in, size: 16),
                    label: const Text('Perbesar Layar Penuh (Untuk Satpam)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.navy900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showQrModal(BuildContext context, LetterDocument doc) {
    showDialog(
      context: context,
      barrierColor: const Color(0xEB0F172A),
      builder: (_) => _QrFullscreenModal(doc: doc),
    );
  }
}

// ── QR Fullscreen Modal ───────────────────────────────────────────────────────

class _QrFullscreenModal extends StatelessWidget {
  final LetterDocument doc;
  const _QrFullscreenModal({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('IJIN RESMI DEKANAT FT',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.sealGreen,
                    letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Text(doc.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy900)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: QrImageView(
                data: doc.qrToken,
                version: QrVersions.auto,
                size: 220,
                embeddedImage: const AssetImage('assets/img/logo_untidar.png'),
                embeddedImageStyle:
                    const QrEmbeddedImageStyle(size: Size(36, 36)),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: doc.qrToken));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token disalin ke clipboard!')),
                );
              },
              child: Text('UUID: ${doc.qrToken}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 9,
                      fontFamily: 'monospace',
                      color: AppTheme.textTertiary)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pindai menggunakan kamera smartphone Satpam untuk memeriksa keabsahan izin dan instruksi pembukaan pintu gedung.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Tutup Tampilan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── TAB 4: SCAN ──────────────────────────────────────────────────────────────

class ScanTab extends StatefulWidget {
  final LocalStore store;
  const ScanTab({super.key, required this.store});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  String? _selectedToken;
  LetterDocument? _scanResult;

  @override
  Widget build(BuildContext context) {
    final docs = widget.store.getDocs().toList();
    if (_selectedToken == null && docs.isNotEmpty) {
      _selectedToken = docs.first.qrToken;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Verifikasi QR Dokumen',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.navy900)),
        const SizedBox(height: 2),
        const Text(
            'Uji coba simulasi pemindaian QR oleh petugas keamanan kampus.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.qr_code_scanner,
                    size: 52, color: AppTheme.navy900),
                const SizedBox(height: 10),
                const Text('Pemindai QR Lapangan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy900)),
                const SizedBox(height: 4),
                const Text(
                    'Kamera aktif mendeteksi stempel token izin dekanat FT UNTIDAR.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('PILIH TOKEN SURAT UNTUK DIVERIFIKASI:',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textTertiary,
                          letterSpacing: 0.5)),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.borderStrong),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedToken,
                      isExpanded: true,
                      style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          color: AppTheme.textPrimary),
                      items: docs.map((d) {
                        final title = d.title.length > 30
                            ? '${d.title.substring(0, 30)}...'
                            : d.title;
                        final label =
                            '[${d.status.toUpperCase()}] $title (${d.qrToken.substring(0, 8)}...)';
                        return DropdownMenuItem(
                            value: d.qrToken, child: Text(label));
                      }).toList(),
                      onChanged: (v) => setState(() {
                        _selectedToken = v;
                        _scanResult = null;
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _simulate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.sealGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Verifikasi Token Dokumen',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_scanResult != null) _ScanResult(doc: _scanResult!),
      ],
    );
  }

  void _simulate() {
    if (_selectedToken == null) return;
    final doc = widget.store
        .getDocs()
        .where((d) => d.qrToken == _selectedToken)
        .firstOrNull;
    setState(() => _scanResult = doc);
  }
}

class _ScanResult extends StatelessWidget {
  final LetterDocument doc;
  const _ScanResult({required this.doc});

  @override
  Widget build(BuildContext context) {
    final ok = doc.isApproved;
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: ok ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ok ? '✓ DOKUMEN RESMI SAH' : '⚠ DOKUMEN BELUM SAH',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: ok
                          ? const Color(0xFF15803D)
                          : const Color(0xFFB45309)),
                ),
              ),
              Text(
                  'UUID: ${doc.qrToken.length > 8 ? doc.qrToken.substring(0, 8) : doc.qrToken}...',
                  style: const TextStyle(
                      fontSize: 9,
                      fontFamily: 'monospace',
                      color: AppTheme.textTertiary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(doc.title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy900)),
          const SizedBox(height: 6),
          Text('🏢 Izin: ${doc.location}',
              style:
                  const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          Text('⏰ Jadwal: ${doc.eventDate} (${doc.eventTime})',
              style:
                  const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          if (doc.dispositionNote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFCA8A04)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📌 Instruksi Satpam:',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF854D0E))),
                  const SizedBox(height: 3),
                  Text('"${doc.dispositionNote}"',
                      style: const TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF713F12),
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
