import 'package:flutter/material.dart';
// --- ADD THIS IMPORT --
import 'package:flutter_application_3/View/Club/dashboard_page.dart'; // Adjust the path if your dashboard file is located elsewhere

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // You might want to match this to your app's theme later
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Your Sports Club App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Icon(Icons.sports_cricket, size: 100, color: Colors.white), // Example Icon
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // --- THIS IS THE UPDATED NAVIGATION LOGIC ---
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ClubDashboardScreen()), // Directly navigate to the screen
                  );
                  // --- END OF UPDATE ---
                },
                style: ElevatedButton.styleFrom(
                  // Consider matching button colors/style to your app theme
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Go to Dashboard',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}