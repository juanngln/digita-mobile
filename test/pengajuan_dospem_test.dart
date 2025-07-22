import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:digita_mobile/services/request_menjadi_dospem_service.dart';

// Buat mock untuk http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });
  
  late MockHttpClient mockClient;
  late RequestPembimbingKeDosenService service;

  setUp(() {
    mockClient = MockHttpClient();
    service = RequestPembimbingKeDosenService(client: mockClient);
  });

  const token = 'dummy-token';

  group('submitPengajuan', () {
    test('returns normally when status code is 201', () async {
      // Arrange
      final uri = Uri.parse(
        'https://your-base-url/api/v1/tugas-akhir/supervision-requests/',
      );
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('', 201));

      // Act & Assert
      expect(
        () => service.submitPengajuan(
          token: token,
          dosenId: 1,
          alasanMemilihDosen: 'Alasan',
          rencanaJudul: 'Judul',
          rencanaDeskripsi: 'Deskripsi',
        ),
        returnsNormally,
      );
    });

    test(
      'throws NetworkException with message when status is not 201',
      () async {
        // Arrange
        final responseBody = jsonEncode({'detail': 'Unauthorized'});
        when(
          () => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response(responseBody, 401));

        // Act & Assert
        expect(
          () => service.submitPengajuan(
            token: token,
            dosenId: 1,
            alasanMemilihDosen: 'Alasan',
            rencanaJudul: 'Judul',
            rencanaDeskripsi: 'Deskripsi',
          ),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.toString(),
              'message',
              contains('Unauthorized'),
            ),
          ),
        );
      },
    );
  });
}
