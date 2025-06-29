import 'dart:convert';

List<JadwalBimbingan> jadwalBimbinganFromJson(String str) => List<JadwalBimbingan>.from(json.decode(str).map((x) => JadwalBimbingan.fromJson(x)));

class JadwalBimbingan {
  final int id;
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


class BimbinganUser {
  final String namaLengkap;
  final String? nim;
  final String? nik;

  BimbinganUser({
    required this.namaLengkap,
    this.nim,
    this.nik,
  });

  factory BimbinganUser.fromJson(Map<String, dynamic> json) => BimbinganUser(
    namaLengkap: json["nama_lengkap"],
    nim: json["nim"],
    nik: json["nik"],
  );
}

class LokasiRuangan {
  final int id;
  final String namaRuangan;

  LokasiRuangan({
    required this.id,
    required this.namaRuangan,
  });

  factory LokasiRuangan.fromJson(Map<String, dynamic> json) => LokasiRuangan(
    id: json["id"],
    namaRuangan: json["nama_ruangan"],
  );
}