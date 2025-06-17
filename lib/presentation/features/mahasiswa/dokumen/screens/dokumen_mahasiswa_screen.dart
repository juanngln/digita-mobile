import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/dokumen_sudah_upload_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/dokumen_belum_upload_card.dart';
import 'package:flutter/material.dart';

class DokumenMahasiswaScreen extends StatefulWidget {
  const DokumenMahasiswaScreen({super.key});

  @override
  State<DokumenMahasiswaScreen> createState() => _DokumenMahasiswaScreen();
}

class _DokumenMahasiswaScreen extends State<DokumenMahasiswaScreen> {
  final List<Map<String, String>> uploadedDocument = [
    {
      'title': 'BAB III: Analisis dan Perancangan',
      'dateTime': '07 Maret 2025, 14:00',
      'note': '-',
    },
    {
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
                  child: Text( // MODIFIED HERE
                    'Sudah Upload',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: uploadedDocument.length,
                    itemBuilder: (context, index) {
                      return UploadedDocumentCard(
                        title: uploadedDocument[index]['title']!,
                        dateTime: uploadedDocument[index]['dateTime']!,
                        note: uploadedDocument[index]['note']!,
                      );
                    }),
                // Belum Upload Section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text( // MODIFIED HERE
                    'Belum Upload',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: uploadedYetDocument.length,
                    itemBuilder: (context, index) {
                      return UploadedYetDocumentCard(
                        title: uploadedYetDocument[index]['title']!,
                        dateTime: uploadedYetDocument[index]['dateTime']!,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}