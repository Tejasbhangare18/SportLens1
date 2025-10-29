import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- 1. Top Light Image Section ---
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF3F0EC), // soft beige background
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/sport.png', // your image
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),

        // --- 2. Bottom Dark Section ---
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0D1B2A), // dark navy blue background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Record Your Game',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Capture your performance in action. Our AI analyzes your movements and provides personalized feedback to help you level up.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // --- Dots indicator ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDot(isActive: true),
                        const SizedBox(width: 8),
                        _buildDot(isActive: false),
                        const SizedBox(width: 8),
                        _buildDot(isActive: false),
                      ],
                    ),
                  ],
                ),

                // --- Buttons Row (Skip / Next) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Skip logic
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1B263B), // dark gray-blue
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Next Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Next page logic
                          Navigator.of(context).pushNamed('/onboarding2');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A8E8), // cyan blue
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Dot Builder ---
  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF00A8E8) : Colors.grey.shade700,
        shape: BoxShape.circle,
      ),
    );
  }
}
