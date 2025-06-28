
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PdfViewerScreen extends StatefulWidget {
  final String fileUrl;
  final String documentTitle;

  const PdfViewerScreen({
    super.key,
    required this.fileUrl,
    required this.documentTitle,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localFilePath;
  bool _isLoading = true;
  String _errorMessage = '';
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPdfFromUrl();
  }

  // Mengunduh file dari URL dan menyimpannya secara lokal
  Future<void> _loadPdfFromUrl() async {
    try {
      final uri = Uri.parse(widget.fileUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        // Buat nama file yang unik untuk menghindari masalah cache
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(uri.path)}';
        final file = File(p.join(dir.path, fileName));
        await file.writeAsBytes(response.bodyBytes);

        if (mounted) {
          setState(() {
            _localFilePath = file.path;
            _isLoading = false;
          });
        }
      } else {
        throw 'Gagal mengunduh file: Status ${response.statusCode}';
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentTitle),
        actions: _localFilePath != null && !_isLoading
            ? [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text('Hal: ${_currentPage + 1}/$_totalPages'),
            ),
          ),
        ]
            : [],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_errorMessage, textAlign: TextAlign.center),
        ),
      );
    }
    if (_localFilePath != null) {
      return PDFView(
        filePath: _localFilePath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        onRender: (pages) {
          if (mounted) setState(() => _totalPages = pages ?? 0);
        },
        onError: (error) {
          if (mounted) setState(() => _errorMessage = error.toString());
        },
        onPageError: (page, error) {
          if (mounted) setState(() => _errorMessage = 'Halaman $page: ${error.toString()}');
        },
        onPageChanged: (page, total) {
          if (mounted) setState(() => _currentPage = page ?? 0);
        },
      );
    }
    return const Center(child: Text('File tidak dapat ditampilkan.'));
  }
}