import 'package:dio/dio.dart';
import '../models/letter_document.dart';

class ApiService {
  // Point to Microservices API Gateway
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; // 10.0.2.2 for Android Emulator, or localhost
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  // Fallback in-memory data if API Gateway is offline during offline testing
  final List<LetterDocument> _mockDocs = [
    LetterDocument(
      id: 'DOC-UNTIDAR-026A',
      regNumber: '026.a/E/PM/HIMATIF/UNTIDAR/IX/2026',
      title: 'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas',
      type: 'Peminjaman Tempat / Gedung',
      eventName: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026',
      location: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
      eventDate: 'Minggu dan Sabtu, 27 September & 3 Oktober 2026',
      eventTime: '06.00 - 16.00 WIB',
      submitterName: 'Emannuel Henji Pratama Putra',
      contactPerson: '+62 851-8470-9553 (Ilyasa)',
      status: 'disetujui',
      qrToken: '7e4b2d19-8663-4871-9f93-c4083a48e89f',
      dispositionNote: 'ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.',
      secretaryApproval: ApprovalStage(by: 'Hanif Abdillah Alatas', npmOrNip: '2420506041', at: '9 Sep 2026'),
      pelaksanaApproval: ApprovalStage(by: 'Emannuel Henji Pratama Putra', npmOrNip: '2505060012', at: '9 Sep 2026'),
      ketuaApproval: ApprovalStage(by: 'Naufal Miftakhul Siddiq', npmOrNip: '2440506060', at: '10 Sep 2026'),
      pembinaApproval: ApprovalStage(by: 'Dr. Sigit Iswahyudi, S.T., M.T.', npmOrNip: '197510302021211005', at: '23 Sep 2026'),
    ),
    LetterDocument(
      id: 'DOC-UNTIDAR-026B',
      regNumber: '026.b/E/PM/HIMATIF/UNTIDAR/IX/2026',
      title: 'Surat Permohonan Peminjaman Sound dan 2 Buah Mikrofon',
      type: 'Peminjaman Fasilitas / Alat',
      eventName: 'Peningkatan Kompetensi Mahasiswa DigitalWave 2026',
      location: 'Gedung FT 03 Lantai 3 Ruang Auditorium',
      eventDate: 'Sabtu, 24 Oktober 2026',
      eventTime: '08.00 - 15.00 WIB',
      submitterName: 'Emannuel Henji Pratama Putra',
      contactPerson: '+62 851-8470-9553 (Ilyasa)',
      status: 'menunggu_ketua',
      qrToken: 'f1029384-a829-4109-8472-918237465019',
      dispositionNote: '',
      secretaryApproval: ApprovalStage(by: 'Hanif Abdillah Alatas', npmOrNip: '2420506041', at: '24 Sep 2026'),
      pelaksanaApproval: ApprovalStage(by: 'Emannuel Henji Pratama Putra', npmOrNip: '2505060012', at: '24 Sep 2026'),
    ),
  ];

  Future<List<LetterDocument>> fetchDocuments() async {
    try {
      final res = await _dio.get('/documents');
      if (res.statusCode == 200 && res.data['data'] != null) {
        return (res.data['data'] as List)
            .map((j) => LetterDocument.fromJson(j))
            .toList();
      }
    } catch (_) {
      // Fallback to local offline cache
    }
    return _mockDocs;
  }

  Future<LetterDocument?> verifyQrToken(String token) async {
    try {
      final res = await _dio.get('/verification/$token');
      if (res.statusCode == 200 && res.data['data'] != null) {
        return LetterDocument.fromJson(res.data['data']);
      }
    } catch (_) {
      // Local fallback lookup
      for (final doc in _mockDocs) {
        if (doc.qrToken == token) return doc;
      }
    }
    return null;
  }

  Future<bool> submitDocument(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/documents', data: payload);
      return res.statusCode == 201;
    } catch (_) {
      // Add to local mock
      _mockDocs.insert(
        0,
        LetterDocument(
          id: 'DOC-M-${DateTime.now().millisecondsSinceEpoch}',
          regNumber: '${100 + _mockDocs.length}/E/PM/HIMATIF/UNTIDAR/X/2026',
          title: 'Surat Permohonan Izin ${payload['location']}',
          type: 'Peminjaman Fasilitas Kampus',
          eventName: payload['eventName'] ?? '',
          location: payload['location'] ?? '',
          eventDate: payload['eventDate'] ?? '',
          eventTime: payload['eventTime'] ?? '',
          submitterName: 'Emannuel Henji Pratama Putra',
          contactPerson: payload['contactPerson'] ?? '',
          status: 'menunggu_pelaksana',
          qrToken: 'm-qr-${DateTime.now().millisecondsSinceEpoch}',
          dispositionNote: '',
          secretaryApproval: ApprovalStage(by: 'Hanif Abdillah Alatas', npmOrNip: '2420506041', at: 'Hari ini'),
        ),
      );
      return true;
    }
  }
}
