class Dosen {
  final int userId;
  final String nik;
  final String nama;
  final String email;
  final int jurusanId;
  final int jumlahMahasiswaAktif;
  final String avatarPath;

  Dosen({
    required this.userId,
    required this.nik,
    required this.nama,
    required this.email,
    required this.jurusanId,
    required this.jumlahMahasiswaAktif,
    required this.avatarPath,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      userId: json['user_id'] as int,
      nik: json['nik'] as String,
      nama: json['nama_lengkap'] as String,
      email: json['email'] as String,
      jurusanId: json['jurusan'] as int,
      jumlahMahasiswaAktif: json['jumlah_mahasiswa_aktif'] as int,

      avatarPath: 'assets/img/dosen_pria.png', // Placeholder!
    );
  }

  String get jumlahMahasiswaForDisplay => '$jumlahMahasiswaAktif Mahasiswa';
}
