import 'dart:io';

import 'package:flutter/material.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/services/dokumen_mahasiswa_service.dart';
import 'package:intl/intl.dart';

class DokumenViewModel extends ChangeNotifier {
  final DokumenService _dokumenService = DokumenService();
  bool _isFetchingViewUrl = false;
  bool get isFetchingViewUrl => _isFetchingViewUrl;
  double _progressPercentage = 0.0;
  double get progressPercentage => _progressPercentage;
  List<DokumenStatusChecklist> _uploadedDocuments = [];
  List<DokumenStatusChecklist> _notUploadedDocuments = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isUploading = false;
  bool _isUpdating = false; // State for editing
  bool _isDeleting = false; // State for deleting

  List<DokumenStatusChecklist> get uploadedDocuments => _uploadedDocuments;
  List<DokumenStatusChecklist> get notUploadedDocuments => _notUploadedDocuments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isUploading => _isUploading;
  bool get isUpdating => _isUpdating; // Getter for editing state
  bool get isDeleting => _isDeleting; // Getter for deleting state

  void calculateProgress() {
    const double totalDocuments = 6.0;
    final int approvedCount = uploadedDocuments
        .where((doc) => doc.documentDetails?.status?.toLowerCase() == 'disetujui')
        .length;

    if (totalDocuments > 0) {
      _progressPercentage = approvedCount / totalDocuments;
    } else {
      _progressPercentage = 0.0;
    }
  }

  Future<void> fetchDokumenStatus() async {
    _isLoading = true;
    _errorMessage = null;
    // REMOVE calculateProgress(); from here.
    notifyListeners();

    try {
      final allDocuments = await _dokumenService.getDokumenStatus();
      _uploadedDocuments =
          allDocuments.where((doc) => doc.isUploaded).toList();
      _notUploadedDocuments =
          allDocuments.where((doc) => !doc.isUploaded).toList();

      // PASTE IT HERE, after the lists are updated.
      calculateProgress();

    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> uploadDokumen({
    required String namaDokumen,
    required String bab,
    required File file,
  }) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dokumenService.uploadDokumen(
        namaDokumen: namaDokumen,
        bab: bab,
        file: file,
      );
      await fetchDokumenStatus();
      return true;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = "Terjadi kesalahan saat mengunggah: $e";
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<bool> editDokumen({
    required int id,
    required String namaDokumen,
    File? file,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dokumenService.editDokumen(
        id: id,
        namaDokumen: namaDokumen,
        file: file,
      );
      await fetchDokumenStatus();
      return true;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = "Terjadi kesalahan saat memperbarui: $e";
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteDokumen({required int id}) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dokumenService.deleteDokumen(id: id);
      await fetchDokumenStatus();
      return true;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = "Terjadi kesalahan saat menghapus: $e";
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  Future<String?> getSecureFileUrl(int id) async {
    _isFetchingViewUrl = true;
    _errorMessage = null;
    notifyListeners();
    String? url;

    try {
      url = await _dokumenService.getAccessFileUrl(id);
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = "Gagal mendapatkan URL file: $e";
    } finally {
      _isFetchingViewUrl = false;
      notifyListeners();
    }
    return url;
  }

  String formatDateTime(DateTime dt) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt);
  }
}