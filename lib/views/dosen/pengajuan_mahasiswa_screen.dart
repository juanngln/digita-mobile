import 'package:digita_mobile/models/list_request_pembimbing_dari_mahasiswa_model.dart';
import 'package:digita_mobile/services/list_request_pembimbing_dari_mahasiswa_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:digita_mobile/widgets/bottom_sheet/form_pengajuan_mahasiswa.dart';

class PengajuanMahasiswaScreen extends StatefulWidget {
  const PengajuanMahasiswaScreen({super.key});

  @override
  State<PengajuanMahasiswaScreen> createState() => _PengajuanMahasiswaState();
}

class _PengajuanMahasiswaState extends State<PengajuanMahasiswaScreen> {
  late Future<List<ListRequestPembimbingDariMahasiswaModel>> _requestsFuture;
  final ListRequestPembimbingDariMahasiswaService _pengajuanService = ListRequestPembimbingDariMahasiswaService();
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

  Future<List<ListRequestPembimbingDariMahasiswaModel>> _fetchIncomingRequests() async {
    final token = await _storageService.getAccessToken();
    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login kembali.");
    }
    return await _pengajuanService.getIncomingRequests(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengajuan Mahasiswa',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Daftar Mahasiswa',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F47AD),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<ListRequestPembimbingDariMahasiswaModel>>(
                  future: _requestsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child:
                          Text('Gagal memuat data: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Tidak ada pengajuan masuk saat ini.'));
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
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 2))
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
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F47AD),
                                            fontFamily: 'Poppins'),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${request
                                            .mahasiswaNim} - Teknik Informatika",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded,
                                    color: Colors.black87, size: 24),
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

  void _showFormPengajuanBottomSheet(BuildContext context,
      ListRequestPembimbingDariMahasiswaModel request) async {
    // Wait for the bottom sheet to be closed and check if it returned 'true'
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FormPengajuanMahasiswaWidget(
            selectedRequest: request,
          ),
    );

    // If the result is true, it means an action was successful
    if (result == true) {
      _refreshRequests();
    }
  }
}

