import 'package:flutter/material.dart';

class HomeDosenScreen extends StatefulWidget {
  const HomeDosenScreen({super.key});

  @override
  State<HomeDosenScreen> createState() => _HomeDosenScreenState();
}

class _HomeDosenScreenState extends State<HomeDosenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Dosen'),
      ),
      body: const Center(
        child: Text('Home Dosen Screen'),
      ),
    );
  }
}
