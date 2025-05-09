import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPengajuan extends StatefulWidget {
  const StatusPengajuan({super.key});

  @override
  State<StatusPengajuan> createState() => _StatusPengajuanState();
}

class _StatusPengajuanState extends State<StatusPengajuan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/terkirim.png',
                  height: 300,
                ),
                const SizedBox(height: 24),

                const Text(
                  'Wah, Terkirim!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F47AD),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Pengajuan Dosen Pembimbingmu\nsudah terkirim\nYuk, cek status pengajuanmu\nsekarang!',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/daftar_dosen');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF0F47AD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'LIHAT STATUS PENGAJUAN',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ) 
      ),
    );
  }
}