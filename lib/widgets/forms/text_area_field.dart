import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;
  final Color? fillColor;

  const TextAreaField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.keyboardType = TextInputType.multiline,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
    this.fillColor,
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
