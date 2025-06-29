import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/pengumuman_viewmodel.dart';

class PengumumanDetailDialog extends StatefulWidget {
  final String title;
  final String description;
  final String tglMulai;
  final String tglSelesai;
  final String? attachment;
  final String? lampiranUrl;

  const PengumumanDetailDialog({
    super.key,
    required this.title,
    required this.description,
    required this.tglMulai,
    required this.tglSelesai,
    this.attachment,
    this.lampiranUrl,
  });

  @override
  State<PengumumanDetailDialog> createState() => _PengumumanDetailDialogState();
}

class _PengumumanDetailDialogState extends State<PengumumanDetailDialog> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    final viewModel = Provider.of<PengumumanViewModel>(context, listen: false);

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Judul Pengumuman
              Text(
                widget.title,
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              // Tanggal Berlaku
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.tglMulai} - ${widget.tglSelesai}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Deskripsi Pengumuman
              Text(
                widget.description,
                style: GoogleFonts.poppins(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 22),
              if (widget.attachment != null && widget.attachment!.isNotEmpty && widget.lampiranUrl != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _isDownloading
                        ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : const Icon(Icons.download_rounded),
                    label: Text(
                      _isDownloading ? 'Mengunduh...' : 'Unduh Lampiran',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _isDownloading
                        ? null // Disable button while processing
                        : () async {
                      setState(() => _isDownloading = true);
                      try {
                        // This now calls the flutter_downloader method in the ViewModel
                        await viewModel.downloadFile(widget.lampiranUrl!, widget.attachment!);

                        if (mounted) {
                          // Show the same message as in status_dokumen_dosen_screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pengunduhan dimulai. Periksa status bar Anda.')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isDownloading = false);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF0F47AD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              // Tombol Tutup
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Avatar Ikon di atas konten
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: const Color(0xFF0F47AD),
            radius: 45,
            child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 50),
          ),
        ),
      ],
    );
  }
}