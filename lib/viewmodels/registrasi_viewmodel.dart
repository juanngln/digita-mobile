import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/models/jurusan.dart';
import 'package:digita_mobile/models/program_studi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// --- Enums ---
enum ViewState { idle, busy, error, success }

enum RegistrationStatus {
  idle,
  success,
  networkError,
  serverError,
  validationError,
  timeoutError,
  unknownError,
}

class RegistrationViewModel extends ChangeNotifier {
  // --- Base URL Configuration ---
  // menggunakan 10.0.2.2 untuk Android emulator untuk mengakses localhost/127.0.0.1
  static const String _baseUrl = "http://10.0.2.2:8000";

  // --- Program Studi State ---
  List<ProgramStudi> _programStudiList = [];
  int? _selectedProdiId;
  ViewState _prodiFetchState = ViewState.idle;
  String? _prodiFetchError;

  // --- Jurusan State ---
  List<Jurusan> _jurusanList = [];
  int? _selectedJurusanId;
  ViewState _jurusanFetchState = ViewState.idle;
  String? _jurusanFetchError;

  // --- Prodi Getters ---
  List<ProgramStudi> get programStudiList => _programStudiList;
  int? get selectedProdiId => _selectedProdiId;
  ViewState get prodiFetchState => _prodiFetchState;
  String? get prodiFetchError => _prodiFetchError;

  // --- Shared Registration State ---
  ViewState _registrationState = ViewState.idle;
  String? _registrationError;
  RegistrationStatus _registrationStatus = RegistrationStatus.idle;

  // --- Jurusan Getters ---
  List<Jurusan> get jurusanList => _jurusanList;
  int? get selectedJurusanId => _selectedJurusanId;
  ViewState get jurusanFetchState => _jurusanFetchState;
  String? get jurusanFetchError => _jurusanFetchError;

  // Shared Registration getters
  ViewState get registrationState => _registrationState;
  String? get registrationError => _registrationError;
  RegistrationStatus get registrationStatus => _registrationStatus;

  // --- Prodi Setters ---
  void setSelectedProdiId(int? prodiId) {
    if (_selectedProdiId != prodiId) {
      _selectedProdiId = prodiId;
      _selectedJurusanId = null;
      notifyListeners();
    }
  }

  // --- Jurusan Setter ---
  void setSelectedJurusanId(int? jurusanId) {
    if (_selectedJurusanId != jurusanId) {
      _selectedJurusanId = jurusanId;
      _selectedProdiId = null;
      notifyListeners();
    }
  }

  // --- Data Fetching Methods ---

  // Fetch Program Studi
  Future<void> fetchProgramStudi() async {
    _prodiFetchState = ViewState.busy;
    _prodiFetchError = null;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/api/users/program-studi/');

    try {
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        _programStudiList =
            decodedData
                .map(
                  (jsonItem) =>
                      ProgramStudi.fromJson(jsonItem as Map<String, dynamic>),
                )
                .toList();
        _prodiFetchState = ViewState.success;
      } else {
        // Handle errors... (existing logic is fine)
        _prodiFetchError =
            "Gagal memuat data Prodi (Server Error: ${response.statusCode})";
        _prodiFetchState = ViewState.error;
      }
    } on SocketException {
      _prodiFetchError = "Koneksi internet bermasalah (Prodi).";
      _prodiFetchState = ViewState.error;
    } on HttpException {
      _prodiFetchError = "Tidak dapat menghubungi server (Prodi).";
      _prodiFetchState = ViewState.error;
    } on FormatException {
      _prodiFetchError = "Format data Prodi tidak valid.";
      _prodiFetchState = ViewState.error;
    } on TimeoutException {
      _prodiFetchError = "Koneksi timeout (Prodi).";
      _prodiFetchState = ViewState.error;
    } catch (e) {
      _prodiFetchError = "Kesalahan tidak terduga (Prodi): $e";
      _prodiFetchState = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // Fetch Jurusan
  Future<void> fetchJurusan() async {
    _jurusanFetchState = ViewState.busy;
    _jurusanFetchError = null;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/api/users/jurusan/');

    try {
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        // Use the Jurusan.fromJson factory
        _jurusanList =
            decodedData
                .map(
                  (jsonItem) =>
                      Jurusan.fromJson(jsonItem as Map<String, dynamic>),
                )
                .toList();
        _jurusanFetchState = ViewState.success;
      } else {
        _jurusanFetchError =
            "Gagal memuat data Jurusan (Server Error: ${response.statusCode})";
        _jurusanFetchState = ViewState.error;
        if (kDebugMode) {
          print(
            "Error fetching jurusan: ${response.statusCode} - ${response.body}",
          );
        }
      }
    } on SocketException {
      _jurusanFetchError = "Koneksi internet bermasalah (Jurusan).";
      _jurusanFetchState = ViewState.error;
    } on HttpException {
      _jurusanFetchError = "Tidak dapat menghubungi server (Jurusan).";
      _jurusanFetchState = ViewState.error;
    } on FormatException {
      _jurusanFetchError = "Format data Jurusan tidak valid.";
      _jurusanFetchState = ViewState.error;
    } on TimeoutException {
      _jurusanFetchError = "Koneksi timeout (Jurusan).";
      _jurusanFetchState = ViewState.error;
    } catch (e) {
      _jurusanFetchError = "Kesalahan tidak terduga (Jurusan): $e";
      _jurusanFetchState = ViewState.error;
      if (kDebugMode) {
        print("Unknown error fetching jurusan: $e");
      }
    } finally {
      notifyListeners();
    }
  }

  // --- Combined Registration Method ---
  Future<void> handleRegister({
    required String role, // 'mahasiswa' or 'dosen'
    required String namaLengkap,
    required String email,
    String? nim, // untuk Mahasiswa
    String? nik, // untuk Dosen
    int? programStudiId, // untuk Mahasiswa
    int? jurusanId, // untuk Dosen
    // Common fields
    required String password,
    required String password2,
  }) async {
    _registrationState = ViewState.busy;
    _registrationError = null;
    _registrationStatus = RegistrationStatus.idle;
    notifyListeners();

    // --- Role-based Validation ---
    String? validationErrorMessage;
    if (role.toLowerCase() == 'mahasiswa') {
      if (nim == null || nim.trim().isEmpty) {
        validationErrorMessage = "NIM tidak boleh kosong.";
      } else if (programStudiId == null) {
        validationErrorMessage = "Program Studi harus dipilih.";
      }
    } else if (role.toLowerCase() == 'dosen') {
      if (nik == null || nik.trim().isEmpty) {
        validationErrorMessage = "NIK tidak boleh kosong.";
      } else if (jurusanId == null) {
        validationErrorMessage = "Jurusan harus dipilih.";
      }
    } else {
      validationErrorMessage = "Peran tidak valid.";
    }

    // Common validation
    if (validationErrorMessage == null && namaLengkap.trim().isEmpty) {
      validationErrorMessage = "Nama Lengkap tidak boleh kosong.";
    }
    if (validationErrorMessage == null && email.trim().isEmpty) {
      validationErrorMessage = "Email tidak boleh kosong.";
    }
    // Basic email format check (optional but good)
    if (validationErrorMessage == null &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      validationErrorMessage = "Format email tidak valid.";
    }
    if (validationErrorMessage == null && password.isEmpty) {
      validationErrorMessage = "Kata Sandi tidak boleh kosong.";
    }
    if (validationErrorMessage == null && password.length < 8) {
      validationErrorMessage = "Kata Sandi minimal 8 karakter.";
    }
    if (validationErrorMessage == null && password != password2) {
      validationErrorMessage = "Kata Sandi tidak cocok.";
    }

    if (validationErrorMessage != null) {
      _registrationError = validationErrorMessage;
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.validationError;
      notifyListeners();
      return;
    }

    // --- menentukan endpoint dan data berdasarkan role ---
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
    } else {
      // role == 'dosen'
      endpoint = '/api/users/register/dosen/';
      registrationData = {
        "nik": nik!.trim(),
        "nama_lengkap": namaLengkap.trim(),
        "email": email.trim().toLowerCase(),
        "jurusan_id": jurusanId!,
        "password": password,
        "password2": password2,
      };
    }

    final url = Uri.parse('$_baseUrl$endpoint');
    final String jsonBody = jsonEncode(registrationData);

    if (kDebugMode) {
      print("--- Sending Registration Request ($role) ---");
      print("URL: $url");
      print("Body: $jsonBody");
      print("-----------------------------");
    }

    // --- API Call ---
    try {
      final response = await http
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

      if (response.statusCode == 201) {
        // SUCCESS
        _registrationState = ViewState.success;
        _registrationStatus = RegistrationStatus.success;
      } else {
        // FAILURE
        _registrationState = ViewState.error;
        _registrationStatus = RegistrationStatus.serverError;
        try {
          final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
          List<String> errorMessages = [];
          errorBody.forEach((key, value) {
            // Prioritize 'detail' or 'message' keys jika ada
            if (key == 'detail' || key == 'message') {
              errorMessages.insert(
                0,
                value.toString(),
              ); // Menampilkan pesan umum dahulu
            } else if (value is List && value.isNotEmpty) {
              String fieldName = key
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map((word) => word[0].toUpperCase() + word.substring(1))
                  .join(' ');
              // membuat nama field lebih user-friendly
              if (key == 'nim' || key == 'nik') fieldName = key.toUpperCase();
              if (key == 'program_studi_id') fieldName = 'Program Studi';
              if (key == 'jurusan_id') fieldName = 'Jurusan';
              errorMessages.add("$fieldName: ${value[0]}");
            } else if (value is String) {
              // tangkapan pesan error lain
              errorMessages.add("$key: $value");
            }
          });

          if (errorMessages.isNotEmpty) {
            _registrationError = errorMessages.join('\n');
            // cek apakah ada error validasi
            if (errorBody.containsKey('nim') ||
                errorBody.containsKey('nik') ||
                errorBody.containsKey('email') ||
                errorBody.containsKey('program_studi_id') ||
                errorBody.containsKey('jurusan_id') ||
                errorBody.containsKey('password') ||
                response.statusCode == 400) {
              _registrationStatus = RegistrationStatus.validationError;
            }
          } else {
            _registrationError =
                "Error ${response.statusCode}: Gagal registrasi.";
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing error body: $e");
          }
          // menggunakan response.body jika tidak bisa di-decode
          _registrationError =
              response.body.isNotEmpty
                  ? "Error ${response.statusCode}: ${response.body}"
                  : "Registrasi gagal (Status: ${response.statusCode})";
          _registrationStatus =
              (response.statusCode == 400)
                  ? RegistrationStatus.validationError
                  : RegistrationStatus.unknownError;
        }
      }
    } on SocketException {
      _registrationError = "Koneksi internet bermasalah saat registrasi.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.networkError;
    } on HttpException {
      _registrationError = "Tidak dapat menghubungi server registrasi.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.networkError;
    } on FormatException {
      _registrationError = "Format respons server registrasi salah.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.serverError;
    } on TimeoutException {
      _registrationError = "Koneksi timeout saat registrasi.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.timeoutError;
    } catch (e) {
      _registrationError = "Terjadi kesalahan tidak dikenal: $e";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.unknownError;
      if (kDebugMode) {
        print("Unknown registration error: $e");
      }
    } finally {
      notifyListeners();
    }
  }

  // --- Reset Status ---
  void resetRegistrationStatus() {
    if (_registrationStatus != RegistrationStatus.idle ||
        _registrationState != ViewState.idle) {
      if (kDebugMode) {
        print("Resetting registration status.");
      }
      _registrationStatus = RegistrationStatus.idle;
      _registrationError = null;
      if (_registrationState != ViewState.busy) {
        _registrationState = ViewState.idle;
      }
    }
  }
}
