import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// --- Custom Exceptions ---
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
  @override
  String toString() => message;
}

class LoginService {
  // --- Base URL Configuration ---
  // Gunakan 10.0.2.2 untuk Android emulator untuk access ke localhost/127.0.0.1
  /* jika menggunakan android device asli
     Ganti alamat ip menggunakan alamat ip laptop/komputermu */
  static const String _baseUrl =
      kReleaseMode
          ? "_PRODUCTION_URL"
           : "https://digita-admin-api.onrender.com";
          //: "http://10.0.2.2:8000";


  final http.Client _client;

  LoginService({http.Client? client}) : _client = client ?? http.Client();

  // --- Login Method ---
  Future<Map<String, dynamic>> login({
    required String role,
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/users/login/');
    final Map<String, String> loginData = {
      "role": role.toLowerCase(),
      "identifier": identifier,
      "password": password,
    };
    final String jsonBody = jsonEncode(loginData);

    if (kDebugMode) {
      print("--- Sending Login Request ---");
      print("URL: $url");
      print("Body: $jsonBody");
      print("-----------------------------");
    }

    try {
      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonBody,
          )
          .timeout(const Duration(seconds: 20));

      if (kDebugMode) {
        print("Login Response Status: ${response.statusCode}");
        print("Login Response Body: ${response.body}");
      }

      final responseBody = jsonDecode(response.body);


      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Check for the new structure
        if (responseBody is Map<String, dynamic> &&
            responseBody['status'] == 'success' &&
            responseBody.containsKey('data')) {
          final data = responseBody['data'] as Map<String, dynamic>;
          // Ensure tokens and user data exist within the 'data' object
          if (data.containsKey('tokens') && data.containsKey('user')) {
            return data;
          }
        }
        // If the structure is not as expected, throw an exception.
        throw AuthenticationException(
          "Login successful, but response data is missing or invalid.",
        );
      } else {
        String errorMessage = "Login gagal.";
        if (responseBody is Map<String, dynamic>) {
          errorMessage = responseBody['detail'] ??
              responseBody['error'] ??
              "Login gagal (Status: ${response.statusCode})";
        } else {
          errorMessage = "Login gagal (Status: ${response.statusCode})";
        }
        throw AuthenticationException(errorMessage);
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
      );
    } on HttpException {
      throw NetworkException(
        "Gagal menemukan layanan login. Periksa alamat server.",
      );
    } on FormatException {
      throw AuthenticationException(
        "Format respons login dari server tidak valid.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat mencoba login.");
    } catch (e) {
      if (e is NetworkException || e is AuthenticationException) rethrow;
      if (kDebugMode) print("Unknown login error in Service: $e");
      throw Exception("Terjadi kesalahan tidak dikenal saat login: $e");
    }
  }

  // --- Method to Check Mahasiswa Request Status  ---
  Future<Map<String, dynamic>?> checkThesisRequestStatus(String token) async {
    final requestStatusUrl = Uri.parse(
      '$_baseUrl/api/v1/tugas-akhir/supervision-requests/',
    );
    if (kDebugMode) print("Checking thesis status from: $requestStatusUrl");

    try {
      final response = await _client
          .get(
            requestStatusUrl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          return responseData[0] as Map<String, dynamic>?;
        } else {
          return null;
        }
      } else {
        throw NetworkException(
          "Gagal memeriksa status permintaan (Status: ${response.statusCode}).",
        );
      }
    } on SocketException {
      throw NetworkException(
        "Tidak dapat terhubung ke server untuk memeriksa status.",
      );
    } on HttpException {
      throw NetworkException("Gagal menemukan layanan status.");
    } on FormatException {
      throw NetworkException("Format respons status dari server tidak valid.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat memeriksa status.");
    } catch (e) {
      if (kDebugMode) print("Unknown error checking status in Service: $e");
      throw Exception(
        "Terjadi kesalahan tidak diketahui saat memeriksa status: $e",
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
