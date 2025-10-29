// File: scouting_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/full_profile_page.dart'; // Ensure correct path
import 'package:flutter_application_3/models/player.dart'; // Ensure correct path

// --- Modern Gradient Glow Theme (Unchanged) ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Card/Field Background
const Color kNewAccentCyan = Color(0xFF00A8E8); // Glow & Accent Color
const Color kPrimaryText = Colors.white; // Primary Text
const Color kSecondaryText = Colors.white70; // Secondary Text
// --- End Theme ---

class ScoutingPage extends StatefulWidget {
  final bool showBackButton;
  ScoutingPage({Key? key, this.showBackButton = false}) : super(key: key);

  // Example Player Data (Unchanged)
   final List<Map<String, String>> players = [
     {'name': 'Ethan Carter', 'position': 'Forward', 'age': 'U18', 'level': 'Elite', 'imageUrl': 'assets/tejas2.png', 'username': '@ethanc', 'points': '12k', 'score': '985', 'team': 'Lakers'},
     {'name': 'Liam Harper', 'position': 'Midfielder', 'age': 'U16', 'level': 'Pro', 'imageUrl': 'assets/profile4.png', 'username': '@liamh', 'points': '11k', 'score': '950', 'team': 'Suns'},
     {'name': 'Noah Bennett', 'position': 'Defender', 'age': 'U18', 'level': 'Advanced', 'imageUrl': 'assets/profile8.png', 'username': '@noahb', 'points': '11.5k', 'score': '970', 'team': 'Clippers'},
     {'name': 'Oliver Hayes', 'position': 'Goalkeeper', 'age': 'U16', 'level': 'Elite', 'imageUrl': 'assets/profile3.png', 'username': '@oliverh', 'points': '10k', 'score': '920', 'team': 'Bulls'},
  ];


  @override
  State<ScoutingPage> createState() => _ScoutingPageState();
}

class _ScoutingPageState extends State<ScoutingPage> {
  final TextEditingController searchCtrl = TextEditingController();
  String searchQuery = '';
  final List<String> filterOptions = ['Top Rated', 'Nearby', 'Available for Trial'];
  final Set<String> activeFilters = {};

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  // Filtering logic (Unchanged)
  List<Map<String, String>> get filteredPlayers {
     final q = searchQuery.trim().toLowerCase();
    return widget.players.where((player) {
      bool matches = true;
      if (q.isNotEmpty) {
        matches =
            player['name']!.toLowerCase().contains(q) ||
            player['position']!.toLowerCase().contains(q) ||
            player['age']!.toLowerCase().contains(q) ||
            player['level']!.toLowerCase().contains(q);
      }
      for (final filter in activeFilters) {
        if (filter == 'Top Rated' && !(player['level'] == 'Elite' || player['level'] == 'Pro')) { matches = false; break; }
        if (filter == 'Nearby') { matches = false; break; } // Placeholder
        if (filter == 'Available for Trial') { matches = false; break; } // Placeholder
      }
      return matches;
    }).toList();
  }

  // Helper to build a Player object (Unchanged)
  Player _createPlayerFromMap(Map<String, String> playerMap, int index) {
      return Player(
        rank: index + 1,
        name: playerMap['name'] ?? 'N/A',
        username: playerMap['username'] ?? '@unknown',
        score: int.tryParse(playerMap['score'] ?? '0') ?? 0,
        avatar: playerMap['imageUrl'] ?? 'assets/images/defaultprofile.png',
        points: playerMap['points'] ?? '0',
        level: 0,
        age: playerMap['age'] ?? 'N/A',
        sport: playerMap['sport'] ?? playerMap['position'] ?? 'N/A',
        role: playerMap['role'] ?? playerMap['position'] ?? 'N/A',
        team: playerMap['team'] ?? 'N/A',
      );
  }

  // Helper to navigate (Unchanged)
  void _navigateToProfile(Player player) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FullProfilePage(
                player: player,
                showAddFriend: false,
                isViewedByClub: true
              ),
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: kDarkBlue,
          elevation: 0,
          automaticallyImplyLeading: widget.showBackButton,
          iconTheme: const IconThemeData(color: kPrimaryText),
          centerTitle: true,
          title: const Text(
            'Scouting',
            style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: SingleChildScrollView( // Keeps content scrollable
        // Use ListView instead of SingleChildScrollView+Column for better performance
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // --- AI Assistant Section (with new Tune button) ---
              const Text(
                'AI Scouting Assistant',
                style: TextStyle(color: kPrimaryText, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField( // Search Bar
                controller: searchCtrl,
                onChanged: (value) => setState(() => searchQuery = value),
                style: const TextStyle(color: kPrimaryText),
                decoration: InputDecoration(
                  hintText: "Ask AI: 'Find U18 forwards with high potential'...",
                  hintStyle: const TextStyle(color: kSecondaryText),
                  prefixIcon: const Icon(Icons.auto_awesome, color: kNewAccentCyan, size: 22),
                  // --- NEW: Advanced Filter Button (UI Only) ---
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: kSecondaryText),
                    onPressed: () {
                      // This button is for UI. No functionality added as requested.
                      // TODO: Implement showModalBottomSheet for advanced filters here.
                    },
                  ),
                  // --- End New Button ---
                  filled: true,
                  fillColor: kFieldColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: kFieldColor.withOpacity(0.5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kNewAccentCyan, width: 2)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              
              const SizedBox(height: 24),

              // --- NEW: AI-Generated Shortlist ---
              const Text(
                'AI-Generated Shortlist',
                style: TextStyle(color: kPrimaryText, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250, // Fixed height for the horizontal list
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.players.length > 4 ? 4 : widget.players.length, // Show max 4
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final playerMap = widget.players[index];
                    final playerObj = _createPlayerFromMap(playerMap, index);

                    return _ShortlistCard(
                      player: playerObj,
                      levelString: playerMap['level'] ?? 'N/A',
                      onTap: () => _navigateToProfile(playerObj),
                    );
                  },
                ),
              ),
              // --- End New Section ---

              const SizedBox(height: 24),

              // --- All Players Section ---
              const Text(
                'All Players',
                style: TextStyle(color: kPrimaryText, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SizedBox( // Filter Chips (Unchanged)
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder:(context, index) {
                    final filter = filterOptions[index];
                    final isActive = activeFilters.contains(filter);
                    return FilterChip(
                        label: Text(filter),
                        selected: isActive,
                        onSelected: (selected) { setState(() { if (selected) { activeFilters.add(filter); } else { activeFilters.remove(filter); } }); },
                        backgroundColor: kFieldColor,
                        selectedColor: kNewAccentCyan,
                        labelStyle: TextStyle(color: isActive ? kDarkBlue : kPrimaryText, fontWeight: FontWeight.bold, fontSize: 14),
                        shape: StadiumBorder(side: BorderSide(color: isActive ? kNewAccentCyan : kFieldColor.withOpacity(0.5))),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // --- Player Grid (Unchanged functionality) ---
              filteredPlayers.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: Text("No matching players found.", style: TextStyle(color: kSecondaryText, fontSize: 16)),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredPlayers.length,
                      padding: const EdgeInsets.only(top: 4, bottom: 16), // Kept your padding
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7, // Your aspect ratio
                          ),
                      itemBuilder: (context, index) {
                        final playerMap = filteredPlayers[index];
                        final playerObj = _createPlayerFromMap(playerMap, index);

                        return InkWell(
                          onTap: () => _navigateToProfile(playerObj),
                          borderRadius: BorderRadius.circular(20),
                          // Using your existing _PlayerCard
                          child: _PlayerCard(
                            player: playerObj,
                            levelString: playerMap['level'] ?? 'N/A',
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Your Existing Player Card (Unchanged) ---
class _PlayerCard extends StatelessWidget {
  final Player player;
  final String levelString;

  const _PlayerCard({
    Key? key,
    required this.player,
    required this.levelString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
           colors: [ kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.6) ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kNewAccentCyan.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow( color: kNewAccentCyan.withOpacity(0.1), blurRadius: 12, spreadRadius: 1),
          BoxShadow( color: Colors.black.withOpacity(0.3), blurRadius: 5, spreadRadius: -3),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    player.avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                       Container(color: kDarkBlue, child: const Icon(Icons.person, color: kSecondaryText, size: 50)),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kNewAccentCyan,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5,
                            offset: Offset(0, 1)
                          )
                        ],
                      ),
                      child: Text(
                        levelString,
                        style: const TextStyle(
                          color: kDarkBlue,
                          fontWeight: FontWeight.bold, 
                          fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle( color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16,),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${player.role}, ${player.age}',
                    style: const TextStyle( color: kSecondaryText, fontSize: 13,),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- NEW: Shortlist Card Widget ---
// This card uses the "text-over-image" design for a high-class, distinct look
class _ShortlistCard extends StatelessWidget {
  final Player player;
  final String levelString;
  final VoidCallback onTap;

  const _ShortlistCard({
    Key? key,
    required this.player,
    required this.levelString,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Using the same navigation functionality
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 160, // Fixed width for horizontal list
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kNewAccentCyan.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow( color: kNewAccentCyan.withOpacity(0.1), blurRadius: 12, spreadRadius: 1),
            BoxShadow( color: Colors.black.withOpacity(0.3), blurRadius: 5, spreadRadius: -3),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand, // Makes the Stack fill the container
            children: [
              // 1. The Image (Bottom Layer)
              Image.asset(
                player.avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                   Container(color: kDarkBlue, child: const Icon(Icons.person, color: kSecondaryText, size: 50)),
              ),

              // 2. The Protective Gradient (Sits on top of image)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ Colors.transparent, Colors.black.withOpacity(0.9) ],
                    stops: [0.5, 1.0], // Starts fading from 50% height
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                ),
              ),

              // 3. The "Level" Badge (Top-Right)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kNewAccentCyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    levelString,
                    style: const TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.bold, 
                      fontSize: 12
                    ),
                  ),
                ),
              ),

              // 4. The Text Info (Bottom-Left)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12, // Ensure text can't overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text( // Name
                      player.name,
                      style: const TextStyle( color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16,),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text( // Position & Age
                      '${player.role}, ${player.age}',
                      style: const TextStyle( color: kSecondaryText, fontSize: 13,),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}