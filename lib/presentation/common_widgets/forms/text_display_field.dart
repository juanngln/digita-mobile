
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDisplayField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? icon;

  const CustomDisplayField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD9EEFF), // Consistent color
            borderRadius: BorderRadius.circular(8), // Consistent border radius
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                icon!,
              ]
            ],
          ),
        ),
      ],
    );
  }
}