import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/models/list_request_pembimbing_dari_mahasiswa_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class ListRequestPembimbingDariMahasiswaService {
  static const String _baseUrl =
  kReleaseMode
      ? "YOUR_PRODUCTION_API_URL"
   : "https://digita-admin-api.onrender.com";
  //    : "http://10.0.2.2:8000";
  final http.Client _client;

  ListRequestPembimbingDariMahasiswaService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ListRequestPembimbingDariMahasiswaModel>> getIncomingRequests(String token) async {
    final url = Uri.parse('$_baseUrl/api/v1/tugas-akhir/request-mahasiswa/incoming/');
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
        return responseData
            .map((data) => ListRequestPembimbingDariMahasiswaModel.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw NetworkException("Gagal memuat data pengajuan (Status: ${response.statusCode})");
      }
    } on SocketException {
      throw NetworkException("Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat memuat data.");
    } catch (e) {
      if (kDebugMode) print("Error in getIncomingRequests: $e");
      rethrow;
    }
  }

  Future<void> respondToRequest({
    required int requestId,
    required String status,
    required String responseMessage,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/tugas-akhir/request-mahasiswa/$requestId/respond/');
    if (kDebugMode) {
      print("--- Responding to Request ---");
      print("URL: $url");
      print("Status: $status, Message: $responseMessage");
      print("-----------------------------");
    }

    try {
      final response = await _client.patch(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
          'dosen_response': responseMessage,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        String errorMessage = "Gagal mengirim respons (Status: ${response.statusCode})";
        try {
          final body = jsonDecode(response.body);
          if (body is Map && body.containsKey('detail')) {
            errorMessage = body['detail'];
          }
        } catch (_) {
        }
        throw NetworkException(errorMessage);
      }
    } on SocketException {
      throw NetworkException("Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat mengirim respons.");
    } catch (e) {
      if (kDebugMode) print("Error in respondToRequest: $e");
      rethrow;
    }
  }
}