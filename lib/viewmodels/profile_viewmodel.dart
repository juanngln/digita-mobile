import 'package:digita_mobile/models/dosen_model.dart';
import 'package:digita_mobile/models/mahasiswa_profile.dart';
import 'package:digita_mobile/models/program_studi_model.dart';
import 'package:digita_mobile/services/profile_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

import '../models/dosen_profile.dart';

enum ProfileState { idle, loading, success, error }
enum UpdateProfileState { idle, loading, success, error }

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
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MahasiswaProfile? mahasiswaProfile;

  Dosen? dosenProfile;
  DosenProfile? loggedInDosenProfile;

  ProfileState _supervisorState = ProfileState.idle;
  ProfileState get supervisorState => _supervisorState;
  Dosen? _supervisorDosenProfile;
  Dosen? get supervisorDosenProfile => _supervisorDosenProfile;
  String? _supervisorErrorMessage;
  String? get supervisorErrorMessage => _supervisorErrorMessage;

  ProfileState _prodiState = ProfileState.idle;
  ProfileState get prodiState => _prodiState;
  List<ProgramStudi> _programStudiList = [];
  List<ProgramStudi> get programStudiList => _programStudiList;
  String? _prodiErrorMessage;
  String? get prodiErrorMessage => _prodiErrorMessage;

  UpdateProfileState _updateState = UpdateProfileState.idle;
  UpdateProfileState get updateState => _updateState;
  String? _updateErrorMessage;
  String? get updateErrorMessage => _updateErrorMessage;

  Future<void> loadUserProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      final token = await _secureStorageService.getAccessToken();
      final userData = await _secureStorageService.getUserData();

      if (token == null || userData == null) {
        throw Exception("Sesi tidak valid atau data pengguna tidak ditemukan.");
      }

      final role = userData['role'] as String?;
      if (role == null) throw Exception("Peran pengguna tidak ditemukan.");

      mahasiswaProfile = null;
      dosenProfile = null;
      loggedInDosenProfile = null;

      if (role == 'mahasiswa') {
        mahasiswaProfile =
        await _profileService.getCurrentMahasiswaProfile(token: token);
      } else if (role == 'dosen') {

        final userId = userData['id'] as int?;
        if (userId == null) throw Exception("User ID Dosen tidak ditemukan.");

        final results = await Future.wait([
          _profileService.getDosenProfile(userId: userId, token: token),

          _profileService.getCurrentDosenProfile(token: token),
        ]);

        dosenProfile = results[0] as Dosen;
        loggedInDosenProfile = results[1] as DosenProfile;

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


  Future<void> fetchProgramStudi() async {
    if (_programStudiList.isNotEmpty) return;

    _prodiState = ProfileState.loading;
    notifyListeners();

    try {
      final token = await _secureStorageService.getAccessToken();
      if (token == null) throw Exception("Sesi tidak valid.");

      _programStudiList = await _profileService.getProgramStudiList(token: token);
      _prodiState = ProfileState.success;
    } catch (e) {
      _prodiErrorMessage = e.toString();
      _prodiState = ProfileState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile({
    required String namaLengkap,
    required String email,
    required String programStudiId,
  }) async {
    _updateState = UpdateProfileState.loading;
    _updateErrorMessage = null;
    notifyListeners();

    try {
      final token = await _secureStorageService.getAccessToken();
      if (token == null) throw Exception("Sesi tidak valid.");

      final body = {
        "nama_lengkap": namaLengkap,
        "email": email,
        "program_studi_id": programStudiId,
      };

      final updatedProfile = await _profileService.updateMahasiswaProfile(
        token: token,
        body: body,
      );

      mahasiswaProfile = updatedProfile;
      _updateState = UpdateProfileState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _updateErrorMessage = e.toString();
      _updateState = UpdateProfileState.error;
      notifyListeners();
      return false;
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
