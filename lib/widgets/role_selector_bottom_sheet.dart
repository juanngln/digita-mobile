import 'package:flutter/material.dart';

/* 3312301051 - Muhammad Padanta Tarigan 25-04-2025:
  --- Penambahan Widget Role Selection ---
  */

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

  @override
  void initState() {
    super.initState();
    _tempSelectedRole = widget.initialSelectedRole;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        left: 24.0,
        right: 24.0,
        top: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Dashboard menyesuaikan peranmu,',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const Text(
            'Pilih Peranmu!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                widget.roles.map((role) {
                  bool isSelected = _tempSelectedRole == role;
                  String imagePath;
                  if (role == 'Mahasiswa') {
                    imagePath = 'assets/img/role_mahasiswa.png';
                  } else {
                    imagePath = 'assets/img/role_dosen.png';
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _tempSelectedRole = role;
                      });
                    },
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF2E3E69)
                                : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(imagePath, height: 100, width: 100),
                          const SizedBox(height: 12),
                          Text(
                            role,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
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
                disabledBackgroundColor: Colors.grey[400],
                elevation: 3,
              ),
              onPressed:
                  _tempSelectedRole == null
                      ? null
                      : () {
                        widget.onRoleSelected(_tempSelectedRole!);
                        Navigator.pop(context);
                      },
              child: Text(
                "LANJUT",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color:
                      _tempSelectedRole == null ? Colors.white70 : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
