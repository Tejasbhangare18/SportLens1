import 'package:flutter/material.dart';
import 'trials_theme.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: kTrialBackground,
      ),
      body: const Center(
        child: Text(
          'Support form or contact link here',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
