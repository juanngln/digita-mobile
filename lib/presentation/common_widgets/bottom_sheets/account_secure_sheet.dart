import 'package:flutter/material.dart';

void showAccountSecureSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AccountSecureSheet(),
  );
}

class AccountSecureSheet extends StatefulWidget {
  const AccountSecureSheet({super.key});

  @override
  State<AccountSecureSheet> createState() => _AccountSecureSheetState();
}

class _AccountSecureSheetState extends State<AccountSecureSheet> {
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 153,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Keamanan Akun",
                  //==================================================
                  //== PERUBAHAN UKURAN FONT JUDUL DI SINI
                  //==================================================
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Secara eksplisit mengatur ukuran font menjadi 20
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildReadOnlyTextField(textTheme: textTheme, label: "Email", value: "udinprakoso12@gmail.com"),
              const SizedBox(height: 16),
              _buildPasswordField(
                textTheme: textTheme,
                label: "Kata Sandi",
                isVisible: _isPasswordVisible,
                onVisibilityChanged: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                textTheme: textTheme,
                label: "Ubah Kata Sandi",
                isVisible: _isNewPasswordVisible,
                onVisibilityChanged: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                textTheme: textTheme,
                label: "Konfirmasi Kata Sandi",
                isVisible: _isConfirmPasswordVisible,
                onVisibilityChanged: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  child: const Text("SIMPAN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyTextField({required TextTheme textTheme, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          width: 350,
          height: 50,
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextTheme textTheme,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          width: 350,
          height: 50,
          child: TextField(
            obscureText: !isVisible,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              hintText: "••••••••••",
              hintStyle: textTheme.bodyMedium,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey.shade600),
                onPressed: onVisibilityChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
