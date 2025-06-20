import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/tambah_jadwal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ScheduleStatus { kosong, disetujui, ditolak }

class UpcomingScheduleCard extends StatefulWidget {
  final String title;
  final String dateTime;
  final String supervisor;
  final String location;
  final String note;
  final ScheduleStatus status;

  const UpcomingScheduleCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.supervisor,
    required this.location,
    required this.note,
    required this.status,
  });

  @override
  State<UpcomingScheduleCard> createState() => _UpcomingScheduleCard();
}

class _UpcomingScheduleCard extends State<UpcomingScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 225,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4),
            color: Colors.black.withAlpha(50),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                        ),
                      ),
                      _buildStatusBadge(widget.status),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time_filled, color: Colors.black),
                      SizedBox(width: 12),
                      Text(
                        widget.dateTime,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.black),
                      SizedBox(width: 12),
                      Text(
                        widget.supervisor,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 12),
                      Text(
                        widget.location,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.edit_document, color: Colors.black),
                      SizedBox(width: 12),
                      Text(
                        'Catatan: ${widget.note}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildActionButton(context, widget.status),
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
    case ScheduleStatus.kosong:
      color = Colors.transparent;
      label = '';
      break;
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

Widget _buildActionButton(BuildContext context, ScheduleStatus status) {
  final divider = Divider(
    thickness: 5,
    color: Theme.of(context).colorScheme.primary,
  );

  final rescheduleButton = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: TextButton(
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
            return TambahJadwalBottomSheet(
              onTambah: (BimbinganItem newItem) {
                // final newSchedule = {
                //   'title': newItem.title,
                //   'dateTime': newItem.date,
                //   'supervisor': newItem.student,
                //   'location': newItem.location,
                //   'note': newItem.catatan,
                // };

                // setState(() {
                //   upcomingSchedule.add(newSchedule);
                // });

                Navigator.pop(builderContext);
              },
            );
          },
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.orange.withAlpha(75),
        minimumSize: Size(0, 0),
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
    case ScheduleStatus.kosong:
      return SizedBox.shrink();
    case ScheduleStatus.disetujui:
      return SizedBox.shrink();
    case ScheduleStatus.ditolak:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [divider, rescheduleButton],
      );
  }
}
