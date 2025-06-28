// lib/presentation/features/mahasiswa/dokumen/widgets/edit_document_bottom_sheet.dart

import 'dart:io';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:digita_mobile/viewmodels/dokumen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class EditDocumentBottomSheet extends StatefulWidget {
  final DocumentDetails details;
  const EditDocumentBottomSheet({super.key, required this.details});

  @override
  State<EditDocumentBottomSheet> createState() => _EditDocumentBottomSheet();
}

class _EditDocumentBottomSheet extends State<EditDocumentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaDokumenController;
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    _namaDokumenController =
        TextEditingController(text: widget.details.namaDokumen);
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
    super.dispose();
  }

  void _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = Provider.of<DokumenViewModel>(context, listen: false);
    final success = await viewModel.editDokumen(
      id: widget.details.id,
      namaDokumen: _namaDokumenController.text,
      file: _selectedFile != null ? File(_selectedFile!.path!) : null,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen berhasil diperbarui!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  viewModel.errorMessage ?? 'Gagal memperbarui dokumen.')),
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
          height: 380, // Adjusted height
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
                    'Edit File Dokumen',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File (Opsional)',
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
                                      _selectedFile?.name ?? 'Pilih file baru...',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedFile == null ? Colors.grey : Colors.black,
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
                            fillColor:
                            Theme.of(context).colorScheme.secondary,
                            readOnly: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: viewModel.isUpdating
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryActionButton(
                      label: 'UPDATE', onPressed: _handleUpdate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}