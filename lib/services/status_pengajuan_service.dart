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

class StatusPengajuanService {
  static const String _baseUrl =
  kReleaseMode
      ? "_PRODUCTION_URL"
      : "https://digita-admin-api.onrender.com";
      //: "http://10.0.2.2:8000";
  final http.Client _client;

  StatusPengajuanService({http.Client? client}) : _client = client ?? http.Client();
  Future<String> getRejectionReason(String token) async {
    final url = Uri.parse('$_baseUrl/api/v1/tugas-akhir/request-dosen/pribadi/');
    if (kDebugMode) {
      print("--- Fetching Personal TA Request Status ---");
      print("URL: $url");
      print("-----------------------------------------");
    }

    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

        final rejectedRequest = responseData.firstWhere(
              (item) => item is Map<String, dynamic> && item['status'] == 'REJECTED',
          orElse: () => null,
        );

        if (rejectedRequest != null) {
          final reason = rejectedRequest['dosen_response'] as String?;
          return reason != null && reason.isNotEmpty
              ? reason
              : "Dosen tidak memberikan alasan spesifik.";
        } else {
          throw NetworkException("Data pengajuan ditolak tidak ditemukan.");
        }
      } else {
        throw NetworkException("Gagal memuat status pengajuan (Status: ${response.statusCode})");
      }
    } on SocketException {
      throw NetworkException("Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat memuat data.");
    } catch (e) {
      if (kDebugMode) print("Error in getRejectionReason: $e");
      rethrow;
    }
  }
}