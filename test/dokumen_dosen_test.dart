import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:digita_mobile/services/dokumen_dosen_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/models/list_mahasiswa_bimbingan.dart';
import 'package:digita_mobile/models/dokumen_mahasiswa_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSecureStorageService mockStorageService;
  late DokumenDosenService service;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockStorageService = MockSecureStorageService();
    service = DokumenDosenService(
      client: mockHttpClient,
      secureStorage: mockStorageService,
    );
  });

  group('fetchSupervisedStudents', () {
    test('returns list of students when response is 200', () async {
      final token = 'dummy_token';
      final mockJson = [
        {
          "user_id": 1,
          "nama_lengkap": "Juan Jonathan Nainggolan",
          "nim": "3312301009",
          "program_studi": {"id": 1, "nama_prodi": "D3 Teknik Informatika"},
          "judul_skripsi": "Aplikasi mobile",
        },
      ];

      when(
        () => mockStorageService.getAccessToken(),
      ).thenAnswer((_) async => token);

      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final result = await service.fetchSupervisedStudents();
      expect(result, isA<List<ListMahasiswaBimbingan>>());
      expect(result.first.nim, '3312301009');
    });
  });

  group('fetchDokumenMahasiswa', () {
    test('returns list of documents when response is 200', () async {
      final token = 'dummy_token';
      final mockJson = [
        {
          "id": 1,
          "bab": "BAB I",
          "bab_display": "Bab I Pendahuluan",
          "nama_dokumen": "Proposal",
          "file_url": "https://example.com/file.pdf",
          "status": "DRAFT",
          "status_display": "Draft",
          "catatan_revisi": "Perbaiki abstrak",
          "pemilik_info": {
            "user_id": 123,
            "nim": "12345678",
            "nama_lengkap": "Budi Santoso",
            "program_studi": {"id": 10, "nama_prodi": "Teknik Informatika"},
          },
          "uploaded_at": "2025-07-20T12:00:00.000Z",
        },
      ];

      when(
        () => mockStorageService.getAccessToken(),
      ).thenAnswer((_) async => token);

      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final result = await service.fetchDokumenMahasiswa(1);
      expect(result, isA<List<DocumentDetails>>());
      expect(result.first.bab, 'BAB I');
    });
  });

  group('updateDokumenStatus', () {
    test('updates document and returns updated document', () async {
      final token = 'dummy_token';
      final mockJson = {
        "id": 1,
        "bab": "BAB I",
        "bab_display": "Bab I Pendahuluan",
        "nama_dokumen": "Proposal",
        "file_url": "https://example.com/file.pdf",
        "status": "DRAFT",
        "status_display": "Draft",
        "catatan_revisi": "Perbaiki abstrak",
        "pemilik_info": {
          "user_id": 123,
          "nim": "12345678",
          "nama_lengkap": "Budi Santoso",
          "program_studi": {"id": 10, "nama_prodi": "Teknik Informatika"},
        },
        "uploaded_at": "2025-07-20T12:00:00.000Z",
      };

      when(
        () => mockStorageService.getAccessToken(),
      ).thenAnswer((_) async => token);

      when(
        () => mockHttpClient.patch(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final result = await service.updateDokumenStatus(
        dokumenId: 1,
        status: 'Disetujui',
        catatanRevisi: 'Good job',
      );

      expect(result.bab, 'BAB I');
    });
  });
}
