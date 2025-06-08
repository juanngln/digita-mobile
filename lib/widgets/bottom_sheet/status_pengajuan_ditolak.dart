import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/services/status_pengajuan_service.dart';
import 'package:flutter/material.dart';

class StatusPengajuanDitolak extends StatefulWidget {
  const StatusPengajuanDitolak({super.key});

  @override
  State<StatusPengajuanDitolak> createState() => _StatusPengajuanDitolakState();
}

class _StatusPengajuanDitolakState extends State<StatusPengajuanDitolak> {
  final StatusPengajuanService _service = StatusPengajuanService();
  final SecureStorageService _storage = SecureStorageService();
  late Future<String> _reasonFuture;

  @override
  void initState() {
    super.initState();
    _reasonFuture = _fetchReason();
  }

  Future<String> _fetchReason() async {
    final token = await _storage.getAccessToken();
    if (token == null) {
      throw Exception("Autentikasi gagal. Silakan login kembali.");
    }
    return await _service.getRejectionReason(token);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/img/pengajuan_dosen_ditolak.png', height: 300),
          const SizedBox(height: 24),
          const Text(
            'Yah, Pengajuanmu Ditolak!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F47AD),
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          FutureBuilder<String>(
            future: _reasonFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text(
                  'Gagal memuat alasan: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.red, fontFamily: 'Poppins'),
                );
              }

              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Alasan:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '"${snapshot.data!}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F47AD),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/daftar_dosen');
              },
              child: const Text(
                'Cari Dosen Pembimbing',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}