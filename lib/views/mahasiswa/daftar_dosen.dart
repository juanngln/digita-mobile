import 'package:digita_mobile/widgets/button/primary_action_button.dart';
import 'package:digita_mobile/widgets/forms/text_area_field.dart';
import 'package:digita_mobile/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              Text(
                'Daftar Dosen Pembimbing',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Pilih Dosen Pembimbingmu',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
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
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      builder:
                          (context) =>
                              FormPengajuanDosen(pilihDosen: dosen.nama),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
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
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F47AD),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dosen.jumlahMahasiswa,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black54,
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

class FormPengajuanDosen extends StatefulWidget {
  final String pilihDosen;
  const FormPengajuanDosen({super.key, required this.pilihDosen});

  @override
  State<FormPengajuanDosen> createState() => _FormPengajuanDosenState();
}

class _FormPengajuanDosenState extends State<FormPengajuanDosen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dosenPembimbingController;
  final TextEditingController _programStudiController = TextEditingController();
  final TextEditingController _rencanaJudulController = TextEditingController();
  final TextEditingController _deskripsiSingkatController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _dosenPembimbingController = TextEditingController(text: widget.pilihDosen);
  }

  @override
  void dispose() {
    _dosenPembimbingController.dispose();
    _programStudiController.dispose();
    _rencanaJudulController.dispose();
    _deskripsiSingkatController.dispose();
    super.dispose();
  }

  void _submitPengajuan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/status_pengajuan_dosen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30.0,
        left: 30.0,
        right: 30.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 90,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Pengajuan Dosen Pembimbing',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Dosen Pembimbing',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _dosenPembimbingController,
                hintText: 'DOSEN PEMBIMBING',
                enabled: false,

                fillColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),
              Text(
                'Program Studi',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _programStudiController,
                hintText: 'PROGRAM STUDI',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Program Studi tidak boleh kosong';
                  }
                  return null;
                },

                fillColor: const Color(0xFFD9EEFF),
              ),
              const SizedBox(height: 20),
              Text(
                'Rencana Judul TA',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _rencanaJudulController,
                hintText: 'RENCANA JUDUL TA',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Rencana Judul TA tidak boleh kosong';
                  }
                  return null;
                },

                fillColor: const Color(0xFFD9EEFF),
              ),
              const SizedBox(height: 20),
              Text(
                'Deskripsi Singkat',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextAreaField(
                controller: _deskripsiSingkatController,
                hintText: 'DESKRIPSI SINGKAT',
                maxLines: 7,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi Singkat tidak boleh kosong';
                  }
                  return null;
                },

                fillColor: const Color(0xFFD9EEFF),
              ),
              const SizedBox(height: 30),
              PrimaryActionButton(
                text: 'AJUKAN',
                isLoading: false,
                onPressed: _submitPengajuan,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
