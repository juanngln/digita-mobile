// lib/viewmodels/dokumen_viewmodel.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/services/dokumen_service.dart';
import 'package:intl/intl.dart';

class DokumenViewModel extends ChangeNotifier {
  final DokumenService _dokumenService = DokumenService();

  List<DokumenStatusChecklist> _uploadedDocuments = [];
  List<DokumenStatusChecklist> _notUploadedDocuments = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isUploading = false;


  List<DokumenStatusChecklist> get uploadedDocuments => _uploadedDocuments;
  List<DokumenStatusChecklist> get notUploadedDocuments => _notUploadedDocuments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isUploading => _isUploading;

  Future<void> fetchDokumenStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final allDocuments = await _dokumenService.getDokumenStatus();
      _uploadedDocuments =
          allDocuments.where((doc) => doc.isUploaded).toList();
      _notUploadedDocuments =
          allDocuments.where((doc) => !doc.isUploaded).toList();
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
      // Refresh the document list after successful upload
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

  String formatDateTime(DateTime dt) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt);
  }
}
