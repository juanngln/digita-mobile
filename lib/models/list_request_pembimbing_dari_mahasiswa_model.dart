class ListRequestPembimbingDariMahasiswaModel {
  final int id;
  final String mahasiswaNama;
  final String mahasiswaNim;
  final String rencanaJudul;
  final String deskripsiSingkat;
  final String alasanMemilihDosen;

  ListRequestPembimbingDariMahasiswaModel({
    required this.id,
    required this.mahasiswaNama,
    required this.mahasiswaNim,
    required this.rencanaJudul,
    required this.deskripsiSingkat,
    required this.alasanMemilihDosen,
  });

  factory ListRequestPembimbingDariMahasiswaModel.fromJson(Map<String, dynamic> json) {
    final mahasiswaData = json['mahasiswa'] as Map<String, dynamic>? ?? {};

    return ListRequestPembimbingDariMahasiswaModel(
      id: json['id'] as int? ?? 0,
      mahasiswaNama: mahasiswaData['nama_lengkap'] as String? ?? 'N/A',
      mahasiswaNim: mahasiswaData['nim'] as String? ?? 'N/A',
      rencanaJudul: json['rencana_judul'] as String? ?? 'Judul tidak tersedia.',
      deskripsiSingkat: json['rencana_deskripsi'] as String? ?? 'Deskripsi tidak tersedia.',
      alasanMemilihDosen: json['alasan_memilih_dosen'] as String? ?? 'Alasan tidak tersedia.',
    );
  }
}