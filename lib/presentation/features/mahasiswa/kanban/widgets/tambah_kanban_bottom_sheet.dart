import 'package:digita_mobile/helper/db_helper.dart';
import 'package:digita_mobile/models/kanban_model.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/kanban/widgets/section_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahKanbanBottomSheet extends StatefulWidget {
  const TambahKanbanBottomSheet({super.key});

  @override
  State<TambahKanbanBottomSheet> createState() =>
      _TambahKanbanBottomSheetState();
}

class _TambahKanbanBottomSheetState extends State<TambahKanbanBottomSheet> {
  final DBHelper dbHelper = DBHelper.instance;
  String selectedSection = 'To Do';
  final TextEditingController _babController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _dueController = TextEditingController();

  void addKanban() async {
    String section = selectedSection;
    String bab = _babController.text.trim();
    String keterangan = _keteranganController.text.trim();
    String due = _dueController.text.trim();
    Kanban kanban = Kanban(section: section, bab: bab, keterangan: keterangan, due: due);

    await dbHelper.insertKanban(kanban);

    _babController.clear();
    _keteranganController.clear();
    _dueController.clear();
  }

  @override
  void dispose() {
    _babController.dispose();
    _keteranganController.dispose();
    _dueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          height: 600,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Tambah Papan Kanban',
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
                          'Section',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SectionDropdown(
                          selectedSection: selectedSection,
                          onChanged: (value) {
                            setState(() {
                              selectedSection = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bab',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: _babController,
                          hintText: 'Masukkan bab dokumen',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Bab dokumen tidak boleh kosong';
                            }
                            return null;
                          },
                          fillColor: Theme.of(context).colorScheme.secondary,
                          readOnly: false,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keterangan',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: _keteranganController,
                          hintText: 'Masukkan keterangan',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Keterangan tidak boleh kosong';
                            }
                            return null;
                          },
                          fillColor: Theme.of(context).colorScheme.secondary,
                          readOnly: false,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        CustomTextField(
                          controller: _dueController,
                          hintText: 'Masukkan tenggat waktu',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Tenggat waktu tidak boleh kosong';
                            }
                            return null;
                          },
                          fillColor: Theme.of(context).colorScheme.secondary,
                          readOnly: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: PrimaryActionButton(
                  label: 'SIMPAN',
                  onPressed: () async {
                    addKanban();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
