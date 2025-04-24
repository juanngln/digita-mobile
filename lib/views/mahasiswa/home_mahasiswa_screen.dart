import 'package:flutter/material.dart';

class HomeMahasiswaScreen extends StatefulWidget {
  const HomeMahasiswaScreen({super.key});

  @override
  State<HomeMahasiswaScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeMahasiswaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Mahasiswa'),
      ),
      body: const Center(
        child: Text('Home Mahasiswa Screen'),
      ),
    );
  }
}
