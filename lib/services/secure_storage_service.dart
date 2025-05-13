import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'digita_access_token';
  static const String _refreshTokenKey = 'digita_refresh_token';
  static const String _userDataKey = 'digita_user_data';

  // --- Access Token ---
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
    // For debugging
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    // For debugging
    return token;
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
    // For debugging
  }

  // --- Refresh Token ---
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
    // For debugging
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
    // For debugging
  }

  // --- User Data (Example: store basic user info as JSON string) ---
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final String userDataJson = jsonEncode(userData);
      await _storage.write(key: _userDataKey, value: userDataJson);
    } catch (e) {
      //for debugging
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final String? userDataJson = await _storage.read(key: _userDataKey);
      if (userDataJson != null && userDataJson.isNotEmpty) {
        return jsonDecode(userDataJson) as Map<String, dynamic>;
      }
    } catch (e) {
      //for debugging
    }
    return null;
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: _userDataKey);
    // For debugging
  }

  // --- Clear All ( for logout) ---
  Future<void> deleteAllData() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userDataKey);
  }
}
