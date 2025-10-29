import 'package:flutter/material.dart';
// +++ CORRECT IMPORTS +++
import 'package:flutter_application_3/models/player.dart'; // Import your Player model
import 'package:flutter_application_3/View/full_profile_page.dart'; // Import FullProfilePage

// --- UI Constants ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End Theme ---

class MyPlayersPage extends StatefulWidget {
  const MyPlayersPage({Key? key}) : super(key: key);

  @override
  State<MyPlayersPage> createState() => _MyPlayersPageState();
}

class _MyPlayersPageState extends State<MyPlayersPage> {
  // Use Player model for data
  final List<Player> players = [
    // Ensure these match your Player model constructor
    Player(rank: 1, name: 'Ethan Carter', username: '@ethancarter', score: 985, avatar: 'assets/tejas2.png', points: '12,580', level: 15, age: 'U18', sport: 'Basketball', role: 'Forward', team: 'MyClubTeam'),
    Player(rank: 2, name: 'Liam Harper', username: '@liamharper', score: 950, avatar: 'assets/images/user2.png', points: '11,000', level: 13, age: 'U16', sport: 'Soccer', role: 'Midfielder', team: 'MyClubTeam'),
    Player(rank: 3, name: 'Noah Bennett', username: '@noahb', score: 970, avatar: 'assets/images/user3.png', points: '11,500', level: 14, age: 'U18', sport: 'Basketball', role: 'Defender', team: 'MyClubTeam'),
    Player(rank: 4, name: 'Oliver Hayes', username: '@oliverh', score: 920, avatar: 'assets/images/user4.png', points: '10,000', level: 12, age: 'U16', sport: 'Soccer', role: 'Goalkeeper', team: 'MyClubTeam'),
    // Add more players as needed
  ];

  // Removed filter variables
  // final List<String> filters = ['Top Rated', 'Nearby', 'Available for Trial'];
  // String selectedFilter = 'Top Rated';
  String searchQuery = '';

  // Updated filter logic for search only
  List<Player> get filteredPlayers {
    // Return all players if search query is empty
    if (searchQuery.isEmpty) {
      return players;
    }
    // Otherwise, filter by name
    return players.where((player) {
      final matchesSearch = player.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: kPrimaryText),
        title: const Text(
          'My Players',
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Apply horizontal padding once
        child: Column(
          children: [
            const SizedBox(height: 16), // Spacing below AppBar
            // Search bar (Remains the same)
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: const TextStyle(color: kPrimaryText),
              decoration: InputDecoration(
                filled: true,
                fillColor: kFieldColor,
                prefixIcon: const Icon(Icons.search, color: kSecondaryText),
                hintText: 'Search players by name...', // Updated hint text
                hintStyle: const TextStyle(color: kSecondaryText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kFieldColor.withOpacity(0.5)),
                ),
                 focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kNewAccentCyan, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24), // Increased spacing

            // --- REMOVED Filter chips section ---

            // --- CHANGED Players Grid to Players List ---
            Expanded(
              child: filteredPlayers.isEmpty
                  ? const Center(
                      child: Text(
                        "No players found matching your search.",
                        style: TextStyle(color: kSecondaryText, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredPlayers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12), // Spacing between list items
                      itemBuilder: (context, index) {
                        final player = filteredPlayers[index];

                        return Material( // Added Material for InkWell splash effect
                          color: kFieldColor, // Background color of the tile
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FullProfilePage(
                                    player: player,
                                    showAddFriend: false,
                                    isViewedByClub: true
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16), // Match shape for splash
                            child: Padding( // Padding inside the list tile
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30, // Slightly larger avatar
                                    backgroundImage: AssetImage(player.avatar),
                                    backgroundColor: kDarkBlue, // Fallback color
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          player.name,
                                          style: const TextStyle(
                                            color: kPrimaryText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${player.role} • ${player.age}', // Role and Age
                                          style: const TextStyle(color: kSecondaryText, fontSize: 14),
                                           maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                        // Optional: Add score or level here if desired
                                        // Text(
                                        //   'Avg Score: ${(player.score / 10).round()}', // Example
                                        //   style: const TextStyle(color: kNewAccentCyan, fontSize: 13, fontWeight: FontWeight.w600),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: kSecondaryText), // Indicator icon
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
             const SizedBox(height: 16), // Padding at the bottom
          ],
        ),
      ),
    );
  }
}