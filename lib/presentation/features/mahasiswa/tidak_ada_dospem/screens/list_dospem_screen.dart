import 'package:digita_mobile/models/dosen_model.dart';
import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Dosen Pembimbing',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Subtitle(text: 'Pilih Dosen Pembimbing'),
              ),
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
          padding: const EdgeInsets.all(12.0),
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
                        style: Theme.of(context).textTheme.bodyLarge
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dosen.jumlahMahasiswaForDisplay,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
