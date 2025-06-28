import 'dart:convert';

List<DokumenStatusChecklist> dokumenStatusChecklistFromJson(String str) =>
    List<DokumenStatusChecklist>.from(
        json.decode(str).map((x) => DokumenStatusChecklist.fromJson(x)));

class DokumenStatusChecklist {
  final String bab;
  final bool isUploaded;
  final DocumentDetails? documentDetails;

  DokumenStatusChecklist({
    required this.bab,
    required this.isUploaded,
    this.documentDetails,
  });

  factory DokumenStatusChecklist.fromJson(Map<String, dynamic> json) =>
      DokumenStatusChecklist(
        bab: json["bab"],
        isUploaded: json["is_uploaded"],
        documentDetails: json["document_details"] == null
            ? null
            : DocumentDetails.fromJson(json["document_details"]),
      );
}

class DocumentDetails {
  final int id;
  final String bab;
  final String babDisplay;
  final String namaDokumen;
  final String fileUrl;
  late final String status;
  final String statusDisplay;
  late final String? catatanRevisi;
  final PemilikInfo pemilikInfo;
  final DateTime uploadedAt;

  DocumentDetails({
    required this.id,
    required this.bab,
    required this.babDisplay,
    required this.namaDokumen,
    required this.fileUrl,
    required this.status,
    required this.statusDisplay,
    this.catatanRevisi,
    required this.pemilikInfo,
    required this.uploadedAt,
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) =>
      DocumentDetails(
        id: json["id"],
        bab: json["bab"],
        babDisplay: json["bab_display"],
        namaDokumen: json["nama_dokumen"],
        fileUrl: json["file_url"],
        status: json["status"],
        statusDisplay: json["status_display"],
        catatanRevisi: json["catatan_revisi"],
        pemilikInfo: PemilikInfo.fromJson(json["pemilik_info"]),
        uploadedAt: DateTime.parse(json["uploaded_at"]),
      );
}

class PemilikInfo {
  final int userId;
  final String nim;
  final String namaLengkap;
  final ProgramStudi programStudi;

  PemilikInfo({
    required this.userId,
    required this.nim,
    required this.namaLengkap,
    required this.programStudi,
  });

  factory PemilikInfo.fromJson(Map<String, dynamic> json) => PemilikInfo(
    userId: json["user_id"],
    nim: json["nim"],
    namaLengkap: json["nama_lengkap"],
    programStudi: ProgramStudi.fromJson(json["program_studi"]),
  );
}

class ProgramStudi {
  final int id;
  final String namaProdi;

  ProgramStudi({
    required this.id,
    required this.namaProdi,
  });

  factory ProgramStudi.fromJson(Map<String, dynamic> json) => ProgramStudi(
    id: json["id"],
    namaProdi: json["nama_prodi"],
  );
}