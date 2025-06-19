import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/not_uploaded_document_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/uploaded_document_card.dart';
import 'package:flutter/material.dart';

class DokumenMahasiswaScreen extends StatefulWidget {
  const DokumenMahasiswaScreen({super.key});

  @override
  State<DokumenMahasiswaScreen> createState() => _DokumenMahasiswaScreen();
}

class _DokumenMahasiswaScreen extends State<DokumenMahasiswaScreen> {
  final List<Map<String, dynamic>> uploadedDocument = [
    {
      'status': 'pending',
      'title': 'BAB III: Analisis dan Perancangan',
      'dateTime': '07 Maret 2025, 14:00',
      'note': '-',
    },
    {
      'status': 'revisi',
      'title': 'BAB II: Landasan Teori',
      'dateTime': '10 Maret 2025, 10:00',
      'note': 'Struktur penulisan kurang sistematis',
    },
    {
      'status': 'disetujui',
      'title': 'BAB II: Landasan Teori',
      'dateTime': '10 Maret 2025, 10:00',
      'note': 'Struktur penulisan kurang sistematis',
    },
  ];

  final List<Map<String, String>> uploadedYetDocument = [
    {
      'title': 'BAB IV: Implementasi dan Pembahasan',
      'dateTime': '07 Maret 2025, 14:00',
    },
    {
      'title': 'BAB V: Kesimpulan dan Saran',
      'dateTime': '10 Maret 2025, 10:00',
    },
  ];

  DocumentStatus parseStatus(String? value) {
    switch (value) {
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dokumen Tugas Akhir',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // Sudah Upload Section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Subtitle(text: 'Sudah Upload'),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: uploadedDocument.length,
                  itemBuilder: (context, index) {
                    return UploadedDocumentCard(
                      status: parseStatus(uploadedDocument[index]['status']),
                      title: uploadedDocument[index]['title']!,
                      dateTime: uploadedDocument[index]['dateTime']!,
                      note: uploadedDocument[index]['note']!,
                    );
                  },
                ),
                // Belum Upload Section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Subtitle(text: 'Belum Upload'),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: uploadedYetDocument.length,
                  itemBuilder: (context, index) {
                    return NotUploadedDocumentCard(
                      title: uploadedYetDocument[index]['title']!,
                      dateTime: uploadedYetDocument[index]['dateTime']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
