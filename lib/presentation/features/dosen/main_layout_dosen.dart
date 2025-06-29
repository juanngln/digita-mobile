import 'package:digita_mobile/presentation/features/dosen/dokumen/screens/dokumen_dosen_screen.dart';
import 'package:digita_mobile/presentation/features/dosen/home/screens/home_dosen_screen.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/screens/jadwal_dosen_screen.dart';
import 'package:digita_mobile/presentation/features/dosen/pengajuan/screens/list_pengajuan_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/navbar/bottom_navbar_dosen.dart';
import 'package:digita_mobile/presentation/features/dosen/profile/screens/profile_dosen_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/dio_client.dart';
import '../../../services/profile_service.dart';
import '../../../services/secure_storage_service.dart';
import '../../../viewmodels/jadwal_dosen_viewmodel.dart';
import '../../../viewmodels/pengumuman_viewmodel.dart';
import '../../../viewmodels/profile_viewmodel.dart';

class MainLayoutDosen extends StatefulWidget {
  const MainLayoutDosen({super.key});

  @override
  State<MainLayoutDosen> createState() => _MainLayoutDosenState();
}

class _MainLayoutDosenState extends State<MainLayoutDosen> {
  int _selectedIndex = 0;

  final SecureStorageService _secureStorageService = SecureStorageService();
  late final DioClient _dioClient;
  late final ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    _dioClient = DioClient(Dio(), _secureStorageService);
    _profileService = ProfileService();
  }

  final List<Widget> _pages = <Widget>[
    const HomeDosenScreen(),
    JadwalDosenScreen(),
    const DokumenDosenScreen(),
    const PengajuanMahasiswaScreen(),
    const ProfileDosenScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _profileService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileViewModel>(
          create: (context) => ProfileViewModel(
            profileService: _profileService,
            secureStorageService: _secureStorageService,
          ),
        ),
        ChangeNotifierProvider<PengumumanViewModel>(
          create: (context) => PengumumanViewModel(),
        ),
        ChangeNotifierProvider<JadwalDosenViewModel>(
          create: (context) => JadwalDosenViewModel(dio: _dioClient.dio),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavbarDosen(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}