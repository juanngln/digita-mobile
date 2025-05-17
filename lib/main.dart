import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/services/registration_service.dart';
import 'package:digita_mobile/viewmodels/login_viewmodel.dart';
import 'package:digita_mobile/viewmodels/registration_viewmodel.dart';
import 'package:digita_mobile/views/authentication/login_screen.dart';
import 'package:digita_mobile/views/authentication/register_dosen_screen.dart';
import 'package:digita_mobile/views/authentication/register_mahasiswa_screen.dart';
import 'package:digita_mobile/views/dosen/home_dosen_screen.dart';
import 'package:digita_mobile/views/landing_screen.dart';
import 'package:digita_mobile/views/mahasiswa/cari_dosen.dart';
import 'package:digita_mobile/views/mahasiswa/daftar_dosen.dart';
import 'package:digita_mobile/views/mahasiswa/home_mahasiswa_screen.dart';
import 'package:digita_mobile/views/mahasiswa/status_pengajuan_dosen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
          seedColor: Color(0xFF0F47AD),
          primary: Color(0xFF0F47AD),
          secondary: Color(0xFFD9EEFF),
          surface: Colors.white,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFF0F47AD),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),        
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F47AD),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LandingScreen(),
        '/login':
            (context) => ChangeNotifierProvider(
              create: (context) => LoginViewModel(LoginService()),
              child: const LoginScreen(),
            ),
        '/register_mahasiswa':
            (context) => ChangeNotifierProvider(
              create: (context) => RegistrationViewModel(RegistrationService()),
              child: const RegisterMahasiswaScreen(),
            ),
        '/register_dosen':
            (context) => ChangeNotifierProvider(
              create: (context) => RegistrationViewModel(RegistrationService()),
              child: const RegisterDosenScreen(),
            ),
        '/home_mahasiswa': (context) => const HomeMahasiswaScreen(),
        '/home_dosen': (context) => const HomeDosenScreen(),
        '/cari_dosen': (context) => const CariDosen(),
        '/daftar_dosen': (context) => const DaftarDosen(),
        '/status_pengajuan_dosen': (context) => const StatusPengajuan(),
      },
    );
  }
}
