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

  // Filtered lists for each UI section based on API status
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
      _errorMessage = 'Failed to load schedule: ${e.response?.data ?? e.message}';
      notifyListeners();
    } catch (e) {
      _state = DosenViewState.error;
      _errorMessage = 'An unknown error occurred: $e';
      notifyListeners();
    }
  }

  // --- Action Methods for Dosen ---

  Future<bool> approveJadwal(int jadwalId) async {
    try {
      // IMPORTANT: Use your actual API endpoint for approving
      await _dio.post('/api/v1/tugas-akhir/jadwal-bimbingan/$jadwalId/approve/');
      await fetchJadwalBimbinganDosen(); // Refresh list on success
      return true;
    } on DioException catch (e) {
      _errorMessage = "Failed to approve: ${e.message}";
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectJadwal(int jadwalId, String alasan) async {
    try {
      // IMPORTANT: Use your actual API endpoint for rejecting
      await _dio.post(
        '/api/v1/tugas-akhir/jadwal-bimbingan/$jadwalId/reject/',
        data: {'alasan_penolakan': alasan},
      );
      await fetchJadwalBimbinganDosen(); // Refresh list on success
      return true;
    } on DioException catch (e) {
      _errorMessage = "Failed to reject: ${e.message}";
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeJadwal(int jadwalId, String catatan) async {
    try {
      // IMPORTANT: Use your actual API endpoint for completing
      await _dio.post(
        '/api/v1/tugas-akhir/jadwal-bimbingan/$jadwalId/complete/',
        data: {'catatan_bimbingan': catatan},
      );
      await fetchJadwalBimbinganDosen(); // Refresh list on success
      return true;
    } on DioException catch (e) {
      _errorMessage = "Failed to complete: ${e.message}";
      notifyListeners();
      return false;
    }
  }
}