import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<bool?> showLogoutDialog(BuildContext context) {
  return showModalBottomSheet<bool>(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => const LogoutDialog(),
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 201,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Logout",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Apakah kamu yakin ingin keluar akun?",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.black,
                    fixedSize: const Size(110, 40),
                    shape: const StadiumBorder(),
                    elevation: 0,
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  child: const Text("Batal"),
                ),
                const SizedBox(width: 70),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(110, 40),
                    shape: const StadiumBorder(),
                    elevation: 0,
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  child: const Text("Keluar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
