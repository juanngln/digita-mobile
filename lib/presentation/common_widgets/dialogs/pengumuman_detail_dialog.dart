import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PengumumanDetailDialog extends StatelessWidget {
  final String title;
  final String description;
  final String tglMulai;
  final String tglSelesai;
  final String? attachment;

  const PengumumanDetailDialog({
    super.key,
    required this.title,
    required this.description,
    required this.tglMulai,
    required this.tglSelesai,
    this.attachment,
  });

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
                title,
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
                  '$tglMulai - $tglSelesai',
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
                description,
                style: GoogleFonts.poppins(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 22),
              if (attachment != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.attachment_rounded),
                    label: Text('Lihat Lampiran', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuka lampiran: $attachment')),
                      );
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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
