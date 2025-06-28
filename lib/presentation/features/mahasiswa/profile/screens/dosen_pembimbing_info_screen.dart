import 'package:flutter/material.dart';

class DosenPembimbingInfoScreen extends StatelessWidget {
  const DosenPembimbingInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Informasi Dosen Pembimbing"),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          //==================================================================
          //== PERUBAHAN UTAMA DI SINI
          //== Seluruh konten sekarang dibungkus dengan Container ini
          //==================================================================
          child: Container(
            width: 369,
            height: 415,
            padding: const EdgeInsets.all(20.0), // Padding di dalam box
            decoration: BoxDecoration(
              color: Colors.white, // Warna FFFFFF
              borderRadius: BorderRadius.circular(12), // Corner radius 12
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Warna bayangan
                  spreadRadius: 2, // Seberapa menyebar bayangannya
                  blurRadius: 7, // Seberapa kabur bayangannya
                  offset: const Offset(0, 3), // Posisi bayangan (X, Y)
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceAround, // Agar item terdistribusi
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 257,
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7FCC9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Status: Dosen Pembimbing Aktif",
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF0A7D0C),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(), // Gunakan Spacer untuk mendorong konten
                _buildInfoItem(
                  textTheme,
                  label: "Nama Dosen Pembimbing",
                  value: "Dr. Budi Santoso",
                ),
                const Spacer(),
                _buildInfoItem(
                  textTheme,
                  label: "NIK",
                  value: "214765",
                ),
                const Spacer(),
                _buildInfoItem(
                  textTheme,
                  label: "Program Studi",
                  value: "Teknik Informatika",
                ),
                const Spacer(),
                _buildInfoItem(
                  textTheme,
                  label: "Email",
                  value: "budi@polibatam.ac.id",
                ),
                const Spacer(),
                _buildInfoItem(
                  textTheme,
                  label: "Topik Bimbingan",
                  value: "Rancang Bangun Aplikasi Absensi Karyawan Perusahaan Telkomsel Indonesia",
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(TextTheme textTheme, {required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F47AD),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
