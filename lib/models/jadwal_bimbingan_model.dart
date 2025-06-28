import 'dart:convert';

List<JadwalBimbingan> jadwalBimbinganFromJson(String str) => List<JadwalBimbingan>.from(json.decode(str).map((x) => JadwalBimbingan.fromJson(x)));

class JadwalBimbingan {
  final int id;
  final DosenPembimbing mahasiswa;
  final DosenPembimbing dosenPembimbing;
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
    mahasiswa: DosenPembimbing.fromJson(json["mahasiswa"]),
    dosenPembimbing: DosenPembimbing.fromJson(json["dosen_pembimbing"]),
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

class DosenPembimbing {
  final String namaLengkap;

  DosenPembimbing({
    required this.namaLengkap,
  });

  factory DosenPembimbing.fromJson(Map<String, dynamic> json) => DosenPembimbing(
    namaLengkap: json["nama_lengkap"],
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