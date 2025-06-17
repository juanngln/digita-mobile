import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:digita_mobile/presentation/common_widgets/base_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/primary_action_button.dart';

class EditDocumentBottomSheet extends StatefulWidget {
  const EditDocumentBottomSheet({super.key});

  @override
  State<EditDocumentBottomSheet> createState() => _EditDocumentBottomSheet();
}

class _EditDocumentBottomSheet extends State<EditDocumentBottomSheet> {
  final TextEditingController _namaDokumenController = TextEditingController();
  final TextEditingController _pemilikController = TextEditingController();

  PlatformFile? _selectedFile;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _namaDokumenController.text = 'BAB II: Landasan Teori.pdf';
    _pemilikController.text = 'Udin Prakoso Bakti';
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isUpdating = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (_selectedFile != null) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to update.')),
      );
    }
    setState(() => _isUpdating = false);
  }

  @override
  void dispose() {
    _namaDokumenController.dispose();
    _pemilikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Replace the old layout with the BaseBottomSheet
    return BaseBottomSheet(
      title: 'Edit File Dokumen',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('File'),
          const SizedBox(height: 8.0),
          _buildFilePicker(),
          const SizedBox(height: 20.0),
          _buildSectionTitle('Nama Dokumen'),
          const SizedBox(height: 8.0),
          _buildInfoField(_namaDokumenController.text),
          const SizedBox(height: 20.0),
          _buildSectionTitle('Pemilik'),
          const SizedBox(height: 8.0),
          _buildInfoField(_pemilikController.text),
          const SizedBox(height: 32.0),
          PrimaryActionButton(
            text: 'UPDATE',
            isLoading: _isUpdating,
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }

  // Helper widgets remain the same
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFilePicker() {
    const primaryColor = Color(0xFF0F47AD);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedFile?.name ?? '',
                style: GoogleFonts.poppins(color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            minimumSize: const Size(100, 48),
          ),
          child: Text(
            'Pilih File',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 15.0,
          color: Colors.black87,
        ),
      ),
    );
  }
}