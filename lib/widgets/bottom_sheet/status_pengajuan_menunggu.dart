import 'package:flutter/material.dart';

class StatusPengajuanMenunggu extends StatefulWidget {
  const StatusPengajuanMenunggu({super.key});

  @override
  State<StatusPengajuanMenunggu> createState() =>
      _StatusPengajuanMenungguState();
}

class _StatusPengajuanMenungguState extends State<StatusPengajuanMenunggu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/img/pengajuan_dosen_pending.png', height: 300),
          const SizedBox(height: 24),
          const Text(
            'Sedang Menunggu Konfirmasi',
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
            'Pengajuan dosen pembimbing.\nsedang diproses\nSabar sebentar ya!.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
