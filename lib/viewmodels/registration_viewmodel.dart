import 'dart:async';

import 'package:digita_mobile/models/jurusan_model.dart';
import 'package:digita_mobile/models/program_studi_model.dart';
import 'package:digita_mobile/services/registration_service.dart';
import 'package:flutter/foundation.dart';

enum ViewState { idle, busy, error, success }

enum RegistrationStatus {
  idle,
  success,
  networkError,
  serverError,
  validationError,
  unknownError,
}

class RegistrationViewModel extends ChangeNotifier {
  final RegistrationService _registrationService;
  RegistrationViewModel(this._registrationService);

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
    if (_isDisposed) return;
    if (_selectedProdiId != prodiId) {
      _selectedProdiId = prodiId;
      _selectedJurusanId = null;
      notifyListeners();
    }
  }

  void setSelectedJurusanId(int? jurusanId) {
    if (_isDisposed) return;
    if (_selectedJurusanId != jurusanId) {
      _selectedJurusanId = jurusanId;
      _selectedProdiId = null;
      notifyListeners();
    }
  }

  // --- Method Fetch---

  Future<void> fetchProgramStudi() async {
    if (_isDisposed || _prodiFetchState == ViewState.busy) return;

    _prodiFetchState = ViewState.busy;
    _prodiFetchError = null;
    if (!_isDisposed) notifyListeners();

    try {
      _programStudiList = await _registrationService.fetchProgramStudi();
      if (_isDisposed) return;
      _prodiFetchState = ViewState.success;
    } on NetworkException catch (e) {
      if (_isDisposed) return;
      _prodiFetchError = e.toString();
      _prodiFetchState = ViewState.error;
    } on DataFetchException catch (e) {
      if (_isDisposed) return;
      _prodiFetchError = e.toString();
      _prodiFetchState = ViewState.error;
    } catch (e) {
      if (_isDisposed) return;
      _prodiFetchError = "Kesalahan tidak terduga saat memuat Prodi: $e";
      _prodiFetchState = ViewState.error;
      if (kDebugMode) print("Unknown error fetching prodi in VM: $e");
    } finally {
      if (!_isDisposed) notifyListeners();
    }
  }

  Future<void> fetchJurusan() async {
    if (_isDisposed || _jurusanFetchState == ViewState.busy) return;

    _jurusanFetchState = ViewState.busy;
    _jurusanFetchError = null;
    if (!_isDisposed) notifyListeners();

    try {
      _jurusanList = await _registrationService.fetchJurusan();
      if (_isDisposed) return;
      _jurusanFetchState = ViewState.success;
    } on NetworkException catch (e) {
      if (_isDisposed) return;
      _jurusanFetchError = e.toString();
      _jurusanFetchState = ViewState.error;
    } on DataFetchException catch (e) {
      if (_isDisposed) return;
      _jurusanFetchError = e.toString();
      _jurusanFetchState = ViewState.error;
    } catch (e) {
      if (_isDisposed) return;
      _jurusanFetchError = "Kesalahan tidak terduga saat memuat Jurusan: $e";
      _jurusanFetchState = ViewState.error;
      if (kDebugMode) print("Unknown error fetching jurusan in VM: $e");
    } finally {
      if (!_isDisposed) notifyListeners();
    }
  }

  // --- Registration Method  ---
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
    if (_isDisposed || _registrationState == ViewState.busy) return;

    // --- Validation  ---
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

    if (validationErrorMessage != null) {
      _registrationError = validationErrorMessage;
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.validationError;
      if (!_isDisposed) notifyListeners();
      return;
    }
    _registrationState = ViewState.busy;
    _registrationError = null;
    _registrationStatus = RegistrationStatus.idle;
    if (!_isDisposed) notifyListeners();

    // --- API Call ---
    try {
      await _registrationService.register(
        role: role,
        namaLengkap: namaLengkap.trim(),
        email: email.trim().toLowerCase(),
        nim: nim?.trim(),
        nik: nik?.trim(),
        programStudiId: programStudiId,
        jurusanId: jurusanId,
        password: password,
        password2: password2,
      );

      if (_isDisposed) return;
      _registrationState = ViewState.success;
      _registrationStatus = RegistrationStatus.success;
    } on NetworkException catch (e) {
      if (_isDisposed) return;
      _registrationError = e.toString();
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.networkError;
    } on RegistrationFailedException catch (e) {
      if (_isDisposed) return;
      _registrationError = e.toString();
      _registrationState = ViewState.error;

      if (e.message.toLowerCase().contains('nim') ||
          e.message.toLowerCase().contains('nik') ||
          e.message.toLowerCase().contains('email') ||
          e.message.toLowerCase().contains('sudah terdaftar') ||
          e.message.toLowerCase().contains('password')) {
        _registrationStatus = RegistrationStatus.validationError;
      } else {
        _registrationStatus = RegistrationStatus.serverError;
      }
    } catch (e) {
      if (_isDisposed) return;
      _registrationError =
          "Terjadi kesalahan tidak dikenal saat registrasi: $e";
      _registrationState = ViewState.error;
      _registrationStatus = RegistrationStatus.unknownError;
      if (kDebugMode) print("Unknown registration error in VM: $e");
    } finally {
      if (!_isDisposed) notifyListeners();
    }
  }

  // --- Reset Status ---
  void resetRegistrationStatus() {
    if (_isDisposed) return;
    if (_registrationStatus != RegistrationStatus.idle ||
        _registrationState != ViewState.idle) {
      if (kDebugMode) print("Resetting registration status.");
      _registrationStatus = RegistrationStatus.idle;
      _registrationError = null;
      if (_registrationState != ViewState.busy) {
        _registrationState = ViewState.idle;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("Disposing RegistrationViewModel (Instance hash: $hashCode)...");
    }
    _isDisposed = true;
    super.dispose();
  }
}
