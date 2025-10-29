// File: full_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/player.dart'; // Ensure Player model is correct
import 'widgets/videos_section.dart'; // Assuming VideoItem model is defined here or imported

// --- UI Constants ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentGreen = Color(0xFF34D399);
const Color kNewAccentCyan = Color(0xFF00A8E8); // Button color
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;

class FullProfilePage extends StatelessWidget {
  final Player player;
  final bool showAddFriend;
  final bool isViewedByClub; // Flag to determine view context

  // Example video items
  final List<VideoItem> videoItems = [
    VideoItem(thumbnail: 'assets/images/placeholder_icon.png', title: 'Dribbling Drill', score: 88),
    VideoItem(thumbnail: 'assets/images/placeholder_icon.png', title: 'Shooting Practice', score: 75),
    VideoItem(thumbnail: 'assets/images/placeholder_icon.png', title: 'Game Highlights', score: 92),
    VideoItem(thumbnail: 'assets/images/placeholder_icon.png', title: 'Defensive Drills', score: 80),
  ];

  FullProfilePage({
    super.key,
    required this.player,
    this.showAddFriend = true, // Still useful for player-to-player view
    this.isViewedByClub = false, // Default is player view
  });

  // Calculate average score
  double _calculateAverageScore() {
    double score = double.tryParse(player.score.toString()) ?? 0.0;
    return score / 10.0; // Convert 0-1000 score to 0-100 rating
  }

  @override
  Widget build(BuildContext context) {
    final double averageScore = _calculateAverageScore();

    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryText),
        title: const Text('Player Profile', style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold)),
        actions: showAddFriend && !isViewedByClub // Conditionally show Add Friend
            ? [
                IconButton(
                  tooltip: 'Add Friend',
                  icon: const Icon(Icons.person_add, color: kPrimaryText),
                  onPressed: () { /* ... */ },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(radius: 50, backgroundImage: AssetImage(player.avatar)),
            const SizedBox(height: 16),
            Text(player.name, style: const TextStyle(color: kPrimaryText, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${player.username} • Total Points: ${player.points}',
              style: const TextStyle(color: kSecondaryText)
            ),
            const SizedBox(height: 24),
            _buildPerformanceRating(averageScore),
            const SizedBox(height: 32),
            _buildAchievementsSection(),
            const SizedBox(height: 32),
            VideosSection(items: videoItems),
            const SizedBox(height: 32),

            // --- THIS IS THE KEY PART ---
            // If viewed by club, show club buttons (including Invite)
            // Otherwise, show player buttons
            if (isViewedByClub)
              _buildClubActionButtons(context)
            else
              _buildPlayerActionButtons(context),
            // --- END KEY PART ---

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Buttons shown when isViewedByClub is TRUE ---
  Widget _buildClubActionButtons(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         // Invite button IS included here
         ElevatedButton.icon(
           icon: const Icon(Icons.person_add_alt_1, size: 20),
           label: const Text('Invite to Trials'),
           onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Club Invite Sent (Placeholder)')),
               );
           },
           style: ElevatedButton.styleFrom(
               backgroundColor: kNewAccentCyan,
               foregroundColor: kDarkBlue, // Text color on cyan button
               padding: const EdgeInsets.symmetric(vertical: 14),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
           ),
        ),
        const SizedBox(height: 12),
         ElevatedButton.icon( // Changed to ElevatedButton for consistency or keep OutlinedButton
           icon: const Icon(Icons.note_add_outlined, size: 20),
           label: const Text('Add Scouting Note'),
           onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Add Note Tapped (Placeholder)')),
               );
           },
           style: ElevatedButton.styleFrom(
               backgroundColor: kFieldColor, // Darker button background
               foregroundColor: kPrimaryText, // White text
               padding: const EdgeInsets.symmetric(vertical: 14),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12),
                 side: const BorderSide(color: Colors.white24) // Subtle border
               ),
               textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
           ),
        ),
      ],
     );
   }

  // --- Buttons shown when isViewedByClub is FALSE ---
  Widget _buildPlayerActionButtons(BuildContext context) {
    // Player does NOT see 'Invite to Trials' here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         OutlinedButton.icon(
           icon: const Icon(Icons.share, size: 20),
           label: const Text('Share Profile'),
           onPressed: () { /* ... */ },
            style: OutlinedButton.styleFrom(
              foregroundColor: kPrimaryText,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
         ),
         // Add other player-specific buttons like "Edit Profile" if needed
      ],
    );
  }


  // --- Helper Widgets ---
  Widget _buildPerformanceRating(double averageScore) {
    int displayRating = averageScore.round();
    int currentRating = averageScore.floor();
    int nextRating = currentRating + 1;
    double progress = averageScore - currentRating;
    String progressPercent = (progress * 100).toStringAsFixed(0);

    return Column(
      children: [
        const Text(
          'Average Ai Score',
          style: TextStyle(color: kSecondaryText, fontSize: 16)
        ),
        const SizedBox(height: 8),
        Row( /* Score / 100 */
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.baseline,
           textBaseline: TextBaseline.alphabetic,
           children: [
             Text('$displayRating', style: const TextStyle(color: kPrimaryText, fontSize: 48, fontWeight: FontWeight.bold)),
             const Text(' / 100', style: TextStyle(color: kSecondaryText, fontSize: 20, fontWeight: FontWeight.w500)),
           ],
        ),
        const SizedBox(height: 24),
        ClipRRect( /* Progress Bar */
           borderRadius: BorderRadius.circular(10),
           child: LinearProgressIndicator( value: progress, minHeight: 8, backgroundColor: kFieldColor, valueColor: const AlwaysStoppedAnimation<Color>(kAccentGreen), ),
        ),
        const SizedBox(height: 8),
        Row( /* Progress Text */
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Rating $currentRating', style: const TextStyle(color: kSecondaryText)),
             Text('Rating $nextRating ($progressPercent% Complete)', style: const TextStyle(color: kSecondaryText)),
           ],
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Achievements', style: TextStyle(color: kPrimaryText, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildAchievementItem('assets/images/gold_medal.png', 'Gold Medalist', 'Achieved 100 wins')),
            Expanded(child: _buildAchievementItem('assets/images/silver_medal.png', 'First Place', 'Top of the leaderboard')),
            Expanded(child: _buildAchievementItem('assets/images/bronze_medal.png', 'Bronze Star', 'Completed 50 matches')),
          ],
        ),
      ],
     );
  }

  Widget _buildAchievementItem(String imagePath, String title, String subtitle) {
      return Column(
       children: [
        CircleAvatar( radius: 40, backgroundColor: kFieldColor, child: CircleAvatar(radius: 38, backgroundColor: Colors.grey[700]),), // Placeholder
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: kSecondaryText, fontSize: 12)),
      ],
     );
   }
}