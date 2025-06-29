import 'dart:convert';

List<Pengumuman> pengumumanFromJson(String str) => List<Pengumuman>.from(json.decode(str).map((x) => Pengumuman.fromJson(x)));

class Pengumuman {
  final int id;
  final String title;
  final String description;
  final DateTime tglMulai;
  final DateTime tglSelesai;
  final String? attachment;
  final String? lampiranUrl;

  Pengumuman({
    required this.id,
    required this.title,
    required this.description,
    required this.tglMulai,
    required this.tglSelesai,
    this.attachment,
    this.lampiranUrl,
  });

  factory Pengumuman.fromJson(Map<String, dynamic> json) => Pengumuman(
    id: json["id"],
    title: json["judul"] ?? '',
    description: json["deskripsi"] ?? '',

    tglMulai: DateTime.parse(json["tanggal_mulai"]),
    tglSelesai: DateTime.parse(json["tanggal_selesai"]),

    attachment: json["lampiran"],
    lampiranUrl: json["lampiran_url"],
  );
}