import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/presentation/common_widgets/dialogs/custom_dialog.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/edit_document_bottom_sheet.dart';
import 'package:digita_mobile/viewmodels/dokumen_mahasiswa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/screens/pdf_viewer_screen.dart';

enum DocumentStatus { pending, revisi, disetujui }

class UploadedDocumentCard extends StatefulWidget {
  final DocumentDetails details;

  const UploadedDocumentCard({
    super.key,
    required this.details,
  });

  @override
  State<UploadedDocumentCard> createState() => _UploadedDocumentCardState();
}

class _UploadedDocumentCardState extends State<UploadedDocumentCard> {
  bool _isTryingToView = false;

  DocumentStatus _parseStatus(String? apiStatus) {
    switch (apiStatus?.toLowerCase()) {
      case 'pending':
        return DocumentStatus.pending;
      case 'revisi':
        return DocumentStatus.revisi;
      case 'disetujui':
        return DocumentStatus.disetujui;
      default:
        return DocumentStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DokumenViewModel>(context, listen: false);
    final status = _parseStatus(widget.details.status);

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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.details.babDisplay,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 16),
                        ),
                      ),
                      _buildStatusBadge(status),
                    ],
                  ),
                  Text(
                    viewModel.formatDateTime(widget.details.uploadedAt),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Keterangan: ${widget.details.catatanRevisi ?? '-'}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Divider(thickness: 5, color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildActionButtons(context, status, widget.details, viewModel),
          ),
        ],
      ),
    );
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

  Widget _buildActionButtons(BuildContext context, DocumentStatus status,
      DocumentDetails details, DokumenViewModel viewModel) {
    final buttonColor = Colors.black;

    final viewButton = _isTryingToView
        ? Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(14.0),
      child: const CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
    )
        : IconButton(
      onPressed: () async {
        setState(() { _isTryingToView = true; });

        final String? fileUrl = await viewModel.getSecureFileUrl(details.id);

        if (fileUrl != null && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                fileUrl: fileUrl,
                documentTitle: details.babDisplay,
              ),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.errorMessage ?? 'Gagal memuat file.')),
          );
        }

        if (mounted) {
          setState(() { _isTryingToView = false; });
        }
      },
      icon: Icon(Icons.visibility_outlined, color: buttonColor),
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
          builder: (_) => ChangeNotifierProvider.value(
            value: viewModel,
            child: EditDocumentBottomSheet(details: details),
          ),
        );
      },
      icon: Icon(Icons.edit_outlined, color: buttonColor),
    );

    final deleteButton = IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CustomDialog(
            title: 'Hapus File Dokumen',
            contentWidget: const Text(
              'Apakah Anda yakin ingin menghapus file ini?',
            ),
            confirmText: 'Hapus',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () async {
              Navigator.of(context).pop(); // Close dialog
              final success = await viewModel.deleteDokumen(id: details.id);
              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dokumen berhasil dihapus!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            viewModel.errorMessage ?? 'Gagal menghapus dokumen.')),
                  );
                }
              }
            },
          ),
        );
      },
      icon: Icon(Icons.delete_outline, color: buttonColor),
    );

    switch (status) {
      case DocumentStatus.pending:
        return Row(children: [viewButton, editButton, deleteButton]);
      case DocumentStatus.revisi:
        return Row(children: [viewButton, editButton]);
      case DocumentStatus.disetujui:
        return Row(children: [viewButton]);
    }
  }
}