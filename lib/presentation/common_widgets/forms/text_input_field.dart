import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final Color? fillColor;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.obscureText = false,
    this.suffixIcon,
    this.fillColor,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
      filled: true,
      fillColor: fillColor ?? (enabled ? Colors.white : Colors.grey[200]),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      obscureText: obscureText,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: enabled ? Colors.black : Colors.grey[700],
      ),
      decoration: inputDecoration,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
