import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/models/jurusan.dart';
import 'package:digita_mobile/models/program_studi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  // Gunakan 10.0.2.2 untuk Android emulator untuk access ke localhost/127.0.0.1
  /* jika menggunakan android device asli
     Ganti alamat ip menggunakan alamat ip laptop/komputermu
     contoh: static const String _baseUrl = "http://192.168.1.15:8000"; */
  static const String _baseUrl = "http://10.0.2.2:8000";

  // --- State Variables ---
  List<ProgramStudi> _programStudiList = [];
  int? _selectedProdiId;
  ViewState _prodiFetchState = ViewState.idle;
  String? _prodiFetchError;

  List<Jurusan> _jurusanList = [];
  int? _selectedJurusanId;
  ViewState _jurusanFetchState = ViewState.idle;
  String? _jurusanFetchError;

  ViewState _registrationState = ViewState.idle;
  String? _registrationError;
  RegistrationStatus _registrationStatus = RegistrationStatus.idle;

  // --- ADD DISPOSED FLAG ---
  bool _isDisposed = false;

  // --- Getters ---
  List<ProgramStudi> get programStudiList => _programStudiList;
  int? get selectedProdiId => _selectedProdiId;
  ViewState get prodiFetchState => _prodiFetchState;
  String? get prodiFetchError => _prodiFetchError;

  List<Jurusan> get jurusanList => _jurusanList;
  int? get selectedJurusanId => _selectedJurusanId;
  ViewState get jurusanFetchState => _jurusanFetchState;
  String? get jurusanFetchError => _jurusanFetchError;

  ViewState get registrationState => _registrationState;
  String? get registrationError => _registrationError;
  RegistrationStatus get registrationStatus => _registrationStatus;

  // --- Setters ---
  void setSelectedProdiId(int? prodiId) {
    if (_isDisposed) return; // Check if disposed
    if (_selectedProdiId != prodiId) {
      _selectedProdiId = prodiId;
      _selectedJurusanId = null; // Clear the other selection
      notifyListeners();
    }
  }

  void setSelectedJurusanId(int? jurusanId) {
    if (_isDisposed) return; // Check if disposed
    if (_selectedJurusanId != jurusanId) {
      _selectedJurusanId = jurusanId;
      _selectedProdiId = null; // Clear the other selection
      notifyListeners();
    }
  }

  // --- Data Fetching Methods ---

  Future<void> fetchProgramStudi() async {
    // Prevent re-entry if already busy or if disposed
    if (_isDisposed || _prodiFetchState == ViewState.busy) return;

    _prodiFetchState = ViewState.busy;
    _prodiFetchError = null;
    // Notify busy state only if not disposed
    if (!_isDisposed) notifyListeners();

    final url = Uri.parse('$_baseUrl/api/users/program-studi/');

    try {
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (_isDisposed) return; // Check after await

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
        // Handle HTTP errors
        _prodiFetchError =
            "Gagal memuat data Prodi (Server Error: ${response.statusCode})";
        _prodiFetchState = ViewState.error;
        if (kDebugMode) {
          print(
            "Error fetching prodi: ${response.statusCode} - ${response.body}",
          );
        }
      }
    } on SocketException {
      if (_isDisposed) {
        return; // Check after potential await in catch (less likely here)
      }
      _prodiFetchError = "Koneksi internet bermasalah (Prodi).";
      _prodiFetchState = ViewState.error;
    } on HttpException {
      if (_isDisposed) return;
      _prodiFetchError = "Tidak dapat menghubungi server (Prodi).";
      _prodiFetchState = ViewState.error;
    } on FormatException {
      if (_isDisposed) return;
      _prodiFetchError = "Format data Prodi tidak valid.";
      _prodiFetchState = ViewState.error;
    } on TimeoutException {
      if (_isDisposed) return;
      _prodiFetchError = "Koneksi timeout (Prodi).";
      _prodiFetchState = ViewState.error;
    } catch (e) {
      if (_isDisposed) return;
      _prodiFetchError = "Kesalahan tidak terduga (Prodi): $e";
      _prodiFetchState = ViewState.error;
      if (kDebugMode) {
        print("Unknown error fetching prodi: $e");
      }
    } finally {
      // --- CHECK FLAG BEFORE FINAL NOTIFY ---
      if (!_isDisposed) {
        notifyListeners(); // Notify final state
      }
    }
  }

  Future<void> fetchJurusan() async {
    // Prevent re-entry if already busy or if disposed
    if (_isDisposed || _jurusanFetchState == ViewState.busy) return;

    _jurusanFetchState = ViewState.busy;
    _jurusanFetchError = null;
    // Notify busy state only if not disposed
    if (!_isDisposed) notifyListeners();

    // *** IMPORTANT: Verify this is the correct endpoint for Jurusan ***
    final url = Uri.parse('$_baseUrl/api/users/jurusan/');

    try {
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (_isDisposed) return; // Check after await

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        _jurusanList =
            decodedData
                .map(
                  (jsonItem) =>
                      Jurusan.fromJson(jsonItem as Map<String, dynamic>),
                )
                .toList();
        _jurusanFetchState = ViewState.success;
      } else {
        // Handle HTTP errors
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
      if (_isDisposed) return;
      _jurusanFetchError = "Koneksi internet bermasalah (Jurusan).";
      _jurusanFetchState = ViewState.error;
    } on HttpException {
      if (_isDisposed) return;
      _jurusanFetchError = "Tidak dapat menghubungi server (Jurusan).";
      _jurusanFetchState = ViewState.error;
    } on FormatException {
      if (_isDisposed) return;
      _jurusanFetchError = "Format data Jurusan tidak valid.";
      _jurusanFetchState = ViewState.error;
    } on TimeoutException {
      if (_isDisposed) return;
      _jurusanFetchError = "Koneksi timeout (Jurusan).";
      _jurusanFetchState = ViewState.error;
    } catch (e) {
      if (_isDisposed) return;
      _jurusanFetchError = "Kesalahan tidak terduga (Jurusan): $e";
      _jurusanFetchState = ViewState.error;
      if (kDebugMode) {
        print("Unknown error fetching jurusan: $e");
      }
    } finally {
      // --- CHECK FLAG BEFORE FINAL NOTIFY ---
      if (!_isDisposed) {
        notifyListeners(); // Notify final state
      }
    }
  }

  // --- Combined Registration Method ---
  Future<void> handleRegister({
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
    // Prevent re-entry if already busy or if disposed
    if (_isDisposed || _registrationState == ViewState.busy) return;

    _registrationState = ViewState.busy;
    _registrationError = null;
    _registrationStatus = RegistrationStatus.idle;
    // Notify busy state only if not disposed
    if (!_isDisposed) notifyListeners();

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

    // If validation fails, set error state and notify (if not disposed)
    if (validationErrorMessage != null) {
      _registrationError = validationErrorMessage;
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.validationError;
      if (!_isDisposed) notifyListeners();
      return;
    }

    // --- Determine Endpoint and Payload ---
    final String endpoint;
    final Map<String, dynamic> registrationData;

    if (role.toLowerCase() == 'mahasiswa') {
      endpoint = '/api/users/register/mahasiswa/';
      registrationData = {
        "nim": nim!.trim(), // Safe non-null assert after validation
        "nama_lengkap": namaLengkap.trim(),
        "email": email.trim().toLowerCase(),
        "program_studi_id": programStudiId!, // Safe non-null assert
        "password": password,
        "password2": password2,
      };
    } else {
      // role == 'dosen'
      endpoint = '/api/users/register/dosen/';
      registrationData = {
        "nik": nik!.trim(), // Safe non-null assert
        "nama_lengkap": namaLengkap.trim(),
        "email": email.trim().toLowerCase(),
        "jurusan_id": jurusanId!, // Safe non-null assert
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

      if (_isDisposed) return; // Check after await

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
        _registrationStatus = RegistrationStatus.serverError; // Default
        _registrationError = "Registrasi gagal."; // Default

        try {
          final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
          List<String> errorMessages = [];
          errorBody.forEach((key, value) {
            if (key == 'detail' || key == 'message') {
              errorMessages.insert(0, value.toString());
            } else if (value is List && value.isNotEmpty) {
              String fieldName = key
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map((word) => word[0].toUpperCase() + word.substring(1))
                  .join(' ');
              if (key == 'nim' || key == 'nik') fieldName = key.toUpperCase();
              if (key == 'program_studi_id') fieldName = 'Program Studi';
              if (key == 'jurusan_id') fieldName = 'Jurusan';
              // Handle specific password error translation
              if (key == 'password' &&
                  value[0] == "This password is too common.") {
                errorMessages.add("$fieldName: Kata sandi ini terlalu umum.");
              } else {
                errorMessages.add("$fieldName: ${value[0]}");
              }
            } else if (value is String) {
              errorMessages.add("$key: $value");
            }
          });

          if (errorMessages.isNotEmpty) {
            _registrationError = errorMessages.join('\n');
            // Determine if it's a validation error
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
      if (_isDisposed) return;
      _registrationError = "Koneksi internet bermasalah saat registrasi.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.networkError;
    } on HttpException {
      if (_isDisposed) return;
      _registrationError = "Tidak dapat menghubungi server registrasi.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.networkError;
    } on FormatException {
      if (_isDisposed) return;
      _registrationError = "Format respons server registrasi salah.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.serverError;
    } on TimeoutException {
      if (_isDisposed) return;
      _registrationError = "Koneksi timeout saat registrasi.";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.timeoutError;
    } catch (e) {
      if (_isDisposed) return;
      _registrationError = "Terjadi kesalahan tidak dikenal: $e";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.unknownError;
      if (kDebugMode) {
        print("Unknown registration error: $e");
      }
    } finally {
      // --- CHECK FLAG BEFORE FINAL NOTIFY ---
      if (!_isDisposed) {
        notifyListeners(); // Notify final state
      }
    }
  }

  // --- Reset Status ---
  void resetRegistrationStatus() {
    if (_isDisposed) return; // Check if disposed
    // Only reset if not already idle
    if (_registrationStatus != RegistrationStatus.idle ||
        _registrationState != ViewState.idle) {
      if (kDebugMode) {
        print("Resetting registration status.");
      }
      _registrationStatus = RegistrationStatus.idle;
      _registrationError = null;
      // Only reset general state if it wasn't already reset or busy
      if (_registrationState != ViewState.busy) {
        _registrationState = ViewState.idle;
      }
      // No need to notifyListeners() here as this is usually called
      // *after* the UI has already reacted (e.g., after navigation or showing snackbar).
      // If you *do* need the UI to rebuild immediately upon reset, uncomment the line below.
      // notifyListeners();
    }
  }

  // --- OVERRIDE DISPOSE ---
  @override
  void dispose() {
    if (kDebugMode) {
      print("Disposing RegistrationViewModel (Instance hash: $hashCode)...");
    }
    _isDisposed = true; // Set the flag
    super.dispose(); // Call the original dispose
  }
}
