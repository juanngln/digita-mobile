import 'package:digita_mobile/models/jurusan_model.dart';
import 'package:flutter/foundation.dart';

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
