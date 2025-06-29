import 'package:digita_mobile/models/program_studi_model.dart';
import 'package:flutter/foundation.dart';


@immutable
class MahasiswaProfile {
  final String nim;
  final String namaLengkap;
  final String email;
  final ProgramStudi programStudi;
  final String jurusan;
  final int? dosenPembimbingId;

  const MahasiswaProfile({
    required this.nim,
    required this.namaLengkap,
    required this.email,
    required this.programStudi,
    required this.jurusan,
    required this.dosenPembimbingId,
  });

  factory MahasiswaProfile.fromJson(Map<String, dynamic> json) {
    return MahasiswaProfile(
      nim: json['nim'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      email: json['email'] as String,
      programStudi: ProgramStudi.fromJson(json['program_studi'] as Map<String, dynamic>),
      jurusan: json['jurusan'] as String,
      dosenPembimbingId: json['dosen_pembimbing_id'] as int?,
    );
  }
}