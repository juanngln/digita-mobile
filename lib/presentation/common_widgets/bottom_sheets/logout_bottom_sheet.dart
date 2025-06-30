import 'package:flutter/material.dart';

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
              "Apakah kamu yakin ingin Logout?",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3F2FD),
                    foregroundColor: Colors.blue.shade800,
                    fixedSize: const Size(110, 40),
                    shape: const StadiumBorder(),
                    elevation: 0,
                    textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  child: const Text("Batal"),
                ),
                const SizedBox(width: 70),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(110, 40),
                    shape: const StadiumBorder(),
                    elevation: 0,
                    textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  child: const Text("Logout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
