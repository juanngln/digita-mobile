// models/jurusan.dart (Create this new file)
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Jurusan && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
