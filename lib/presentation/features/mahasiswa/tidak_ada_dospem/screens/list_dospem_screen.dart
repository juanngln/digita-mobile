import 'package:digita_mobile/models/dosen_model.dart';
import 'package:digita_mobile/services/list_dosen_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/tidak_ada_dospem/widgets/form_pengajuan_dospem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarDosen extends StatefulWidget {
  const DaftarDosen({super.key});

  @override
  State<DaftarDosen> createState() => _DaftarDosenState();
}

class _DaftarDosenState extends State<DaftarDosen> {
  final DosenService _dosenService = DosenService();
  final SecureStorageService _secureStorageService = SecureStorageService();

  List<Dosen> _dosenList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDosenList();
  }

  Future<void> _fetchDosenList() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final token = await _secureStorageService.getAccessToken();
      if (token == null) {
        throw Exception("Token tidak ditemukan. Silakan login kembali.");
      }
      final List<Dosen> dosenData = await _dosenService.getDosenList(token);
      if (!mounted) return;
      setState(() {
        _dosenList = dosenData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Daftar Dosen Pembimbing',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Pilih Dosen Pembimbing',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
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
              Expanded(child: _buildDosenListWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDosenListWidget() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Oops! Terjadi kesalahan:\n$_errorMessage",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F47AD),
                ),
                onPressed: _fetchDosenList,
                child: const Text(
                  "COBA LAGI",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_dosenList.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada dosen yang tersedia saat ini.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    return ListView.builder(
      itemCount: _dosenList.length,
      itemBuilder: (context, index) {
        final dosen = _dosenList[index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              builder:
                  (context) => FormPengajuanDosenWidget(selectedDosen: dosen),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    dosen.avatarPath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dosen.nama,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F47AD),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dosen.jumlahMahasiswaForDisplay,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black54,
                  size: 28,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
