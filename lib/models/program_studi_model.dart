import 'package:flutter/foundation.dart';

@immutable
class ProgramStudi {
  final int id;
  final String namaProdi;

  const ProgramStudi({required this.id, required this.namaProdi});

  factory ProgramStudi.fromJson(Map<String, dynamic> json) {
    return ProgramStudi(
      id: json['id'] as int,
      namaProdi: json['nama_prodi'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramStudi &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
