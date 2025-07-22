import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/services/base_url.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class DokumenService {
  final http.Client _client;
  final SecureStorageService _secureStorageService;

  DokumenService({
    SecureStorageService? secureStorageService,
    http.Client? client,
  }) : _secureStorageService = secureStorageService ?? SecureStorageService(),
       _client = client ?? http.Client();

  Future<List<DokumenStatusChecklist>> getDokumenStatus() async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token == null) {
      throw NetworkException(
        'Authentication token not found. Please log in again.',
      );
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/status-checklist/',
    );

    try {
      final response = await _client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return responseData
            .map(
              (data) =>
                  DokumenStatusChecklist.fromJson(data as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw NetworkException(
          "Gagal memuat dokumen. Status: ${response.statusCode}, Pesan: ${response.body}",
        );
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Pastikan server backend Anda berjalan dan periksa alamat IP di base_url.dart.",
      );
    } on TimeoutException {
      throw NetworkException(
        "Koneksi timeout. Server tidak merespons tepat waktu.",
      );
    } catch (e) {
      if (kDebugMode) print("Error in getDokumenStatus: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan tidak dikenal: $e");
    }
  }

  Future<DocumentDetails> uploadDokumen({
    required String namaDokumen,
    required String bab,
    required File file,
  }) async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token == null) {
      throw NetworkException(
        'Authentication token not found. Please log in again.',
      );
    }

    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/');

    try {
      var request =
          http.MultipartRequest('POST', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['nama_dokumen'] = namaDokumen
            ..fields['bab'] = bab
            ..files.add(
              await http.MultipartFile.fromPath(
                'file',
                file.path,
                filename: basename(file.path),
              ),
            );

      final streamedResponse = await request.send().timeout(
        AppConfig.apiTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return DocumentDetails.fromJson(responseData);
      } else {
        throw NetworkException(
          "Gagal mengunggah dokumen. Status: ${response.statusCode}, Pesan: ${response.body}",
        );
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi Anda.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout. Server tidak merespons.");
    } catch (e) {
      if (kDebugMode) print("Error in uploadDokumen: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan saat mengunggah: $e");
    }
  }

  Future<DocumentDetails> editDokumen({
    required int id,
    required String namaDokumen,
    File? file,
  }) async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token == null) {
      throw NetworkException(
        'Authentication token not found. Please log in again.',
      );
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/$id/',
    );

    try {
      var request =
          http.MultipartRequest('PATCH', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['nama_dokumen'] = namaDokumen;

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: basename(file.path),
          ),
        );
      }

      final streamedResponse = await request.send().timeout(
        AppConfig.apiTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return DocumentDetails.fromJson(responseData);
      } else {
        throw NetworkException(
          "Gagal mengedit dokumen. Status: ${response.statusCode}, Pesan: ${response.body}",
        );
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi Anda.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout. Server tidak merespons.");
    } catch (e) {
      if (kDebugMode) print("Error in editDokumen: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan saat mengedit: $e");
    }
  }

  /// Fetches a temporary, pre-signed URL to access a document file.
  Future<String> getAccessFileUrl(int id) async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token == null) {
      throw NetworkException(
        'Authentication token not found. Please log in again.',
      );
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/$id/access-file/',
    );

    try {
      final response = await _client
          .get(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        if (responseData.containsKey('url')) {
          return responseData['url'];
        } else {
          throw NetworkException(
            'Kunci "url" tidak ditemukan dalam respons API.',
          );
        }
      } else {
        throw NetworkException(
          "Gagal mendapatkan akses file. Status: ${response.statusCode}, Pesan: ${response.body}",
        );
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi Anda.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout. Server tidak merespons.");
    } catch (e) {
      if (kDebugMode) print("Error in getAccessFileUrl: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan saat mendapatkan URL: $e");
    }
  }

  /// Deletes a document by its ID.
  Future<void> deleteDokumen({required int id}) async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token == null) {
      throw NetworkException(
        'Authentication token not found. Please log in again.',
      );
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/$id/',
    );

    try {
      final response = await _client
          .delete(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw NetworkException(
          "Gagal menghapus dokumen. Status: ${response.statusCode}, Pesan: ${response.body}",
        );
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi Anda.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout. Server tidak merespons.");
    } catch (e) {
      if (kDebugMode) print("Error in deleteDokumen: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan saat menghapus: $e");
    }
  }

  void dispose() {
    _client.close();
  }
}
