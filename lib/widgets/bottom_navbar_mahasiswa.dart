import 'package:flutter/material.dart';

class BottomNavbarMahasiswa extends StatefulWidget {
  const BottomNavbarMahasiswa({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavbarMahasiswaState createState() => _BottomNavbarMahasiswaState();
}

class _BottomNavbarMahasiswaState extends State<BottomNavbarMahasiswa> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, color: Color(0xFFFFFFFF)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded, color: Color(0xFFFFFFFF)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_document, color: Color(0xFFFFFFFF)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart_rounded, color: Color(0xFFFFFFFF)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Color(0xFFFFFFFF)),
        ),
      ],
    );
  }
}
