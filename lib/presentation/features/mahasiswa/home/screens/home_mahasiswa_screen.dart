import 'package:digita_mobile/presentation/features/mahasiswa/home/screens/notification_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/pengumuman_card.dart';
import 'package:digita_mobile/presentation/common_widgets/home_widgets/profile_section.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:digita_mobile/models/quote.dart';
import 'package:digita_mobile/services/quote_service.dart';

class HomeMahasiswaScreen extends StatefulWidget {
  const HomeMahasiswaScreen({super.key});

  @override
  State<HomeMahasiswaScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeMahasiswaScreen> {
  late Future<Quote> _quoteFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _quoteFuture = _apiService.fetchRandomQuote();
  }

  // Data pengumuman diperbarui dengan field tanggal dan lampiran
  final List<Map<String, String?>> pengumumanCards = [
    {
      'title': 'Buku Panduan Tugas Akhir',
      'description': 'Buku panduan lengkap mengenai standar dan format penulisan Tugas Akhir untuk mahasiswa Jurusan Teknik Informatika angkatan 2021. Buku panduan lengkap mengenai standar dan format penulisan Tugas Akhir untuk mahasiswa Jurusan Teknik Informatika angkatan 2021. Buku panduan lengkap mengenai standar dan format penulisan Tugas Akhir untuk mahasiswa Jurusan Teknik Informatika angkatan 2021.',
      'tgl_mulai': '01 Agu 2024',
      'tgl_selesai': '31 Des 2024',
      'attachment': 'panduan_ta_2024.pdf',
    },
    {
      'title': 'Jadwal Seminar Proposal',
      'description': 'Jadwal lengkap pelaksanaan seminar proposal Tugas Akhir untuk semester ganjil tahun ajaran 2024/2025.',
      'tgl_mulai': '15 Sep 2024',
      'tgl_selesai': '20 Sep 2024',
      'attachment': null, // Contoh tanpa lampiran
    },
    {
      'title': 'Template Laporan TA',
      'description': 'Template resmi dalam format .docx untuk penyusunan laporan Tugas Akhir. Wajib diikuti oleh semua mahasiswa.',
      'tgl_mulai': '01 Agu 2024',
      'tgl_selesai': '31 Des 2024',
      'attachment': 'template_laporan_ta.docx',
    },
    {
      'title': 'Daftar Dosen Pembimbing',
      'description': 'Daftar nama dosen beserta kuota bimbingan yang tersedia untuk Tugas Akhir semester ini.',
      'tgl_mulai': '25 Jul 2024',
      'tgl_selesai': '05 Agu 2024',
      'attachment': 'daftar_dosen_pembimbing.xlsx',
    },
  ];

  final List<Map<String, String>> upcomingCards = [
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
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<ProfileViewModel>(
              builder: (context, viewModel, child) {
                Widget profileWidget;
                if (viewModel.state == ProfileState.loading) {
                  profileWidget = const Center(child: CircularProgressIndicator());
                } else if (viewModel.state == ProfileState.success) {
                  profileWidget = ProfileSection(
                    name: viewModel.mahasiswaProfile?.namaLengkap ?? 'Nama tidak ditemukan',
                    status: viewModel.mahasiswaProfile?.programStudi.namaProdi ?? 'Status tidak ditemukan',
                    page: const NotificationMahasiswaScreen(),
                  );
                } else {
                  profileWidget = Text('Error: ${viewModel.errorMessage}');
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: profileWidget,
                    ),

                    // Quote Section... (tidak diubah)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: FutureBuilder<Quote>(
                        future: _quoteFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 48,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                  Text(
                                    '"${snapshot.data!.q}"',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '- ${snapshot.data!.a}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Text('No quote found.');
                          }
                        },
                      ),
                    ),

                    // Progress Section... (tidak diubah)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
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
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: 0.2,
                            minHeight: 10,
                            backgroundColor: const Color(0xFF9DCFF7),
                            color: const Color(0xFF0F47AD),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ],
                      ),
                    ),

                    // Information Section (Diperbarui)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengumuman',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              separatorBuilder:
                                  (context, index) => const SizedBox(width: 16),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: pengumumanCards.length,
                              itemBuilder: (context, index) {
                                final item = pengumumanCards[index];
                                // Memberikan data lengkap ke PengumumanCard
                                return PengumumanCard(
                                  title: item['title']!,
                                  description: item['description']!,
                                  tglMulai: item['tgl_mulai']!,
                                  tglSelesai: item['tgl_selesai']!,
                                  attachment: item['attachment'],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Upcoming Section... (tidak diubah)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
