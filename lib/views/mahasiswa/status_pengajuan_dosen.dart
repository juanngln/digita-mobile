import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/widgets/bottom_sheet/status_pengajuan_ditolak.dart';
import 'package:digita_mobile/widgets/bottom_sheet/status_pengajuan_menunggu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPengajuan extends StatefulWidget {
  const StatusPengajuan({super.key});

  @override
  State<StatusPengajuan> createState() => _StatusPengajuanState();
}

class _StatusPengajuanState extends State<StatusPengajuan> {
  final LoginService _loginService = LoginService();
  final SecureStorageService _secureStorageService = SecureStorageService();
  bool _isLoadingStatus = false;

  Future<String?> _getAuthToken() async {
    return await _secureStorageService.getAccessToken();
  }

  void _showStatusSheet(BuildContext context) async {
    if (_isLoadingStatus) return;

    setState(() {
      _isLoadingStatus = true;
    });

    String? authToken = await _getAuthToken();

    if (authToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal memuat status: Token tidak ditemukan."),
          ),
        );
        setState(() {
          _isLoadingStatus = false;
        });
      }
      return;
    }

    try {
      final statusData = await _loginService.checkThesisRequestStatus(
        authToken,
      );
      Widget bottomSheetWidget;

      if (statusData != null && statusData.containsKey('status')) {
        final String? status = statusData['status']?.toString().toUpperCase();
        if (status == 'REJECTED') {
          bottomSheetWidget = const StatusPengajuanDitolak();
        } else if (status == 'PENDING') {
          bottomSheetWidget = const StatusPengajuanMenunggu();
        } else {
          bottomSheetWidget = const StatusPengajuanMenunggu();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tidak dapat menemukan status pengajuan."),
            ),
          );
        }
        setState(() {
          _isLoadingStatus = false;
        });
        return;
      }

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext bc) {
            return bottomSheetWidget;
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat status: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/terkirim.png', height: 300),
                const SizedBox(height: 24),

                const Text(
                  'Wah, Terkirim!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F47AD),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Pengajuan Dosen Pembimbingmu\nsudah terkirim\nYuk, cek status pengajuanmu\nsekarang!',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed:
                        _isLoadingStatus
                            ? null
                            : () {
                              _showStatusSheet(context);
                            },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF0F47AD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: Text(
                      'LIHAT STATUS PENGAJUAN',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
