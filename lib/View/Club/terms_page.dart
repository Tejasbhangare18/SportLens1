import 'package:flutter/material.dart';
import 'trials_theme.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: kTrialBackground,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Terms & Conditions content goes here',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
