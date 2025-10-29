import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_application_3/View/player_dashboard.dart';


// --- Modern Gradient Glow Theme ---
const Color kDarkBlue = Color(0xFF0F2027);
const Color kCardGlass = Color(0x1AFFFFFF);
const Color kAccentCyan = Color(0xFF00A8E8);
const Color kTextPrimary = Colors.white;
const Color kTextSecondary = Colors.white70;

class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Glassy Image Container ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      decoration: BoxDecoration(
                        color: kCardGlass,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kTextPrimary.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: kAccentCyan.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/fourth.png', // Replace with your image
                        height: 250,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // --- Welcome Text ---
                const Text(
                  'Welcome to SkillBoost!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your registration was successful. Get ready to elevate your game!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextSecondary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // --- Go to Dashboard Button ---
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const  PlayerDashboardPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentCyan,
                    foregroundColor: kTextPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: kAccentCyan.withOpacity(0.5),
                  ),
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
