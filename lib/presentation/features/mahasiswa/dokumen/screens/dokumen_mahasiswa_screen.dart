import 'package:digita_mobile/presentation/common_widgets/subtitle.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/not_uploaded_document_card.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/widgets/uploaded_document_card.dart';
import 'package:digita_mobile/viewmodels/dokumen_mahasiswa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DokumenMahasiswaScreen extends StatefulWidget {
  const DokumenMahasiswaScreen({super.key});

  @override
  State<DokumenMahasiswaScreen> createState() => _DokumenMahasiswaScreenState();
}

class _DokumenMahasiswaScreenState extends State<DokumenMahasiswaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DokumenViewModel>(context, listen: false).fetchDokumenStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<DokumenViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dokumen Tugas Akhir',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Subtitle(text: 'Sudah Upload'),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.uploadedDocuments.length,
                      itemBuilder: (context, index) {
                        final doc = viewModel.uploadedDocuments[index];
                        // Pass the entire details object to the card
                        if (doc.documentDetails == null) {
                          return const SizedBox.shrink(); // or an error widget
                        }
                        return UploadedDocumentCard(
                          details: doc.documentDetails!,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Subtitle(text: 'Belum Upload'),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.notUploadedDocuments.length,
                      itemBuilder: (context, index) {
                        final doc = viewModel.notUploadedDocuments[index];
                        return NotUploadedDocumentCard(
                          title: doc.bab,
                          dateTime: 'Belum diunggah',
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}