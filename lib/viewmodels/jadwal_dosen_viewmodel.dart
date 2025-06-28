import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:digita_mobile/models/jadwal_bimbingan_model.dart';

enum DosenViewState { idle, loading, success, error }

class JadwalDosenViewModel extends ChangeNotifier {
  final Dio _dio;
  JadwalDosenViewModel({required Dio dio}) : _dio = dio;

  DosenViewState _state = DosenViewState.idle;
  DosenViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<JadwalBimbingan> _allSchedules = [];

  List<JadwalBimbingan> get pendingSchedules => _allSchedules.where((s) => s.status == 'PENDING').toList();
  List<JadwalBimbingan> get acceptedSchedules => _allSchedules.where((s) => s.status == 'ACCEPTED').toList();
  List<JadwalBimbingan> get doneSchedules => _allSchedules.where((s) => s.status == 'DONE').toList();

  void _setState(DosenViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchJadwalBimbinganDosen() async {
    _setState(DosenViewState.loading);
    try {
      final response = await _dio.get('/api/v1/tugas-akhir/jadwal-bimbingan/');
      List<dynamic> responseData = response.data;
      _allSchedules = responseData.map((data) => JadwalBimbingan.fromJson(data)).toList();
      _setState(DosenViewState.success);
    } on DioException catch (e) {
      _state = DosenViewState.error;
      _errorMessage = 'Failed to load schedule: ${e.response?.data['message'] ?? e.message}';
      notifyListeners();
    } catch (e) {
      _state = DosenViewState.error;
      _errorMessage = 'An unknown error occurred: $e';
      notifyListeners();
    }
  }

  void _updateLocalSchedule(Response response) {
    final index = _allSchedules.indexWhere((s) => s.id == response.data['id']);
    if (index != -1) {
      _allSchedules[index] = JadwalBimbingan.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<bool> approveJadwal(int jadwalId) async {
    try {
      final response = await _dio.patch(
        '/api/v1/tugas-akhir/jadwal-bimbingan/$jadwalId/respond/',
        data: {"status": "ACCEPTED"},
      );
      _updateLocalSchedule(response);
      return true;
    } on DioException catch (e) {
      _errorMessage = "Gagal menyetujui jadwal: ${e.response?.data['message'] ?? e.message}";
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectJadwal(int jadwalId, String alasan) async {
    if (alasan.trim().isEmpty) {
      _errorMessage = "Alasan penolakan tidak boleh kosong.";
      notifyListeners();
      return false;
    }
    try {
      final response = await _dio.patch(
        '/api/v1/tugas-akhir/jadwal-bimbingan/$jadwalId/respond/',
        data: {"status": "REJECTED", "alasan_penolakan": alasan},
      );
      _updateLocalSchedule(response);
      return true;
    } on DioException catch (e) {
      _errorMessage = "Gagal menolak jadwal: ${e.response?.data['message'] ?? e.message}";
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeJadwal(int jadwalId, String catatan) async {
    if (catatan.trim().isEmpty) {
      _errorMessage = "Catatan bimbingan tidak boleh kosong.";
      notifyListeners();
      return false;
    }
    try {
      final response = await _dio.patch(
        '/api/v1/tugas-akhir/jadwal-bimbingan/$jadwalId/complete/',
        data: {'catatan_bimbingan': catatan},
      );
      _updateLocalSchedule(response);
      return true;
    } on DioException catch (e) {
      _errorMessage = "Gagal menyelesaikan jadwal: ${e.response?.data['message'] ?? e.message}";
      notifyListeners();
      return false;
    }
  }
}