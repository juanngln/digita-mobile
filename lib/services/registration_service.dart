import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/models/jurusan.dart';
import 'package:digita_mobile/models/program_studi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class DataFetchException implements Exception {
  final String message;
  DataFetchException(this.message);
  @override
  String toString() => message;
}

class RegistrationFailedException implements Exception {
  final String message;

  RegistrationFailedException(this.message);
  @override
  String toString() => message;
}

class RegistrationService {
  // --- Base URL Configuration ---
  // Gunakan 10.0.2.2 untuk Android emulator untuk access ke localhost/127.0.0.1
  /* jika menggunakan android device asli
     Ganti alamat ip menggunakan alamat ip laptop/komputermu */
  static const String _baseUrl =
      kReleaseMode
          ? "_PRODUCTION_URL"
          : "https://djangodigitaadmin-development.up.railway.app";

  final http.Client _client;

  RegistrationService({http.Client? client})
    : _client = client ?? http.Client();

  // --- Fetch Program Studi ---
  Future<List<ProgramStudi>> fetchProgramStudi() async {
    final url = Uri.parse('$_baseUrl/api/users/program-studi/');
    if (kDebugMode) print("Fetching Program Studi from: $url");

    try {
      final response = await _client
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        return decodedData
            .map(
              (jsonItem) =>
                  ProgramStudi.fromJson(jsonItem as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw DataFetchException(
          "Gagal memuat data Prodi (Server Error: ${response.statusCode})",
        );
      }
    } on SocketException {
      throw NetworkException("Koneksi internet bermasalah (Prodi).");
    } on HttpException {
      throw NetworkException("Tidak dapat menghubungi server (Prodi).");
    } on FormatException {
      throw DataFetchException("Format data Prodi tidak valid.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout (Prodi).");
    } catch (e) {
      if (kDebugMode) print("Unknown error fetching prodi: $e");
      throw DataFetchException("Kesalahan tidak terduga (Prodi): $e");
    }
  }

  // --- Fetch Jurusan ---
  Future<List<Jurusan>> fetchJurusan() async {
    // *** Verify this endpoint is correct ***
    final url = Uri.parse('$_baseUrl/api/users/jurusan/');
    if (kDebugMode) print("Fetching Jurusan from: $url");

    try {
      final response = await _client
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        return decodedData
            .map(
              (jsonItem) => Jurusan.fromJson(jsonItem as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw DataFetchException(
          "Gagal memuat data Jurusan (Server Error: ${response.statusCode})",
        );
      }
    } on SocketException {
      throw NetworkException("Koneksi internet bermasalah (Jurusan).");
    } on HttpException {
      throw NetworkException("Tidak dapat menghubungi server (Jurusan).");
    } on FormatException {
      throw DataFetchException("Format data Jurusan tidak valid.");
    } on TimeoutException {
      throw NetworkException("Koneksi timeout (Jurusan).");
    } catch (e) {
      if (kDebugMode) print("Unknown error fetching jurusan: $e");
      throw DataFetchException("Kesalahan tidak terduga (Jurusan): $e");
    }
  }

  // --- Register User ---
  Future<void> register({
    required String role,
    required String namaLengkap,
    required String email,
    String? nim,
    String? nik,
    int? programStudiId,
    int? jurusanId,
    required String password,
    required String password2,
  }) async {
    final String endpoint;
    final Map<String, dynamic> registrationData;

    if (role.toLowerCase() == 'mahasiswa') {
      endpoint = '/api/users/register/mahasiswa/';
      registrationData = {
        "nim": nim!.trim(),
        "nama_lengkap": namaLengkap.trim(),
        "email": email.trim().toLowerCase(),
        "program_studi_id": programStudiId!,
        "password": password,
        "password2": password2,
      };
    } else if (role.toLowerCase() == 'dosen') {
      endpoint = '/api/users/register/dosen/';
      registrationData = {
        "nik": nik!.trim(),
        "nama_lengkap": namaLengkap.trim(),
        "email": email.trim().toLowerCase(),
        "jurusan_id": jurusanId!,
        "password": password,
        "password2": password2,
      };
    } else {
      throw ArgumentError("Invalid role provided for registration.");
    }

    final url = Uri.parse('$_baseUrl$endpoint');
    final String jsonBody = jsonEncode(registrationData);

    if (kDebugMode) {
      print("--- Sending Registration Request ($role) ---");
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
        print("Registration Response ($role): ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      // --- Handle Response ---
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // SUCCESS
        return;
      } else {
        // FAILURE
        String errorMessage = "Registrasi gagal.";
        try {
          final errorBody = jsonDecode(response.body) as Map<String, dynamic>;

          errorMessage =
              errorBody['detail'] ??
              errorBody['message'] ??
              errorBody.values.first.toString();

          if (errorBody.values.first is List &&
              (errorBody.values.first as List).isNotEmpty) {
            errorMessage = (errorBody.values.first as List)[0].toString();
          }
        } catch (e) {
          errorMessage =
              response.body.isNotEmpty
                  ? "Error ${response.statusCode}: ${response.body}"
                  : "Registrasi gagal (Status: ${response.statusCode})";
        }
        throw RegistrationFailedException(errorMessage);
      }
    } on SocketException {
      throw NetworkException("Koneksi internet bermasalah saat registrasi.");
    } on HttpException {
      throw NetworkException("Tidak dapat menghubungi server registrasi.");
    } on FormatException {
      throw RegistrationFailedException(
        "Format respons server registrasi salah.",
      );
    } on TimeoutException {
      throw NetworkException("Koneksi timeout saat registrasi.");
    } catch (e) {
      if (e is NetworkException || e is RegistrationFailedException) rethrow;
      if (kDebugMode) print("Unknown registration error: $e");
      throw Exception("Terjadi kesalahan tidak dikenal saat registrasi: $e");
    }
  }

  void dispose() {
    _client.close();
  }
}
