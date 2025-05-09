import 'package:flutter/material.dart';

class Dosen {
  final String nama;
  final String jumlahMahasiswa;
  final String avatarPath;

  Dosen({
    required this.nama,
    required this.jumlahMahasiswa,
    required this.avatarPath,
  });
}

class DaftarDosen extends StatelessWidget {
  DaftarDosen({super.key});

  final List<Dosen> dosenList = [
    Dosen(
      nama: 'Agus Hartoyo, S.T., M.Sc., Ph.D.',
      jumlahMahasiswa: '2 Mahasiswa',
      avatarPath: 'assets/img/dosen_pria.png',
    ),
    Dosen(
      nama: 'Trisha Amalya, S. Eng',
      jumlahMahasiswa: '5 Mahasiswa',
      avatarPath: 'assets/img/dosen_wanita.png',
    ),
    Dosen(
      nama: 'Agung Cahyadi, S.Kom',
      jumlahMahasiswa: '7 Mahasiswa',
      avatarPath: 'assets/img/dosen_pria.png',
    ),
    Dosen(
      nama: 'Ari Moesrami, S.Kom., M.T.',
      jumlahMahasiswa: '5 Mahasiswa',
      avatarPath: 'assets/img/dosen_pria.png',
    ),
    Dosen(
      nama: 'Aniq Atiqi Rohma, S.Si., M.Si.',
      jumlahMahasiswa: '8 Mahasiswa',
      avatarPath: 'assets/img/dosen_wanita.png',
    ),
    Dosen(
      nama: 'Febriyanti Sthevanie, S.T., M.T.',
      jumlahMahasiswa: '9 Mahasiswa',
      avatarPath: 'assets/img/dosen_wanita.png',
    ),
    Dosen(
      nama: 'Endro Ariyanto, S.T., M.T.',
      jumlahMahasiswa: '6 Mahasiswa',
      avatarPath: 'assets/img/dosen_pria.png',
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
                'Daftar Dosen Pembimbing',
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
                    'Pilih Dosen Pembimbingmu',
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
              ...dosenList.map((dosen) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) => FormPengajuanDosen(pilihDosen: dosen.nama),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            dosen.avatarPath,
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
                                dosen.nama,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F47AD),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dosen.jumlahMahasiswa,
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class FormPengajuanDosen extends StatelessWidget {
  final String pilihDosen;
  const FormPengajuanDosen({super.key, required this.pilihDosen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 90,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pengajuan Dosen Pembimbing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            buildTextField('Dosen Pembimbing', pilihDosen, readOnly: true),
            buildTextField('Program Studi', ''),
            buildTextField('Rencana Judul TA', ''),
            buildTextField('Deskripsi Singkat', '', maxLines: 4),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F47AD),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/status_pengajuan_dosen',
                  );
                },
                child: const Text(
                  'AJUKAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String initialValue, {int maxLines = 1, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins', 
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: readOnly,
            initialValue: initialValue,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? Colors.grey[300] : const Color(0xFFD9EEFF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


