import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/dokumen_dosen_viewmodel.dart';
import 'package:digita_mobile/presentation/features/dosen/dokumen/screens/status_dokumen_dosen_screen.dart';
import 'package:digita_mobile/models/list_mahasiswa_bimbingan.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DokumenDosenScreen extends StatefulWidget {
  const DokumenDosenScreen({super.key});

  @override
  State<DokumenDosenScreen> createState() => _DokumenDosenScreenState();
}

class _DokumenDosenScreenState extends State<DokumenDosenScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DokumenDosenViewModel>(
        context,
        listen: false,
      ).fetchMahasiswaBimbingan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dokumen Tugas Akhir',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Subtitle(text: 'Pilih Mahasiswa'),
                ),
                Expanded(
                  child: Consumer<DokumenDosenViewModel>(
                    builder: (context, viewModel, child) {
                      switch (viewModel.mahasiswaState) {
                        case ViewState.Loading:
                          return Skeletonizer(
                            enableSwitchAnimation: true,
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                        color: Colors.black.withAlpha(50),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Skeleton.shade(
                                        child: ClipOval(
                                          child: Image.asset(
                                            '',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              '',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Skeleton.shade(
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        case ViewState.Error:
                          return Center(
                            child: Text(
                              'Error: ${viewModel.mahasiswaErrorMessage}',
                            ),
                          );
                        case ViewState.Success:
                          if (viewModel.mahasiswaList.isEmpty) {
                            return const Center(
                              child: Text(
                                'Anda belum memiliki mahasiswa bimbingan',
                              ),
                            );
                          }
                          return _buildMahasiswaList(viewModel.mahasiswaList);
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMahasiswaList(List<ListMahasiswaBimbingan> mahasiswaList) {
    return ListView.builder(
      itemCount: mahasiswaList.length,
      itemBuilder: (context, index) {
        final mahasiswa = mahasiswaList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ChangeNotifierProvider.value(
                      value: Provider.of<DokumenDosenViewModel>(
                        context,
                        listen: false,
                      ),
                      child: StatusDokumenDosenScreen(mahasiswa: mahasiswa),
                    ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  color: Colors.black.withAlpha(50),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    mahasiswa.avatarPath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mahasiswa.namaLengkap,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                      ),
                      Text(
                        '${mahasiswa.nim} - ${mahasiswa.programStudi.namaProdi}',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                const Icon(Icons.arrow_forward, color: Colors.black, size: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
