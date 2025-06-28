class Ruangan {
  final int id;
  final String namaRuangan;

  Ruangan({required this.id, required this.namaRuangan});

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'],
      namaRuangan: json['nama_ruangan'],
    );
  }
}