import 'package:digita_mobile/widgets/card/finished_schedule_card.dart';
import 'package:digita_mobile/widgets/card/upcoming_schedule_card.dart';
import 'package:digita_mobile/widgets/subtitle.dart';
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
      'note': 'Selesai membahas judul penelitian dan menetapkan judul penelitian.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Container(
          padding: EdgeInsets.all(6.0),
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
                  child: Subtitle(subtitle: 'Jadwal Mendatang'),
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
                  }
                ),
                // Jadwal Selesai Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Subtitle(subtitle: 'Selesai'),
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
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
