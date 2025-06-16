import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPengajuanDospemBottomSheet extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Widget? actionButton; // Optional button

  const StatusPengajuanDospemBottomSheet({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, height: 300),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F47AD),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, child: actionButton),
          ],
        ],
      ),
    );
  }
}