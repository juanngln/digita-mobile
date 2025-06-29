import 'package:digita_mobile/presentation/common_widgets/dialogs/pengumuman_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/pengumuman_viewmodel.dart';

class PengumumanCard extends StatefulWidget {
  final String title;
  final String description;
  final String tglMulai;
  final String tglSelesai;
  final String? attachment;
  final String? lampiranUrl;

  const PengumumanCard({
    super.key,
    required this.title,
    required this.description,
    required this.tglMulai,
    required this.tglSelesai,
    this.attachment,
    this.lampiranUrl,
  });

  @override
  State<PengumumanCard> createState() => _PengumumanCardState();
}

class _PengumumanCardState extends State<PengumumanCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The text content should be flexible.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Wrap the description Text in an Expanded widget.
                // This makes it fill the remaining space without overflowing.
                Expanded(
                  child: Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // The button is aligned to the bottom.
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 32,
              child: TextButton(
                onPressed: () {
                  final pengumumanViewModel = Provider.of<PengumumanViewModel>(context, listen: false);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider.value(
                          value: pengumumanViewModel,
                          child: PengumumanDetailDialog(
                          title: widget.title,
                          description: widget.description,
                          tglMulai: widget.tglMulai,
                          tglSelesai: widget.tglSelesai,
                          attachment: widget.attachment,
                          lampiranUrl: widget.lampiranUrl,
                      )
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF0F47AD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Lihat',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}