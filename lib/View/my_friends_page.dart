import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for AnnotatedRegion
import 'package:flutter_application_3/models/player.dart'; // Adjust path if needed
import 'package:flutter_application_3/View/leaderboard_page.dart'; // Used for PlayerProfileDialog

// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
const Color kGreen = Color(0xFF34D399); // Rank Up Color
const Color kRed = Colors.redAccent;    // Rank Down Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---


class MyFriendsPage extends StatefulWidget { // Changed to StatefulWidget for animation
  const MyFriendsPage({super.key});

  @override
  State<MyFriendsPage> createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> with SingleTickerProviderStateMixin { // Added TickerProvider

  // --- Animation Controller for List Entry ---
  late AnimationController _listAnimationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  // ---

  // --- IMPORTANT: Get the ACTUAL list of followed friends ---
  // This uses sample data. Replace with your state management.
  // Moved data into the state class
  final List<Map<String, dynamic>> friendsData = [
    {'name': 'Ava Harper', 'points': 955, 'change': 12, 'avatar': 'assets/home1.png'},
    {'name': 'Liam Foster', 'points': 948, 'change': 0, 'avatar': 'assets/profile.png'},
    {'name': 'Noah James', 'points': 935, 'change': -5, 'avatar': 'assets/profile.png'},
    {'name': 'Olivia Smith', 'points': 920, 'change': 0, 'avatar': 'assets/profile.png'},
    {'name': 'Emma Wilson', 'points': 912, 'change': 8, 'avatar': 'assets/profile.png'},
    {'name': 'William Brown', 'points': 890, 'change': 0, 'avatar': 'assets/profile.png'},
  ];

 @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Duration for the whole list animation
    );

    // Create staggered animations for each item
    _fadeAnimations = List.generate(
      friendsData.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _listAnimationController,
          // Stagger the start time
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0), // Start later for later items
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

     _slideAnimations = List.generate(
      friendsData.length,
      (index) => Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _listAnimationController,
           curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _listAnimationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _listAnimationController.dispose(); // Dispose controller
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // THEME: Set status bar icons to light
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kDarkBlue, // THEME
        appBar: AppBar(
          backgroundColor: kDarkBlue, // THEME
          elevation: 0,
          title: const Text(
            'My Friends',
            style: TextStyle(
                color: kNewAccentCyan, // THEME
                fontWeight: FontWeight.bold,
                fontSize: 22
            )
          ),
          leading: IconButton( // Back button
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryText, size: 20), // THEME + Updated Icon
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0), // Consistent padding
          itemCount: friendsData.length,
          itemBuilder: (context, index) {
            final friend = friendsData[index];
            final rank = index + 1;

            // Create Player model instance for the dialog
            final player = Player(
              rank: rank,
              name: friend['name'],
              username: '@${friend['name'].toString().toLowerCase().replaceAll(' ', '')}', // Example username
              score: friend['points'],
              avatar: friend['avatar'],
              points: friend['points'].toString(), // Pass points as string if model expects it
              // Fill other Player fields with placeholders or actual data if available
              level: 5, age: 'Adult', sport: 'Soccer', role: 'Player', change: friend['change'], team: '',
            );

            // Apply entry animation to each list item
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: _FriendListItem( // Use the redesigned card
                  rank: rank,
                  name: friend['name'],
                  points: friend['points'],
                  rankChange: friend['change'],
                  avatar: friend['avatar'],
                  onTap: () {
                    // Show the themed PlayerProfileDialog (ensure it's updated)
                    showDialog(
                      context: context,
                       barrierColor: kDarkBlue.withOpacity(0.85),
                      // Assuming PlayerProfileDialog from leaderboard_page is already themed
                      builder: (_) => PlayerProfileDialog(player: player, showAddFriend: false), // showAddFriend is false for friends list
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- Redesigned Friend List Item Widget ---
class _FriendListItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final int rankChange;
  final String avatar;
  final VoidCallback onTap;

  const _FriendListItem({
    required this.rank,
    required this.name,
    required this.points,
    required this.rankChange,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Spacing between items
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0), // Internal padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), // Modern radius
            // Glassy gradient background
            gradient: LinearGradient(
              colors: [
                kFieldColor.withOpacity(0.9),
                kFieldColor.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // Subtle border glow
            border: Border.all(
              color: kNewAccentCyan.withOpacity(0.15),
              width: 1.5,
            ),
             // Soft shadow
            boxShadow: [
              BoxShadow(
                color: kNewAccentCyan.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank Text
              Text(
                '$rank',
                style: const TextStyle(
                  color: kSecondaryText, // THEME
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              // Avatar
              CircleAvatar(
                radius: 25, // Slightly larger avatar
                backgroundColor: kDarkBlue, // Fallback color
                backgroundImage: AssetImage(avatar),
                 onBackgroundImageError: (exception, stackTrace) {
                     print("Error loading avatar: $avatar"); // Handle image load errors
                 },
                 // Placeholder icon if image fails
                 child: (AssetImage(avatar).assetName == avatar) ? null : Icon(Icons.person, color: kSecondaryText),
              ),
              const SizedBox(width: 16),
              // Name and Points
              Expanded( // Use Expanded to push rank change to the end
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: kPrimaryText, // THEME
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$points pts',
                      style: const TextStyle(
                        color: kSecondaryText, // THEME
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Rank Change Indicator
              if (rankChange != 0)
                Row( // Wrap in Row for icon + text
                  mainAxisSize: MainAxisSize.min, // Prevent taking extra space
                  children: [
                     Icon(
                        rankChange > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: rankChange > 0 ? kGreen : kRed, // THEME colors
                        size: 18,
                     ),
                     const SizedBox(width: 4),
                    Text(
                      '${rankChange.abs()}', // Show absolute value
                      style: TextStyle(
                        color: rankChange > 0 ? kGreen : kRed, // THEME colors
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}