import 'package:digita_mobile/views/dosen/home_dosen_screen.dart';
import 'package:digita_mobile/views/authentication/register_dosen_screen.dart';
import 'package:digita_mobile/views/authentication/login_screen.dart';
import 'package:digita_mobile/views/mahasiswa/home_mahasiswa_screen.dart';
import 'package:digita_mobile/views/authentication/register_mahasiswa_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digita_mobile/views/landing_screen.dart';

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
        '/': (context) => const LandingScreen(),
        '/landing_page': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register_mahasiswa': (context) => const RegisterMahasiswaScreen(),
        '/register_dosen': (context) => const RegisterDosenScreen(),
        '/home_mahasiswa': (context) => const HomeMahasiswaScreen(),
        '/home_dosen': (context) => const HomeDosenScreen(),
      },
    );
  }
}
