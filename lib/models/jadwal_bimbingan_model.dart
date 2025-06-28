import 'dart:convert';

List<JadwalBimbingan> jadwalBimbinganFromJson(String str) => List<JadwalBimbingan>.from(json.decode(str).map((x) => JadwalBimbingan.fromJson(x)));

class JadwalBimbingan {
  final int id;
  // Both fields now use the flexible BimbinganUser class
  final BimbinganUser mahasiswa;
  final BimbinganUser dosenPembimbing;
  final String judulBimbingan;
  final DateTime tanggal;
  final String waktu;
  final LokasiRuangan lokasiRuangan;
  final String status;
  final String statusDisplay;
  final String? alasanPenolakan;
  final String? catatanBimbingan;

  JadwalBimbingan({
    required this.id,
    required this.mahasiswa,
    required this.dosenPembimbing,
    required this.judulBimbingan,
    required this.tanggal,
    required this.waktu,
    required this.lokasiRuangan,
    required this.status,
    required this.statusDisplay,
    this.alasanPenolakan,
    this.catatanBimbingan,
  });

  factory JadwalBimbingan.fromJson(Map<String, dynamic> json) => JadwalBimbingan(
    id: json["id"],
    // The fromJson factory now uses BimbinganUser for both
    mahasiswa: BimbinganUser.fromJson(json["mahasiswa"]),
    dosenPembimbing: BimbinganUser.fromJson(json["dosen_pembimbing"]),
    judulBimbingan: json["judul_bimbingan"],
    tanggal: DateTime.parse(json["tanggal"]),
    waktu: json["waktu"],
    lokasiRuangan: LokasiRuangan.fromJson(json["lokasi_ruangan"]),
    status: json["status"],
    statusDisplay: json["status_display"],
    alasanPenolakan: json["alasan_penolakan"],
    catatanBimbingan: json["catatan_bimbingan"],
  );
}

// Renamed from DosenPembimbing to a more generic name
// This single class can represent either a student or a lecturer
class BimbinganUser {
  final String namaLengkap;
  final String? nim; // Nullable to handle lecturer objects
  final String? nik; // Nullable to handle student objects

  BimbinganUser({
    required this.namaLengkap,
    this.nim,
    this.nik,
  });

  // The factory now handles all possible keys from both user types
  factory BimbinganUser.fromJson(Map<String, dynamic> json) => BimbinganUser(
    namaLengkap: json["nama_lengkap"],
    nim: json["nim"], // Will be null if the key doesn't exist (e.g., for a lecturer)
    nik: json["nik"], // Will be null if the key doesn't exist (e.g., for a student)
  );
}

class LokasiRuangan {
  final String namaRuangan;

  LokasiRuangan({
    required this.namaRuangan,
  });

  factory LokasiRuangan.fromJson(Map<String, dynamic> json) => LokasiRuangan(
    namaRuangan: json["nama_ruangan"],
  );
}