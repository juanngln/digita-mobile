import 'dart:math' as math;

import 'package:digita_mobile/helper/db_helper.dart';
import 'package:digita_mobile/presentation/features/dosen/home/screens/notification_dosen_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/pengumuman_card.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/upcoming_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../viewmodels/pengumuman_viewmodel.dart';

class HomeDosenScreen extends StatefulWidget {
  const HomeDosenScreen({super.key});

  @override
  State<HomeDosenScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeDosenScreen> {
  int unreadNotification = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PengumumanViewModel>(
        context,
        listen: false,
      ).fetchAnnouncements();
    });

    _loadUnreadNotification();
  }

  Future<void> _loadUnreadNotification() async {
    final count = await DBHelper.instance.getUnreadNotificationCount();
    setState(() {
      unreadNotification = count;
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
                                      return Skeletonizer(
                                        enableSwitchAnimation: true,
                                        child: ListView.separated(
                                          separatorBuilder:
                                              (context, index) =>
                                                  const SizedBox(width: 16),
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
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
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    ProfileViewModel viewModel,
  ) {
    final bool isLoading = viewModel.state == ProfileState.loading;
    switch (viewModel.state) {
      case ProfileState.loading:
        return Skeletonizer(
          enabled: isLoading,
          enableSwitchAnimation: true,
          child: _profileSection(
            name: '',
            status: '',
            page: NotificationDosenScreen(),
            isLoading: isLoading,
          ),
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
                  child: Image.asset('assets/img/dosen_pria.png'),
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
                          height: 12,
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
              isLabelVisible: unreadNotification > 0,
              alignment: Alignment.topRight,
              offset: const Offset(-10, 6),
              label: Text(unreadNotification.toString()),
              largeSize: 12,
              smallSize: 12,
              child: IconButton(
                icon: Icon(CupertinoIcons.bell_fill),
                iconSize: 28,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                  _loadUnreadNotification();
                },
                color: Theme.of(context).colorScheme.primary,
              ),
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
          _buildCounterItem(context, 'Mahasiswa', mahasiswaCount, isLoading),
          const VerticalDivider(color: Colors.black, thickness: 1.5),
          _buildCounterItem(
            context,
            'Pending Review',
            pendingReviewCount,
            isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterItem(
    BuildContext context,
    String title,
    String count,
    bool isLoading,
  ) {
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
          const SizedBox(height: 8),
          if (isLoading)
            Skeleton.shade(
              child: Container(
                height: 28,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            )
          else
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
