import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.file_download_outlined, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.edit_outlined, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.delete_outline, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
