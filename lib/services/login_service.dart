import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:digita_mobile/models/mahasiswa.dart';
import 'package:digita_mobile/services/base_url.dart';

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

  final http.Client _client;

  LoginService({http.Client? client}) : _client = client ?? http.Client();

  // --- Login Method ---
  Future<Map<String, dynamic>> login({
    required String role,
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/login/');
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
          .timeout(AppConfig.apiTimeout);

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

  Future<String> refreshAccessToken(String refreshToken) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/token/refresh/');
    final body = jsonEncode({'refresh': refreshToken});

    if (kDebugMode) {
      print("--- Refreshing Token ---");
      print("URL: $url");
      print("Body: $body");
    }

    try {
      final response = await _client
          .post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      )
          .timeout(AppConfig.apiTimeout);

      if (kDebugMode) {
        print("Refresh Response Status: ${response.statusCode}");
        print("Refresh Response Body: ${response.body}");
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Assuming the new access token is returned under the 'access' key
        final String? newAccessToken = responseBody['access'];
        if (newAccessToken != null) {
          return newAccessToken;
        } else {
          throw AuthenticationException(
              "Token refresh successful, but new access token not found.");
        }
      } else {
        // If refresh fails (e.g., refresh token is expired), throw an exception.
        final String errorMessage =
            responseBody['detail'] ?? "Gagal memperbarui sesi Anda. Silakan login kembali.";
        throw AuthenticationException(errorMessage);
      }
    } on SocketException {
      throw NetworkException("Koneksi gagal saat memperbarui sesi.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat memperbarui sesi.");
    } catch (e) {
      if (kDebugMode) print("Unknown refresh token error: $e");
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  // --- METHOD: Logout ---
  Future<void> logout(String refreshToken) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/logout/');
    final body = jsonEncode({'refresh': refreshToken});

    if (kDebugMode) {
      print("--- Logging out ---");
      print("URL: $url");
      print("Body: $body");
    }

    try {
      final response = await _client
          .post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      )
          .timeout(AppConfig.apiTimeout);

      if (kDebugMode) {
        print("Logout Response Status: ${response.statusCode}");
        print("Logout Response Body: ${response.body}");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return; // Success
      } else {
        return;
      }
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat mencoba logout.");
    } on SocketException {
      throw NetworkException(
          "Tidak dapat terhubung ke server. Logout akan dilakukan secara lokal.");
    } catch (e) {
      if (kDebugMode) {
        print("Unknown logout error in Service: $e. Proceeding with local logout.");
      }
    }
  }


  // --- Method to Check Mahasiswa Request Status  ---
  Future<Map<String, dynamic>?> checkThesisRequestStatus(String token) async {
    final requestStatusUrl = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/tugas-akhir/supervision-requests/',
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
          .timeout(AppConfig.apiTimeout);

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

  Future<Mahasiswa> getMahasiswaData(int userId) async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/users/mahasiswa/$userId/'));

    if (response.statusCode == 200) {
      return Mahasiswa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load mahasiswa data');
    }
  }

  void dispose() {
    _client.close();
  }
}
