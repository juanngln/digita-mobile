import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showDragHandle;

  const BaseBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Handles keyboard overlap automatically
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20.0,
        left: 24.0,
        right: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          // Unique content is injected here
          Flexible(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
