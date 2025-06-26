import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionDropdown extends StatefulWidget {
  const SectionDropdown({super.key});

  @override
  State<SectionDropdown> createState() => _SectionDropdownState();
}

class _SectionDropdownState extends State<SectionDropdown> {
  String? _selectedSection = 'To Do';
  final List<String> _sections = ['To Do', 'In Progress', 'Done'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedSection,
      hint: Text(
        'Select Section',
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
      ),
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
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
      ),
      onChanged: (value) {
        setState(() {
          _selectedSection = value;
        });
      },
      items: _sections.map((section) {
        return DropdownMenuItem<String>(
          value: section,
          child: Text(
            section,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      validator: (value) =>
          value == null ? 'Section tidak boleh kosong' : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
