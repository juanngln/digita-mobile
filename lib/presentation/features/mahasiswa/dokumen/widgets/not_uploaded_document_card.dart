import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/upload_document_bottom_sheet.dart';
import 'package:digita_mobile/viewmodels/dokumen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotUploadedDocumentCard extends StatefulWidget {
  final String title;
  final String dateTime;

  const NotUploadedDocumentCard({
    super.key,
    required this.title,
    required this.dateTime,
  });

  @override
  State<NotUploadedDocumentCard> createState() => _NotUploadedDocumentCardState();
}

class _NotUploadedDocumentCardState extends State<NotUploadedDocumentCard> {
  @override
  Widget build(BuildContext context) {
    // Get the ViewModel instance from the context.
    final dokumenViewModel = Provider.of<DokumenViewModel>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 150,
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
      // Restoring original padding
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restoring original text style
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.dateTime,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  useSafeArea: true,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  showDragHandle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (BuildContext innerContext) {
                    // Provide the existing ViewModel to the bottom sheet
                    return ChangeNotifierProvider.value(
                      value: dokumenViewModel,
                      child: UploadDocumentBottomSheet(bab: widget.title),
                    );
                  },
                );
              },
              // Restoring original button style
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Upload',
                // Restoring original button text style
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
