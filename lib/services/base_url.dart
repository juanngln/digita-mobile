import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _productionUrl = "PRODUCTION_URL";

  // --- Development URLs ---
  static const String _localDevelopmentUrl = "http://10.0.2.2:8000";
  static const String _remoteDevelopmentUrl = "https://digita-admin-api.onrender.com";

  // --- Switch for development URL ---
  // Set to true to use the local server, false to use the remote server.
  static const bool _useLocalServer = true;

  static String get _developmentUrl {
    return _useLocalServer ? _localDevelopmentUrl : _remoteDevelopmentUrl;
  }

  static String get baseUrl {
    if (kReleaseMode) {
      return _productionUrl;
    } else {
      return _developmentUrl;
    }
  }

  static const Duration apiTimeout = Duration(seconds: 20);
}