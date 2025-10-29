import 'package:flutter/material.dart';
import 'package:flutter_application_3/_Splash_Screen.dart';
import 'View/onboarding_pages/page1.dart';
import 'View/onboarding_pages/page2.dart'; // Make sure you have these files
import 'View/onboarding_pages/page3.dart'; // Make sure you have these files
import 'View/signup/signup_page.dart';

// --- 1. ADDED IMPORT ---
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // Start the app with the SplashScreen (which is now the gatekeeper)
      home: const SplashScreen(),
    );
  }
}

//
// -----------------------------------------------------------------
// --- ONBOARDING SCREEN (Handles buttons, dots, and pages) ---
// -----------------------------------------------------------------
//

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  // --- 2. MODIFIED: This function now saves the 'hasSeenOnboarding' flag ---
  void _goToSignup() async {
    // Get device storage
    final prefs = await SharedPreferences.getInstance();
    // Save that user has seen onboarding
    await prefs.setBool('hasSeenOnboarding', true);

    // Navigate to SignUpPage
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your pages
    final pages = const [
      OnboardingPage1(),
      OnboardingPage2(), // Ensure this widget exists
      OnboardingPage3(), // Ensure this widget exists
    ];

    return Scaffold(
      // This is the dark background for the button/indicator area
      backgroundColor: const Color(0xFF1A2531),
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. PageView ---
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: pages,
              ),
            ),
            
            // --- 2. Page Indicators (Dots) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index: index),
              ),
            ),
            const SizedBox(height: 24), // Space between dots and buttons

            // --- 3. Button Row (Styled) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- "Skip" Button ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToSignup, // Calls modified function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F3A4B), 
                        foregroundColor: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Skip', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16), // Space between buttons

                  // --- "Next" / "Done" Button ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_index < pages.length - 1) {
                          _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        } else {
                          _goToSignup(); // Calls modified function
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF), 
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _index < pages.length - 1 ? 'Next' : 'Done',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for building the dots
  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _index == index ? 24 : 8, // Active dot is wider
      decoration: BoxDecoration(
        color: _index == index ? const Color(0xFF007AFF) : Colors.grey.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}