import 'package:digita_mobile/views/dosen/home_dosen_screen.dart';
import 'package:digita_mobile/widgets/bottom_navbar/bottom_navbar_dosen.dart';
import 'package:flutter/material.dart';

class MainLayoutDosen extends StatefulWidget {
  const MainLayoutDosen({super.key});

  @override
  State<MainLayoutDosen> createState() => _MainLayoutDosen();
}

class _MainLayoutDosen extends State<MainLayoutDosen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeDosenScreen(),
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
