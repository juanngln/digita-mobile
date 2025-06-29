import 'package:flutter/material.dart';
import 'package:digita_mobile/models/pengumuman.dart';
import 'package:digita_mobile/services/pengumuman_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

enum PengumumanState { initial, loading, loaded, error }

class PengumumanViewModel extends ChangeNotifier {
  final PengumumanService _pengumumanService = PengumumanService();
  List<Pengumuman> _announcements = [];
  PengumumanState _state = PengumumanState.initial;

  List<Pengumuman> get announcements => _announcements;

  PengumumanState get state => _state;

  Future<void> fetchAnnouncements() async {
    _state = PengumumanState.loading;
    notifyListeners();
    try {
      _announcements = await _pengumumanService.fetchAnnouncements();
      _state = PengumumanState.loaded;
    } catch (e) {
      print('Gagal mengambil data pengumuman: $e');
      _state = PengumumanState.error;
    }
    notifyListeners();
  }

  Future<void> downloadFile(String downloadUrl, String fileName) async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      final Directory? externalDir = await getExternalStorageDirectory();
      final String savePath = externalDir!.path;

      await FlutterDownloader.enqueue(
        url: downloadUrl,
        savedDir: savePath,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
    } else {
      throw Exception("Izin notifikasi ditolak. Tidak dapat mengunduh.");
    }
  }
}