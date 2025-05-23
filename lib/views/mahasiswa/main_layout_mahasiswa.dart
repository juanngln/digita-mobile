import 'package:digita_mobile/views/mahasiswa/home_mahasiswa_screen.dart';
import 'package:digita_mobile/widgets/bottom_navbar/bottom_navbar_mahasiswa.dart';
import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: Center(child: Text('Content for $title')),
    );
  }
}

class MainMahasiswaLayoutScreen extends StatefulWidget {
  const MainMahasiswaLayoutScreen({super.key});

  @override
  State<MainMahasiswaLayoutScreen> createState() =>
      _MainMahasiswaLayoutScreenState();
}

class _MainMahasiswaLayoutScreenState extends State<MainMahasiswaLayoutScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeMahasiswaScreen(),
    const PlaceholderScreen(title: 'Jadwal (Tab 2)'),
    const PlaceholderScreen(title: 'Dokumen (Tab 3)'),
    const PlaceholderScreen(title: 'Kanban (Tab 4)'),
    const PlaceholderScreen(title: 'Profil (Tab 5)'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          if (mounted) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavbarMahasiswa(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
