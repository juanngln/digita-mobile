import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/edit_dokumen_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/dialog.dart';

class UploadedDocumentCard extends StatefulWidget {
  final String title;
  final String dateTime;
  final String note;

  const UploadedDocumentCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.note,
  });

  @override
  State<UploadedDocumentCard> createState() => _UploadedDocumentCardState();
}

class _UploadedDocumentCardState extends State<UploadedDocumentCard> {

  void _showUnduhDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Unduh File Dokumen',
          contentWidget: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
          confirmText: 'Unduh',
          onConfirm: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dokumen mulai diunduh...')),
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Hapus File Dokumen',
          contentWidget: Text(
            'Apakah kamu yakin ingin Menghapus File?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          confirmText: 'Hapus',
          onConfirm: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dokumen berhasil dihapus')),
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                  Text(
                    widget.dateTime,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Keterangan: ${widget.note}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(thickness: 5, color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _showUnduhDialog,
                  icon: const Icon(Icons.file_download_outlined, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      builder: (BuildContext ctx) {
                        return const EditDocumentBottomSheet();
                      },
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, color: Colors.black),
                ),
                IconButton(
                  onPressed: _showDeleteDialog,
                  icon: const Icon(Icons.delete_outline, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
