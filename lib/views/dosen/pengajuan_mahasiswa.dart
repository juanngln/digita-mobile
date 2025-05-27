import 'package:flutter/material.dart';
import 'package:digita_mobile/widgets/bottom_sheet/form_pengajuan_mahasiswa.dart';

class Mahasiswa {
  final String nama;
  final String informasiMahasiswa;
  final String avatarPath;

  Mahasiswa({
    required this.nama,
    required this.informasiMahasiswa,
    required this.avatarPath,
  });
}

class PengajuanMahasiswa extends StatefulWidget {
  const PengajuanMahasiswa({super.key});

  @override
  State<PengajuanMahasiswa> createState() => PengajuanMahasiswaState();
}

class PengajuanMahasiswaState extends State<PengajuanMahasiswa> {
  final List<Mahasiswa> mahasiswaList = [
    Mahasiswa(
      nama: 'Kageyama Tobio',
      informasiMahasiswa: '4412301127 - TRPL',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
    Mahasiswa(
      nama: 'Dimas Prasetya',
      informasiMahasiswa: '4412112019 - Animasi',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
    Mahasiswa(
      nama: 'Arumi Salsabila',
      informasiMahasiswa: '3309871645 - Animasi',
      avatarPath: 'assets/img/mhs_wanita.png',
    ),
    Mahasiswa(
      nama: 'Bintang Pratama',
      informasiMahasiswa: '4316332414 - RKS',
      avatarPath: 'assets/img/mhs_pria.png',
    ),
    Mahasiswa(
      nama: 'Quinetana Putri',
      informasiMahasiswa: '3312401824 - Teknik Informatika',
      avatarPath: 'assets/img/mhs_wanita.png',
    ),
    Mahasiswa(
      nama: 'Paramitha Putri',
      informasiMahasiswa: '3312401824 - Teknik Informatika',
      avatarPath: 'assets/img/mhs_wanita.png',
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
                'Pengajuan Mahasiswa',
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
                    'Daftar Mahasiswa',
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
                    _showFormPengajuanBottomSheet(context, mahasiswa);
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
                          blurRadius: 8,
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

  void _showFormPengajuanBottomSheet(BuildContext context, Mahasiswa mahasiswa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FormPengajuanMahasiswaWidget(
        selectedDosen: mahasiswa, 
      ),
    );
  }
}