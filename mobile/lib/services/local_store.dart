import '../models/letter_document.dart';

/// In-memory store identical to web's shared.js localStorage simulation.
/// In production this would be SharedPreferences / Hive.
class LocalStore {
  static final LocalStore _instance = LocalStore._internal();
  factory LocalStore() => _instance;
  LocalStore._internal();

  String _currentRole = 'sekretaris';

  final List<LetterDocument> _docs = [
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
      dispositionNote:
          'ACC dt 23/9/26: Satpam mhn bantuan u/ buka gd & kls sesuai jam pinjam. Mhn pastikan ketertiban & kebersihan dr mhs. Tks.',
      secretaryApproval: ApprovalStage(
          by: 'Hanif Abdillah Alatas', npmOrNip: '2420506041', at: '9 Sep 2026'),
      pelaksanaApproval: ApprovalStage(
          by: 'Emannuel Henji Pratama Putra',
          npmOrNip: '2505060012',
          at: '9 Sep 2026'),
      ketuaApproval: ApprovalStage(
          by: 'Naufal Miftakhul Siddiq',
          npmOrNip: '2440506060',
          at: '10 Sep 2026'),
      pembinaApproval: ApprovalStage(
          by: 'Dr. Sigit Iswahyudi, S.T., M.T.',
          npmOrNip: '197510302021211005',
          at: '23 Sep 2026'),
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
      secretaryApproval: ApprovalStage(
          by: 'Hanif Abdillah Alatas', npmOrNip: '2420506041', at: '24 Sep 2026'),
      pelaksanaApproval: ApprovalStage(
          by: 'Emannuel Henji Pratama Putra',
          npmOrNip: '2505060012',
          at: '24 Sep 2026'),
    ),
  ];

  // ── Role ─────────────────────────────────────────────────────────────────
  String get currentRole => _currentRole;
  void setRole(String role) => _currentRole = role;

  UserProfile getProfile(String role) {
    switch (role) {
      case 'ketua_pelaksana':
        return UserProfile(
          name: 'Emannuel Henji Pratama',
          idNum: '2505060012',
          roleLabel: 'Ketua Pelaksana',
          dept: 'Panitia DigitalWave',
          dutyDesc: 'Bertanggung jawab atas penyelenggaraan teknis acara.',
        );
      case 'ketua_himatif':
        return UserProfile(
          name: 'Naufal Miftakhul Siddiq',
          idNum: '2440506060',
          roleLabel: 'Ketua HIMATIF',
          dept: 'Himpunan Mahasiswa TIF',
          dutyDesc: 'Memberikan persetujuan sebagai perwakilan himpunan.',
        );
      case 'wadek':
        return UserProfile(
          name: 'Dr. Sigit Iswahyudi, S.T., M.T.',
          idNum: '197510302021211005',
          roleLabel: 'Wakil Dekan I FT',
          dept: 'Fakultas Teknik',
          dutyDesc: 'Memberikan disposisi & pengesahan resmi surat.',
        );
      case 'satpam':
        return UserProfile(
          name: 'Sutrisno',
          idNum: 'SAT-UNTIDAR-09',
          roleLabel: 'Petugas Satpam',
          dept: 'Pos Jaga Keamanan FT',
          dutyDesc: 'Memeriksa izin QR & membuka akses gedung kuliah.',
        );
      default: // sekretaris
        return UserProfile(
          name: 'Hanif Abdillah Alatas',
          idNum: '2420506041',
          roleLabel: 'Sekretaris Panitia',
          dept: 'Panitia DigitalWave',
          dutyDesc: 'Membuat & mengunggah surat permohonan resmi.',
        );
    }
  }

  // ── Docs ─────────────────────────────────────────────────────────────────
  List<LetterDocument> getDocs() => List.unmodifiable(_docs);

  LetterDocument? getDocById(String id) {
    try {
      return _docs.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  void addDoc(LetterDocument doc) => _docs.insert(0, doc);

  void updateDoc(LetterDocument updated) {
    final idx = _docs.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      _docs[idx] = updated;
    }
  }

  void deleteDoc(String id) {
    _docs.removeWhere((d) => d.id == id);
  }

  // ── Security Logs ────────────────────────────────────────────────────────
  final List<SecurityScanLog> _securityLogs = [
    SecurityScanLog(
      docId: 'DOC-UNTIDAR-026A',
      title: 'Surat Permohonan Peminjaman Gedung FT 03 Ruang Kelas',
      room: 'Gedung FT 03 Ruang Kelas E.03.3.04 - E.03.3.06',
      scannedAt: DateTime.now().subtract(const Duration(hours: 2)),
      isApproved: true,
      officerName: 'Sutrisno (Satpam FT)',
      actionTaken: 'Kunci Ruang Kelas Diserahkan',
    ),
  ];

  List<SecurityScanLog> getSecurityLogs() => List.unmodifiable(_securityLogs);

  void addSecurityLog(SecurityScanLog log) {
    _securityLogs.insert(0, log);
  }
}

class SecurityScanLog {
  final String docId;
  final String title;
  final String room;
  final DateTime scannedAt;
  final bool isApproved;
  final String officerName;
  final String actionTaken;

  SecurityScanLog({
    required this.docId,
    required this.title,
    required this.room,
    required this.scannedAt,
    required this.isApproved,
    required this.officerName,
    required this.actionTaken,
  });
}

class UserProfile {
  final String name;
  final String idNum;
  final String roleLabel;
  final String dept;
  final String dutyDesc;
  UserProfile(
      {required this.name,
      required this.idNum,
      required this.roleLabel,
      required this.dept,
      required this.dutyDesc});
}
