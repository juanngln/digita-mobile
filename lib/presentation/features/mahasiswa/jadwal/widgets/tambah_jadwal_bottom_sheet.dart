import 'package:digita_mobile/presentation/common_widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BimbinganItem {
  final String title;
  final String date;
  final String student;
  final String location;
  String catatan;
  String status;

  BimbinganItem({
    required this.title,
    required this.date,
    required this.student,
    required this.location,
    this.catatan = '',
    this.status = 'Scheduled', // Default status for new items
  });
}

class TambahJadwalBottomSheet extends StatefulWidget {
  final Function(BimbinganItem) onTambah;

  const TambahJadwalBottomSheet({super.key, required this.onTambah});

  @override
  State<TambahJadwalBottomSheet> createState() => _TambahJadwalBottomSheet();
}

class _TambahJadwalBottomSheet extends State<TambahJadwalBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _studentController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  String? _selectedLocation;

  final List<String> _locationOptions = ['Gedung A', 'Gedung B', 'Online'];

  @override
  void initState() {
    super.initState();
    // Initialize with empty controllers for a blank form
    _titleController = TextEditingController();
    _studentController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _selectedLocation = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _studentController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Users can't select past dates
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Using a simpler format for display, you can adjust as needed
      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  void _submitData() {
    // Combine date and time for the BimbinganItem
    final String combinedDateTime =
        '${_dateController.text}, ${_timeController.text}';

    final newItem = BimbinganItem(
      title: _titleController.text,
      student: _studentController.text,
      date: combinedDateTime,
      location: _selectedLocation ?? 'Not specified',
    );

    // Pass the newly created item back to the parent widget
    widget.onTambah(newItem);
  }

  @override
  Widget build(BuildContext context) {
    // Styling definitions remain the same
    final textStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    final hintStyle = GoogleFonts.poppins(
      fontSize: 16,
      color: Colors.grey[500],
    );
    const consistentFillColor = Color(0xFFD9EEFF);
    final baseDecoration = InputDecoration(
      hintStyle: hintStyle,
      filled: true,
      fillColor: consistentFillColor,
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
    );

    return BaseBottomSheet(
      title: 'Tambah Jadwal Bimbingan',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Judul Bimbingan",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _titleController,
            hintText: 'Masukkan judul bimbingan',
            fillColor: consistentFillColor,
          ),
          const SizedBox(height: 16),
          Text(
            "Dosen Pembimbing",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _studentController,
            hintText: 'Dr John Doe',
            fillColor: consistentFillColor,
            enabled: false,
          ),
          const SizedBox(height: 16),
          Text(
            "Tanggal",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            style: textStyle,
            decoration: baseDecoration.copyWith(
              hintText: 'Pilih Tanggal',
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Waktu",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _timeController,
            readOnly: true,
            onTap: () => _selectTime(context),
            style: textStyle,
            decoration: baseDecoration.copyWith(
              hintText: 'Pilih Waktu',
              suffixIcon: const Icon(Icons.access_time, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Lokasi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            hint: Text('Pilih Lokasi', style: hintStyle),
            style: textStyle,
            items:
                _locationOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLocation = newValue;
              });
            },
            decoration: baseDecoration,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(label: 'TAMBAH JADWAL', onPressed: _submitData),
        ],
      ),
    );
  }
}
