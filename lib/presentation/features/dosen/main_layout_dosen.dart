import 'package:digita_mobile/presentation/features/dosen/dokumen/screens/dokumen_dosen_screen.dart';
import 'package:digita_mobile/presentation/features/dosen/home/screens/home_dosen_screen.dart';
import 'package:digita_mobile/presentation/features/dosen/jadwal/screens/jadwal_dosen_screen.dart';
import 'package:digita_mobile/presentation/features/dosen/pengajuan/screens/list_pengajuan_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/navbar/bottom_navbar_dosen.dart';
import 'package:digita_mobile/presentation/features/dosen/profile/screens/profile_dosen_screen.dart';
import 'package:flutter/material.dart';

class MainLayoutDosen extends StatefulWidget {
  const MainLayoutDosen({super.key});

  @override
  State<MainLayoutDosen> createState() => _MainLayoutDosenState();
}

class _MainLayoutDosenState extends State<MainLayoutDosen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeDosenScreen(),
    const JadwalDosenScreen(),
    const DokumenDosenScreen(),
    const PengajuanMahasiswaScreen(),
    const ProfileDosenScreen()
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
      bottomNavigationBar: BottomNavbarDosen(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}