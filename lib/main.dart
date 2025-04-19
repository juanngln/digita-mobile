import 'package:digita_mobile/dosen/home_dosen_screen.dart';
import 'package:digita_mobile/dosen/register_dosen_screen.dart';
import 'package:digita_mobile/login.dart';
import 'package:digita_mobile/mahasiswa/home_mahasiswa_screen.dart';
import 'package:digita_mobile/mahasiswa/register_mahasiswa_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digita_mobile/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigiTA Mobile',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x000F47AD),
          primary: Color(0x000F47AD),
          secondary: Color(0x00D9EEFF),
          surface: Colors.white,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0x000F47AD),
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          titleSmall: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color(0x000F47AD),
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/register_mahasiswa': (context) => const RegisterMahasiswaScreen(),
        '/register_dosen': (context) => const RegisterDosenScreen(),
        '/home_mahasiswa': (context) => const HomeMahasiswaScreen(),
        '/home_dosen': (context) => const HomeDosenScreen(),
      },
    );

  }
}
