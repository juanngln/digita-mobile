import 'package:flutter/material.dart';
import 'package:digita_mobile/views/dosen/status_dokumen.dart';

class DokumenDosen extends StatefulWidget {
  const DokumenDosen({super.key});

  @override
  State<DokumenDosen> createState() => _DokumenDosenState();
}

class _DokumenDosenState extends State<DokumenDosen> {

  final List<Mahasiswa> mahasiswaList = [
    Mahasiswa(
      nama: 'Udin Prakoso Bakti',
      informasiMahasiswa: '3342301827 - Teknik Informatika',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
    Mahasiswa(
      nama: 'Abyan Putra Tama',
      informasiMahasiswa: '4467152497 - Animasi',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
    Mahasiswa(
      nama: 'Siska Putri Nymas',
      informasiMahasiswa: '3309871645 - Teknologi Geomatika',
      avatarPath: 'assets/img/mhs_wanita.png',
    ),
    Mahasiswa(
      nama: 'Anggara Putra Nugroho',
      informasiMahasiswa: '4316332414 - RKS',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
    Mahasiswa(
      nama: 'Wildha Siti Nur',
      informasiMahasiswa: '3312401824 - Teknik Informatika',
      avatarPath: 'assets/img/mhs_wanita.png',
    ),
    Mahasiswa(
      nama: 'Boy Arnez Araby',
      informasiMahasiswa: '4342301827 - TRM',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: ListView(
            children: [
              const Text(
                'Dokumen Tugas Akhir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Pilih Mahasiswa',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F47AD),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...mahasiswaList.map((mahasiswa) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatusDokumen(
                          mahasiswa: mahasiswa,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            mahasiswa.avatarPath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mahasiswa.nama,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F47AD),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mahasiswa.informasiMahasiswa,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
