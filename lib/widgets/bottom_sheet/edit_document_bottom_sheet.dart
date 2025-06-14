import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

class EditDocumentBottomSheet extends StatefulWidget {
  const EditDocumentBottomSheet({super.key});

  @override
  State<EditDocumentBottomSheet> createState() => _EditDocumentBottomSheet();
}

class _EditDocumentBottomSheet extends State<EditDocumentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaDokumenController = TextEditingController();
  final TextEditingController _pemilikController = TextEditingController();

  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _submitForm() {
    if (_selectedFile != null) {
      print('File dipilih: ${_selectedFile!.name}');
    } else {
      print('Belum ada file yang dipilih');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit File Dokumen',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'File',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
