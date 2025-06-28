import 'package:flutter/material.dart';
import 'package:digita_mobile/models/list_mahasiswa_bimbingan.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/services/dokumen_dosen_service.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum ViewState { Idle, Loading, Success, Error }

class DokumenDosenViewModel extends ChangeNotifier {
  final DokumenDosenService _service = DokumenDosenService();
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  // --- State untuk Layar Daftar Mahasiswa ---
  ViewState _mahasiswaState = ViewState.Idle;
  ViewState get mahasiswaState => _mahasiswaState;
  List<ListMahasiswaBimbingan> _mahasiswaList = [];
  List<ListMahasiswaBimbingan> get mahasiswaList => _mahasiswaList;
  String _mahasiswaErrorMessage = '';
  String get mahasiswaErrorMessage => _mahasiswaErrorMessage;

  Future<void> fetchMahasiswaBimbingan() async {
    _mahasiswaState = ViewState.Loading;
    notifyListeners();
    try {
      _mahasiswaList = await _service.fetchSupervisedStudents();
      _mahasiswaState = ViewState.Success;
    } catch (e) {
      _mahasiswaErrorMessage = e.toString();
      _mahasiswaState = ViewState.Error;
    }
    notifyListeners();
  }

  // --- State untuk Layar Status Dokumen ---
  ViewState _dokumenState = ViewState.Idle;
  ViewState get dokumenState => _dokumenState;
  List<DocumentDetails> _dokumenList = [];
  List<DocumentDetails> get dokumenList => _dokumenList;
  String _dokumenErrorMessage = '';
  String get dokumenErrorMessage => _dokumenErrorMessage;

  Future<void> fetchDokumen(int mahasiswaId) async {
    _dokumenState = ViewState.Loading;
    _dokumenList = [];
    notifyListeners();
    try {
      _dokumenList = await _service.fetchDokumenMahasiswa(mahasiswaId);
      _dokumenState = ViewState.Success;
    } catch (e) {
      _dokumenErrorMessage = e.toString();
      _dokumenState = ViewState.Error;
    }
    notifyListeners();
  }

  // --- Aksi untuk Dokumen ---
  void _updateAndNotify(DocumentDetails updatedDokumen) {
    final index = _dokumenList.indexWhere((d) => d.id == updatedDokumen.id);
    if (index != -1) {
      _dokumenList[index] = updatedDokumen;
      notifyListeners();
    }
  }

  Future<void> approveDokumen(DocumentDetails dokumen) async {
    try {
      final updatedDokumen = await _service.updateDokumenStatus(
        dokumenId: dokumen.id,
        status: "Disetujui",
      );
      _updateAndNotify(updatedDokumen);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reviseDokumen(DocumentDetails dokumen, String catatan) async {
    try {
      final updatedDokumen = await _service.updateDokumenStatus(
        dokumenId: dokumen.id,
        status: "Revisi",
        catatanRevisi: catatan,
      );
      _updateAndNotify(updatedDokumen);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getSecureFileUrl(int id) async {
    _dokumenErrorMessage = ''; // Clear previous errors
    try {
      final String url = await _service.getAccessFileUrl(id);
      return url;
    } catch (e) {
      _dokumenErrorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> downloadFile(int dokumenId, String fileName) async {
    _isDownloading = true;
    notifyListeners();

    try {
      final status = await Permission.notification.request();

      if (status.isGranted) {
        final Directory? downloadsDir = await getExternalStorageDirectory();
        final String? savePath = downloadsDir?.path;

        if (savePath == null) {
          throw Exception("Tidak dapat menemukan direktori penyimpanan eksternal.");
        }

        final String downloadUrl = await _service.getDownloadFileUrl(dokumenId);

        await FlutterDownloader.enqueue(
          url: downloadUrl,
          savedDir: savePath,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true,
        );
      } else {
        _dokumenErrorMessage = "Izin notifikasi ditolak. Tidak dapat mengunduh.";
        throw Exception(_dokumenErrorMessage);
      }
    } catch (e) {
      _dokumenErrorMessage = e.toString();
      rethrow;
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }
}