import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'player_register_newpage.dart';
import 'couch_register_page.dart';
import 'club_register_page.dart';
import 'signup_page.dart';

// --- Modern Theme Colors ---
const Color kDarkBlue = Color(0xFF0F2027);
const Color kCardGlass = Color(0x1AFFFFFF);
const Color kAccentCyan = Color(0xFF00A8E8);
const Color kTextPrimary = Colors.white;
const Color kTextSecondary = Colors.white70;
const Color kArrowColor = Colors.white54;

class JoinSportsProPage extends StatelessWidget {
  const JoinSportsProPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Join SportLens',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your role to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                _buildRoleOption(
                  context,
                  icon: Icons.person_outline,
                  iconColor: kAccentCyan,
                  title: 'Sign up as a Player',
                  subtitle: 'Track your performance and compete',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PlayerRegistrationPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildRoleOption(
                  context,
                  icon: Icons.sports,
                  iconColor: Colors.greenAccent,
                  title: 'Sign up as a Coach',
                  subtitle: 'Train athletes and manage teams',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CoachRegistrationPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildRoleOption(
                  context,
                  icon: Icons.business,
                  iconColor: Colors.purpleAccent,
                  title: 'Sign up as a Club',
                  subtitle: 'Manage facilities and members',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClubRegistrationPage()),
                    );
                  },
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: const TextStyle(
                            color: kAccentCyan,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: kCardGlass,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: kTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: kArrowColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
