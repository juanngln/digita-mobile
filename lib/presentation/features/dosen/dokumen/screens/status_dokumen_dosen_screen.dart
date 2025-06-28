import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:digita_mobile/models/list_mahasiswa_bimbingan.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/viewmodels/dokumen_dosen_viewmodel.dart';
import 'package:digita_mobile/presentation/common_widgets/dialogs/custom_dialog.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/widgets/catatan_jadwal_bottom_sheet.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/screens/pdf_viewer_screen.dart';

class StatusDokumenDosenScreen extends StatefulWidget {
  final ListMahasiswaBimbingan mahasiswa;
  const StatusDokumenDosenScreen({super.key, required this.mahasiswa});

  @override
  State<StatusDokumenDosenScreen> createState() => _StatusDokumenState();
}

class _StatusDokumenState extends State<StatusDokumenDosenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _viewingDokumenId;
  int? _downloadingDokumenId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Langsung panggil method untuk fetch dokumen dari ViewModel gabungan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DokumenDosenViewModel>(context, listen: false)
          .fetchDokumen(widget.mahasiswa.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mendengarkan perubahan dari DokumenDosenViewModel
    return Consumer<DokumenDosenViewModel>(
      builder: (context, viewModel, child) {
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
              // --- Header Info Mahasiswa ---
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mahasiswa.namaLengkap,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            "${widget.mahasiswa.nim} - ${widget.mahasiswa.programStudi.namaProdi}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // --- Tab Bar ---
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF0F47AD),
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
              // --- Konten Tab Bar ---
              Expanded(
                child: _buildContent(viewModel),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(DokumenDosenViewModel viewModel) {
    switch (viewModel.dokumenState) {
      case ViewState.Loading:
        return Center(child: CircularProgressIndicator());
      case ViewState.Error:
        return Center(child: Text('Error: ${viewModel.dokumenErrorMessage}'));
      case ViewState.Success:
        return TabBarView(
          controller: _tabController,
          children: [
            buildDokumenList("Pending", viewModel.dokumenList),
            buildDokumenList("Disetujui", viewModel.dokumenList),
            buildDokumenList("Revisi", viewModel.dokumenList),
          ],
        );
      default: // Idle
        return SizedBox.shrink();
    }
  }

  Widget buildDokumenList(String status, List<DocumentDetails> allDokumen) {
    final filteredDokumen =
    allDokumen.where((doc) => doc.status == status).toList();

    if (filteredDokumen.isEmpty) {
      return Center(
        child: Text(
          "Belum ada dokumen $status",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredDokumen.length,
      itemBuilder: (context, index) => buildDokumenCard(filteredDokumen[index]),
    );
  }

  Widget buildDokumenCard(DocumentDetails dokumen) {
    String formattedDate =
    DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dokumen.uploadedAt);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 5,
              offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(dokumen.babDisplay,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F47AD),
                          fontFamily: 'Poppins'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: getStatusColor(dokumen.status),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(dokumen.status,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: getStatusTextColor(dokumen.status),
                        fontFamily: 'Poppins')),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text('Di Upload: $formattedDate',
              style: TextStyle(
                  fontSize: 13, color: Colors.black54, fontFamily: 'Poppins')),
          SizedBox(height: 4),
          Text(
              'Nama Dokumen: ${dokumen.namaDokumen}\nKeterangan: ${dokumen.catatanRevisi ?? "-"}',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  height: 1.5)),
          SizedBox(height: 12),
          Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,),
          SizedBox(height: 4),
          buildActionButtons(dokumen),
        ],
      ),
    );
  }

  Widget buildActionButtons(DocumentDetails dokumen) {
    final viewModel = Provider.of<DokumenDosenViewModel>(context, listen: false);
    final viewButton = _viewingDokumenId == dokumen.id
        ? Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(14.0),
      child: const CircularProgressIndicator(strokeWidth: 2.5),
    )
        : IconButton(
      onPressed: () async {
        setState(() => _viewingDokumenId = dokumen.id);

        final String? fileUrl = await viewModel.getSecureFileUrl(dokumen.id);

        if (fileUrl != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                fileUrl: fileUrl,
                documentTitle: dokumen.babDisplay,
              ),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    viewModel.dokumenErrorMessage.isNotEmpty
                        ? viewModel.dokumenErrorMessage
                        : 'Gagal memuat file.'
                )
            ),
          );
        }

        if (mounted) setState(() => _viewingDokumenId = null);
      },
      icon: Icon(Icons.visibility_outlined, color: Colors.black54),
      tooltip: "Lihat Dokumen",
    );

    final downloadButton = _downloadingDokumenId == dokumen.id
        ? Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(14.0),
      child: const CircularProgressIndicator(strokeWidth: 2.5),
    )
        : IconButton(
      onPressed: () async {
        setState(() => _downloadingDokumenId = dokumen.id);
        try {
          await viewModel.downloadFile(dokumen.id, dokumen.namaDokumen);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pengunduhan dimulai. Periksa status bar Anda.')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memulai unduhan: ${e.toString()}')),
            );
          }
        } finally {
          if (mounted) setState(() => _downloadingDokumenId = null);
        }
      },
      icon: Icon(Icons.download_outlined, color: Colors.black54),
      tooltip: "Unduh Dokumen",
    );

    if (dokumen.status == "Pending") {
      return Row(
        children: [
          viewButton,
          downloadButton,
          Spacer(),
          ElevatedButton(
            onPressed: () => showRevisiBottomSheet(dokumen),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFB3BA),
              foregroundColor: Color(0xFFE20030),
              padding: EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text("Revisi",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 15),
          ElevatedButton(
            onPressed: () async {
              try {
                await viewModel.approveDokumen(dokumen);

                _tabController.animateTo(1);
                if (mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text("Dokumen telah disetujui"),
                        backgroundColor: Colors.green));
                }
              } catch (e) {
                // Handle error
                if (mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text("Error: ${e.toString()}"),
                        backgroundColor: Colors.red));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB7FCC9),
              foregroundColor: Color(0xFF0A7D0C),
              padding: EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text("Setuju",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    } else {
      return Row(children: [viewButton, downloadButton]);
    }
  }

  /// Menampilkan bottom sheet untuk memberi catatan revisi
  void showRevisiBottomSheet(DocumentDetails dokumen) {
    final viewModel = Provider.of<DokumenDosenViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => CatatanDosenBottomSheet(
        title: 'Keterangan Revisi',
        hintText: 'Masukkan catatan revisi untuk mahasiswa...',
        onSave: (String catatanRevisi) {
          viewModel.reviseDokumen(dokumen, catatanRevisi);
          _tabController.animateTo(2);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Dokumen dipindahkan ke revisi"),
                backgroundColor: Colors.orange));
        },
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Pending": return Color(0xFFFFEEB7);
      case "Disetujui": return Color(0xFFB7FCC9);
      case "Revisi": return Color(0xFFFFB3BA);
      default: return Colors.grey;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case "Pending": return Color(0xFFFF8110);
      case "Disetujui": return Color(0xFF0A7D0C);
      case "Revisi": return Color(0xFFE20030);
      default: return Colors.black;
    }
  }

  void showUnduhDialog(DocumentDetails dokumen) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Unduh File Dokumen',
          contentWidget: Text(
            '${dokumen.namaDokumen}.pdf',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15, fontFamily: 'Poppins', height: 1.4),
          ),
          cancelText: 'Batal',
          confirmText: 'Unduh',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text("Fitur unduh belum diimplementasikan."),
                  backgroundColor: Colors.blue));
          },
        );
      },
    );
  }
}