// lib/widgets/password_input_field.dart
import 'package:digita_mobile/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.enabled = true,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      enabled: widget.enabled,
      obscureText: _obscureText,
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey[500],
        ),
        onPressed: widget.enabled ? _toggleVisibility : null,
      ),
    );
  }
}
