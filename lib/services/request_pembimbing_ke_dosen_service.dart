import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class RequestPembimbingKeDosenService {
  // --- Base URL Configuration ---
  // Gunakan 10.0.2.2 untuk Android emulator untuk access ke localhost/127.0.0.1
  /* jika menggunakan android device asli
     Ganti alamat ip menggunakan alamat ip laptop/komputermu */
  static const String _baseUrl =
      kReleaseMode
          ? "YOUR_PRODUCTION_API_URL"
          : "https://digita-admin-api.onrender.com";
          //: "http://10.0.2.2:8000";


  final http.Client _client;

  RequestPembimbingKeDosenService({http.Client? client})
    : _client = client ?? http.Client();

  Future<void> submitPengajuan({
    required String token,
    required int dosenId,
    required String alasanMemilihDosen,
    required String rencanaJudul,
    required String rencanaDeskripsi,
  }) async {
    final url = Uri.parse('$_baseUrl/api/ta/request-dosen/');
    final Map<String, dynamic> requestBody = {
      "dosen_id": dosenId,
      "alasan_memilih_dosen": alasanMemilihDosen,
      "rencana_judul": rencanaJudul,
      "rencana_deskripsi": rencanaDeskripsi,
    };
    final String jsonBody = jsonEncode(requestBody);

    if (kDebugMode) {
      print("--- Submitting Thesis Proposal ---");
      print("URL: $url");
      print("Body: $jsonBody");

      print("----------------------------------");
    }

    try {
      final response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonBody,
          )
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print("Submission Response Status: ${response.statusCode}");
        print("Submission Response Body: ${response.body}");
      }

      if (response.statusCode == 201) {
        return;
      } else {
        String errorMessage = "Gagal mengirim pengajuan.";
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody is Map<String, dynamic>) {
            if (responseBody.containsKey('detail')) {
              errorMessage = responseBody['detail'].toString();
            } else if (responseBody.entries.isNotEmpty) {
              errorMessage = responseBody.entries
                  .map((entry) => '${entry.key}: ${entry.value.toString()}')
                  .join(', ');
            } else {
              errorMessage =
                  "Gagal mengirim pengajuan (Status: ${response.statusCode})";
            }
          } else {
            errorMessage =
                "Gagal mengirim pengajuan (Status: ${response.statusCode})";
          }
        } catch (_) {
          errorMessage =
              "Gagal mengirim pengajuan (Status: ${response.statusCode}, respons tidak valid)";
        }
        throw NetworkException(errorMessage);
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
      );
    } on HttpException {
      throw NetworkException(
        "Gagal menemukan layanan pengajuan. Periksa alamat server.",
      );
    } on FormatException {
      throw NetworkException("Format data pengajuan tidak valid.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat mengirim pengajuan.");
    } catch (e) {
      if (e is NetworkException) rethrow;
      if (kDebugMode) print("Unknown error submitting proposal in Service: $e");
      throw Exception(
        "Terjadi kesalahan tidak dikenal saat mengirim pengajuan: $e",
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
