import 'package:digita_mobile/models/dosen_model.dart';
import 'package:digita_mobile/models/mahasiswa.dart';
import 'package:digita_mobile/services/profile_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

enum ProfileState { idle, loading, success, error }

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService;
  final SecureStorageService _secureStorageService;

  ProfileViewModel({
    required ProfileService profileService,
    required SecureStorageService secureStorageService,
  })  : _profileService = profileService,
        _secureStorageService = secureStorageService;

  ProfileState _state = ProfileState.idle;
  ProfileState get state => _state;
  Mahasiswa? mahasiswaProfile;
  Dosen? dosenProfile;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileState _supervisorState = ProfileState.idle;
  ProfileState get supervisorState => _supervisorState;
  Dosen? _supervisorDosenProfile;
  Dosen? get supervisorDosenProfile => _supervisorDosenProfile;
  String? _supervisorErrorMessage;
  String? get supervisorErrorMessage => _supervisorErrorMessage;

  Future<void> loadUserProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      final token = await _secureStorageService.getAccessToken();
      final userData = await _secureStorageService.getUserData();

      if (token == null || userData == null) {
        throw Exception("Sesi tidak valid atau data pengguna tidak ditemukan.");
      }

      final userId = userData['id'] as int?;
      final role = userData['role'] as String?;

      if (userId == null || role == null) {
        throw Exception("Data pengguna (ID atau Peran) tidak lengkap.");
      }

      mahasiswaProfile = null;
      dosenProfile = null;

      if (role == 'mahasiswa') {
        mahasiswaProfile = await _profileService.getMahasiswaProfile(
          userId: userId,
          token: token,
        );
      } else if (role == 'dosen') {
        dosenProfile = await _profileService.getDosenProfile(
          userId: userId,
          token: token,
        );
      } else {
        throw Exception("Peran pengguna tidak dikenali: $role");
      }

      _state = ProfileState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProfileState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadSupervisorProfile(int supervisorUserId) async {
    _supervisorState = ProfileState.loading;
    _supervisorDosenProfile = null;
    notifyListeners();

    try {
      final token = await _secureStorageService.getAccessToken();
      if (token == null) {
        throw Exception("Sesi tidak valid, token tidak ditemukan.");
      }

      _supervisorDosenProfile = await _profileService.getDosenProfile(
        userId: supervisorUserId,
        token: token,
      );

      _supervisorState = ProfileState.success;
    } catch (e) {
      _supervisorErrorMessage = e.toString();
      _supervisorState = ProfileState.error;
    } finally {
      notifyListeners();
    }
  }
}