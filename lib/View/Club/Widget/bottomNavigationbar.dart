import 'package:flutter/material.dart';

// --- THEME COLORS from AppBottomNavigation ---
const Color kFieldColor = Color(0xFF2A3A4A); // Background Color
const Color kActiveAccent = Color(0xFF00F0FF); // Active Item Color (Bright Cyan)
const Color kInactiveColor = Colors.white70; // Inactive Item Color

class ClubBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  // Removed selectedItemColor parameter as requested

  const ClubBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap, required Color selectedItemColor,
    // Removed selectedItemColor from constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Use kFieldColor for the background
      backgroundColor: kFieldColor,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed, // Keep items visible and sized equally
      // Use kActiveAccent for the selected item's icon and label
      selectedItemColor: kActiveAccent,
      // Use kInactiveColor for unselected items' icons and labels
      unselectedItemColor: kInactiveColor,
      onTap: onTap,
      // Apply the same label styles for consistency
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12), // Match font size
      items: const [
        // Keeping the Club-specific items
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Scouting'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Leaderboard'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}