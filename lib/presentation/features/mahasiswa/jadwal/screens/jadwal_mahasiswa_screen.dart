import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/jadwal_mendatang_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/jadwal_selesai_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/tambah_jadwal_bottom_sheet.dart';
import 'package:flutter/material.dart';

class JadwalMahasiswaScreen extends StatefulWidget {
  const JadwalMahasiswaScreen({super.key});

  @override
  State<JadwalMahasiswaScreen> createState() => _JadwalMahasiswaScreenState();
}

class _JadwalMahasiswaScreenState extends State<JadwalMahasiswaScreen> {
  final List<Map<String, String>> upcomingSchedule = [
    {
      'title': 'Diskusi Pendahuluan',
      'dateTime': '07 Maret 2025, 14:00',
      'supervisor': 'Dr. Santoso Budi',
      'location': 'Zoom Online',
      'note': '-',
    },
    {
      'title': 'Diskusi Landasan Teori',
      'dateTime': '10 Maret 2025, 10:00',
      'supervisor': 'Dr. Santoso Budi',
      'location': 'Zoom Online',
      'note': 'Saya bisa jam 16:00 - 20:00',
    },
  ];

  final List<Map<String, String>> finishedSchedule = [
    {
      'title': 'Diskusi Judul Penelitian',
      'dateTime': '04 Maret 2025, 14:00',
      'supervisor': 'Dr. Santoso Budi',
      'location': 'GU 702',
      'note':
          'Selesai membahas judul penelitian dan menetapkan judul penelitian.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTambahJadwalForm(context);
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Bimbingan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // Jadwal Mendatang Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Jadwal Mendatang',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: upcomingSchedule.length,
                  itemBuilder: (context, index) {
                    return UpcomingScheduleCard(
                      title: upcomingSchedule[index]['title']!,
                      dateTime: upcomingSchedule[index]['dateTime']!,
                      supervisor: upcomingSchedule[index]['supervisor']!,
                      location: upcomingSchedule[index]['location']!,
                      note: upcomingSchedule[index]['note']!,
                    );
                  },
                ),
                // Jadwal Selesai Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Selesai',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: finishedSchedule.length,
                  itemBuilder: (context, index) {
                    return FinishedScheduleCard(
                      title: finishedSchedule[index]['title']!,
                      dateTime: finishedSchedule[index]['dateTime']!,
                      supervisor: finishedSchedule[index]['supervisor']!,
                      location: finishedSchedule[index]['location']!,
                      note: finishedSchedule[index]['note']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Function to show the bottom sheet for adding a new schedule
  void _showTambahJadwalForm(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext builderContext) {
        return TambahJadwalBimbingan(
          onTambah: (BimbinganItem newItem) {
            final newSchedule = {
              'title': newItem.title,
              'dateTime': newItem.date,
              'supervisor': newItem.student,
              'location': newItem.location,
              'note': newItem.catatan,
            };

            setState(() {
              upcomingSchedule.add(newSchedule);
            });

            Navigator.pop(builderContext);
          },
        );
      },
    );
  }
}
