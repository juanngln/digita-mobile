import 'package:digita_mobile/models/jadwal_bimbingan_model.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/reschedule_jadwal_bottom_sheet.dart';
import 'package:digita_mobile/viewmodels/jadwal_mahasiswa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum ScheduleStatus { kosong, disetujui, ditolak, menunggu }

class UpcomingScheduleCard extends StatefulWidget {
  final JadwalBimbingan schedule;
  final ScheduleStatus status;

  const UpcomingScheduleCard({
    super.key,
    required this.schedule,
    required this.status,
  });

  @override
  State<UpcomingScheduleCard> createState() => _UpcomingScheduleCard();
}

class _UpcomingScheduleCard extends State<UpcomingScheduleCard> {
  String formatDateTime(DateTime date, String time) {
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    final formattedTime = time.substring(0, 5);
    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    final scheduleData = widget.schedule;

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
            color: Colors.black.withAlpha(50),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        scheduleData.judulBimbingan,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                      ),
                    ),
                    _buildStatusBadge(widget.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(
                      formatDateTime(scheduleData.tanggal, scheduleData.waktu),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        scheduleData.dosenPembimbing.namaLengkap,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(
                      scheduleData.lokasiRuangan.namaRuangan,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.edit_square, color: Colors.black),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Catatan: ${widget.status == ScheduleStatus.ditolak ? scheduleData.alasanPenolakan ?? '-' : scheduleData.catatanBimbingan ?? '-'}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildActionButton(context, widget.status, scheduleData),
        ],
      ),
    );
  }
}

Widget _buildStatusBadge(ScheduleStatus status) {
  Color color;
  String label;

  switch (status) {
    case ScheduleStatus.disetujui:
      color = Colors.green;
      label = 'Disetujui';
      break;
    case ScheduleStatus.ditolak:
      color = Colors.red;
      label = 'Ditolak';
      break;
    case ScheduleStatus.menunggu:
      color = Colors.blue;
      label = 'Menunggu';
      break;
    case ScheduleStatus.kosong:
      return const SizedBox.shrink();
  }

  return Container(
    width: 80,
    padding: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: color.withAlpha(75),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Center(
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ),
  );
}

Widget _buildActionButton(BuildContext context, ScheduleStatus status, JadwalBimbingan schedule) {
  final rescheduleButton = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: TextButton(
      key: const Key('btnReschedule'),
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          enableDrag: true,
          showDragHandle: true,
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          builder: (BuildContext builderContext) {
            return ChangeNotifierProvider.value(
              value: Provider.of<JadwalViewModel>(context, listen: false),
              child: RescheduleJadwalBottomSheet(schedule: schedule),
            );
          },
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.orange.withAlpha(75),
        minimumSize: const Size(0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        'Reschedule',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    ),
  );

  switch (status) {
    case ScheduleStatus.ditolak:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 5, color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: rescheduleButton,
          )
        ],
      );
    case ScheduleStatus.kosong:
    case ScheduleStatus.menunggu:
    case ScheduleStatus.disetujui:
    return const SizedBox.shrink();
  }
}