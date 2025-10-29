import 'package:flutter/material.dart';
import 'trials_theme.dart';

class InvitePermissionsPage extends StatelessWidget {
  const InvitePermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Invite Permissions'),
        backgroundColor: kTrialBackground,
      ),
      body: const Center(
        child: Text(
          'Configure who can invite you to trials',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
