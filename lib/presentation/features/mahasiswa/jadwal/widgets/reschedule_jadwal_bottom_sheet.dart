import 'package:digita_mobile/models/jadwal_bimbingan_model.dart';
import 'package:digita_mobile/models/ruangan_model.dart';
import 'package:digita_mobile/presentation/common_widgets/bottom_sheets/base_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/viewmodels/jadwal_mahasiswa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RescheduleJadwalBottomSheet extends StatefulWidget {
  final JadwalBimbingan schedule;

  const RescheduleJadwalBottomSheet({super.key, required this.schedule});

  @override
  State<RescheduleJadwalBottomSheet> createState() => _RescheduleJadwalBottomSheetState();
}

class _RescheduleJadwalBottomSheetState extends State<RescheduleJadwalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedLocationId;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data dari jadwal yang ada
    final schedule = widget.schedule;
    _titleController.text = schedule.judulBimbingan;

    _selectedDate = schedule.tanggal;
    _dateController.text = DateFormat('d MMMM yyyy', 'id_ID').format(schedule.tanggal);

    final timeParts = schedule.waktu.split(':');
    _selectedTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

    // --- PERBAIKAN DI SINI ---
    // Format waktu secara manual untuk menghindari penggunaan context di initState.
    if (_selectedTime != null) {
      final hour = _selectedTime!.hour.toString().padLeft(2, '0');
      final minute = _selectedTime!.minute.toString().padLeft(2, '0');
      _timeController.text = '$hour:$minute';
    }
    // --- AKHIR PERBAIKAN ---

    _selectedLocationId = schedule.lokasiRuangan.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JadwalViewModel>(context, listen: false).fetchRuangan();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context); // Di sini aman karena bukan di initState
      });
    }
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<JadwalViewModel>(context, listen: false);

      final success = await viewModel.rescheduleJadwalBimbingan(
        scheduleId: widget.schedule.id,
        judul: _titleController.text,
        tanggal: _selectedDate!,
        waktu: _selectedTime!,
        lokasiRuanganId: _selectedLocationId!,
      );

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(key: Key('snackbarReschedule'), content: Text('Jadwal berhasil di-reschedule, menunggu persetujuan dosen.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.errorMessage ?? 'Terjadi kesalahan saat reschedule'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Style
    final textStyle = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
    final hintStyle = GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]);
    const consistentFillColor = Color(0xFFD9EEFF);
    final baseDecoration = InputDecoration(
        hintStyle: hintStyle,
        filled: true,
        fillColor: consistentFillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5)));

    return BaseBottomSheet(
      title: 'Reschedule Jadwal Bimbingan',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Judul Bimbingan"),
            TextFormField(
              key: const Key('fieldTitleReschedule'),
              controller: _titleController,
              decoration: baseDecoration.copyWith(hintText: 'Masukkan judul bimbingan'),
              style: textStyle,
              validator: (value) => (value == null || value.isEmpty) ? 'Judul tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Tanggal"),
            TextFormField(
              key: const Key('fieldDateReschedule'),
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              style: textStyle,
              decoration: baseDecoration.copyWith(hintText: 'Pilih Tanggal', suffixIcon: const Icon(Icons.calendar_today, size: 20)),
              validator: (value) => (value == null || value.isEmpty) ? 'Tanggal tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Waktu"),
            TextFormField(
              key: const Key('fieldTimeReschedule'),
              controller: _timeController,
              readOnly: true,
              onTap: () => _selectTime(context),
              style: textStyle,
              decoration: baseDecoration.copyWith(hintText: 'Pilih Waktu', suffixIcon: const Icon(Icons.access_time, size: 20)),
              validator: (value) => (value == null || value.isEmpty) ? 'Waktu tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Lokasi"),
            Consumer<JadwalViewModel>(
              builder: (context, viewModel, child) {
                return DropdownButtonFormField<int>(
                  key: const Key('fieldLocationReschedule'),
                  value: _selectedLocationId,
                  hint: Text('Pilih Lokasi', style: hintStyle),
                  style: textStyle,
                  items: viewModel.ruanganList.map<DropdownMenuItem<int>>((Ruangan value) {
                    return DropdownMenuItem<int>(
                      value: value.id,
                      child: Text(value.namaRuangan),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedLocationId = newValue;
                    });
                  },
                  decoration: baseDecoration,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  validator: (value) => (value == null) ? 'Lokasi harus dipilih' : null,
                );
              },
            ),
            const SizedBox(height: 24),
            Consumer<JadwalViewModel>(
              builder: (context, viewModel, child) {
                return viewModel.isRescheduling
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryActionButton(key: const Key('btnSubmitRechedule'), label: 'RESCHEDULE JADWAL', onPressed: _submitData);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }
}