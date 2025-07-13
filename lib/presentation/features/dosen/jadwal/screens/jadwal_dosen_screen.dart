import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/models/jadwal_bimbingan_model.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/widgets/catatan_jadwal_bottom_sheet.dart';
import 'package:digita_mobile/viewmodels/jadwal_dosen_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JadwalDosenScreen extends StatefulWidget {
  const JadwalDosenScreen({super.key});

  @override
  State<JadwalDosenScreen> createState() => _JadwalDosenState();
}

class _JadwalDosenState extends State<JadwalDosenScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JadwalDosenViewModel>(
        context,
        listen: false,
      ).fetchJadwalBimbinganDosen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<JadwalDosenViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.state == DosenViewState.loading &&
                  viewModel.pendingSchedules.isEmpty) {
                return Skeletonizer(
                  child: ListView(
                    children: [
                      Skeleton.ignore(
                        child: Text(
                          'Jadwal Bimbingan',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Skeleton.ignore(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Subtitle(text: 'Permintaan Bimbingan'),
                        ),
                      ),
                      Skeleton.shade(
                        child: Card(
                          child: ListTile(title: Text(''), subtitle: Text('')),
                        ),
                      ),
                      Skeleton.ignore(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Subtitle(text: 'Bimbingan Disetujui'),
                        ),
                      ),
                      Skeleton.shade(
                        child: Card(
                          child: ListTile(title: Text(''), subtitle: Text('')),
                        ),
                      ),
                      Skeleton.ignore(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Subtitle(text: 'Bimbingan Selesai'),
                        ),
                      ),
                      Skeleton.shade(
                        child: Card(
                          child: ListTile(title: Text(''), subtitle: Text('')),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (viewModel.state == DosenViewState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gagal memuat data: ${viewModel.errorMessage ?? "Terjadi kesalahan"}',
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchJadwalBimbinganDosen(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => viewModel.fetchJadwalBimbinganDosen(),
                child: ListView(
                  children: [
                    Text(
                      'Jadwal Bimbingan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // --- Permintaan Bimbingan Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Subtitle(text: 'Permintaan Bimbingan'),
                    ),
                    if (viewModel.pendingSchedules.isEmpty)
                      _buildEmptyListPlaceholder('permintaan')
                    else
                      ...viewModel.pendingSchedules.map(
                        (item) => _buildBimbinganCard(item),
                      ),
                    // --- Bimbingan Disetujui Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Subtitle(text: 'Bimbingan Disetujui'),
                    ),
                    if (viewModel.acceptedSchedules.isEmpty)
                      _buildEmptyListPlaceholder('disetujui')
                    else
                      ...viewModel.acceptedSchedules.map(
                        (item) => _buildBimbinganCard(item),
                      ),
                    // --- Bimbingan Selesai Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Subtitle(text: 'Bimbingan Selesai'),
                    ),
                    if (viewModel.doneSchedules.isEmpty)
                      _buildEmptyListPlaceholder('selesai')
                    else
                      ...viewModel.doneSchedules.map(
                        (item) => _buildBimbinganCard(item),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyListPlaceholder(String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Belum ada bimbingan ${status == "permintaan" ? "yang diajukan" : status}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Poppins',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBimbinganCard(JadwalBimbingan bimbingan) {
    final String formattedDate = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(bimbingan.tanggal);
    final String formattedTime = bimbingan.waktu.substring(0, 5);
    final String dateTimeString = '$formattedDate, $formattedTime';
    final String studentInfo =
        '${bimbingan.mahasiswa.nim ?? "N/A"} - ${bimbingan.mahasiswa.namaLengkap}';

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
            color: Colors.black.withAlpha(50),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bimbingan.judulBimbingan,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF0F47AD),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time_filled, dateTimeString),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, studentInfo),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on,
                  bimbingan.lokasiRuangan.namaRuangan,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.edit_square,
                  'Catatan: ${bimbingan.catatanBimbingan ?? '-'}',
                ),
              ],
            ),
          ),
          if (bimbingan.status == 'PENDING')
            _buildActionButtonsForPending(bimbingan),
          if (bimbingan.status == 'ACCEPTED')
            _buildActionButtonForAccepted(bimbingan),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsForPending(JadwalBimbingan bimbingan) {
    return Column(
      children: [
        Divider(thickness: 5, color: Theme.of(context).colorScheme.primary),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _showTolakBottomSheet(bimbingan),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB3BA),
                  foregroundColor: const Color(0xFFE20030),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(100, 0),
                ),
                child: Text(
                  'Tolak',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => _showSetujuBottomSheet(bimbingan),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFB7FCC9),
                  foregroundColor: const Color(0xFF0A7D0C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(100, 0),
                ),
                child: Text(
                  'Setuju',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonForAccepted(JadwalBimbingan bimbingan) {
    return Column(
      children: [
        Divider(thickness: 5, color: Theme.of(context).colorScheme.primary),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              child: TextButton(
                onPressed: () => _showSelesaikanBottomSheet(bimbingan),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEEB7),
                  foregroundColor: const Color(0xFFFF8110),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Selesaikan dan perbarui Catatan',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Bottom Sheet Handlers (robust async/await pattern) ---
  void _showSetujuBottomSheet(JadwalBimbingan bimbingan) async {
    final success = await context.read<JadwalDosenViewModel>().approveJadwal(
      bimbingan.id,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bimbingan disetujui"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<JadwalDosenViewModel>().errorMessage ??
                "Gagal menyetujui jadwal",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showTolakBottomSheet(JadwalBimbingan bimbingan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => CatatanDosenBottomSheet(
            title: 'Alasan Penolakan',
            hintText: 'Masukkan alasan penolakan bimbingan...',
            buttonText: 'TOLAK BIMBINGAN',
            onSave: (String catatan) async {
              final success = await context
                  .read<JadwalDosenViewModel>()
                  .rejectJadwal(bimbingan.id, catatan);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bimbingan ditolak"),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.read<JadwalDosenViewModel>().errorMessage ??
                          "Gagal menolak jadwal",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
    );
  }

  void _showSelesaikanBottomSheet(JadwalBimbingan bimbingan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => CatatanDosenBottomSheet(
            title: 'Catatan hasil bimbingan',
            hintText: 'Masukkan catatan hasil bimbingan...',
            buttonText: 'SIMPAN',
            onSave: (String catatan) async {
              final success = await context
                  .read<JadwalDosenViewModel>()
                  .completeJadwal(bimbingan.id, catatan);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bimbingan telah diselesaikan"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.read<JadwalDosenViewModel>().errorMessage ??
                          "Gagal menyimpan catatan",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
    );
  }
}
