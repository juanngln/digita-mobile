import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:digita_mobile/models/list_mahasiswa_bimbingan.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'base_url.dart';
import 'package:flutter/foundation.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class DokumenDosenService {
  final SecureStorageService _secureStorage;
  final http.Client _client;

  DokumenDosenService({
    SecureStorageService? secureStorage,
    http.Client? client,
  }) : _secureStorage = secureStorage ?? SecureStorageService(),
       _client = client ?? http.Client();

  Future<List<ListMahasiswaBimbingan>> fetchSupervisedStudents() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Autentikasi gagal: Token tidak ditemukan.');
    }
    final response = await _client.get(
      Uri.parse(
        '${AppConfig.baseUrl}/api/v1/tugas-akhir/dosen/supervised-students/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody
          .map((data) => ListMahasiswaBimbingan.fromJson(data))
          .toList();
    } else {
      throw Exception('Gagal memuat mahasiswa: ${response.statusCode}');
    }
  }

  Future<List<DocumentDetails>> fetchDokumenMahasiswa(int mahasiswaId) async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Autentikasi gagal: Token tidak ditemukan.');
    }
    final response = await _client.get(
      Uri.parse(
        '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/?mahasiswa_id=$mahasiswaId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody
          .map((data) => DocumentDetails.fromJson(data))
          .toList();
    } else {
      throw Exception('Gagal memuat dokumen: ${response.statusCode}');
    }
  }

  Future<DocumentDetails> updateDokumenStatus({
    required int dokumenId,
    required String status,
    String? catatanRevisi,
  }) async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw Exception('Autentikasi gagal: Token tidak ditemukan.');
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/$dokumenId/update-status/',
    );

    final body = {'status': status, 'catatan_revisi': catatanRevisi ?? ''};

    final response = await _client.patch(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      return DocumentDetails.fromJson(responseBody);
    } else {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(
        'Gagal memperbarui status dokumen: ${errorBody['detail'] ?? response.reasonPhrase}',
      );
    }
  }

  Future<String> getAccessFileUrl(int dokumenId) async {
    final String? token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw NetworkException(
        'Authentication token not found. Please log in again.',
      );
    }

    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/$dokumenId/access-file/',
    );

    try {
      final response = await _client
          .get(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        if (responseData.containsKey('url') && responseData['url'] != null) {
          return responseData['url'];
        } else {
          throw NetworkException(
            'Kunci "url" tidak ditemukan atau null dalam respons API.',
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
      throw NetworkException(
        "Koneksi timeout. Server tidak merespons tepat waktu.",
      );
    } catch (e) {
      if (kDebugMode) print("Error in getAccessFileUrl (Dosen): $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan saat mendapatkan URL: $e");
    }
  }

  Future<String> getDownloadFileUrl(int dokumenId) async {
    final String? token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw NetworkException('Authentication token not found.');
    }

    // Note the added query parameter '?action=download'
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/dokumen/$dokumenId/access-file/?action=download',
    );

    try {
      final response = await _client
          .get(url, headers: {'Authorization': 'Bearer $token'})
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        if (responseData.containsKey('url') && responseData['url'] != null) {
          return responseData['url'];
        } else {
          throw NetworkException(
            'Kunci "url" tidak ditemukan dalam respons API.',
          );
        }
      } else {
        throw NetworkException(
          "Gagal mendapatkan link unduhan. Status: ${response.statusCode}",
        );
      }
    } on SocketException {
      throw NetworkException("Tidak dapat terhubung ke server.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout.");
    } catch (e) {
      if (kDebugMode) print("Error in getDownloadFileUrl (Dosen): $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Terjadi kesalahan: $e");
    }
  }
}
