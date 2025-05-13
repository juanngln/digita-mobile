import 'package:flutter/material.dart';

class StatusPengajuanDitolak extends StatefulWidget {
  const StatusPengajuanDitolak({super.key});

  @override
  State<StatusPengajuanDitolak> createState() => _StatusPengajuanDitolakState();
}

class _StatusPengajuanDitolakState extends State<StatusPengajuanDitolak> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/img/pengajuan_dosen_ditolak.png', height: 300),
          const SizedBox(height: 24),
          const Text(
            'Yah, Pengajuanmu Ditolak!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F47AD),
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Pengajuan Ditolak.\nYuk, cari dosen\npembimbing baru!\n',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F47AD),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/daftar_dosen');
              },
              child: const Text(
                'Cari Dosen Pembimbing',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
