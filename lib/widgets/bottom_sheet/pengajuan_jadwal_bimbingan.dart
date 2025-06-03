import 'package:flutter/material.dart';

class BimbinganItem {
  final String title;
  final String date;
  final String student;
  final String location;
  String catatan;
  String status;

  BimbinganItem({
    required this.title,
    required this.date,
    required this.student,
    required this.location,
    required this.catatan,
    required this.status,
  });
}

class PengajuanJadwalBimbingan extends StatelessWidget {
  final BimbinganItem bimbingan;
  final VoidCallback onSetuju;

  const PengajuanJadwalBimbingan({
    super.key,
    required this.bimbingan,
    required this.onSetuju,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'Judul Bimbingan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD9EEFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              bimbingan.title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Nama Mahasiswa
          const Text(
            'Nama Mahasiswa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD9EEFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              bimbingan.student,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Tanggal
          const Text(
            'Tanggal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFD9EEFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _extractDate(bimbingan.date),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Waktu
          const Text(
            'Waktu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD9EEFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _extractTime(bimbingan.date),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Lokasi
          const Text(
            'Lokasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD9EEFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bimbingan.location,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Setuju Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSetuju,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F47AD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'SETUJU',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _extractDate(String dateTime) {
    // Extract date from "07 Maret 2025, 14:00" format
    if (dateTime.contains(',')) {
      return dateTime.split(',')[0].trim();
    }
    return dateTime;
  }

  String _extractTime(String dateTime) {
    // Extract time from "07 Maret 2025, 14:00" format
    if (dateTime.contains(',')) {
      return dateTime.split(',')[1].trim();
    }
    return "00:00";
  }
}