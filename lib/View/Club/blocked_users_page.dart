import 'package:flutter/material.dart';
import 'trials_theme.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Blocked Users'),
        backgroundColor: kTrialBackground,
      ),
      body: const Center(
        child: Text(
          'Blocked users management screen',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
