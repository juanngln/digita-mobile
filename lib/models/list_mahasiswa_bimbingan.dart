import 'dart:convert';

List<ListMahasiswaBimbingan> mahasiswaFromJson(String str) => List<ListMahasiswaBimbingan>.from(json.decode(str).map((x) => ListMahasiswaBimbingan.fromJson(x)));

class ListMahasiswaBimbingan {
  final int userId;
  final String nim;
  final String namaLengkap;
  final ProgramStudi programStudi;
  final String judulSkripsi;
  final String avatarPath;

  ListMahasiswaBimbingan({
    required this.userId,
    required this.nim,
    required this.namaLengkap,
    required this.programStudi,
    required this.judulSkripsi,
    this.avatarPath = 'assets/img/mhs_pria.png',
  });

  factory ListMahasiswaBimbingan.fromJson(Map<String, dynamic> json) => ListMahasiswaBimbingan(
    userId: json["user_id"],
    nim: json["nim"],
    namaLengkap: json["nama_lengkap"],
    programStudi: ProgramStudi.fromJson(json["program_studi"]),
    judulSkripsi: json["judul_skripsi"],
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