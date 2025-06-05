import 'package:digita_mobile/views/mahasiswa/home_mahasiswa_screen.dart';
import 'package:digita_mobile/views/mahasiswa/jadwal_mahasiswa_screen.dart';
import 'package:digita_mobile/widgets/bottom_navbar/bottom_navbar_mahasiswa.dart';
import 'package:flutter/material.dart';

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
