// lib/widgets/secondary_auth_link.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryAuthLink extends StatelessWidget {
  final String leadingText;
  final String linkText;
  final bool isLoading;
  final VoidCallback? onPressed;

  const SecondaryAuthLink({
    super.key,
    required this.leadingText,
    required this.linkText,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText, style: GoogleFonts.poppins(color: Colors.black)),
        TextButton(
          onPressed: isLoading ? null : onPressed, // disable jika loading
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: isLoading ? Colors.grey : Colors.black,
          ),
          child: Text(
            linkText,
            style: GoogleFonts.poppins(
              color: isLoading ? Colors.grey : Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
