import 'package:digita_mobile/widgets/bottom_navbar/bottom_navbar_mahasiswa.dart';
import 'package:digita_mobile/widgets/information_card.dart';
import 'package:digita_mobile/widgets/profile_section.dart';
import 'package:digita_mobile/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMahasiswaScreen extends StatefulWidget {
  const HomeMahasiswaScreen({super.key});

  @override
  State<HomeMahasiswaScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeMahasiswaScreen> {
  int _page = 0;

  final List<Map<String, String>> informationCards = [
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
                    name: 'Udin Prakoso Bakti',
                    status: 'Mahasiswa Teknik Informatika',
                  ),
                ),
                // Quote Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 48,
                        height: 96,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                            Text(
                              'Masa depan adalah milik mereka yang percaya akan impiannya.',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '- Tan Malaka',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress Section
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Progress TA',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '20%',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: 20,
                        minHeight: 10,
                        backgroundColor: Color(0xFF9DCFF7),
                        color: Color(0x000F47AD),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ],
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
                          itemCount: informationCards.length,
                          itemBuilder: (context, index) {
                            return InformationCard(
                              title: informationCards[index]['title']!,
                              description:
                                  informationCards[index]['description']!,
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
      bottomNavigationBar: BottomNavbarMahasiswa(
        currentIndex: _page,
        onTap: (index) {
            setState(() {
              _page = index;
            });
          },
      ),
    );
  }
}
