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

  List<JadwalBimbingan> _allSchedules = [];
  List<JadwalBimbingan> get upcomingSchedules =>
      _allSchedules.where((s) => s.status != 'DONE' && s.status != 'CANCELED').toList();
  List<JadwalBimbingan> get finishedSchedules =>
      _allSchedules.where((s) => s.status == 'DONE' || s.status == 'CANCELED').toList();

  List<Ruangan> _ruanganList = [];
  List<Ruangan> get ruanganList => _ruanganList;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _isRescheduling = false;
  bool get isRescheduling => _isRescheduling;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setIsCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setIsRescheduling(bool rescheduling) {
    _isRescheduling = rescheduling;
    notifyListeners();
  }

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

  // --- Method: Fetch Ruangan ---
  Future<void> fetchRuangan() async {
    try {
      final response = await _dio.get('/api/v1/tugas-akhir/ruangan/');
      List<dynamic> responseData = response.data;
      _ruanganList = responseData.map((data) => Ruangan.fromJson(data)).toList();
      notifyListeners();
    } on DioException catch (e) {
    }
  }

  // --- Method: Create Jadwal Bimbingan ---
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
      await fetchJadwalBimbingan();
      _setIsCreating(false);
      return true;
    } on DioException catch (e) {
      _errorMessage = 'Gagal mengajukan jadwal: ${e.response?.data['message'] ?? e.message}';
      _setIsCreating(false);
      return false;
    }
  }

  // --- Method: Reschedule Jadwal Bimbingan ---
  Future<bool> rescheduleJadwalBimbingan({
    required int scheduleId,
    required String judul,
    required DateTime tanggal,
    required TimeOfDay waktu,
    required int lokasiRuanganId,
  }) async {
    _setIsRescheduling(true);

    final requestBody = {
      "judul_bimbingan": judul,
      "tanggal": DateFormat('yyyy-MM-dd').format(tanggal),
      "waktu": "${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}:00",
      "lokasi_ruangan_id": lokasiRuanganId,
    };

    try {
      await _dio.patch(
        '/api/v1/tugas-akhir/jadwal-bimbingan/$scheduleId/reschedule/',
        data: requestBody,
      );
      await fetchJadwalBimbingan();
      _setIsRescheduling(false);
      return true;
    } on DioException catch (e) {
      _errorMessage = 'Gagal reschedule jadwal: ${e.response?.data['message'] ?? e.message}';
      _setIsRescheduling(false);
      return false;
    }
  }
}