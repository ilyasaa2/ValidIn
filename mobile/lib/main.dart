import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'theme/app_theme.dart';
import 'models/letter_document.dart';
import 'services/api_service.dart';

void main() {
  runApp(const ValidInMobileApp());
}

class ValidInMobileApp extends StatelessWidget {
  const ValidInMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValidIn Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainMobileNavigation(),
    );
  }
}

class MainMobileNavigation extends StatefulWidget {
  const MainMobileNavigation({super.key});

  @override
  State<MainMobileNavigation> createState() => _MainMobileNavigationState();
}

class _MainMobileNavigationState extends State<MainMobileNavigation> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  List<LetterDocument> _docs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _apiService.fetchDocuments();
    setState(() {
      _docs = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/img/logo_untidar.png',
              width: 26,
              height: 26,
              errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 24, color: Colors.amber),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ValidIn Mobile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                Text(
                  'FAKULTAS TEKNIK UNTIDAR',
                  style: TextStyle(fontSize: 9, color: Colors.blue.shade100, letterSpacing: 0.5),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x1FFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              'Sekretaris',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeScreen(),
                _buildSubmitScreen(),
                _buildSatpamPassScreen(),
                _buildScannerScreen(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
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
            icon: Icon(Icons.qr_code_2),
            activeIcon: Icon(Icons.qr_code_2),
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

  // 1. HOME SCREEN (Clean & Minimalist Tracking)
  Widget _buildHomeScreen() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Permohonan Surat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.navy900)),
                  Text('Hanif Abdillah Alatas (NPM 2420506041)', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _currentIndex = 1),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Baru'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._docs.map((doc) => _buildLetterCard(doc)),
        ],
      ),
    );
  }

  Widget _buildLetterCard(LetterDocument doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    doc.regNumber,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppTheme.textTertiary),
                  ),
                ),
                _buildStatusBadge(doc.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(doc.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.navy900)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.apartment, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Expanded(child: Text(doc.location, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text('${doc.eventDate} (${doc.eventTime})', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            // Minimalist Stepper
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TAHAP PENGESAHAN:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textTertiary)),
                  const SizedBox(height: 6),
                  _buildStepRow('1. Sekretaris Panitia', doc.secretaryApproval != null),
                  _buildStepRow('2. Ketua Pelaksana', doc.pelaksanaApproval != null),
                  _buildStepRow('3. Ketua HIMATIF', doc.ketuaApproval != null),
                  _buildStepRow('4. Wakil Dekan I FT', doc.pembinaApproval != null),
                ],
              ),
            ),
            if (doc.dispositionNote.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.sealAmberBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.sealAmberBorder, style: BorderStyle.solid),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📌 DISPOSISI RESMI WADEK I:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF854D0E))),
                    const SizedBox(height: 3),
                    Text('"${doc.dispositionNote}"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF713F12))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (doc.isApproved)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _currentIndex = 2),
                  icon: const Icon(Icons.qr_code, size: 16),
                  label: const Text('Buka Pass QR Satpam'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.navy900,
                    side: const BorderSide(color: AppTheme.navy900),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(String title, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isDone ? AppTheme.sealGreen : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(title, style: TextStyle(fontSize: 11, fontWeight: isDone ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    if (status == 'disetujui') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.sealGreenBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.sealGreenBorder),
        ),
        child: const Text('✓ Sah', style: TextStyle(color: AppTheme.sealGreen, fontSize: 10, fontWeight: FontWeight.w700)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.sealAmberBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: const Text('● Proses', style: TextStyle(color: AppTheme.sealAmber, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  // 2. SUBMIT SCREEN
  Widget _buildSubmitScreen() {
    final formKey = GlobalKey<FormState>();
    final eventController = TextEditingController();
    final locationController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final contactController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pengajuan Izin Fasilitas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.navy900)),
                const SizedBox(height: 4),
                const Text('Format resmi HIMATIF Fakultas Teknik UNTIDAR', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: eventController,
                  decoration: const InputDecoration(labelText: 'Nama Kegiatan *', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Fasilitas / Ruangan *', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(labelText: 'Tanggal *', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: timeController,
                        decoration: const InputDecoration(labelText: 'Waktu *', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Kontak WhatsApp *', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await _apiService.submitDocument({
                          'eventName': eventController.text,
                          'location': locationController.text,
                          'eventDate': dateController.text,
                          'eventTime': timeController.text,
                          'contactPerson': contactController.text,
                        });
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Surat permohonan berhasil diajukan!')),
                        );
                        _loadData();
                        setState(() => _currentIndex = 0);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navy900, foregroundColor: Colors.white),
                    child: const Text('Kirimkan Permohonan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. SATPAM PASS SCREEN
  Widget _buildSatpamPassScreen() {
    final approvedDoc = _docs.firstWhere((d) => d.isApproved, orElse: () => _docs.first);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('FAKULTAS TEKNIK UNIVERSITAS TIDAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(approvedDoc.regNumber, style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: AppTheme.textTertiary)),
                const SizedBox(height: 10),
                Text(approvedDoc.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.navy900)),
                const SizedBox(height: 12),
                _buildStatusBadge(approvedDoc.status),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.navy900, width: 2),
                  ),
                  child: QrImageView(
                    data: approvedDoc.qrToken,
                    version: QrVersions.auto,
                    size: 180.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Token: ${approvedDoc.qrToken.substring(0, 16)}...', style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.grey)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🏢 Izin: ${approvedDoc.location}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('⏰ Waktu: ${approvedDoc.eventDate} (${approvedDoc.eventTime})', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                if (approvedDoc.dispositionNote.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.sealAmberBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.sealAmberBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📝 INSTRUKSI RESMI SATPAM:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF854D0E))),
                        const SizedBox(height: 2),
                        Text('"${approvedDoc.dispositionNote}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF713F12))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 4. SCANNER SCREEN
  Widget _buildScannerScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_scanner, size: 64, color: AppTheme.navy900),
                const SizedBox(height: 12),
                const Text('Verifikasi QR Lapangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text(
                  'Arahkan kamera ke QR Code surat untuk memverifikasi keabsahan izin dan instruksi satpam.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kamera scanner siap diuji coba di perangkat fisik Android.')),
                    );
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Buka Kamera Scanner'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.sealGreen, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
