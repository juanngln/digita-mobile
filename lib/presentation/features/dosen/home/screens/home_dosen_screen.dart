import 'package:digita_mobile/presentation/features/dosen/home/screens/notification_dosen_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/pengumuman_card.dart';
import 'package:digita_mobile/presentation/common_widgets/home_widgets/profile_section.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDosenScreen extends StatefulWidget {
  const HomeDosenScreen({super.key});

  @override
  State<HomeDosenScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeDosenScreen> {
  final List<Map<String, String>> pengumumanCards = [
    {
      'title': 'Buku Panduan',
      'description': 'Buku panduan tugas Akhir jurusan teknik informatika',
    },
    {
      'title': 'Jadwal Seminar',
      'description': 'Jadwal seminar tugas akhir semester ini',
    },
    {
      'title': 'Template Laporan',
      'description': 'Template laporan tugas akhir yang harus diikuti',
    },
    {
      'title': 'Daftar Dosen',
      'description': 'Daftar dosen pembimbing tugas akhir',
    },
    {
      'title': 'Prosedur TA',
      'description': 'Prosedur lengkap pendaftaran tugas akhir',
    },
    {
      'title': 'Kontak Admin',
      'description': 'Informasi kontak admin untuk bantuan tugas akhir',
    },
  ];

  final List<Map<String, String>> upcomingCards = [
    {'title': 'Bimbingan dengan dosen', 'description': 'Besok, 14:00 WIB'},
    {
      'title': 'Pengumpulan Daftar isi',
      'description': '12 September, 23:59 WIB',
    },
    {'title': 'Bimbingan dengan dosen', 'description': 'Besok, 14:00 WIB'},
    {'title': 'Bimbingan dengan dosen', 'description': 'Besok, 14:00 WIB'},
    {
      'title': 'Pengumpulan Daftar isi',
      'description': '12 September, 23:59 WIB',
    },
    {'title': 'Bimbingan dengan dosen', 'description': 'Besok, 14:00 WIB'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ProfileSection(
                    name: 'Dr. Budi Santoso',
                    status: 'Dosen Teknik Informatika',
                    page: NotificationDosenScreen(),
                  ),
                ),
                // Counter Section
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 48,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Mahasiswa',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(fontSize: 16),
                              ),
                              Text(
                                '15',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(color: Colors.black, thickness: 1.5),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Pending Review',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(fontSize: 16),
                              ),
                              Text(
                                '15',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Information Section
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lihat Alur Pendaftaran Tugas Akhir',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 128,
                        child: ListView.separated(
                          separatorBuilder:
                              (context, index) => const SizedBox(width: 16),
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pengumumanCards.length,
                          itemBuilder: (context, index) {
                            return PengumumanCard(
                              title: pengumumanCards[index]['title']!,
                              description:
                              pengumumanCards[index]['description']!,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Upcoming Section
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: upcomingCards.length,
                        itemBuilder: (context, index) {
                          return UpcomingCard(
                            title: upcomingCards[index]['title']!,
                            description: upcomingCards[index]['description']!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
