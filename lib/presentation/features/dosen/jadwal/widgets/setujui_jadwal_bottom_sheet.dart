import 'package:digita_mobile/presentation/common_widgets/base_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_display_field.dart';
import 'package:digita_mobile/presentation/common_widgets/primary_action_button.dart';
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
    required this.catatan,
    required this.status,
  });
}

class PengajuanJadwalBimbingan extends StatelessWidget {
  final BimbinganItem bimbingan;
  final VoidCallback onSetuju;

  const PengajuanJadwalBimbingan({
    super.key,
    required this.bimbingan,
    required this.onSetuju,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'Detail Pengajuan Jadwal',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomDisplayField(
            label: 'Judul Bimbingan',
            value: bimbingan.title,
          ),
          const SizedBox(height: 16),

          CustomDisplayField(
            label: 'Nama Mahasiswa',
            value: bimbingan.student,
          ),
          const SizedBox(height: 16),

          CustomDisplayField(
            label: 'Tanggal',
            value: _extractDate(bimbingan.date),
            icon: const Icon(Icons.calendar_today, size: 16),
          ),
          const SizedBox(height: 16),

          CustomDisplayField(
            label: 'Waktu',
            value: _extractTime(bimbingan.date),
          ),
          const SizedBox(height: 16),

          CustomDisplayField(
            label: 'Lokasi',
            value: bimbingan.location,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          ),
          const SizedBox(height: 24),

          // Setuju Button
          PrimaryActionButton(
            text: 'SETUJU',
            onPressed: onSetuju,
            // isLoading property can be added here if you introduce state management
          ),
        ],
      ),
    );
  }

  String _extractDate(String dateTime) {
    if (dateTime.contains(',')) {
      return dateTime.split(',')[0].trim();
    }
    return dateTime;
  }

  String _extractTime(String dateTime) {
    if (dateTime.contains(',')) {
      return dateTime.split(',')[1].trim();
    }
    return "00:00";
  }
}