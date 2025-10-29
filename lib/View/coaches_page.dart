

import 'package:flutter/material.dart';

const Color kDarkBlue = Color(0xFF1A2531);

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(title: const Text('Coaches')),
      body: const Center(child: Text('Coaches content here', style: TextStyle(color: Colors.white))),
    );
  }
  }