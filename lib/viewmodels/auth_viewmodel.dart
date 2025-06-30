import 'package:digita_mobile/services/biometric_service.dart';
import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginService _loginService;
  final SecureStorageService _secureStorageService;
  final BiometricService _biometricService;

  AuthViewModel({
    required LoginService loginService,
    required SecureStorageService secureStorageService,
    required BiometricService biometricService,
  })  : _loginService = loginService,
        _secureStorageService = secureStorageService,
        _biometricService = biometricService;

  Future<void> initializeApp(BuildContext context) async {
    final accessToken = await _secureStorageService.getAccessToken();

    if (accessToken == null) {
      _navigateTo(context, '/login');
      return;
    }

    if (!JwtDecoder.isExpired(accessToken)) {
      // Scenario A: Token is valid
      await _handleSuccessfulLogin(context, accessToken);
    } else {
      // Scenario B: Token is expired, try to refresh
      await _handleExpiredToken(context);
    }
  }

  Future<void> _handleExpiredToken(BuildContext context) async {
    final refreshToken = await _secureStorageService.getRefreshToken();
    if (refreshToken == null || JwtDecoder.isExpired(refreshToken)) {
      await _logoutAndNavigateToLogin(context);
      return;
    }

    // Ask for fingerprint
    final canAuth = await _biometricService.canCheckBiometrics();
    if (canAuth) {
      final isAuthenticated = await _biometricService.authenticate(
        'Sesi Anda telah berakhir. Silakan otentikasi untuk melanjutkan.',
      );

      if (isAuthenticated) {
        try {
          final newAccessToken = await _loginService.refreshAccessToken(refreshToken);
          await _secureStorageService.saveAccessToken(newAccessToken);
          await _handleSuccessfulLogin(context, newAccessToken);
        } catch (e) {
          // Refresh failed (e.g., server rejected refresh token)
          await _logoutAndNavigateToLogin(context);
        }
      } else {
        // User failed or cancelled biometrics
        await _logoutAndNavigateToLogin(context);
      }
    } else {
      // No biometrics available on device
      await _logoutAndNavigateToLogin(context);
    }
  }

  Future<void> _handleSuccessfulLogin(BuildContext context, String accessToken) async {
    final userData = await _secureStorageService.getUserData();
    if (userData == null || !userData.containsKey('role')) {
      await _logoutAndNavigateToLogin(context);
      return;
    }

    final String role = userData['role'].toString().toLowerCase();

    if (role == 'dosen') {
      _navigateTo(context, '/home_dosen');
    } else if (role == 'mahasiswa') {
      try {
        final statusData = await _loginService.checkThesisRequestStatus(accessToken);
        String route = '/cari_dosen'; // Default route
        if (statusData != null && statusData.containsKey('status')) {
          final String? status = statusData['status']?.toString().toUpperCase();
          switch (status) {
            case 'PENDING':
            case 'REJECTED':
              route = '/status_pengajuan_dosen';
              break;
            case 'ACCEPTED':
              route = '/home_mahasiswa';
              break;
          }
        }
        _navigateTo(context, route);
      } catch (e) {
        // Failed to get status, maybe network error, go to a safe default
        _navigateTo(context, '/home_mahasiswa');
      }
    } else {
      await _logoutAndNavigateToLogin(context);
    }
  }

  Future<void> _logoutAndNavigateToLogin(BuildContext context) async {
    await _secureStorageService.deleteAllData();
    _navigateTo(context, '/login');
  }

  void _navigateTo(BuildContext context, String routeName) {
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(routeName);
    }
  }
}