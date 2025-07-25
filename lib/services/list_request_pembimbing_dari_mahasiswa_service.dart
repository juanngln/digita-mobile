import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/models/list_request_pembimbing_dari_mahasiswa_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:digita_mobile/services/base_url.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class ListRequestPembimbingDariMahasiswaService {
  final http.Client _client;

  ListRequestPembimbingDariMahasiswaService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ListRequestPembimbingDariMahasiswaModel>> getIncomingRequests(String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/tugas-akhir/supervision-requests/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

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
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/tugas-akhir/supervision-requests/$requestId/');
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
      ).timeout(AppConfig.apiTimeout);

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