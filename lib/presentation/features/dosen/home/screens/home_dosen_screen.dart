import 'dart:math' as math;

import 'package:digita_mobile/presentation/features/dosen/home/screens/notification_dosen_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/pengumuman_card.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/upcoming_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../viewmodels/pengumuman_viewmodel.dart';

class HomeDosenScreen extends StatefulWidget {
  const HomeDosenScreen({super.key});

  @override
  State<HomeDosenScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeDosenScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PengumumanViewModel>(
        context,
        listen: false,
      ).fetchAnnouncements();
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<ProfileViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    // --- Profile Section ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildProfileSection(context, viewModel),
                    ),

                    // --- Counter Section ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildCounterSection(context, viewModel),
                    ),

                    // --- Information Section  ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengumuman Tugas Akhir',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 150,
                            child: Consumer<PengumumanViewModel>(
                              builder: (context, viewModel, child) {
                                switch (viewModel.state) {
                                  case PengumumanState.loading:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  case PengumumanState.error:
                                    return const Center(
                                      child: Text('Gagal memuat pengumuman.'),
                                    );
                                  case PengumumanState.loaded:
                                    if (viewModel.announcements.isEmpty) {
                                      return const Center(
                                        child: Text('Tidak ada pengumuman.'),
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

                    // --- Upcoming Section ---
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
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    ProfileViewModel viewModel,
  ) {
    switch (viewModel.state) {
      case ProfileState.loading:
        return _profileSection(
          name: 'Memuat...',
          status: '...',
          page: NotificationDosenScreen(),
        );
      case ProfileState.error:
        return Center(child: Text('Gagal: ${viewModel.errorMessage}'));
      case ProfileState.success:
        final updatedProfile = viewModel.loggedInDosenProfile;

        return _profileSection(
          name: updatedProfile?.namaLengkap ?? 'Nama Tidak Ditemukan',
          status: "Dosen ${updatedProfile?.jurusan.namaJurusan ?? ''}",
          page: NotificationDosenScreen(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _profileSection({
    required String name,
    required String status,
    required Widget page,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Image.asset('assets/img/dosen_pria.png'),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
      ],
    );
  }

  Widget _buildCounterSection(
    BuildContext context,
    ProfileViewModel viewModel,
  ) {
    final bool isLoading = viewModel.state == ProfileState.loading;

    final String mahasiswaCount =
        viewModel.dosenProfile?.jumlahMahasiswaAktif.toString() ?? '0';

    const String pendingReviewCount = '0';

    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: 92,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCounterItem(
            context,
            'Mahasiswa',
            isLoading ? '...' : mahasiswaCount,
          ),
          const VerticalDivider(color: Colors.black, thickness: 1.5),
          _buildCounterItem(
            context,
            'Pending Review',
            isLoading ? '...' : pendingReviewCount,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterItem(BuildContext context, String title, String count) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontSize: 16),
          ),
          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
