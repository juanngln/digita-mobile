class Mahasiswa {
  final int userId;
  final String nim;
  final String namaLengkap;
  final String email;
  final String programStudi;
  final String dosenPembimbing;
  final int dosenPembimbingId;

  Mahasiswa({
    required this.userId,
    required this.nim,
    required this.namaLengkap,
    required this.email,
    required this.programStudi,
    required this.dosenPembimbing,
    required this.dosenPembimbingId,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
    userId: json["user_id"],
    nim: json["nim"],
    namaLengkap: json["nama_lengkap"],
    email: json["email"],
    programStudi: json["program_studi"],
    dosenPembimbing: json["dosen_pembimbing"],
    dosenPembimbingId: json["dosen_pembimbing_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "nim": nim,
    "nama_lengkap": namaLengkap,
    "email": email,
    "program_studi": programStudi,
    "dosen_pembimbing": dosenPembimbing,
    "dosen_pembimbing_id": dosenPembimbingId,
  };
}