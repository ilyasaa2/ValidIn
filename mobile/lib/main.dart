import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'theme/app_theme.dart';
import 'models/letter_document.dart';
import 'services/local_store.dart';
import 'screens/review_screen.dart';
import 'screens/submit_screen.dart';

void main() {
  if (!kReleaseMode) {
    DevicePreviewBindingMixin.latchConfiguration(
      initialSimulation: DevicePresets.iPhone16.resolve(),
    );
    DevicePreview.enable();
  }
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
      if (role == 'satpam') {
        _tabIndex = 3;
      }
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
          if (!kReleaseMode)
            PopupMenuButton<String>(
              tooltip: 'Ganti Perangkat Simulasi',
              icon: const Icon(Icons.devices, size: 20, color: Colors.white70),
              offset: const Offset(0, 40),
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF334155)),
              ),
              onSelected: (val) {
                final ctrl = DevicePreview.maybeController;
                if (ctrl == null) return;
                switch (val) {
                  case 'iphone16':
                    ctrl.applyPreset(DevicePresets.iPhone16);
                    break;
                  case 's25':
                    ctrl.applyPreset(DevicePresets.galaxyS25);
                    break;
                  case 'pixel9':
                    ctrl.applyPreset(DevicePresets.pixel9);
                    break;
                  case 'ipad10':
                    ctrl.applyPreset(DevicePresets.iPad10);
                    break;
                  case 'rotate':
                    final current =
                        ctrl.simulation?.orientation ?? Orientation.portrait;
                    ctrl.setOrientation(
                      current == Orientation.portrait
                          ? Orientation.landscape
                          : Orientation.portrait,
                    );
                    break;
                  case 'fullscreen':
                    ctrl.reset();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'iphone16',
                  child: Row(
                    children: [
                      Icon(Icons.phone_iphone, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('iPhone 16 (iOS)',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 's25',
                  child: Row(
                    children: [
                      Icon(Icons.phone_android, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Galaxy S25 (Android)',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'pixel9',
                  child: Row(
                    children: [
                      Icon(Icons.smartphone, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Pixel 9 (Android)',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'ipad10',
                  child: Row(
                    children: [
                      Icon(Icons.tablet_mac, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('iPad (10th gen)',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuDivider(height: 1),
                const PopupMenuItem(
                  value: 'rotate',
                  child: Row(
                    children: [
                      Icon(Icons.screen_rotation,
                          size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Putar Orientasi',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'fullscreen',
                  child: Row(
                    children: [
                      Icon(Icons.fullscreen, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Tampilan Penuh (Reset)',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
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
                SubmitScreen(
                    store: _store,
                    onSubmitted: () => _switchTab(0),
                    isTab: true),
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
      'satpam': 'Sutrisno (Petugas Keamanan / Satpam FT)',
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
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
                      store: widget.store,
                      onOpenPass: () => widget.onNavigate(2),
                      onChanged: () => setState(() {}),
                    )),
            ],
          ),
        ),
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
  final LocalStore store;
  final VoidCallback onOpenPass;
  final VoidCallback onChanged;
  const _LetterCard({
    required this.doc,
    required this.store,
    required this.onOpenPass,
    required this.onChanged,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Berkas Surat?'),
        content: Text(
            'Apakah Anda yakin ingin menghapus berkas surat "${doc.regNumber}" dari arsip ValidIn? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              store.deleteDoc(doc.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Berkas surat ${doc.regNumber} berhasil dihapus.')),
              );
              onChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Berkas'),
          ),
        ],
      ),
    );
  }

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
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewScreen(
                            doc: doc,
                            store: store,
                          ),
                        ),
                      );
                      onChanged();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: AppTheme.borderStrong),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Lihat Berkas',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: doc.isApproved
                      ? ElevatedButton.icon(
                          onPressed: onOpenPass,
                          icon: const Icon(Icons.shield, size: 14),
                          label: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Pass QR',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.navy900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReviewScreen(
                                  doc: doc,
                                  store: store,
                                ),
                              ),
                            );
                            onChanged();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.navy900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Periksa Alur',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _confirmDelete(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Icon(Icons.delete_outline,
                      size: 16, color: Color(0xFFDC2626)),
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
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
    ),
    ),
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
      child: Center(
        child: SingleChildScrollView(
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
      ),
      ),
    );
  }
}

// ── TAB 4: SCAN (PETUGAS KEAMANAN / SATPAM) ──────────────────────────────────

class ScanTab extends StatefulWidget {
  final LocalStore store;
  const ScanTab({super.key, required this.store});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  int _activeMode = 0; // 0: Live Camera, 1: Manual/Dropdown, 2: Logbook
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _torchOn = false;
  String? _selectedToken;
  LetterDocument? _scanResult;
  bool _unknownTokenScanned = false;
  String? _lastRawScanned;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _processScannedCode(String rawCode) {
    String cleanToken = rawCode.trim();
    if (cleanToken.contains('token=')) {
      cleanToken = cleanToken.split('token=').last.split('&').first;
    }

    final doc = widget.store.getDocs().where((d) {
      return d.qrToken.toLowerCase() == cleanToken.toLowerCase() ||
          d.id.toLowerCase() == cleanToken.toLowerCase();
    }).firstOrNull;

    setState(() {
      _lastRawScanned = rawCode;
      _selectedToken = cleanToken;
      _scanResult = doc;
      _unknownTokenScanned = (doc == null);
    });

    if (doc != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(doc.isApproved
              ? '✓ QR Valid! Surat resmi disahkan Wadek FT.'
              : '⚠ QR Terdeteksi, namun surat belum sah!'),
          backgroundColor:
              doc.isApproved ? AppTheme.sealGreen : const Color(0xFFB45309),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _recordSecurityAction(LetterDocument doc) {
    final now = DateTime.now();
    widget.store.addSecurityLog(
      SecurityScanLog(
        docId: doc.id,
        title: doc.title,
        room: doc.location,
        scannedAt: now,
        isApproved: doc.isApproved,
        officerName: 'Sutrisno (Petugas Satpam FT)',
        actionTaken: 'Kunci Ruang Diserahkan & Izin Diverifikasi',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            '✓ Pemeriksaan dicatat ke Logbook Satpam! Kunci dapat diserahkan.'),
        backgroundColor: AppTheme.sealGreen,
        duration: Duration(seconds: 3),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final docs = widget.store.getDocs().toList();
    if (_selectedToken == null && docs.isNotEmpty) {
      _selectedToken = docs.first.qrToken;
    }
    final logs = widget.store.getSecurityLogs();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          children: [
            // Header Satpam
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.navy900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0x2EFFFFFF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.security,
                        color: Colors.amber, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pos Keamanan FT UNTIDAR',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                        Text(
                            'Pemeriksaan QR Code pembukaan gedung kuliah & perizinan',
                            style: TextStyle(
                                color: Color(0xFFCBD5E1), fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x33FFC107),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x66FFC107)),
                    ),
                    child: const Text('SATPAM',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Mode Selector
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  _modeButton(0, 'Kamera Live', Icons.camera_alt),
                  _modeButton(1, 'Pilih Token', Icons.keyboard),
                  _modeButton(2, 'Logbook (${logs.length})', Icons.history),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Mode Content
            if (_activeMode == 0) _buildCameraScanner(),
            if (_activeMode == 1) _buildManualSelector(docs),
            if (_activeMode == 2) _buildLogbook(logs),

            // Scan Results Section
            if (_scanResult != null) ...[
              const SizedBox(height: 16),
              _buildResultCard(_scanResult!),
            ] else if (_unknownTokenScanned) ...[
              const SizedBox(height: 16),
              _buildUnknownCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _modeButton(int mode, String label, IconData icon) {
    final active = _activeMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: active
                ? [
                    const BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 4,
                        offset: Offset(0, 1))
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: active ? AppTheme.navy900 : AppTheme.textSecondary),
              const SizedBox(width: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? AppTheme.navy900 : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Live Camera Scanner View ───────────────────────────────────────────────

  Widget _buildCameraScanner() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppTheme.borderStrong),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: MobileScanner(
                  controller: _cameraController,
                  errorBuilder: (context, error, child) {
                    return Container(
                      color: const Color(0xFF0F172A),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.videocam_off_outlined,
                              size: 40, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 8),
                          const Text('Kamera Live Tidak Aktif di Peramban Ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text(
                              'Gunakan tab "Pilih Token" di atas untuk simulasi langsung surat.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF94A3B8), fontSize: 10)),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => setState(() => _activeMode = 1),
                            icon: const Icon(Icons.tune, size: 14),
                            label: const Text('Buka Pemilih Token Cepat',
                                style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.navy900,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final raw = barcodes.first.rawValue;
                      if (raw != null && raw != _lastRawScanned) {
                        _processScannedCode(raw);
                      }
                    }
                  },
                ),
              ),

              // Viewfinder Framing Overlay
              IgnorePointer(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          'BIDIK QR SURAT',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: Colors.amber.shade200,
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        color: Colors.black54,
                        child: const Text('Arahkan ke QR Mahasiswa',
                            style:
                                TextStyle(fontSize: 9, color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
              ),

              // Camera Floating Action Controls
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _torchOn ? Icons.flash_on : Icons.flash_off,
                        color: _torchOn ? Colors.amber : Colors.white,
                        size: 20,
                      ),
                      tooltip: 'Nyalakan/Matikan Senter',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        _cameraController.toggleTorch();
                        setState(() => _torchOn = !_torchOn);
                      },
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios,
                          color: Colors.white, size: 20),
                      tooltip: 'Ganti Kamera Depan/Belakang',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: () => _cameraController.switchCamera(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Footnote under camera
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Pindai QR fisik di kertas atau layar HP mahasiswa.',
                    style: TextStyle(
                        fontSize: 10, color: AppTheme.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _activeMode = 1),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Input Manual →',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Manual Token Selector View ─────────────────────────────────────────────

  Widget _buildManualSelector(List<LetterDocument> docs) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppTheme.borderStrong),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tune, size: 16, color: AppTheme.navy900),
                SizedBox(width: 6),
                Text('Uji Coba Cepat Token Dokumen',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy900)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih surat terdaftar untuk mensimulasikan hasil pemindaian lapangan:',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
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
                      fontSize: 11,
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
                  onChanged: (v) {
                    if (v != null) _processScannedCode(v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_selectedToken != null) {
                    _processScannedCode(_selectedToken!);
                  }
                },
                icon: const Icon(Icons.qr_code_scanner, size: 16),
                label: const Text('Verifikasi Dokumen Ini',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sealGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logbook Satpam View ────────────────────────────────────────────────────

  Widget _buildLogbook(List<SecurityScanLog> logs) {
    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('Belum ada riwayat pemindaian hari ini.',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('LOG PEMERIKSAAN SATPAM HARI INI:',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5)),
        ),
        ...logs.map((log) {
          final timeStr =
              '${log.scannedAt.hour.toString().padLeft(2, '0')}:${log.scannedAt.minute.toString().padLeft(2, '0')} WIB';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: log.isApproved
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    log.isApproved ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: log.isApproved
                        ? AppTheme.sealGreen
                        : const Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(log.docId,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.navy900)),
                          Text(timeStr,
                              style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(log.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.meeting_room,
                              size: 12, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(log.room,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Aksi: ${log.actionTaken}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.sealGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Result Cards ───────────────────────────────────────────────────────────

  Widget _buildResultCard(LetterDocument doc) {
    final ok = doc.isApproved;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ok ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Header
          Row(
            children: [
              Icon(
                ok ? Icons.verified : Icons.warning_amber_rounded,
                color: ok ? AppTheme.sealGreen : const Color(0xFFD97706),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ok
                          ? 'SURAT RESMI & SAH — IZIN DISETUJUI'
                          : 'DOKUMEN BELUM SAH / BELUM DISELESAIKAN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color:
                            ok ? AppTheme.sealGreen : const Color(0xFFB45309),
                      ),
                    ),
                    Text(
                      ok
                          ? 'Petugas Satpam berwenang membuka ruangan sesuai jadwal'
                          : 'Jangan membuka gedung sebelum ada disposisi resmi Wadek',
                      style: const TextStyle(
                          fontSize: 9, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Details Grid
          Text(doc.title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy900)),
          const SizedBox(height: 8),

          _infoRow(Icons.meeting_room, 'Ruang / Gedung', doc.location,
              highlight: true),
          const SizedBox(height: 4),
          _infoRow(Icons.calendar_today, 'Waktu Kegiatan',
              '${doc.eventDate} (${doc.eventTime})'),
          const SizedBox(height: 4),
          _infoRow(Icons.person, 'Penanggung Jawab',
              '${doc.submitterName} — ${doc.contactPerson}'),

          // Wadek Disposition Box
          if (doc.dispositionNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.assignment_turned_in,
                          size: 14, color: Color(0xFF92400E)),
                      SizedBox(width: 4),
                      Text('Instruksi Disposisi Wakil Dekan I FT:',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${doc.dispositionNote}"',
                    style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF78350F),
                        height: 1.35),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Action Button
          if (ok) ...[
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _recordSecurityAction(doc),
                icon: const Icon(Icons.key, size: 16),
                label: const Text('Serahkan Kunci & Catat Pemeriksaan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sealGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUnknownCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KODE QR TIDAK TERDAFTAR',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF991B1B))),
                SizedBox(height: 2),
                Text(
                  'Token QR ini tidak ditemukan dalam arsip resmi pengesahan FT UNTIDAR. Waspada pemalsuan izin.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF7F1D1D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String val,
      {bool highlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 14,
            color: highlight ? AppTheme.navy900 : AppTheme.textSecondary),
        const SizedBox(width: 6),
        SizedBox(
          width: 110,
          child: Text('$label:',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                  color: AppTheme.textSecondary)),
        ),
        Expanded(
          child: Text(
            val,
            style: TextStyle(
              fontSize: 10,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              color: highlight ? AppTheme.navy900 : AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
