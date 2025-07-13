import 'dart:math' as math;

import 'package:digita_mobile/presentation/features/mahasiswa/home/screens/notification_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/pengumuman_card.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/upcoming_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:digita_mobile/models/quote.dart';
import 'package:digita_mobile/services/quote_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../viewmodels/dokumen_mahasiswa_viewmodel.dart';
import '../../../../../viewmodels/pengumuman_viewmodel.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PengumumanViewModel>(
        context,
        listen: false,
      ).fetchAnnouncements();
      Provider.of<DokumenViewModel>(
        context,
        listen: false,
      ).fetchDokumenStatus();
    });
  }

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
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Theme.of(context).colorScheme.primary,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
                  Widget profileWidget;
                  final bool isLoading = viewModel.state == ProfileState.loading;
                  if (viewModel.state == ProfileState.loading) {
                    profileWidget = Skeletonizer(
                      enabled: isLoading,
                      enableSwitchAnimation: true,
                      child: _buildProfileSection(
                        name: '',
                        status: '',
                        page: NotificationMahasiswaScreen(),
                        isLoading: isLoading,
                      ),
                    );
                  } else if (viewModel.state == ProfileState.success) {
                    profileWidget = _buildProfileSection(
                      name:
                          viewModel.mahasiswaProfile?.namaLengkap ??
                          'Nama tidak ditemukan',
                      status:
                          viewModel.mahasiswaProfile?.programStudi.namaProdi ??
                          'Status tidak ditemukan',
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
            
                      // Quote Section
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: FutureBuilder<Quote>(
                          future: _quoteFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Skeletonizer(
                                enableSwitchAnimation: true,
                                child: Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'lorem ipsum',
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
                                          'name',
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
                              );
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
            
                      // Progress Section
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Consumer<DokumenViewModel>(
                          builder: (context, dokumenViewModel, child) {
                            final progress = dokumenViewModel.progressPercentage;
                            final progressText =
                                '${(progress * 100).toStringAsFixed(0)}%';
            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Progress TA',
                                      style:
                                          Theme.of(context).textTheme.titleSmall,
                                    ),
                                    Text(
                                      progressText, // Dynamic Text
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: progress, // Dynamic Value
                                  minHeight: 10,
                                  backgroundColor: const Color(0xFF9DCFF7),
                                  color: const Color(0xFF0F47AD),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
            
                      // Information Section
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
                              child: Consumer<PengumumanViewModel>(
                                builder: (context, viewModel, child) {
                                  switch (viewModel.state) {
                                    case PengumumanState.loading:
                                      return Skeletonizer(
                                        enableSwitchAnimation: true,
                                        child: ListView.separated(
                                          separatorBuilder:
                                              (context, index) =>
                                                  const SizedBox(width: 16),
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 2,
                                          itemBuilder: (context, index) {
                                            return PengumumanCard(
                                              title: 'title pengumuman',
                                              description: 'description',
                                              tglMulai: 'date',
                                              tglSelesai: 'date',
                                              attachment: 'attachment',
                                              lampiranUrl: 'lampiran',
                                            );
                                          },
                                        ),
                                      );
                                    case PengumumanState.error:
                                      return const Center(
                                        child: Text('Gagal memuat pengumuman'),
                                      );
                                    case PengumumanState.loaded:
                                      if (viewModel.announcements.isEmpty) {
                                        return const Center(
                                          child: Text('Tidak ada pengumuman'),
                                        );
                                      }
                                      return ListView.separated(
                                        separatorBuilder:
                                            (context, index) =>
                                                const SizedBox(width: 16),
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: math.min(
                                          viewModel.announcements.length,
                                          10,
                                        ),
                                        itemBuilder: (context, index) {
                                          final item =
                                              viewModel.announcements[index];
                                          return PengumumanCard(
                                            title: item.title,
                                            description: item.description,
                                            tglMulai: DateFormat(
                                              'dd MMM yyyy',
                                            ).format(item.tglMulai),
                                            tglSelesai: DateFormat(
                                              'dd MMM yyyy',
                                            ).format(item.tglSelesai),
                                            attachment: item.attachment,
                                            lampiranUrl: item.lampiranUrl,
                                          );
                                        },
                                      );
                                    default:
                                      return const SizedBox.shrink();
                                  }
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
                                  description:
                                      upcomingCards[index]['description']!,
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
      ),
    );
  }

  Widget _buildProfileSection({
    required String name,
    required String status,
    required Widget page,
    bool isLoading = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              if (isLoading)
                Skeleton.shade(child: CircleAvatar(radius: 28))
              else
                CircleAvatar(
                  radius: 28,
                  child: Image.asset('assets/img/mhs_pria.png'),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      Skeleton.shade(
                        child: Container(
                          width: double.infinity,
                          height: 16,
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      )
                    else
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isLoading)
                      Skeleton.shade(
                        child: Container(
                          width: double.infinity,
                          height: 16,
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      )
                    else
                      Text(
                        status,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Skeleton.shade(
            child: Badge(
              alignment: Alignment.topRight,
              offset: const Offset(-6, 8),
              label: const Text(''),
              largeSize: 16,
              smallSize: 12,
              child: IconButton(
                icon: Icon(CupertinoIcons.bell_fill),
                iconSize: 28,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
