import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/coaches_and_clubs_page.dart';
import 'package:flutter_application_3/View/drills_page.dart';
import 'package:flutter_application_3/View/leaderboard_page.dart';

import '../profile_page.dart';


// --- THEME COLORS ---
const Color kFieldColor = Color(0xFF2A3A4A); // Theme: Bottom Nav Background
const Color kActiveAccent = Color(0xFF00F0FF); // Theme: Active Icon
const Color kInactiveColor = Colors.white70; // Theme: Regular Text (Muted)

// This color is no longer used here but kept for reference
// const Color kAccentBlue = Color(0xFF4A90E2); 

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTapOverride;

  const AppBottomNavigation({super.key, required this.currentIndex, this.onTapOverride});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        if (onTapOverride != null) return onTapOverride!(i);
        // Default navigation behavior shared across pages
        if (i == currentIndex) return; // no-op when tapping the active tab

        if (i == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }

        if (i == 1) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LeaderboardPage()));
          return;
        }

        if (i == 2) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DrillsPage()));
          return;
        }

        if (i == 3) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CoachesAndClubsPage()));
          return;
        }

        if (i == 4) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
          return;
        }
      },
      backgroundColor: kFieldColor, // CHANGED: (Matches theme spec)
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kActiveAccent, // CHANGED: (Matches theme spec)
      unselectedItemColor: kInactiveColor, // CHANGED: (Matches theme spec)
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Leaderboard'),
        BottomNavigationBarItem(icon: Icon(Icons.sports_soccer_outlined), label: 'Drills'),
        BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Coaches & Club'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}