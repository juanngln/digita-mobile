import 'package:digita_mobile/presentation/features/dosen/home/screens/notification_dosen_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/pengumuman_card.dart';
import 'package:digita_mobile/presentation/common_widgets/home_widgets/profile_section.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/models/dosen_model.dart';

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

                    // --- Information Section (Static) ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
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
                              separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
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

                    // --- Upcoming Section (Static) ---
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

  Widget _buildProfileSection(BuildContext context, ProfileViewModel viewModel) {
    switch (viewModel.state) {
      case ProfileState.loading:
        return ProfileSection(name: 'Memuat...', status: '...', page: NotificationDosenScreen());
      case ProfileState.error:
        return Center(child: Text('Gagal: ${viewModel.errorMessage}'));
      case ProfileState.success:
      // --- PERUBAHAN DI SINI ---
      // Use `viewModel.dosenProfile` which is of type `Dosen`
        final Dosen? profile = viewModel.dosenProfile;
        return ProfileSection(
          name: profile?.nama ?? 'Nama Tidak Ditemukan',
          status: 'Dosen Teknik Informatika', // You can make this dynamic if needed
          page: NotificationDosenScreen(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// Builds the counter section.
  Widget _buildCounterSection(BuildContext context, ProfileViewModel viewModel) {
    final bool isLoading = viewModel.state == ProfileState.loading;

    // --- PERUBAHAN DI SINI ---
    // Use `viewModel.dosenProfile` to get the student count.
    final String mahasiswaCount = viewModel.dosenProfile?.jumlahMahasiswaAktif.toString() ?? '0';

    // The 'Pending Review' count is still static as it's not in the Dosen model.
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
          _buildCounterItem(context, 'Mahasiswa', isLoading ? '...' : mahasiswaCount),
          const VerticalDivider(color: Colors.black, thickness: 1.5),
          _buildCounterItem(context, 'Pending Review', isLoading ? '...' : pendingReviewCount),
        ],
      ),
    );
  }

  Widget _buildCounterItem(BuildContext context, String title, String count) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16)),
          Text(
            count,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
