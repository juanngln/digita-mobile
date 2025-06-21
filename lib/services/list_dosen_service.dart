import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/models/dosen_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Custom Exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class DosenService {
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

  DosenService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Dosen>> getDosenList(String token) async {
    final url = Uri.parse('$_baseUrl/api/v1/users/dosen/');
    if (kDebugMode) {
      print("--- Fetching Dosen List ---");
      print("URL: $url");

      print("---------------------------");
    }

    try {
      final response = await _client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (kDebugMode) {
        print("Dosen List Response Status: ${response.statusCode}");
        print(
          "Dosen List Response Body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}",
        );
      }

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        // Map the JSON data to your Dosen model
        return responseData
            .map((data) => Dosen.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        String errorMessage = "Gagal memuat daftar dosen.";
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody is Map<String, dynamic>) {
            errorMessage =
                responseBody['detail'] ??
                responseBody['error'] ??
                "Gagal memuat daftar dosen (Status: ${response.statusCode})";
          }
        } catch (_) {
          // Ignore if error body isn't JSON or doesn't have expected fields
        }
        throw NetworkException(errorMessage);
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
      );
    } on HttpException {
      throw NetworkException(
        "Gagal menemukan layanan dosen. Periksa alamat server.",
      );
    } on FormatException {
      throw NetworkException(
        "Format respons daftar dosen dari server tidak valid.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat memuat daftar dosen.");
    } catch (e) {
      if (e is NetworkException) rethrow;
      if (kDebugMode) {
        print("Unknown error fetching dosen list in DosenService: $e");
      }
      throw Exception(
        "Terjadi kesalahan tidak dikenal saat memuat daftar dosen: $e",
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
