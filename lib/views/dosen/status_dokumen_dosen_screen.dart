import 'package:flutter/material.dart';
import 'package:digita_mobile/widgets/dialog.dart'; 
import 'package:digita_mobile/widgets/bottom_sheet/catatan_revisi.dart'; 

class Mahasiswa {
  final String nama;
  final String informasiMahasiswa;
  final String avatarPath;

  Mahasiswa({
    required this.nama,
    required this.informasiMahasiswa,
    required this.avatarPath,
  });
}

class DokumenItem {
  final String judul;
  final String tanggalUpload;
  String keterangan;
  String status;

  DokumenItem({
    required this.judul,
    required this.tanggalUpload,
    required this.keterangan,
    required this.status,
  });
}

class StatusDokumenDosenScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const StatusDokumenDosenScreen({super.key, required this.mahasiswa});

  @override
  State<StatusDokumenDosenScreen> createState() => _StatusDokumenState();
}

class _StatusDokumenState extends State<StatusDokumenDosenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<DokumenItem> dokumenList = [
    DokumenItem(
      judul: "BAB I: Pendahuluan",
      tanggalUpload: "07 Maret 2025, 14:00",
      keterangan: "Pendahuluan sudah sesuai dengan topik penelitian. Pastikan landasan teori nantinya selaras dengan masalah yang diangkat",
      status: "Disetujui",
    ),
    DokumenItem(
      judul: "BAB II: Landasan Teori",
      tanggalUpload: "28 Maret 2025, 14:00",
      keterangan: "Struktur penulisan di bagian ini kurang sistematis. Sebaiknya mulai dari teori umum dulu, baru ke teori yang lebih spesifik.",
      status: "Revisi",
    ),
    DokumenItem(
      judul: "BAB III: Analisis dan Perancangan",
      tanggalUpload: "07 Maret 2025, 14:00",
      keterangan: "-",
      status: "Pending",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'Dokumen Mahasiswa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xFFD9EEFF),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    widget.mahasiswa.avatarPath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mahasiswa.nama,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      widget.mahasiswa.informasiMahasiswa,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Disetujui'),
              Tab(text: 'Revisi'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildDokumenList("Pending"),
                buildDokumenList("Disetujui"),
                buildDokumenList("Revisi"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDokumenList(String status) {
    List<DokumenItem> filteredDokumen = dokumenList.where((doc) => doc.status == status).toList();
    
    if (filteredDokumen.isEmpty) {
      return Center(
        child: Text(
          "Belum ada dokumen $status",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredDokumen.length,
      itemBuilder: (context, index) {
        return buildDokumenCard(filteredDokumen[index]);
      },
    );
  }

  Widget buildDokumenCard(DokumenItem dokumen) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dokumen.judul,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0F47AD),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(dokumen.status),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  dokumen.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: getStatusTextColor(dokumen.status),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Di Upload: ${dokumen.tanggalUpload}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Keterangan: ${dokumen.keterangan}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
            color: const Color(0xFF0F47AD),
            borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 12),
          buildActionButtons(dokumen),
        ],
      ),
    );
  }

  Widget buildActionButtons(DokumenItem dokumen) {
    if (dokumen.status == "Pending") {
      return Row(
        children: [
          IconButton(
            onPressed: () => showUnduhDialog(dokumen.judul),
            icon: Icon(Icons.download, color: Colors.black),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () => showRevisiBottomSheet(dokumen),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color (0xFFFFB3BA),
              foregroundColor: Color (0xFFE20030),
              padding: EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Revisi",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 15),
          ElevatedButton(
            onPressed: () => setujuiDokumen(dokumen),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color (0xFFB7FCC9),
              foregroundColor: Color (0xFF0A7D0C),
              padding: EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Setuju",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          IconButton(
            onPressed: () => showUnduhDialog(dokumen.judul),
            icon: Icon(Icons.download, color: Colors.black),
          ),
          Spacer(),
        ],
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Color(0xFFFFEEB7);
      case "Disetujui":
        return Color(0xFFB7FCC9);
      case "Revisi":
        return Color(0xFFFFB3BA);
      default:
        return Colors.black; 
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case "Pending":
        return Color(0xFFFF8110);
      case "Disetujui":
        return Color (0xFF0A7D0C);
      case "Revisi":
        return Color (0xFFE20030);
      default:
        return Colors.black;
    }
  }

  void showUnduhDialog(String namaFile) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Unduh File Dokumen',
          contentWidget: Text(
            '$namaFile.pdf',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          cancelText: 'Batal',
          confirmText: 'Unduh',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Dokumen berhasil diunduh"),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }


void showRevisiBottomSheet(DokumenItem dokumen) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CatatanRevisi(
        onSave: (String catatanRevisi) {
          setState(() {
            dokumen.status = "Revisi";
            // Simpan catatan revisi yang diinput user
            dokumen.keterangan = catatanRevisi;
          });
          _tabController.animateTo(2); // Pindah ke tab Revisi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Dokumen dipindahkan ke revisi"),
              backgroundColor: Colors.orange,
            ),
          );
        },
      ),
    ),
  );
}

  void setujuiDokumen(DokumenItem dokumen) {
    setState(() {
      dokumen.status = "Disetujui";
    });
    _tabController.animateTo(1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Dokumen telah disetujui"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
