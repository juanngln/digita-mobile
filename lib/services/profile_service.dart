import 'dart:async';
import 'dart:convert';

import 'package:digita_mobile/models/dosen_model.dart';
import 'package:digita_mobile/models/jurusan_model.dart';
import 'package:digita_mobile/models/mahasiswa.dart';
import 'package:digita_mobile/models/mahasiswa_profile.dart';
import 'package:digita_mobile/models/program_studi_model.dart';
import 'package:digita_mobile/services/login_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:digita_mobile/services/base_url.dart';

import '../models/dosen_profile.dart';

class ProfileService {
  final http.Client _client;

  ProfileService({http.Client? client}) : _client = client ?? http.Client();

  Future<Mahasiswa> getMahasiswaProfile({
    required int userId,
    required String token,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/mahasiswa/$userId/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        return Mahasiswa.fromJson(jsonDecode(response.body));
      } else {
        throw NetworkException(
            "Gagal memuat profil mahasiswa (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getMahasiswaProfile: $e");
      rethrow;
    }
  }

  Future<MahasiswaProfile> getCurrentMahasiswaProfile({required String token}) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/profil/mahasiswa/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        return MahasiswaProfile.fromJson(jsonDecode(response.body));
      } else {
        throw NetworkException(
            "Gagal memuat profil Anda (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getCurrentMahasiswaProfile: $e");
      rethrow;
    }
  }

  Future<MahasiswaProfile> updateMahasiswaProfile({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/profil/mahasiswa/');
    try {
      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        return MahasiswaProfile.fromJson(jsonDecode(response.body));
      } else {
        throw NetworkException(
            "Gagal memperbarui profil (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in updateMahasiswaProfile: $e");
      rethrow;
    }
  }

  Future<List<ProgramStudi>> getProgramStudiList({required String token}) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/program-studi/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => ProgramStudi.fromJson(item)).toList();
      } else {
        throw NetworkException(
            "Gagal memuat daftar program studi (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getProgramStudiList: $e");
      rethrow;
    }
  }

  // --- Dosen Methods ---

  Future<Dosen> getDosenProfile({
    required int userId,
    required String token,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/dosen/$userId/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);
      if (response.statusCode == 200) {
        return Dosen.fromJson(jsonDecode(response.body));
      } else {
        throw NetworkException(
            "Gagal memuat profil dosen (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getDosenProfile: $e");
      rethrow;
    }
  }

  Future<DosenProfile> getCurrentDosenProfile({required String token}) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/profil/dosen/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        return DosenProfile.fromJson(jsonDecode(response.body));
      } else {
        throw NetworkException(
            "Gagal memuat profil Anda (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getCurrentDosenProfile: $e");
      rethrow;
    }
  }

  Future<DosenProfile> updateDosenProfile({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/profil/dosen/');
    try {
      final response = await _client.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        return DosenProfile.fromJson(jsonDecode(response.body));
      } else {
        throw NetworkException(
            "Gagal memperbarui profil (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in updateDosenProfile: $e");
      rethrow;
    }
  }

  Future<List<Jurusan>> getJurusanList({required String token}) async {
    // Assuming the endpoint for jurusan is '/api/v1/users/jurusan/'
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/users/jurusan/');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Jurusan.fromJson(item)).toList();
      } else {
        throw NetworkException(
            "Gagal memuat daftar jurusan (Status: ${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getJurusanList: $e");
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
