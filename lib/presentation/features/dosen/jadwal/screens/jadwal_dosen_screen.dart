import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/models/jadwal_bimbingan_model.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/widgets/catatan_jadwal_bottom_sheet.dart';
import 'package:digita_mobile/viewmodels/jadwal_dosen_viewmodel.dart';

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
      Provider.of<JadwalDosenViewModel>(context, listen: false)
          .fetchJadwalBimbinganDosen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Consumer<JadwalDosenViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.state == DosenViewState.loading &&
                  viewModel.pendingSchedules.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.state == DosenViewState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Gagal memuat data: ${viewModel.errorMessage ?? "Terjadi kesalahan"}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchJadwalBimbinganDosen(),
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => viewModel.fetchJadwalBimbinganDosen(),
                child: ListView(
                  children: [
                    const Text(
                      'Jadwal Bimbingan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Permintaan Bimbingan Section ---
                    _buildSectionTitle('Permintaan Bimbingan'),
                    const SizedBox(height: 12),
                    if (viewModel.pendingSchedules.isEmpty)
                      _buildEmptyListPlaceholder('permintaan')
                    else
                      ...viewModel.pendingSchedules
                          .map((item) => _buildBimbinganCard(item)),

                    const SizedBox(height: 24),

                    // --- Bimbingan Disetujui Section ---
                    _buildSectionTitle('Bimbingan Disetujui'),
                    const SizedBox(height: 12),
                    if (viewModel.acceptedSchedules.isEmpty)
                      _buildEmptyListPlaceholder('disetujui')
                    else
                      ...viewModel.acceptedSchedules
                          .map((item) => _buildBimbinganCard(item)),

                    const SizedBox(height: 24),

                    // --- Bimbingan Selesai Section ---
                    _buildSectionTitle('Bimbingan Selesai'),
                    const SizedBox(height: 12),
                    if (viewModel.doneSchedules.isEmpty)
                      _buildEmptyListPlaceholder('selesai')
                    else
                      ...viewModel.doneSchedules
                          .map((item) => _buildBimbinganCard(item)),
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
        'Belum ada bimbingan ${status == "permintaan" ? "yang diminta" : status}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Poppins',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
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
    );
  }

  Widget _buildBimbinganCard(JadwalBimbingan bimbingan) {
    final String formattedDate =
    DateFormat('dd MMMM yyyy', 'id_ID').format(bimbingan.tanggal);
    final String formattedTime = bimbingan.waktu.substring(0, 5);
    final String dateTimeString = '$formattedDate, $formattedTime';
    final String studentInfo =
        '${bimbingan.mahasiswa.nim ?? "N/A"} - ${bimbingan.mahasiswa.namaLengkap}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                Icons.location_on, bimbingan.lokasiRuangan.namaRuangan),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.edit_document,
                'Catatan: ${bimbingan.catatanBimbingan ?? '-'}'),
            if (bimbingan.status == 'PENDING')
              _buildActionButtonsForPending(bimbingan),
            if (bimbingan.status == 'ACCEPTED')
              _buildActionButtonForAccepted(bimbingan),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.black54,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsForPending(JadwalBimbingan bimbingan) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF0F47AD), thickness: 1.5),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => _showTolakBottomSheet(bimbingan),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB3BA),
                foregroundColor: const Color(0xFFE20030),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(80, 36),
              ),
              child: const Text('Tolak'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _showSetujuBottomSheet(bimbingan),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7FCC9),
                foregroundColor: const Color(0xFF0A7D0C),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(80, 36),
              ),
              child: const Text('Setuju'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtonForAccepted(JadwalBimbingan bimbingan) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF0F47AD), thickness: 1.5),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showSelesaikanBottomSheet(bimbingan),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8110),
              foregroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Selesaikan dan perbarui Catatan'),
          ),
        ),
      ],
    );
  }

  // --- Bottom Sheet Handlers (robust async/await pattern) ---

  void _showSetujuBottomSheet(JadwalBimbingan bimbingan) async {
    final success = await context
        .read<JadwalDosenViewModel>()
        .approveJadwal(bimbingan.id);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Bimbingan disetujui"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(context.read<JadwalDosenViewModel>().errorMessage ??
                "Gagal menyetujui jadwal"),
            backgroundColor: Colors.red),
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
      builder: (ctx) => CatatanDosenBottomSheet(
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
                  backgroundColor: Colors.orange),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      context.read<JadwalDosenViewModel>().errorMessage ??
                          "Gagal menolak jadwal"),
                  backgroundColor: Colors.red),
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
      builder: (ctx) => CatatanDosenBottomSheet(
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
                          "Gagal menyimpan catatan"),
                  backgroundColor: Colors.red),
            );
          }
        },
      ),
    );
  }
}