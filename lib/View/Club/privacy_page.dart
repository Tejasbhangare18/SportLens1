import 'package:flutter/material.dart';
import 'trials_theme.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: kTrialBackground,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Privacy Policy content here',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
