import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error checking biometrics: $e");
      }
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true, // Keep the dialog open on app backgrounding
          biometricOnly: true, // Only allow biometric, not device PIN/pattern
        ),
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error during authentication: $e");
      }
      return false;
    }
  }
}