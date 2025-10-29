import 'package:flutter/material.dart';

const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _sectionTitle('Account'),
          _buildTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Name, handle, team',
            onTap: () => Navigator.of(context).pushNamed('/edit-profile'),
          ),
          _buildTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {},
          ),
          const Divider(color: Colors.white12),

          _sectionTitle('Notifications'),
          SwitchListTile(
            value: true,
            onChanged: (v) {},
            title: const Text(
              'Push Notifications',
              style: TextStyle(color: Colors.white),
            ),
            activeColor: kAccentBlue,
            subtitle: const Text(
              'Receive alerts about sessions and messages',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          SwitchListTile(
            value: false,
            onChanged: (v) {},
            title: const Text(
              'Email Notifications',
              style: TextStyle(color: Colors.white),
            ),
            activeColor: kAccentBlue,
            subtitle: const Text(
              'Weekly summary and tips',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white12),

          _sectionTitle('Privacy'),
          _buildTile(
            context,
            icon: Icons.visibility_off,
            title: 'Private Account',
            subtitle: 'Only approved users can see you',
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.block,
            title: 'Blocked Users',
            subtitle: 'Manage blocked users',
            onTap: () {},
          ),
          const Divider(color: Colors.white12),

          _sectionTitle('App'),
          _buildTile(
            context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.color_lens_outlined,
            title: 'Theme',
            subtitle: 'Light / Dark',
            onTap: () {},
          ),
          const Divider(color: Colors.white12),

          _sectionTitle('About'),
          _buildTile(
            context,
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Support',
            subtitle: 'Contact us',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              // Confirm logout
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      backgroundColor: kFieldColor,
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
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
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text('Logout', style: TextStyle(fontSize: 16)),
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

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: const TextStyle(color: Colors.white70))
              : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}
