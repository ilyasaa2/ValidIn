import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/letter_document.dart';
import '../services/local_store.dart';
import 'review_screen.dart';

/// Mirrors submit.html exactly: category selector, reg number preview,
/// all form fields, template quick-fill, file attachment area, alur info.
class SubmitScreen extends StatefulWidget {
  final LocalStore store;
  final void Function()? onSubmitted;

  const SubmitScreen({super.key, required this.store, this.onSubmitted});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _docType = 'Peminjaman Tempat / Gedung';
  final _eventNameCtrl = TextEditingController(
      text: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026');
  final _docTitleCtrl = TextEditingController(
      text: 'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas');
  final _secretaryNameCtrl =
      TextEditingController(text: 'Hanif Abdillah Alatas');
  final _secretaryNimCtrl = TextEditingController(text: '2420506041');
  final _submitterNameCtrl =
      TextEditingController(text: 'Emannuel Henji Pratama Putra');
  final _submitterNimCtrl = TextEditingController(text: '2505060012');
  final _eventDateCtrl = TextEditingController(
      text: 'Minggu dan Sabtu, 27 September dan 3 Oktober 2026');
  final _eventTimeCtrl = TextEditingController(text: '06.00 - 16.00 WIB');
  final _locationCtrl = TextEditingController(
      text: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06');
  final _borrowedItemsCtrl = TextEditingController(
      text: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06');
  final _contactCtrl =
      TextEditingController(text: '+62 851-8470-9553 (Ilyasa)');

  String _regPreview = '';
  bool _fileAttached = true; // simulated as already attached

  final _docTypes = [
    'Peminjaman Tempat / Gedung',
    'Peminjaman Fasilitas / Alat',
    'Permohonan Izin Kegiatan',
  ];

  @override
  void initState() {
    super.initState();
    _updateRegPreview();
  }

  void _updateRegPreview() {
    final rnd = 30 + Random().nextInt(10);
    final code = _docType.contains('Kegiatan') ? 'PH' : 'PM';
    setState(() => _regPreview =
        'Nomor Registrasi: 0$rnd.a/E/$code/HIMATIF/UNTIDAR/X/2026');
  }

  void _applyTemplate(String type) {
    setState(() {
      if (type == 'gedung') {
        _docType = 'Peminjaman Tempat / Gedung';
        _docTitleCtrl.text =
            'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas';
        _eventNameCtrl.text =
            'Peningkatan Kompetensi Mahasiswa DigitalWave 2026';
        _locationCtrl.text = 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06';
        _borrowedItemsCtrl.text =
            'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06';
        _eventDateCtrl.text =
            'Minggu dan Sabtu, 27 September dan 3 Oktober 2026';
        _eventTimeCtrl.text = '06.00 - 16.00 WIB';
      } else if (type == 'sound') {
        _docType = 'Peminjaman Fasilitas / Alat';
        _docTitleCtrl.text =
            'Surat Permohonan Peminjaman Sound dan 2 Buah Mikrofon';
        _eventNameCtrl.text =
            'Peningkatan Kompetensi Mahasiswa DigitalWave 2026';
        _locationCtrl.text = 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06';
        _borrowedItemsCtrl.text =
            'Sound system portable dan 2 buah mikrofon kabel FT';
        _eventDateCtrl.text =
            'Minggu dan Sabtu, 27 September dan 3 Oktober 2026';
        _eventTimeCtrl.text = '06.00 - 16.00 WIB';
      } else if (type == 'seminar') {
        _docType = 'Permohonan Izin Kegiatan';
        _docTitleCtrl.text =
            'Surat Permohonan Izin Workshop Cloud & DevOps 2026';
        _eventNameCtrl.text = 'HIMATIF DevConnect 2026';
        _locationCtrl.text = 'Auditorium Gedung FT 01 Lantai 3';
        _borrowedItemsCtrl.text =
            'Izin kegiatan, keamanan satpam, dan auditorium FT 01';
        _eventDateCtrl.text = 'Sabtu, 7 November 2026';
        _eventTimeCtrl.text = '08.00 - 15.00 WIB';
      }
      _updateRegPreview();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Template berhasil diterapkan!')),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final rnd = 30 + Random().nextInt(69);
    final code = _docType.contains('Kegiatan') ? 'PH' : 'PM';
    final newId = 'DOC-UNTIDAR-0${rnd}A';
    final newReg = '0$rnd.a/E/$code/HIMATIF/UNTIDAR/X/2026';
    final uuid =
        '9a${Random().nextInt(999999).toRadixString(36)}-4e81-8b29-${Random().nextInt(999999).toRadixString(36)}';

    final doc = LetterDocument(
      id: newId,
      regNumber: newReg,
      title: _docTitleCtrl.text,
      type: _docType,
      eventName: _eventNameCtrl.text,
      location: _locationCtrl.text,
      eventDate: _eventDateCtrl.text,
      eventTime: _eventTimeCtrl.text,
      submitterName: _submitterNameCtrl.text,
      contactPerson: _contactCtrl.text,
      status: 'menunggu_pelaksana',
      qrToken: uuid,
      dispositionNote: '',
      secretaryApproval: ApprovalStage(
        by: _secretaryNameCtrl.text,
        npmOrNip: _secretaryNimCtrl.text,
        at: '30 Oktober 2026',
      ),
    );

    widget.store.addDoc(doc);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Surat berhasil didaftarkan ke sistem ValidIn UNTIDAR!')),
    );

    widget.onSubmitted?.call();

    // Navigate to review
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReviewScreen(doc: doc, store: widget.store),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.store.currentRole;
    final isSecretary = role == 'sekretaris';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Buat Surat Baru'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page header
            const Text('Formulir Pengajuan Surat & Perizinan HIMATIF',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy900)),
            const SizedBox(height: 2),
            const Text(
                'Gunakan formulir ini untuk mengajukan permohonan peminjaman gedung/kelas FT 03, alat, atau izin kegiatan resmi ke Dekanat FT UNTIDAR.',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),

            // Role access notice (non-sekretaris)
            if (!isSecretary)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: const Color(0xFFFDE047), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚠️ Perhatian Hak Akses',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB45309),
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text(
                        'Penyusunan dan pengunggahan berkas adalah wewenang Sekretaris Panitia (Hanif Abdillah Alatas).',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF92400E),
                            height: 1.4)),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        widget.store.setRole('sekretaris');
                        setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFB45309),
                        side: const BorderSide(color: Color(0xFFB45309)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                      child: const Text('Beralih ke Akun Sekretaris Panitia →',
                          style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),

            // Template selector box
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⚡ TEMPLATE CEPAT PENGAJUAN SURAT:',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _templatePill(
                          '🏢 Pinjam Gedung FT 03 Ruang Kelas', 'gedung'),
                      _templatePill('🎤 Pinjam Sound & Mikrofon FT', 'sound'),
                      _templatePill(
                          '📋 Izin Kegiatan Workshop Ormawa', 'seminar'),
                    ],
                  ),
                ],
              ),
            ),

            // Form card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Surat
                      _label('Kategori Surat Permohonan *'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderStrong),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _docType,
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 13, color: AppTheme.textPrimary),
                            items: _docTypes
                                .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t,
                                        style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _docType = v);
                                _updateRegPreview();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Reg number preview badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Text(_regPreview,
                            style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: Color(0xFF0369A1),
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 14),

                      // Nama Kegiatan
                      _field(_eventNameCtrl, 'Nama Program Kerja / Kegiatan *'),
                      const SizedBox(height: 12),

                      // Perihal Surat
                      _field(_docTitleCtrl, 'Perihal Surat *'),
                      const SizedBox(height: 12),

                      // Sekretaris & NPM
                      Row(children: [
                        Expanded(
                            child: _field(_secretaryNameCtrl,
                                'Sekretaris Panitia (Penyusun Surat) *')),
                        const SizedBox(width: 10),
                        Expanded(
                            child:
                                _field(_secretaryNimCtrl, 'NPM Sekretaris *')),
                      ]),
                      const SizedBox(height: 12),

                      // Ketua Pelaksana & NPM
                      Row(children: [
                        Expanded(
                            child: _field(
                                _submitterNameCtrl, 'Ketua Pelaksana *')),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _field(
                                _submitterNimCtrl, 'NPM Ketua Pelaksana *')),
                      ]),
                      const SizedBox(height: 12),

                      // Tanggal & Waktu
                      Row(children: [
                        Expanded(
                            child: _field(_eventDateCtrl,
                                'Hari & Tanggal Pelaksanaan *')),
                        const SizedBox(width: 10),
                        Expanded(
                            child:
                                _field(_eventTimeCtrl, 'Waktu Peminjaman *')),
                      ]),
                      const SizedBox(height: 12),

                      // Lokasi
                      _field(_locationCtrl, 'Tempat / Ruangan yang Dipinjam *'),
                      const SizedBox(height: 12),

                      // Rincian & CP
                      Row(children: [
                        Expanded(
                            child: _field(_borrowedItemsCtrl,
                                'Rincian Fasilitas / Ruang *')),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _field(_contactCtrl,
                                'Contact Person Panitia (WhatsApp) *')),
                      ]),
                      const SizedBox(height: 14),

                      // Alur pengesahan info box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFBFDBFE), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Alur Pengesahan Berjenjang (Tahap 1):',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.untidarBlue,
                                    fontSize: 12)),
                            const SizedBox(height: 4),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF1E40AF),
                                    height: 1.45),
                                children: [
                                  TextSpan(
                                      text:
                                          'Surat disusun dan diunggah langsung oleh '),
                                  TextSpan(
                                      text:
                                          'Sekretaris Panitia (Hanif Abdillah Alatas)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800)),
                                  TextSpan(
                                      text:
                                          '. Setelah dikirim, surat otomatis dibubuhi paraf kesekretariatan dan diteruskan ke meja '),
                                  TextSpan(
                                      text:
                                          'Ketua Pelaksana (Emannuel Henji Pratama Putra)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800)),
                                  TextSpan(text: ' untuk ditandatangani.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // File upload area (simulated)
                      _label('Lampiran Berkas PDF Surat UNTIDAR (Maks. 5MB) *'),
                      GestureDetector(
                        onTap: () => setState(() => _fileAttached = true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _fileAttached
                                ? const Color(0xFFF0FDF4)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _fileAttached
                                  ? AppTheme.sealGreenBorder
                                  : AppTheme.borderLight,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _fileAttached
                                    ? Icons.check_circle
                                    : Icons.cloud_upload_outlined,
                                size: 36,
                                color: _fileAttached
                                    ? AppTheme.sealGreen
                                    : AppTheme.textTertiary,
                              ),
                              const SizedBox(height: 6),
                              const Text('Berkas Surat Siap Diregistrasi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              const SizedBox(height: 2),
                              const Text(
                                  'Format resmi kop surat HIMATIF & Universitas Tidar',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary)),
                              if (_fileAttached) ...[
                                const SizedBox(height: 6),
                                const Text(
                                  'surat_permohonan_digitalwave_2026.pdf (1.4 MB) • ✓ Terlampir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563EB),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textSecondary,
                              side: const BorderSide(
                                  color: AppTheme.borderStrong),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.navy900,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text(
                                'Simpan & Daftarkan Surat Resmi →',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary)),
    );
  }

  Widget _field(TextEditingController ctrl, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextFormField(
          controller: ctrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 12),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _templatePill(String label, String type) {
    return GestureDetector(
      onTap: () => _applyTemplate(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderStrong),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
      ),
    );
  }
}
