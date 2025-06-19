import 'package:digita_mobile/presentation/common_widgets/dialogs/dialog.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/edit_document_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DocumentStatus { pending, revisi, disetujui }

class UploadedDocumentCard extends StatefulWidget {
  final String title;
  final String dateTime;
  final String note;
  final DocumentStatus status;

  const UploadedDocumentCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.note,
    required this.status,
  });

  @override
  State<UploadedDocumentCard> createState() => _UploadedDocumentCardState();
}

class _UploadedDocumentCardState extends State<UploadedDocumentCard> {
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
            offset: Offset(0, 4),
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
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                        ),
                      ),
                      _buildStatusBadge(widget.status),
                    ],
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
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildActionButtons(context, widget.status),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusBadge(DocumentStatus status) {
  Color color;
  String label;

  switch (status) {
    case DocumentStatus.pending:
      color = Colors.orange;
      label = 'Pending';
      break;
    case DocumentStatus.revisi:
      color = Colors.red;
      label = 'Revisi';
      break;
    case DocumentStatus.disetujui:
      color = Colors.green;
      label = 'Disetujui';
      break;
  }

  return Container(
    width: 80,
    padding: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: color.withAlpha(75),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Center(
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ),
  );
}

Widget _buildActionButtons(BuildContext context, DocumentStatus status) {
  final buttonColor = Colors.black;

  final downloadButton = IconButton(
    onPressed: () {
      showDialog(
        context: context,
        builder:
            (_) => CustomDialog(
              title: 'Unduh File Dokumen',
              contentWidget: Text(
                'BAB III: Analisis dan Perancangan.pdf',
                style: GoogleFonts.poppins(
                  decoration: TextDecoration.underline,
                ),
              ),
              confirmText: 'Unduh',
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () {},
            ),
      );
    },
    icon: Icon(Icons.file_download_outlined, color: buttonColor),
  );

  final editButton = IconButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (_) => const EditDocumentBottomSheet(),
      );
    },
    icon: Icon(Icons.edit_outlined, color: buttonColor),
  );

  final deleteButton = IconButton(
    onPressed: () {
      showDialog(
        context: context,
        builder:
            (_) => CustomDialog(
              title: 'Hapus File Dokumen',
              contentWidget: const Text(
                'Apakah kamu yakin ingin menghapus file?',
              ),
              confirmText: 'Hapus',
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () {},
            ),
      );
    },
    icon: Icon(Icons.delete_outline, color: buttonColor),
  );

  switch (status) {
    case DocumentStatus.pending:
      return Row(children: [downloadButton, editButton, deleteButton]);
    case DocumentStatus.revisi:
      return Row(children: [downloadButton, editButton]);
    case DocumentStatus.disetujui:
      return Row(children: [downloadButton]);
  }
}
