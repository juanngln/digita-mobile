import 'package:digita_mobile/services/login_service.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, busy, error, success }

enum LoginResult {
  idle,
  successMahasiswaHome,
  successMahasiswaCariDosen,
  successDosenHome,
  failed,
}

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService;

  LoginViewModel(this._loginService);

  // --- State Variables ---
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  String? _selectedRole;
  LoginResult _loginResult = LoginResult.idle;
  String? _authToken; // Store the auth token

  // --- Getters ---
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get selectedRole => _selectedRole;
  LoginResult get loginResult => _loginResult;
  bool get isLoading => _state == ViewState.busy;
  String? get authToken => _authToken;

  final List<String> roles = ['Mahasiswa', 'Dosen'];

  // --- Setters / Actions ---
  void setSelectedRole(String? role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      notifyListeners();
    }
  }

  // --- Login Logic ---
  Future<void> handleLogin({
    required String identifier,
    required String password,
  }) async {
    if (_selectedRole == null) {
      _setError("Silakan pilih peran Anda.");
      return;
    }
    if (identifier.isEmpty) {
      _setError("NIM/NIK tidak boleh kosong.");
      return;
    }
    if (password.isEmpty) {
      _setError("Kata sandi tidak boleh kosong.");
      return;
    }

    _setState(ViewState.busy);

    try {
      final loginResponse = await _loginService.login(
        role: _selectedRole!,
        identifier: identifier,
        password: password,
      );

      // --- Process Successful Login ---

      _authToken = loginResponse['tokens']?['access'] as String?;

      if (_authToken == null) {
        throw AuthenticationException(
          "Token tidak ditemukan dalam respons login.",
        );
      }
      // TODO: Persist the token securely (e.g., flutter_secure_storage) here or pass it back

      // --- Role-Based Navigation Logic ---
      if (_selectedRole!.toLowerCase() == 'mahasiswa') {
        await _checkThesisStatusAndSetResult();
      } else if (_selectedRole!.toLowerCase() == 'dosen') {
        _loginResult = LoginResult.successDosenHome;
        _setState(ViewState.success);
      } else {
        _setError("Peran tidak dikenal setelah login berhasil.");
      }
    } on NetworkException catch (e) {
      _setError(e.toString());
    } on AuthenticationException catch (e) {
      _setError(e.toString());
    } catch (e) {
      _setError("Terjadi kesalahan tidak dikenal: $e");
    }
  }

  // --- Check Status Mahasiswa Logic  ---
  Future<void> _checkThesisStatusAndSetResult() async {
    if (_authToken == null) {
      _setError("Tidak dapat memeriksa status: token tidak tersedia.");
      return;
    }

    try {
      final statusData = await _loginService.checkThesisRequestStatus(
        _authToken!,
      );

      if (statusData != null) {
        final String? status = statusData['status'] as String?;
        if (status == 'PENDING' || status == null) {
          _loginResult = LoginResult.successMahasiswaCariDosen;
        } else {
          _loginResult = LoginResult.successMahasiswaHome;
        }
      } else {
        _loginResult = LoginResult.successMahasiswaCariDosen;
      }
      _setState(ViewState.success);
    } on NetworkException catch (e) {
      _setError(
        "Login berhasil, tapi gagal memeriksa status bimbingan: ${e.toString()}",
      );

      _loginResult = LoginResult.failed;
      _setState(ViewState.error);
    } catch (e) {
      _setError(
        "Login berhasil, tapi terjadi kesalahan saat memeriksa status: $e",
      );
      _loginResult = LoginResult.failed;
      _setState(ViewState.error);
    }
  }

  // --- Helper Methods for State ---
  void _setState(ViewState newState) {
    if (_state != newState) {
      _state = newState;
      if (_state != ViewState.error) {
        _errorMessage = null;
      }
      if (_state != ViewState.success) {
        _loginResult = LoginResult.idle;
      }
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    _loginResult = LoginResult.failed;
    notifyListeners();
  }

  // --- Reset state ---
  void resetLoginStatus() {
    _setState(ViewState.idle);
    _loginResult = LoginResult.idle;
    _authToken = null;
  }
}
