import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/player.dart'; // Ensure this path is correct
import 'package:flutter_application_3/View/full_profile_page.dart'; // Ensure this path is correct

// --- UI Constants ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End Theme ---

class MyPlayersPage extends StatefulWidget {
  const MyPlayersPage({super.key});

  @override
  State<MyPlayersPage> createState() => _MyPlayersPageState();
}

class _MyPlayersPageState extends State<MyPlayersPage> {
  // Mock data for players in the club (replace with your actual data source)
  final List<Player> _myPlayers = [
    Player(rank: 1, name: 'Ethan Carter', username: '@ethancarter', score: 985, avatar: 'assets/tejas2.png', points: '12,580', level: 15, age: 'U18', sport: 'Basketball', role: 'Point Guard', team: 'MyClubTeam'),
    Player(rank: 4, name: 'Ava Harper', username: '@avaharper', score: 955, avatar: 'assets/profile4.png', points: '11,200', level: 13, age: 'U16', sport: 'Basketball', role: 'Power Forward', team: 'MyClubTeam'),
    Player(rank: 5, name: 'Liam Foster', username: '@liamf', score: 948, avatar: 'assets/profile3.png', points: '10,900', level: 12, age: 'U14', sport: 'Basketball', role: 'Center', team: 'MyClubTeam'),
    // Add more players as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        leading: const BackButton(color: kPrimaryText),
        title: const Text(
          'My Players',
          style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _myPlayers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final player = _myPlayers[index];
          // Use the Player object directly for navigation
          final Player profileMap = player; // Or construct from player if needed

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  // --- THIS IS THE CORRECTED LINE ---
                  builder: (_) => FullProfilePage(
                    player: profileMap, // Pass the player object
                    showAddFriend: false, // Club likely doesn't add friends this way
                    isViewedByClub: true  // This is the club's view
                  ),
                  // --- END OF CORRECTION ---
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: kFieldColor.withOpacity(0.8), // Use field color
                border: Border.all(color: kNewAccentCyan.withOpacity(0.15), width: 1.5),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 25, backgroundImage: AssetImage(player.avatar)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: const TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${player.role} • ${player.age}', // Example details
                          style: const TextStyle(color: kSecondaryText, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: kSecondaryText), // Arrow indicator
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}