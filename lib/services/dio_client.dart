import 'package:dio/dio.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/services/base_url.dart';


class DioClient {
  final Dio _dio;
  final SecureStorageService _storageService;

  DioClient(this._dio, this._storageService) {
    _dio
      ..options.baseUrl = AppConfig.baseUrl
      ..options.connectTimeout = AppConfig.apiTimeout
      ..options.receiveTimeout = AppConfig.apiTimeout
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await _storageService.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
        ),
      );
  }

  Dio get dio => _dio;
}