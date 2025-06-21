import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, busy, error, success }

enum LoginResult {
  idle,
  successMahasiswaHome,
  successMahasiswaCariDosen,
  successMahasiswaStatusPengajuan,
  successDosenHome,
  failed,
}

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService;
  final SecureStorageService _secureStorageService = SecureStorageService();
  LoginViewModel(this._loginService);

  // --- State Variables ---
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  String? _selectedRole;
  LoginResult _loginResult = LoginResult.idle;
  String? _authToken;

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
      final loginData = await _loginService.login(
        role: _selectedRole!,
        identifier: identifier,
        password: password,
      );
      final String? accessToken = loginData['tokens']?['access'] as String?;
      final String? refreshToken = loginData['tokens']?['refresh'] as String?;
      final Map<String, dynamic>? userData =
      loginData['user'] as Map<String, dynamic>?;

      // --- Process Successful Login ---

      if (accessToken == null) {
        throw AuthenticationException(
          "Token akses tidak ditemukan dalam respons login.",
        );
      }
      if (userData == null) {
        throw AuthenticationException(
          "Data pengguna tidak ditemukan dalam respons login.",
        );
      }

      _authToken = accessToken;
      // Save all data to secure storage
      await _secureStorageService.saveAccessToken(accessToken);
      await _secureStorageService.saveUserData(userData);
      if (refreshToken != null) {
        await _secureStorageService.saveRefreshToken(refreshToken);
      }


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
      _loginResult = LoginResult.failed;
      _setState(ViewState.error);
      return;
    }

    _setState(ViewState.busy);

    try {
      final statusData = await _loginService.checkThesisRequestStatus(
        _authToken!,
      );

      if (statusData != null && statusData.containsKey('status')) {
        final String? status = statusData['status']?.toString().toUpperCase();

        switch (status) {
          case 'PENDING':
            _loginResult = LoginResult.successMahasiswaStatusPengajuan;
            break;
          case 'REJECTED':
            _loginResult = LoginResult.successMahasiswaStatusPengajuan;
            break;
          case 'ACCEPTED':
            _loginResult = LoginResult.successMahasiswaHome;
            break;
          default:
            _loginResult = LoginResult.successMahasiswaCariDosen;
            break;
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

  // --- Logout (Example) ---
  // Future<void> logout() async {
  //   await _secureStorageService.deleteAllTokensAndData();
  //   _authToken = null;
  //   _selectedRole = null;
  //   // Reset other states and navigate to login screen
  //   _loginResult = LoginResult.idle;
  //   _setState(ViewState.idle);
  //   notifyListeners();
  // }

  // --- Method to load token on app start  ---
  Future<String?> tryLoadTokenAndSetAuthStatus() async {
    final token = await _secureStorageService.getAccessToken();
    _authToken = token;
    notifyListeners();
    return token;
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
