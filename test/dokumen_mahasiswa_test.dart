import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:digita_mobile/services/dokumen_mahasiswa_service.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  late MockHttpClient mockHttpClient;
  late MockSecureStorageService mockStorageService;
  late DokumenService dokumenService;

  const mockToken = 'test-token';

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockStorageService = MockSecureStorageService();

    dokumenService = DokumenService(client: mockHttpClient);
    dokumenService = DokumenService(
      client: mockHttpClient,
      secureStorageService: mockStorageService,
    );
  });

  test(
    'getDokumenStatus returns a list of DokumenStatusChecklist on success',
    () async {
      // Arrange
      final mockResponseJson = [
        {
          "bab": "BAB I",
          "is_uploaded": false,
          "document_details": null,
        },
      ];
      final mockResponse = http.Response(jsonEncode(mockResponseJson), 200);

      when(
        () => mockStorageService.getAccessToken(),
      ).thenAnswer((_) async => mockToken);
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dokumenService.getDokumenStatus();

      // Assert
      expect(result, isA<List<DokumenStatusChecklist>>());
      expect(result.first.bab, equals('BAB I'));
    },
  );

  test('getDokumenStatus throws NetworkException when token is null', () async {
    when(
      () => mockStorageService.getAccessToken(),
    ).thenAnswer((_) async => null);

    expect(
      () => dokumenService.getDokumenStatus(),
      throwsA(isA<NetworkException>()),
    );
  });
}
