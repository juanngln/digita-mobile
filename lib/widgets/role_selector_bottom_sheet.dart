import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionBottomSheet extends StatefulWidget {
  final List<String> roles;
  final String? initialSelectedRole;
  final Function(String) onRoleSelected;

  const RoleSelectionBottomSheet({
    super.key,
    required this.roles,
    this.initialSelectedRole,
    required this.onRoleSelected,
  });

  @override
  State<RoleSelectionBottomSheet> createState() =>
      _RoleSelectionBottomSheetState();
}

class _RoleSelectionBottomSheetState extends State<RoleSelectionBottomSheet> {
  // Local state untuk manage pilihan role didalam sheet
  String? _tempSelectedRole;
  static const Duration _animationDuration = Duration(
    milliseconds: 200,
  ); // durasi animasi

  @override
  void initState() {
    super.initState();
    _tempSelectedRole = widget.initialSelectedRole;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
        left: 24.0,
        right: 24.0,
        top: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Dashboard menyesuaikan peranmu,',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
          ),
          Text(
            'Pilih Peranmu!',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                widget.roles.map((role) {
                  bool isSelected = _tempSelectedRole == role;
                  // --- Menentukan gambar yang ditampilkan berdasarkan role dan state (dipilih/tidak dipilih) ---
                  String finalImagePath;
                  // nama gambar dasar berdasarkan role
                  String baseImageName;
                  if (role == 'Mahasiswa') {
                    baseImageName = 'role_mahasiswa';
                  } else {
                    baseImageName = 'role_dosen';
                  }
                  Color textColor = isSelected ? Colors.white : Colors.black;
                  // menentukan suffix gambar berdasarkan state
                  String stateSuffix = isSelected ? '_selected' : '_normal';
                  // hasil akhir dari path gambar
                  finalImagePath =
                      'assets/img/$baseImageName$stateSuffix.png'; // nama dasar + suffix.png
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _tempSelectedRole = role;
                      });
                    },
                    // --- Menggunakan AnimatedContainer untuk transisi warna background ---
                    child: AnimatedContainer(
                      duration: _animationDuration, // durasi animasi
                      curve: Curves.easeInOut, // tipe transisi

                      width: 130,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      // properti animasi ada disini di decoration
                      decoration: BoxDecoration(
                        // Transisi warna background role
                        color:
                            isSelected
                                ? const Color(0xFF2E3E69) // dipilih
                                : const Color(0xFFEFEFEF), // tidak dipilih
                        borderRadius: BorderRadius.circular(16.0),
                        // Transisi warna shadow
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: const Color(0xFF2E3E69),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      // --- Child Column ---
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(finalImagePath, height: 100, width: 100),
                          const SizedBox(height: 12),
                          // ---  AnimatedDefaultTextStyle untuk transisi warna teks ---
                          AnimatedDefaultTextStyle(
                            duration: _animationDuration,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                            child: Text(role),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 32),
          // LANJUT Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F47AD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                disabledBackgroundColor: const Color(0xFFEFEFEF),
                elevation: 3,
              ),
              onPressed:
                  _tempSelectedRole == null
                      ? null
                      : () {
                        widget.onRoleSelected(_tempSelectedRole!);
                      },
              child: Text(
                "LANJUT",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color:
                      _tempSelectedRole == null ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
