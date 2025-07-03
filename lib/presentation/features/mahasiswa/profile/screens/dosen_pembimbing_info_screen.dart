import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:digita_mobile/models/dosen_model.dart';

class DosenPembimbingInfoScreen extends StatefulWidget {
  final int dosenId;

  const DosenPembimbingInfoScreen({super.key, required this.dosenId});

  @override
  State<DosenPembimbingInfoScreen> createState() =>
      _DosenPembimbingInfoScreenState();
}

class _DosenPembimbingInfoScreenState extends State<DosenPembimbingInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(
        context,
        listen: false,
      ).loadSupervisorProfile(widget.dosenId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi Dosen Pembimbing',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.supervisorState) {
            case ProfileState.loading:
              return const Center(child: CircularProgressIndicator());
            case ProfileState.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    viewModel.supervisorErrorMessage ??
                        "Gagal memuat data dosen.",
                  ),
                ),
              );
            case ProfileState.success:
              if (viewModel.supervisorDosenProfile == null) {
                return const Center(child: Text("Data dosen tidak ditemukan."));
              }
              return _buildContentView(
                context,
                viewModel.supervisorDosenProfile!,
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildContentView(BuildContext context, Dosen dosen) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 257,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7FCC9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Status: Dosen Pembimbing Aktif",
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF0A7D0C),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildInfoItem(
                textTheme,
                label: "Nama Dosen Pembimbing",
                value: dosen.nama, // DYNAMIC DATA
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                textTheme,
                label: "NIK",
                value: dosen.nik, // DYNAMIC DATA
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                textTheme,
                label: "Jurusan",
                value: "Teknik Informatika", // HARDCODE DATA
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                textTheme,
                label: "Email",
                value: dosen.email, // DYNAMIC DATA
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                textTheme,
                label: "Topik Bimbingan",
                value: "Data tidak tersedia", // HARDCODE DATA
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    TextTheme textTheme, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F47AD),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
