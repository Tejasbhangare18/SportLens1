import 'package:flutter/material.dart';
import 'trials_theme.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Community Guidelines'),
        backgroundColor: kTrialBackground,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Community guidelines content here',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
