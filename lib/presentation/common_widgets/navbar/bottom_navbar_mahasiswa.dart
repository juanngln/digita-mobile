import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavbarMahasiswa extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbarMahasiswa({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavbarMahasiswa> createState() => _BottomNavbarMahasiswaState();
}

class _BottomNavbarMahasiswaState extends State<BottomNavbarMahasiswa> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: widget.currentIndex,
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        animationDuration: Duration(milliseconds: 500),
        items: <Widget>[
          Icon(key: const Key('navHome'), Icons.home_filled, size: 28, color: Colors.white),
          Icon(key: const Key('navSchedule'), Icons.calendar_month_rounded, size: 28, color: Colors.white),
          Icon(key: const Key('navDocument'), Icons.sticky_note_2_rounded, size: 28, color: Colors.white),
          Icon(key: const Key('navKanban'), Icons.view_kanban_rounded, size: 28, color: Colors.white),
          Icon(key: const Key('navProfile'), Icons.person, size: 28, color: Colors.white),
        ],
        onTap: widget.onTap,
      ),
    );
  }
}
