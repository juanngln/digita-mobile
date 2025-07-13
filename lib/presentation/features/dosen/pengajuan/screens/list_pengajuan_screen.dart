import 'package:digita_mobile/models/list_request_pembimbing_dari_mahasiswa_model.dart';
import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
import 'package:digita_mobile/services/list_request_pembimbing_dari_mahasiswa_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:digita_mobile/presentation/features/dosen/pengajuan/widgets/form_pengajuan_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PengajuanMahasiswaScreen extends StatefulWidget {
  const PengajuanMahasiswaScreen({super.key});

  @override
  State<PengajuanMahasiswaScreen> createState() => _PengajuanMahasiswaState();
}

class _PengajuanMahasiswaState extends State<PengajuanMahasiswaScreen> {
  late Future<List<ListRequestPembimbingDariMahasiswaModel>> _requestsFuture;
  final ListRequestPembimbingDariMahasiswaService _pengajuanService =
      ListRequestPembimbingDariMahasiswaService();
  final SecureStorageService _storageService = SecureStorageService();

  void _refreshRequests() {
    setState(() {
      _requestsFuture = _fetchIncomingRequests();
    });
  }

  @override
  void initState() {
    super.initState();
    _requestsFuture = _fetchIncomingRequests();
  }

  Future<List<ListRequestPembimbingDariMahasiswaModel>>
  _fetchIncomingRequests() async {
    final token = await _storageService.getAccessToken();
    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login kembali.");
    }
    return await _pengajuanService.getIncomingRequests(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengajuan Mahasiswa',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Subtitle(text: 'Daftar Mahasiswa'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<
                  List<ListRequestPembimbingDariMahasiswaModel>
                >(
                  future: _requestsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeletonizer(
                        enableSwitchAnimation: true,
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
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
                                        const SizedBox(height: 2),
                                        Text(
                                          '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Gagal memuat data: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada pengajuan masuk saat ini',
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }

                    final requests = snapshot.data!;
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return GestureDetector(
                          onTap: () {
                            _showFormPengajuanBottomSheet(context, request);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
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
                                    'assets/img/mhs_pria.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.mahasiswaNama,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${request.mahasiswaNim} - ${request.mahasiswaProdi}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFormPengajuanBottomSheet(
    BuildContext context,
    ListRequestPembimbingDariMahasiswaModel request,
  ) async {
    final result = await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder:
          (context) => FormPengajuanMahasiswaWidget(selectedRequest: request),
    );

    if (result == true) {
      _refreshRequests();
    }
  }
}
