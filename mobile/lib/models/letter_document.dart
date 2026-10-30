class ApprovalStage {
  final String by;
  final String npmOrNip;
  final String at;

  ApprovalStage({required this.by, required this.npmOrNip, required this.at});

  factory ApprovalStage.fromJson(Map<String, dynamic> json) {
    return ApprovalStage(
      by: json['by'] ?? '',
      npmOrNip: json['npm'] ?? json['nip'] ?? '',
      at: json['at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'by': by,
    'npmOrNip': npmOrNip,
    'at': at,
  };
}

class LetterDocument {
  final String id;
  final String regNumber;
  final String title;
  final String type;
  final String eventName;
  final String location;
  final String eventDate;
  final String eventTime;
  final String submitterName;
  final String contactPerson;
  final String status; // 'menunggu_pelaksana', 'menunggu_ketua', 'disetujui', 'perlu_revisi'
  final String qrToken;
  final String dispositionNote;
  final ApprovalStage? secretaryApproval;
  final ApprovalStage? pelaksanaApproval;
  final ApprovalStage? ketuaApproval;
  final ApprovalStage? pembinaApproval;

  LetterDocument({
    required this.id,
    required this.regNumber,
    required this.title,
    required this.type,
    required this.eventName,
    required this.location,
    required this.eventDate,
    required this.eventTime,
    required this.submitterName,
    required this.contactPerson,
    required this.status,
    required this.qrToken,
    required this.dispositionNote,
    this.secretaryApproval,
    this.pelaksanaApproval,
    this.ketuaApproval,
    this.pembinaApproval,
  });

  bool get isApproved => status == 'disetujui';

  factory LetterDocument.fromJson(Map<String, dynamic> json) {
    return LetterDocument(
      id: json['id'] ?? '',
      regNumber: json['regNumber'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      eventName: json['eventName'] ?? '',
      location: json['location'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventTime: json['eventTime'] ?? '',
      submitterName: json['submitterName'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      status: json['status'] ?? 'menunggu_pelaksana',
      qrToken: json['qrToken'] ?? '',
      dispositionNote: json['dispositionNote'] ?? '',
      secretaryApproval: json['secretaryApproval'] != null
          ? ApprovalStage.fromJson(json['secretaryApproval'])
          : null,
      pelaksanaApproval: json['pelaksanaApproval'] != null
          ? ApprovalStage.fromJson(json['pelaksanaApproval'])
          : null,
      ketuaApproval: json['ketuaApproval'] != null
          ? ApprovalStage.fromJson(json['ketuaApproval'])
          : null,
      pembinaApproval: json['pembinaApproval'] != null
          ? ApprovalStage.fromJson(json['pembinaApproval'])
          : null,
    );
  }
}
