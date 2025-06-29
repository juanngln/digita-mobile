import 'package:flutter/foundation.dart';

@immutable
class Jurusan {
  final int id;
  final String namaJurusan;

  const Jurusan({required this.id, required this.namaJurusan});

  factory Jurusan.fromJson(Map<String, dynamic> json) {
    return Jurusan(
      id: json['id'] as int,
      namaJurusan: json['nama_jurusan'] as String,
    );
  }
}

@immutable
class DosenProfile {
  final String nik;
  final String namaLengkap;
  final String email;
  final Jurusan jurusan;

  const DosenProfile({
    required this.nik,
    required this.namaLengkap,
    required this.email,
    required this.jurusan,
  });

  factory DosenProfile.fromJson(Map<String, dynamic> json) {
    return DosenProfile(
      nik: json['nik'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      email: json['email'] as String,
      jurusan: Jurusan.fromJson(json['jurusan'] as Map<String, dynamic>),
    );
  }
}