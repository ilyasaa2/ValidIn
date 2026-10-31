import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';
import '../models/letter_document.dart';
import '../services/local_store.dart';

class ReviewScreen extends StatefulWidget {
  final LetterDocument doc;
  final LocalStore store;

  const ReviewScreen({super.key, required this.doc, required this.store});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late LetterDocument _doc;

  @override
  void initState() {
    super.initState();
    _doc = widget.doc;
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  void _signAsSekretaris() {
    // Not mutable directly since LetterDocument is final — rebuild with new
    // data via store addDoc pattern. For demo, just show toast.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paraf Sekretaris berhasil dibubuhkan!')),
    );
  }

  void _signAsPelaksana() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Tanda tangan Ketua Pelaksana & Cap Panitia berhasil!')),
    );
  }

  void _approveAsKetuaHimatif() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Surat diparaf & diteruskan ke Dekanat FT UNTIDAR!')),
    );
  }

  void _openDispositionModal() {
    showDialog(
      context: context,
      builder: (_) => _DispositionModal(
        onConfirm: (note) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Disposisi Wadek disimpan & QR Code diterbitkan!')),
          );
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final role = widget.store.currentRole;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1EF),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lembar Surat Resmi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            Text(
              _doc.regNumber,
              style: const TextStyle(
                  fontSize: 9,
                  fontFamily: 'monospace',
                  color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Cetak / Share',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Fitur cetak tersedia di versi desktop web.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ── Surat Fisik (Official Paper) ──
            _OfficialPaperCard(doc: _doc),
            const SizedBox(height: 14),

            // ── Audit Trail ──
            _AuditTrailCard(doc: _doc),
            const SizedBox(height: 14),

            // ── Action Panel ──
            _ActionPanel(
              doc: _doc,
              role: role,
              onSignSekretaris: _signAsSekretaris,
              onSignPelaksana: _signAsPelaksana,
              onApproveKetua: _approveAsKetuaHimatif,
              onOpenDisposition: _openDispositionModal,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Official Paper Card ───────────────────────────────────────────────────────

class _OfficialPaperCard extends StatelessWidget {
  final LetterDocument doc;
  const _OfficialPaperCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // Disposition handwritten box (yellow, top-right style)
          if (doc.isApproved && doc.dispositionNote.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFFEFCE8),
                border: Border(
                    bottom: BorderSide(color: Color(0xFFCA8A04), width: 1.5)),
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📌 Disposisi Pejabat Fakultas Teknik',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF854D0E),
                          letterSpacing: 0.5)),
                  const SizedBox(height: 3),
                  Text(doc.dispositionNote,
                      style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF713F12),
                          height: 1.4)),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Kop Surat ──
                _KopSurat(),
                const Divider(thickness: 2, height: 24),

                // ── Metadata ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          _metaRow('Nomor', doc.regNumber),
                          _metaRow('Lampiran', '-'),
                          _metaRow('Perihal', doc.type.split('/').first.trim()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text('Magelang, 9 September 2026',
                        style: TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Destinasi ──
                const Text('Kepada Yth.', style: TextStyle(fontSize: 11)),
                const Text('Dekan Fakultas Teknik',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                const Text('di Universitas Tidar',
                    style: TextStyle(fontSize: 11)),
                const SizedBox(height: 14),

                // ── Body ──
                const Text('Dengan hormat,', style: TextStyle(fontSize: 11)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textPrimary, height: 1.6),
                    children: [
                      const TextSpan(
                          text:
                              '        Berdasarkan Program Kerja Himpunan Mahasiswa Teknologi Informasi Universitas Tidar (HIMATIF UNTIDAR) 2026 yang akan mengadakan kegiatan '),
                      TextSpan(
                        text: doc.eventName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const TextSpan(text: ' pada:'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ── Tabel Detail ──
                _DetailTable(doc: doc),
                const SizedBox(height: 12),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textPrimary, height: 1.6),
                    children: [
                      const TextSpan(
                          text:
                              'Sehubung dengan kegiatan tersebut, kami selaku panitia bermaksud mengajukan '),
                      TextSpan(
                        text: doc.location,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(
                          text:
                              ' demi terlaksananya kegiatan tersebut.\n\nDemikian surat permohonan ini kami sampaikan. Atas perhatian Bapak/Ibu kami sampaikan terima kasih.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Tanda Tangan Matrix ──
                _SignatureMatrix(doc: doc),
                const SizedBox(height: 12),

                // ── QR Seal (if approved) ──
                if (doc.isApproved) _QrSeal(doc: doc),

                // ── Contact Person ──
                const Divider(height: 20),
                Row(
                  children: [
                    const Text('Contact Person: ',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700)),
                    Text(doc.contactPerson,
                        style: const TextStyle(
                            fontSize: 10, color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _metaRow(String key, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 3, right: 6),
        child: Text(key,
            style:
                const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text(': $value',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ),
    ]);
  }
}

// ── Kop Surat ────────────────────────────────────────────────────────────────

class _KopSurat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/img/logo_untidar.png',
          width: 48,
          height: 48,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.school, size: 44, color: AppTheme.untidarBlue),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            children: [
              Text('HIMPUNAN MAHASISWA TEKNOLOGI INFORMASI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.navy900,
                      letterSpacing: 0.3)),
              Text('UNIVERSITAS TIDAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.untidarBlue)),
              SizedBox(height: 3),
              Text(
                'Alamat: Jalan Kapten Suparman 39 Magelang 56116\nTelp. (0293) 364113  |  ft.untidar.ac.id  |  untidarhimatif@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 8, color: AppTheme.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/img/logo_himatif.jpg',
          width: 44,
          height: 44,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.groups, size: 44, color: AppTheme.untidarBlue),
        ),
      ],
    );
  }
}

// ── Detail Table ─────────────────────────────────────────────────────────────

class _DetailTable extends StatelessWidget {
  final LetterDocument doc;
  const _DetailTable({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderLight),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: [
          _row('Hari, Tanggal', doc.eventDate),
          _row('Waktu', doc.eventTime),
          _row('Tempat', doc.location),
        ],
      ),
    );
  }

  TableRow _row(String key, String val) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(key,
              style:
                  const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(': $val',
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ── Signature Matrix ──────────────────────────────────────────────────────────

class _SignatureMatrix extends StatelessWidget {
  final LetterDocument doc;
  const _SignatureMatrix({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text('Hormat kami,',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
                child: _SignBox(
              title: 'Ketua Pelaksana,',
              name: doc.submitterName,
              nim: 'NPM. 2505060012',
              isApproved: doc.pelaksanaApproval != null,
              approvedAt: doc.pelaksanaApproval?.at,
              signText: 'Henji Pratama',
              stampLabel: 'PANITIA\nPELAKSANA',
              stampColor: const Color(0xFF2563EB),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _SignBox(
              title: 'Sekretaris,',
              name: 'Hanif Abdillah Alatas',
              nim: 'NPM. 2420506041',
              isApproved: doc.secretaryApproval != null,
              approvedAt: doc.secretaryApproval?.at,
              signText: 'Hanif A. Alatas',
              stampLabel: null,
              stampColor: null,
            )),
          ],
        ),
        const SizedBox(height: 12),
        const Align(
          alignment: Alignment.center,
          child: Text('Mengetahui,',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
                child: _SignBox(
              title: 'Ketua HIMATIF UNTIDAR,',
              name: 'Naufal Miftakhul Siddiq',
              nim: 'NPM. 2440506060',
              isApproved: doc.ketuaApproval != null,
              approvedAt: doc.ketuaApproval?.at,
              signText: 'Naufal M.S.',
              stampLabel: 'HIMATIF\nUNTIDAR',
              stampColor: AppTheme.untidarBlue,
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _SignBox(
              title: 'Wakil Dekan Bid. Akademik & Kemahasiswaan FT,',
              name: 'Dr. Sigit Iswahyudi, S.T., M.T.',
              nim: 'NIP. 197510302021211005',
              isApproved: doc.isApproved,
              approvedAt: doc.pembinaApproval?.at,
              signText: 'Dr. Sigit I.',
              stampLabel: 'FAKULTAS\nTEKNIK',
              stampColor: const Color(0xFF15803D),
            )),
          ],
        ),
      ],
    );
  }
}

class _SignBox extends StatelessWidget {
  final String title;
  final String name;
  final String nim;
  final bool isApproved;
  final String? approvedAt;
  final String signText;
  final String? stampLabel;
  final Color? stampColor;

  const _SignBox({
    required this.title,
    required this.name,
    required this.nim,
    required this.isApproved,
    this.approvedAt,
    required this.signText,
    this.stampLabel,
    this.stampColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderLight),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: isApproved
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      if (stampLabel != null && stampColor != null)
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: stampColor!,
                                width: 1.5,
                                style: BorderStyle.solid),
                          ),
                          alignment: Alignment.center,
                          child: Text(stampLabel!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 6,
                                  fontWeight: FontWeight.w800,
                                  color: stampColor,
                                  letterSpacing: 0.3)),
                        ),
                      Text(signText,
                          style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: AppTheme.untidarBlue,
                              fontFamily: 'serif')),
                    ],
                  )
                : const Center(
                    child: Text('Menunggu\ntanda tangan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.textTertiary))),
          ),
          if (isApproved && approvedAt != null)
            Text('(${approvedAt!})',
                style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF0284C7),
                    fontWeight: FontWeight.w700)),
          const Divider(height: 10),
          Text(name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
          Text(nim,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 8, color: AppTheme.textTertiary)),
        ],
      ),
    );
  }
}

// ── QR Seal Box ───────────────────────────────────────────────────────────────

class _QrSeal extends StatelessWidget {
  final LetterDocument doc;
  const _QrSeal({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.sealGreen, width: 1.5),
        borderRadius: BorderRadius.circular(6),
        color: AppTheme.sealGreenBg,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.borderLight),
              borderRadius: BorderRadius.circular(4),
            ),
            child: QrImageView(
              data: doc.qrToken,
              version: QrVersions.auto,
              size: 60,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TERVERIFIKASI RESMI SISTEM VALIDIN UNTIDAR',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.sealGreen,
                        letterSpacing: 0.3)),
                const SizedBox(height: 2),
                Text('UUID: ${doc.qrToken}',
                    style: const TextStyle(
                        fontSize: 8,
                        fontFamily: 'monospace',
                        color: AppTheme.textTertiary)),
                const SizedBox(height: 2),
                const Text(
                    'Satpam kampus dapat memindai QR ini untuk memastikan izin pembukaan gedung/ruang kelas.',
                    style: TextStyle(
                        fontSize: 8,
                        color: AppTheme.textSecondary,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Audit Trail Card ──────────────────────────────────────────────────────────

class _AuditTrailCard extends StatelessWidget {
  final LetterDocument doc;
  const _AuditTrailCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final hasSecretary = doc.secretaryApproval != null;
    final hasPelaksana = doc.pelaksanaApproval != null;
    final hasKetua = doc.ketuaApproval != null;
    final isApproved = doc.isApproved;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alur Pengesahan Berjenjang',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy900)),
                _StatusBadge(doc.status),
              ],
            ),
            const SizedBox(height: 12),
            _auditStep(
                '1',
                'Paraf Sekretaris Panitia',
                'Hanif Abdillah Alatas',
                hasSecretary
                    ? 'Diparaf (${doc.secretaryApproval!.at})'
                    : 'Menunggu Paraf',
                hasSecretary,
                !hasSecretary),
            _auditStep(
                '2',
                'Tanda Tangan Ketua Pelaksana',
                doc.submitterName,
                hasPelaksana
                    ? 'Ditandatangani (${doc.pelaksanaApproval!.at})'
                    : 'Menunggu',
                hasPelaksana,
                hasSecretary && !hasPelaksana),
            _auditStep(
                '3',
                'Paraf & Cap Ketua HIMATIF',
                'Naufal Miftakhul Siddiq',
                hasKetua
                    ? 'Diparaf (${doc.ketuaApproval!.at})'
                    : 'Menunggu Peninjauan Ormawa',
                hasKetua,
                hasPelaksana && !hasKetua),
            _auditStep(
                '4',
                'Disposisi & Pengesahan Wadek FT',
                'Dr. Sigit Iswahyudi, S.T., M.T.',
                isApproved
                    ? 'Disahkan (${doc.pembinaApproval!.at})'
                    : 'Menunggu Disposisi Fakultas',
                isApproved,
                hasKetua && !isApproved),
            _auditStep(
                '★',
                'Penerbitan QR Code Satpam',
                '',
                isApproved
                    ? 'Surat Sah & QR Siap Dipindai Satpam'
                    : 'Otomatis aktif setelah disetujui Wadek',
                isApproved,
                false),
          ],
        ),
      ),
    );
  }

  Widget _auditStep(String num, String label, String by, String meta,
      bool isDone, bool isActive) {
    Color bgColor, borderColor, textColor;
    if (isDone) {
      bgColor = const Color(0xFFECFDF5);
      borderColor = AppTheme.sealGreen;
      textColor = AppTheme.sealGreen;
    } else if (isActive) {
      bgColor = const Color(0xFFEFF6FF);
      borderColor = const Color(0xFF2563EB);
      textColor = const Color(0xFF2563EB);
    } else {
      bgColor = const Color(0xFFF4F4F5);
      borderColor = AppTheme.borderStrong;
      textColor = AppTheme.textTertiary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(num,
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: textColor)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700)),
                Text(by.isNotEmpty ? '$by • $meta' : meta,
                    style: const TextStyle(
                        fontSize: 10, color: AppTheme.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Panel ──────────────────────────────────────────────────────────────

class _ActionPanel extends StatelessWidget {
  final LetterDocument doc;
  final String role;
  final VoidCallback onSignSekretaris;
  final VoidCallback onSignPelaksana;
  final VoidCallback onApproveKetua;
  final VoidCallback onOpenDisposition;

  const _ActionPanel({
    required this.doc,
    required this.role,
    required this.onSignSekretaris,
    required this.onSignPelaksana,
    required this.onApproveKetua,
    required this.onOpenDisposition,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tindakan Akun Terhubung',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy900)),
            const SizedBox(height: 12),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (role == 'sekretaris') {
      if (doc.secretaryApproval == null) {
        return Column(
          children: [
            _actionBtn('Bubuhi Paraf Sekretaris', const Color(0xFF0284C7),
                onSignSekretaris),
            const SizedBox(height: 6),
            const Text(
                'Paraf Anda memvalidasi format surat sebelum disahkan Ketua Pelaksana.',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
        );
      }
      return _doneInfo(
          '✓ Anda (Hanif Abdillah Alatas) telah membubuhi paraf pada draf surat ini.');
    }

    if (role == 'ketua_pelaksana') {
      if (doc.pelaksanaApproval == null) {
        return Column(
          children: [
            _actionBtn('Tandatangani & Bubuhi Cap Panitia',
                const Color(0xFF2563EB), onSignPelaksana),
            const SizedBox(height: 6),
            const Text(
                'Anda memberikan persetujuan operasional sebelum diajukan ke Ketua HIMATIF.',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
        );
      }
      return _doneInfo(
          '✓ Anda (Emannuel Henji) telah menandatangani surat. Menunggu paraf Ketua HIMATIF.');
    }

    if (role == 'ketua_himatif') {
      if (doc.ketuaApproval == null && doc.pelaksanaApproval != null) {
        return Column(
          children: [
            _actionBtn('Beri Paraf & Cap HIMATIF UNTIDAR',
                const Color(0xFF1D4ED8), onApproveKetua),
          ],
        );
      }
      if (doc.ketuaApproval != null) {
        return _doneInfo(
            '✓ Anda (Naufal Miftakhul Siddiq) telah membubuhkan paraf dan cap resmi HIMATIF.');
      }
      return _pendingInfo(
          'Surat masih dalam tahap paraf panitia sebelum masuk ke Ketua HIMATIF.');
    }

    if (role == 'wadek') {
      if (doc.ketuaApproval != null && !doc.isApproved) {
        return Column(
          children: [
            _actionBtn('Tulis Disposisi & Sahkan QR Code', AppTheme.sealGreen,
                onOpenDisposition),
            const SizedBox(height: 6),
            const Text(
                'Pengesahan Anda akan mengaktifkan QR Code resmi untuk Petugas Satpam.',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
        );
      }
      if (doc.isApproved) {
        return _doneInfo(
            '✓ Surat telah disahkan resmi oleh Anda (Dr. Sigit Iswahyudi, S.T., M.T.).');
      }
      return _pendingInfo(
          'Surat masih dalam tahap paraf panitia/ormawa sebelum masuk ke meja disposisi Wadek FT.');
    }

    return _pendingInfo('Tidak ada tindakan tersedia untuk akun ini.');
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _doneInfo(String msg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.sealGreenBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.sealGreenBorder),
      ),
      child: Text(msg,
          style: const TextStyle(
              fontSize: 11,
              color: AppTheme.sealGreen,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _pendingInfo(String msg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Text(msg,
          style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
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
      return _badge('✓ Disahkan', AppTheme.sealGreen, AppTheme.sealGreenBg,
          AppTheme.sealGreenBorder);
    } else if (status == 'perlu_revisi') {
      return _badge('⚠ Revisi', AppTheme.sealAmber, AppTheme.sealAmberBg,
          AppTheme.sealAmberBorder);
    }
    return _badge('● Proses', const Color(0xFF2563EB), const Color(0xFFEFF6FF),
        const Color(0xFFBFDBFE));
  }

  Widget _badge(String label, Color text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

// ── Disposition Modal ─────────────────────────────────────────────────────────

class _DispositionModal extends StatefulWidget {
  final void Function(String) onConfirm;
  const _DispositionModal({required this.onConfirm});

  @override
  State<_DispositionModal> createState() => _DispositionModalState();
}

class _DispositionModalState extends State<_DispositionModal> {
  final _ctrl = TextEditingController();

  void _applyPreset(String text) => setState(() => _ctrl.text = text);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pengesahan & Catatan Disposisi Wadek FT',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text(
                'Catatan ini akan tertulis di lembar fisik surat dan dibaca oleh Petugas Satpam.',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            const Text('PILIH TEMPLATE CEPAT:',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTertiary,
                    letterSpacing: 0.5)),
            const SizedBox(height: 6),
            _presetBtn('Template A (Gedung & Kelas):',
                'ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.'),
            _presetBtn('Template B (Sound & Alat):',
                'ACC: Peminjaman fasilitas sound system dan mikrofon diizinkan untuk kegiatan HIMATIF. Harap dijaga dengan baik.'),
            _presetBtn('Template C (Izin Kegiatan):',
                'ACC: Disetujui pelaksanaan kegiatan sesuai jadwal. Panitia wajib melapor ke pos satpam sebelum dan sesudah acara.'),
            const SizedBox(height: 10),
            TextField(
              controller: _ctrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Teks Catatan Disposisi:',
                hintText: 'Tuliskan catatan instruksi satpam...',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(_ctrl.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sealGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sahkan & Terbitkan QR Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetBtn(String title, String text) {
    return GestureDetector(
      onTap: () => _applyPreset(text),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 10, color: AppTheme.textPrimary),
            children: [
              TextSpan(
                  text: '$title ',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }
}
