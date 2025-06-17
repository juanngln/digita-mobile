import 'package:flutter/material.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/widgets/setujui_jadwal_bottom_sheet.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/widgets/catatan_jadwal_bottom_sheet.dart';

class JadwalDosenScreen extends StatefulWidget {
  const JadwalDosenScreen({super.key});

  @override
  State<JadwalDosenScreen> createState() => _JadwalDosenState();
}

class _JadwalDosenState extends State<JadwalDosenScreen> {
  List<BimbinganItem> bimbinganList = [
    BimbinganItem(
      title: 'Diskusi Pendahuluan',
      date: '07 Maret 2025, 14:00',
      student: '4467152497 - Abyan Putra Tama',
      location: 'Zoom Online',
      catatan: '-',
      status: 'permintaan',
    ),
    BimbinganItem(
      title: 'Diskusi Latar Belakang',
      date: '14 Maret 2025, 14:00',
      student: '331240824 - Wildha Siti Nur',
      location: 'GU 706',
      catatan: '-',
      status: 'permintaan',
    ),
    BimbinganItem(
      title: 'Diskusi Latar Belakang',
      date: '14 Maret 2025, 14:00',
      student: '331230190 - Nadya Arina',
      location: 'GU 702',
      catatan: '-',
      status: 'disetujui',
    ),
    BimbinganItem(
      title: 'Diskusi Latar Belakang',
      date: '14 Maret 2025, 14:00',
      student: '4434671523 - Almayzah Rasti',
      location: 'GU 702',
      catatan: 'Selesai membahas terkait latar belakang, dan membahas terkait kendala yang dialami mahasiswa',
      status: 'selesai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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

              // Permintaan Bimbingan Section
              _buildSectionTitle('Permintaan Bimbingan'),
              const SizedBox(height: 12),
              ...buildBimbinganSection('permintaan'),

              const SizedBox(height: 24),

              // Bimbingan Disetujui Section
              _buildSectionTitle('Bimbingan Disetujui'),
              const SizedBox(height: 12),
              ...buildBimbinganSection('disetujui'),

              const SizedBox(height: 24),

              // Bimbingan Selesai Section
              _buildSectionTitle('Bimbingan Selesai'),
              const SizedBox(height: 12),
              ...buildBimbinganSection('selesai'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildBimbinganSection(String status) {
    List<BimbinganItem> filteredList = bimbinganList.where((item) => item.status == status).toList();

    if (filteredList.isEmpty) {
      return [
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            'Belum ada bimbingan ${status == "permintaan" ? "yang diminta" : status}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        )
      ];
    }

    return filteredList.map((item) => _buildBimbinganCard(item)).toList();
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

  Widget _buildBimbinganCard(BimbinganItem bimbingan) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              bimbingan.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF0F47AD),
              ),
            ),
            const SizedBox(height: 12),

            // Info rows
            _buildInfoRow(Icons.access_time_filled, bimbingan.date),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person, bimbingan.student),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, bimbingan.location),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.edit_document, 'Catatan: ${bimbingan.catatan}'),

            // Buttons based on status
            if (bimbingan.status == 'permintaan') ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F47AD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _showTolakBottomSheet(bimbingan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFB3BA),
                      foregroundColor: Color(0xFFE20030),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(80, 36),
                    ),
                    child: Text(
                      'Tolak',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _showSetujuBottomSheet(bimbingan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB7FCC9),
                      foregroundColor: Color(0xFF0A7D0C),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(80, 36),
                    ),
                    child: Text(
                      'Setuju',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Action button for approved bimbingan
            if (bimbingan.status == 'disetujui') ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F47AD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showSelesaikanBottomSheet(bimbingan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF8110),
                    foregroundColor: Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Selesaikan dan perbarui Catatan',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
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
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

// Bottom Sheet untuk Setuju - menampilkan detail pengajuan
void _showSetujuBottomSheet(BimbinganItem bimbingan) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: PengajuanJadwalBimbingan(
        bimbingan: bimbingan,
        onSetuju: () {
          setState(() {
            bimbingan.status = 'disetujui';
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bimbingan disetujui"),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    ),
  );
}

  // Bottom Sheet untuk Tolak
  void _showTolakBottomSheet(BimbinganItem bimbingan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => CatatanDosenBottomSheet(
        title: 'Alasan Penolakan',
        hintText: 'Masukkan alasan penolakan bimbingan...',
        buttonText: 'TOLAK BIMBINGAN',
        onSave: (String catatan) {
          setState(() {
            bimbinganList.remove(bimbingan);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bimbingan ditolak"),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  void _showSelesaikanBottomSheet(BimbinganItem bimbingan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => CatatanDosenBottomSheet(
        title: 'Catatan hasil bimbingan',
        hintText: 'Masukkan catatan hasil bimbingan...',
        buttonText: 'SIMPAN',
        onSave: (String catatan) {
          setState(() {
            bimbingan.catatan = catatan;
            bimbingan.status = 'selesai';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bimbingan telah diselesaikan"),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}