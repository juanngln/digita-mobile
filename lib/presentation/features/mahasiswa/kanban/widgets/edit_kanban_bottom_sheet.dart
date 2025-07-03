import 'package:digita_mobile/helper/db_helper.dart';
import 'package:digita_mobile/models/kanban_model.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/kanban/widgets/section_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditKanbanBottomSheet extends StatefulWidget {
  final Kanban kanban;

  const EditKanbanBottomSheet({super.key, required this.kanban});

  @override
  State<EditKanbanBottomSheet> createState() => _EditKanbanBottomSheetState();
}

class _EditKanbanBottomSheetState extends State<EditKanbanBottomSheet> {
  final DBHelper dbHelper = DBHelper();
  late String selectedSection;
  late TextEditingController _babController;
  late TextEditingController _keteranganController;
  late TextEditingController _dueController;

  @override
  void initState() {
    super.initState();
    selectedSection = widget.kanban.section;
    _babController = TextEditingController(text: widget.kanban.bab);
    _keteranganController =
        TextEditingController(text: widget.kanban.keterangan);
    _dueController = TextEditingController(text: widget.kanban.due);
  }

  void updateKanban() async {
    final updatedKanban = Kanban(
      id: widget.kanban.id,
      section: selectedSection,
      bab: _babController.text.trim(),
      keterangan: _keteranganController.text.trim(),
      due: _dueController.text.trim(),
    );

    await dbHelper.updateKanban(updatedKanban);
  }

  void deleteKanban() async {
    await dbHelper.deleteKanban(widget.kanban.id!);
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
                  'Edit Papan Kanban',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          deleteKanban();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'HAPUS',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: PrimaryActionButton(
                        label: 'SIMPAN',
                        onPressed: () {
                          updateKanban();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
