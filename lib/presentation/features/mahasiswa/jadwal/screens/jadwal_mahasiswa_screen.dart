import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/jadwal_mendatang_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/jadwal_selesai_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/widgets/tambah_jadwal_bottom_sheet.dart';
import 'package:digita_mobile/viewmodels/jadwal_mahasiswa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class JadwalMahasiswaScreen extends StatefulWidget {
  const JadwalMahasiswaScreen({super.key});

  @override
  State<JadwalMahasiswaScreen> createState() => _JadwalMahasiswaScreenState();
}

class _JadwalMahasiswaScreenState extends State<JadwalMahasiswaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JadwalViewModel>(
        context,
        listen: false,
      ).fetchJadwalBimbingan();
    });
  }

  ScheduleStatus parseStatus(String? apiStatus) {
    switch (apiStatus) {
      case 'ACCEPTED':
        return ScheduleStatus.disetujui;
      case 'REJECTED':
        return ScheduleStatus.ditolak;
      case 'PENDING':
        return ScheduleStatus.menunggu;
      default:
        return ScheduleStatus.kosong;
    }
  }

  String formatDateTime(DateTime date, String time) {
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    final formattedTime = time.substring(0, 5);
    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'addSchedule',
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
        child: Consumer<JadwalViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.state == ViewState.loading &&
                viewModel.upcomingSchedules.isEmpty &&
                viewModel.finishedSchedules.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.state == ViewState.error &&
                viewModel.upcomingSchedules.isEmpty &&
                viewModel.finishedSchedules.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Gagal memuat data: ${viewModel.errorMessage}'),
                ),
              );
            }

            final upcomingSchedule = viewModel.upcomingSchedules;
            final finishedSchedule = viewModel.finishedSchedules;

            return RefreshIndicator(
              onRefresh: () => viewModel.fetchJadwalBimbingan(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Bimbingan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      // Bagian Jadwal Mendatang
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Subtitle(text: 'Jadwal Mendatang'),
                      ),
                      if (upcomingSchedule.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Tidak ada jadwal mendatang',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: upcomingSchedule.length,
                          itemBuilder: (context, index) {
                            final schedule = upcomingSchedule[index];
                            return UpcomingScheduleCard(
                              schedule: schedule, //
                              status: parseStatus(schedule.status), //
                            );
                          },
                        ),
                      // Bagian Jadwal Selesai
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Subtitle(text: 'Selesai'),
                      ),
                      if (finishedSchedule.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Tidak ada jadwal yang selesai',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: finishedSchedule.length,
                          itemBuilder: (context, index) {
                            final schedule = finishedSchedule[index];
                            return FinishedScheduleCard(
                              title: schedule.judulBimbingan, //
                              dateTime: formatDateTime(
                                schedule.tanggal,
                                schedule.waktu,
                              ), //
                              supervisor:
                                  schedule.dosenPembimbing.namaLengkap, //
                              location: schedule.lokasiRuangan.namaRuangan, //
                              note:
                                  schedule.catatanBimbingan ??
                                  'Tidak ada catatan.', //
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTambahJadwalForm(BuildContext context) {
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
        return ChangeNotifierProvider.value(
          value: Provider.of<JadwalViewModel>(context, listen: false),
          child: const TambahJadwalBottomSheet(),
        );
      },
    );
  }
}
