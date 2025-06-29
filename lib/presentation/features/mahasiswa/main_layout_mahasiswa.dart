import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/screens/dokumen_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/home/screens/home_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/screens/jadwal_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/navbar/bottom_navbar_mahasiswa.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/kanban/screens/kanban_board_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/profile/screens/profile_mahasiswa_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../../services/dio_client.dart';
import '../../../services/profile_service.dart'; // Import ProfileService
import '../../../services/secure_storage_service.dart';
import '../../../viewmodels/dokumen_mahasiswa_viewmodel.dart';
import '../../../viewmodels/jadwal_mahasiswa_viewmodel.dart';
import '../../../viewmodels/profile_viewmodel.dart'; // Import ProfileViewModel

class MainLayoutMahasiswa extends StatefulWidget {
  const MainLayoutMahasiswa({super.key});

  @override
  State<MainLayoutMahasiswa> createState() => _MainLayoutMahasiswa();
}

class _MainLayoutMahasiswa extends State<MainLayoutMahasiswa> {
  int _selectedIndex = 0;

  // Initialize services once
  final SecureStorageService _secureStorageService = SecureStorageService();
  late final DioClient _dioClient;
  late final ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    _dioClient = DioClient(Dio(), _secureStorageService);
    _profileService = ProfileService();
  }

  late final List<Widget> _pages = <Widget>[
    const HomeMahasiswaScreen(),
    ChangeNotifierProvider(
      create: (context) {
        return JadwalViewModel(dio: _dioClient.dio);
      },
      child: const JadwalMahasiswaScreen(),
    ),
    ChangeNotifierProvider(
      create: (context) => DokumenViewModel(),
      child: const DokumenMahasiswaScreen(),
    ),
    const KanbanBoardScreen(),
    ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        profileService: _profileService,
        secureStorageService: _secureStorageService,
      ),
      child: const ProfileMahasiswaScreen(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavbarMahasiswa(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _profileService.dispose(); // Dispose the client in ProfileService
    super.dispose();
  }
}