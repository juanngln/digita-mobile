import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:digita_mobile/models/jadwal_bimbingan_model.dart';
import 'package:digita_mobile/models/ruangan_model.dart';
import 'package:intl/intl.dart';


enum ViewState { idle, loading, success, error }

class JadwalViewModel extends ChangeNotifier {
  final Dio _dio;
  JadwalViewModel({required Dio dio}) : _dio = dio;

  // --- State Management ---
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- Data Properties ---
  List<JadwalBimbingan> _allSchedules = [];
  List<JadwalBimbingan> get upcomingSchedules =>
      _allSchedules.where((s) => s.status != 'DONE').toList();
  List<JadwalBimbingan> get finishedSchedules =>
      _allSchedules.where((s) => s.status == 'DONE').toList();

  List<Ruangan> _ruanganList = [];
  List<Ruangan> get ruanganList => _ruanganList;

  // --- State for creating schedule ---
  bool _isCreating = false;
  bool get isCreating => _isCreating;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setIsCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  // --- Existing Method ---
  Future<void> fetchJadwalBimbingan() async {
    _setState(ViewState.loading);
    try {
      final response = await _dio.get('/api/v1/tugas-akhir/jadwal-bimbingan/');
      List<dynamic> responseData = response.data;
      _allSchedules =
          responseData.map((data) => JadwalBimbingan.fromJson(data)).toList();
      _setState(ViewState.success);
    } on DioException catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Failed to load schedule: ${e.message}';
      notifyListeners();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'An unknown error occurred: $e';
      notifyListeners();
    }
  }

  // --- NEW Method: Fetch Ruangan ---
  Future<void> fetchRuangan() async {
    try {
      final response = await _dio.get('/api/v1/tugas-akhir/ruangan/');
      List<dynamic> responseData = response.data;
      _ruanganList = responseData.map((data) => Ruangan.fromJson(data)).toList();
      notifyListeners();
    } on DioException catch (e) {
      // Handle error, maybe set an error message for the dropdown
      print('Failed to load ruangan: ${e.message}');
    }
  }

  // --- NEW Method: Create Jadwal Bimbingan ---
  Future<bool> createJadwalBimbingan({
    required String judul,
    required DateTime tanggal,
    required TimeOfDay waktu,
    required int lokasiRuanganId,
  }) async {
    _setIsCreating(true);

    final requestBody = {
      "judul_bimbingan": judul,
      "tanggal": DateFormat('yyyy-MM-dd').format(tanggal),
      "waktu": "${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}:00",
      "lokasi_ruangan_id": lokasiRuanganId,
    };

    try {
      await _dio.post(
        '/api/v1/tugas-akhir/jadwal-bimbingan/',
        data: requestBody,
      );
      // After successfully creating, refresh the main schedule list
      await fetchJadwalBimbingan();
      _setIsCreating(false);
      return true;
    } on DioException catch (e) {
      _errorMessage = 'Gagal mengajukan jadwal: ${e.response?.data['message'] ?? e.message}';
      _setIsCreating(false);
      return false;
    }
  }
}