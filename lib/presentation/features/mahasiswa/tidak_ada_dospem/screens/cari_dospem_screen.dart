import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CariDosen extends StatefulWidget {
  const CariDosen({super.key});

  @override
  State<CariDosen> createState() => _CariDosenState();
}

class _CariDosenState extends State<CariDosen> {
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
                  key: const Key('imgWaduh'),
                  'assets/img/waduh.png',
                  height: 300,
                ),
                const SizedBox(height: 24),

                const Text(
                  'Waduh!!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F47AD),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Sepertinya kamu belum ada\ndosen pembimbing\nDaftar dulu yuk!',
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
                    key: const Key('btnCariDospem'),
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
                      'CARI DOSEN PEMBIMBING',
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