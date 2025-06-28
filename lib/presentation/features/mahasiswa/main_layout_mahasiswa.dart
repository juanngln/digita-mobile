import 'package:digita_mobile/presentation/features/mahasiswa/dokumen/screens/dokumen_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/home/screens/home_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/jadwal/screens/jadwal_mahasiswa_screen.dart';
import 'package:digita_mobile/presentation/common_widgets/navbar/bottom_navbar_mahasiswa.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/kanban/screens/kanban_board_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/profile/screens/profile_mahasiswa_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/dokumen_viewmodel.dart';

class MainLayoutMahasiswa extends StatefulWidget {
  const MainLayoutMahasiswa({super.key});

  @override
  State<MainLayoutMahasiswa> createState() => _MainLayoutMahasiswa();
}

class _MainLayoutMahasiswa extends State<MainLayoutMahasiswa> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeMahasiswaScreen(),
    const JadwalMahasiswaScreen(),
    ChangeNotifierProvider(
      create: (context) => DokumenViewModel(),
      child: const DokumenMahasiswaScreen(),
    ),
    const KanbanBoardScreen(),
    const ProfileMahasiswaScreen()
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
}
