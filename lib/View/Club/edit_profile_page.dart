import 'package:flutter/material.dart';
import 'app_settings.dart';
import 'trials_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController(
      text: AppSettings.instance.username.value,
    );
    _email = TextEditingController(text: AppSettings.instance.email.value);
    _phone = TextEditingController(text: AppSettings.instance.phone.value);
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    AppSettings.instance.username.value = _username.text.trim();
    AppSettings.instance.email.value = _email.text.trim();
    AppSettings.instance.phone.value = _phone.text.trim();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: kTrialBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _username,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Username',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Email',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Phone',
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
