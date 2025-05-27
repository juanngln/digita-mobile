import 'package:flutter/material.dart';

class FormPengajuanMahasiswaWidget extends StatefulWidget {
  final dynamic selectedDosen; 
  
  const FormPengajuanMahasiswaWidget({
    Key? key, 
    required this.selectedDosen
  }) : super(key: key);

  @override
  State<FormPengajuanMahasiswaWidget> createState() => _FormPengajuanMahasiswaWidgetState();
}

class _FormPengajuanMahasiswaWidgetState extends State<FormPengajuanMahasiswaWidget> {
  final TextEditingController _judulTAController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  
  @override
  void dispose() {
    _judulTAController.dispose();
    _deskripsiController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Pengajuan Dosen Pembimbing',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection(
                            'Nama Mahasiswa',
                            widget.selectedDosen?.nama ?? 'Anggara Putra',
                          ),
                          const SizedBox(height: 20),
                          _buildInputSection(
                            'Alasan Memilih Dosen',
                            'Karena sesuai bidang penelitian saya, dan ingin belajar lebih dalam tentang website',
                            _alasanController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          _buildInputSection(
                            'Rencana Judul TA',
                            'Rancang Bangun Aplikasi Sistem Informasi Absensi Karyawan Online',
                            _judulTAController,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 20),
                          _buildInputSection(
                            'Deskripsi Singkat',
                            'Tujuan dari penelitian ini adalah merancang sistem informasi absensi karyawan berbasis web pada CV Cahaya Toner agar menghasilkan sistem informasi yang efektif dan efisien serta mempermudah dalam pengolahan data rekap absensi karyawan.',
                            _deskripsiController,
                            maxLines: 6,
                          ),                      
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB3BA),
                            foregroundColor: const Color(0xFFE20030),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Tolak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _handleSetuju();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB7FCC9),
                            foregroundColor: const Color(0xFF0A7D0C),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Setuju',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD9EEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(String title, String placeholder, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD9EEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            placeholder,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  void _handleSetuju() {
    // Handle approve action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengajuan telah disetujui'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}