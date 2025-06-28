import 'dart:io';

import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:digita_mobile/viewmodels/dokumen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class UploadDocumentBottomSheet extends StatefulWidget {
  final String bab;
  const UploadDocumentBottomSheet({super.key, required this.bab});

  @override
  State<UploadDocumentBottomSheet> createState() =>
      _UploadDocumentBottomSheetState();
}

class _UploadDocumentBottomSheetState extends State<UploadDocumentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaDokumenController = TextEditingController();
  final TextEditingController _babController = TextEditingController();

  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    // Auto-fill the BAB controller with the value from the card
    _babController.text = widget.bab;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  void dispose() {
    _namaDokumenController.dispose();
    _babController.dispose();
    super.dispose();
  }

  void _handleUpload() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if a file has been selected
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih file terlebih dahulu.')),
      );
      return;
    }

    final viewModel = Provider.of<DokumenViewModel>(context, listen: false);
    final success = await viewModel.uploadDokumen(
      namaDokumen: _namaDokumenController.text,
      bab: widget.bab, // Use the original widget.bab for the API call
      file: File(_selectedFile!.path!),
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen berhasil diunggah!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage ?? 'Gagal mengunggah dokumen.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DokumenViewModel>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          height: 450,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Upload File Dokumen',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    child: Text(
                                      _selectedFile?.name ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: double.infinity,
                                  child: TextButton(
                                    onPressed: _pickFile,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    child: Text(
                                      'Pilih File',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Dokumen',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: _namaDokumenController,
                            hintText: 'Masukkan judul dokumen',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Judul dokumen tidak boleh kosong';
                              }
                              return null;
                            },
                            fillColor: Theme.of(context).colorScheme.secondary, readOnly: false,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BAB',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            readOnly: true, 
                            controller: _babController,
                            hintText: '',
                            fillColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: viewModel.isUploading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryActionButton(
                    label: 'UPLOAD',
                    onPressed: _handleUpload,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
