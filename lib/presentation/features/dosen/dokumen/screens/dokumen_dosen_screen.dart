import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/dokumen_dosen_viewmodel.dart';
import 'package:digita_mobile/presentation/features/dosen/dokumen/screens/status_dokumen_dosen_screen.dart';
import 'package:digita_mobile/models/list_mahasiswa_bimbingan.dart';

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
      Provider.of<DokumenDosenViewModel>(context, listen: false)
          .fetchMahasiswaBimbingan();
    });
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
                'Dokumen Tugas Akhir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Pilih Mahasiswa',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
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
              Expanded(
                child: Consumer<DokumenDosenViewModel>(
                  builder: (context, viewModel, child) {
                    switch (viewModel.mahasiswaState) {
                      case ViewState.Loading:
                        return const Center(child: CircularProgressIndicator());
                      case ViewState.Error:
                        return Center(child: Text('Error: ${viewModel.mahasiswaErrorMessage}'));
                      case ViewState.Success:
                        if (viewModel.mahasiswaList.isEmpty) {
                          return const Center(
                            child: Text('Anda belum memiliki mahasiswa bimbingan.'),
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
                builder: (_) => ChangeNotifierProvider.value(
                  value: Provider.of<DokumenDosenViewModel>(context, listen: false),
                  child: StatusDokumenDosenScreen(
                    mahasiswa: mahasiswa,
                  ),
                ),
              ),
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
                  color: Colors.black.withAlpha(50),
                  blurRadius: 5,
                  offset: Offset(0, 4),
                )
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mahasiswa.namaLengkap,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F47AD),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${mahasiswa.nim} - ${mahasiswa.programStudi.namaProdi}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black87,
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