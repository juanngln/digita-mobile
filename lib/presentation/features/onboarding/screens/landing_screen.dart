import 'package:digita_mobile/presentation/common_widgets/bottom_sheets/role_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(key: const Key('imgLogo'), 'assets/img/digita_logo.png', height: 300),
                const SizedBox(height: 24),
                // Text
                Text(
                  'Solusi simpel dan praktis untuk bimbingan tugas akhir yang lebih teratur dan efisien!',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 48),
                // Button Masuk
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    key: const Key('btnLogin'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF0F47AD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'MASUK',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Button Daftar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      _showRoleSelectionBottomSheet(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF9DCFF7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'DAFTAR',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showRoleSelectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: const Color(0xFFD9EEFF),
    builder: (BuildContext builderContext) {
      return RoleSelectionBottomSheet(
        roles: const ['Mahasiswa', 'Dosen'],
        onRoleSelected: (selectedRole) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!context.mounted) {
              return;
            }
            final routeName =
                selectedRole.toLowerCase() == 'mahasiswa'
                    ? '/register_mahasiswa'
                    : '/register_dosen';
            Navigator.pushNamed(context, routeName);
          });
        },
      );
    },
  );
}
