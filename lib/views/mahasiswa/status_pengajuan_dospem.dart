// lib/screens/status_pengajuan_dospem.dart

import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/widgets/bottom_sheet/status_pengajuan_dospem_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPengajuan extends StatefulWidget {
  const StatusPengajuan({super.key});

  @override
  State<StatusPengajuan> createState() => _StatusPengajuanState();
}

class _StatusPengajuanState extends State<StatusPengajuan> {
  final LoginService _thesisStatusService = LoginService();
  final SecureStorageService _secureStorageService = SecureStorageService();
  bool _isLoadingButton = false;

  Future<String?> _getAuthToken() async {
    return await _secureStorageService.getAccessToken();
  }

  Future<void> _fetchAndUpdateStatus({
    bool showBottomSheetOnClick = false,
  }) async {
    if (!mounted) return;

    if (showBottomSheetOnClick) {
      setState(() {
        _isLoadingButton = true;
      });
    }

    String? authToken = await _getAuthToken();
    if (authToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memuat status: Token tidak ditemukan."),
          ),
        );
        if (showBottomSheetOnClick) setState(() => _isLoadingButton = false);
      }
      return;
    }

    try {
      final statusData = await _thesisStatusService.checkThesisRequestStatus(
        authToken,
      );

      if (!mounted) return;

      if (statusData != null && statusData.containsKey('status')) {
        final String? status = statusData['status']?.toString().toUpperCase();

        if (status == 'DISETUJUI' || status == 'ACCEPTED') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Pengajuan telah disetujui!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
            ),
          );

          Navigator.pushReplacementNamed(context, '/home_mahasiswa');
          return;
        }

        if (showBottomSheetOnClick) {
          Widget bottomSheetContent;

          if (status == 'REJECTED' || status == 'DITOLAK') {
            // Assumes the rejection reason is in the same API response
            final reason = statusData['alasan_penolakan'] ?? 'Tidak ada alasan yang diberikan.';

            bottomSheetContent = StatusPengajuanDospemBottomSheet(
              imagePath: 'assets/img/pengajuan_dosen_ditolak.png',
              title: 'Yah, Pengajuanmu Ditolak!',
              description: 'Alasan: "$reason"',
              actionButton: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F47AD),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pushNamed(context, '/daftar_dosen'),
                child: const Text('Cari Dosen Pembimbing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            );
          } else {
            bottomSheetContent = const StatusPengajuanDospemBottomSheet(
              imagePath: 'assets/img/pengajuan_dosen_pending.png',
              title: 'Sedang Menunggu Konfirmasi',
              description: 'Pengajuan dosen pembimbing sedang diproses. Sabar sebentar ya!',
            );
          }

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white, // Can be set here now
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => bottomSheetContent,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tidak ada pengajuan aktif yang ditemukan."),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat status: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted && showBottomSheetOnClick) {
        setState(() => _isLoadingButton = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: RefreshIndicator(
        onRefresh: () => _fetchAndUpdateStatus(showBottomSheetOnClick: false),
        color: const Color(0xFF0F47AD),
        child: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: (MediaQuery.of(context).size.height * 0.2).clamp(
                    50.0,
                    200.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/terkirim.png', height: 250),
                    const SizedBox(height: 24),
                    Text(
                      'Pengajuan Terkirim!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F47AD),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pengajuan dosen pembimbingmu telah berhasil dikirim.\nSilakan cek status pengajuanmu secara berkala.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _isLoadingButton
                                ? null
                                : () => _fetchAndUpdateStatus(
                                  showBottomSheetOnClick: true,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F47AD),
                          disabledBackgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            _isLoadingButton
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  'LIHAT STATUS PENGAJUAN',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tarik ke bawah untuk menyegarkan status.",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
