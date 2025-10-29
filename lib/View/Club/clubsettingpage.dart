import 'package:flutter/material.dart';
import 'app_settings.dart';

const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // No local copies; use AppSettings for persistence and app-wide sync

  void _editField({
    required String title,
    required String value,
    required Function(String) onSave,
    bool obscure = false,
  }) {
    final controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: kFieldColor,
            title: Text(title, style: const TextStyle(color: Colors.white)),
            content: TextField(
              controller: controller,
              obscureText: obscure,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF23252B),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onSave(controller.text.trim());
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _changePassword() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: kFieldColor,
            title: const Text(
              'Change Password',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Current password',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: newCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'New password',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Confirm new password',
                    filled: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (newCtrl.text.isEmpty ||
                      newCtrl.text != confirmCtrl.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  // Placeholder: accept change
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _openBlockedUsers() {
    Navigator.of(context).pushNamed('/blocked-users');
  }

  void _openWhoCanInvite() {
    Navigator.of(context).pushNamed('/invite-permissions');
  }

  void _openLanguagePicker() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (_) => SimpleDialog(
            backgroundColor: kFieldColor,
            title: const Text(
              'Select Language',
              style: TextStyle(color: Colors.white),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop('English (US)'),
                child: const Text(
                  'English (US)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop('Español'),
                child: const Text(
                  'Español',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
    if (result != null) {
      AppSettings.instance.language.value = result;
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: kFieldColor,
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: kFieldColor,
            title: const Text(
              'Delete Club',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'This will permanently delete or deactivate the club. Are you sure?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // perform deletion flow (placeholder)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Account section
          _sectionTitle('Account'),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white70),
            title: const Text(
              'Username',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: ValueListenableBuilder<String>(
              valueListenable: AppSettings.instance.username,
              builder:
                  (_, val, __) =>
                      Text(val, style: const TextStyle(color: Colors.white70)),
            ),
            trailing: const Icon(Icons.edit, color: Colors.white54),
            onTap:
                () => _editField(
                  title: 'Username',
                  value: AppSettings.instance.username.value,
                  onSave: (v) => AppSettings.instance.username.value = v,
                ),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined, color: Colors.white70),
            title: const Text(
              'Change Email',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: ValueListenableBuilder<String>(
              valueListenable: AppSettings.instance.email,
              builder:
                  (_, val, __) =>
                      Text(val, style: const TextStyle(color: Colors.white70)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap:
                () => _editField(
                  title: 'Change Email',
                  value: AppSettings.instance.email.value,
                  onSave: (v) => AppSettings.instance.email.value = v,
                ),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined, color: Colors.white70),
            title: const Text(
              'Change Phone Number',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: ValueListenableBuilder<String>(
              valueListenable: AppSettings.instance.phone,
              builder:
                  (_, val, __) =>
                      Text(val, style: const TextStyle(color: Colors.white70)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap:
                () => _editField(
                  title: 'Change Phone Number',
                  value: AppSettings.instance.phone.value,
                  onSave: (v) => AppSettings.instance.phone.value = v,
                ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.white70),
            title: const Text(
              'Change Password',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Update your password',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: _changePassword,
          ),
          const Divider(color: Colors.white12),

          // Privacy section
          _sectionTitle('Privacy'),
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.instance.privateAccount,
            builder:
                (_, val, __) => SwitchListTile(
                  value: val,
                  onChanged:
                      (v) => AppSettings.instance.privateAccount.value = v,
                  title: const Text(
                    'Private Account',
                    style: TextStyle(color: Colors.white),
                  ),
                  activeColor: kAccentBlue,
                  subtitle: const Text(
                    'Switch to toggle visibility',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.white70),
            title: const Text(
              'Manage Blocked Users',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Manage blocked users',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: _openBlockedUsers,
          ),
          ListTile(
            leading: const Icon(
              Icons.how_to_reg_outlined,
              color: Colors.white70,
            ),
            title: const Text(
              'Who Can Invite You to Trials',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Permissions',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: _openWhoCanInvite,
          ),
          // Data sharing preferences could be added here
          const Divider(color: Colors.white12),

          // App section
          _sectionTitle('App'),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white70),
            title: const Text(
              'Language Selection',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: ValueListenableBuilder<String>(
              valueListenable: AppSettings.instance.language,
              builder:
                  (_, val, __) =>
                      Text(val, style: const TextStyle(color: Colors.white70)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: _openLanguagePicker,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.instance.darkMode,
            builder:
                (_, val, __) => SwitchListTile(
                  value: val,
                  onChanged: (v) => AppSettings.instance.darkMode.value = v,
                  title: const Text(
                    'Theme (Dark Mode)',
                    style: TextStyle(color: Colors.white),
                  ),
                  activeColor: kAccentBlue,
                  subtitle: const Text(
                    'Toggle light/dark app-wide',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
          ),
          const Divider(color: Colors.white12),

          // About section
          _sectionTitle('About'),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white70),
            title: const Text(
              'App Version',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              '1.0.0',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white70,
            ),
            title: const Text('Support', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              'Contact us',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () => Navigator.of(context).pushNamed('/support'),
          ),
          ListTile(
            leading: const Icon(Icons.rule, color: Colors.white70),
            title: const Text(
              'Terms & Conditions',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.of(context).pushNamed('/terms'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.white70),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.of(context).pushNamed('/privacy'),
          ),
          ListTile(
            leading: const Icon(
              Icons.people_alt_outlined,
              color: Colors.white70,
            ),
            title: const Text(
              'Community Guidelines',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.of(context).pushNamed('/guidelines'),
          ),
          const SizedBox(height: 16),

          // Logout & Delete
          ElevatedButton(
            onPressed: _confirmLogout,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text('Logout', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _confirmDeleteAccount,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Delete / Deactivate Club',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      t,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Helper removed; ListTiles are inlined for clarity.
}
