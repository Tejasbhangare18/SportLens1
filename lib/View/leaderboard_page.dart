import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/player.dart';
import 'drills_page.dart';
import 'profile_page.dart';
import 'coaches_and_clubs_page.dart';
import 'compare_with_pro_page.dart';
import 'personal_stats_page.dart';

import 'full_profile_page.dart';
import 'widgets/app_bottom_navigation.dart';

// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
const Color kGreen = Color(0xFF34D399); // (For rank changes)
// --- Text Colors --- (Added for clarity in popup)
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---

/// Displays a leaderboard with a podium for the top 3 players and a list for the rest.
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 1;

  // --- Filter bar state ---
  String _selectedArea = 'Area';
  String _selectedSport = 'Sport';
  String _selectedRole = 'Roll';
  String _selectedAge = 'Age';

  final List<String> _areaOptions = ['Area', 'All', 'Local', 'Regional', 'National'];
  final List<String> _sportOptions = ['Sport', 'All', 'Basketball', 'Soccer', 'Tennis'];
  final List<String> _roleOptions = ['Roll', 'All', 'Point Guard', 'Center', 'Forward'];
  final List<String> _ageOptions = ['Age', 'All', 'U12', 'U14', 'U16', 'U18', 'Adult'];

  // Animation controllers for the podium entrance
  late AnimationController _podiumAnimationController;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<Offset> _slideAnimation3;

  // Mock Data for the Leaderboard
  final List<Player> _leaderboardData = [
    // Top 4 synced with Home dashboard sample data
  Player(rank: 1, name: 'Ethan Carter', username: '@ethancarter', score: 985, avatar: 'assets/tejas2.png', points: '12,580', level: 15, age: 'U18', sport: 'Basketball', role: 'Point Guard', team: ''),
  Player(rank: 2, name: 'Olivia Bennett', username: '@oliviab', score: 972, avatar: 'assets/tejas1.png', points: '11,980', level: 14, age: 'U18', sport: 'Basketball', role: 'Shooting Guard', team: ''),
  Player(rank: 3, name: 'Noah Thompson', username: '@noaht', score: 968, avatar: 'assets/profile8.png', points: '11,550', level: 14, age: 'U18', sport: 'Basketball', role: 'Small Forward', team: ''),
  Player(rank: 4, name: 'Ava Harper', username: '@avaharper', score: 955, avatar: 'assets/profile4.png', change: 12, points: '11,200', level: 13, age: 'U18', sport: 'Basketball', role: 'Power Forward', team: ''),
  Player(rank: 5, name: 'Liam Foster', username: '@liamf', score: 948, avatar: 'assets/profile3.png', points: '10,900', level: 12, age: 'U18', sport: 'Basketball', role: 'Center', team: ''),
  Player(rank: 5, name: 'Liam Foster', username: '@liamf', score: 948, avatar: 'assets/profile3.png', points: '10,900', level: 12, age: 'U18', sport: 'Basketball', role: 'Center', team: ''),
  Player(rank: 5, name: 'Liam Foster', username: '@liamf', score: 948, avatar: 'assets/profile3.png', points: '10,900', level: 12, age: 'U18', sport: 'Basketball', role: 'Center', team: ''),
  ];

  @override
  void initState() {
    super.initState();
    _podiumAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _slideAnimation1 = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _podiumAnimationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    _slideAnimation2 = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _podiumAnimationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOut)));
    _slideAnimation3 = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _podiumAnimationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));
    _podiumAnimationController.forward();
  }

  @override
  void dispose() {
    _podiumAnimationController.dispose();
    super.dispose();
  }

  void _refreshLeaderboard() {
     // TODO: Add actual data refresh logic
    _podiumAnimationController.reset();
    _podiumAnimationController.forward();
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Leaderboard refreshed (Placeholder)'), duration: Duration(seconds: 1)),
     );
  }

  void _showPlayerProfileDialog(Player player) {
    showDialog(
        context: context,
        barrierColor: kDarkBlue.withOpacity(0.85), // Darker barrier
        builder: (context) => PlayerProfileDialog(player: player));
  }


  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;
    // Simplified navigation logic (assumes these are main tabs)
    Widget destinationPage;
    switch (index) {
      case 0: // Home - Assuming popUntil is desired
        Navigator.of(context).popUntil((route) => route.isFirst);
        return; // Exit function after popUntil
      case 1: destinationPage = const LeaderboardPage(); break; // Already here, but for completeness
      case 2: destinationPage = const DrillsPage(); break;
      case 3: destinationPage = const CoachesAndClubsPage(); break;
      case 4: destinationPage = const ProfilePage(); break;
      default: return; // Should not happen
    }
     // Use pushReplacement to avoid building stack when switching main tabs
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (_) => destinationPage, settings: RouteSettings(name: '/${destinationPage.runtimeType}')), // Add route names if needed
     );
  }

  @override
  Widget build(BuildContext context) {
    // Filtering logic would go here, using _selectedArea, etc.
    // final filteredData = _leaderboardData.where(...).toList();
    // For now, we use the full list
    final displayedData = _leaderboardData; // Use filteredData in a real app

    final topThree = displayedData.where((p) => p.rank <= 3).toList();
    final rest = displayedData.where((p) => p.rank > 3).toList();

    Player? player1, player2, player3;
    List<Player> orderedTopThree = [];

    if(topThree.length >= 1) player1 = topThree.firstWhere((p) => p.rank == 1, orElse: () => topThree[0]); // Handle cases with less than 3
    if(topThree.length >= 2) player2 = topThree.firstWhere((p) => p.rank == 2, orElse: () => topThree[1]);
    if(topThree.length >= 3) player3 = topThree.firstWhere((p) => p.rank == 3, orElse: () => topThree[2]);

    // Build ordered list safely
    if (player2 != null) orderedTopThree.add(player2);
    if (player1 != null) orderedTopThree.add(player1);
    if (player3 != null) orderedTopThree.add(player3);


    return Scaffold(
      backgroundColor: kDarkBlue, // THEME: Page Background
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(), // AppBar now includes the filter button
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 240), // Bottom padding leaves space for buttons
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    if (orderedTopThree.isNotEmpty) _buildPodium(orderedTopThree), // Only build if data exists
                    if (orderedTopThree.isEmpty) const Center(child: Text("No top players found.", style: TextStyle(color: Colors.white70))),
                    const SizedBox(height: 32),
                    const Text(
                      'All Players',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (rest.isNotEmpty) _buildPlayerList(rest), // Only build if data exists
                    if (rest.isEmpty && displayedData.isNotEmpty) const Center(child: Text("No other players found.", style: TextStyle(color: Colors.white70))),
                    if (displayedData.isEmpty) const Center(child: Text("Leaderboard is empty.", style: TextStyle(color: Colors.white70))),
                  ]),
                ),
              ),
            ],
          ),
          _buildFloatingActionButtons(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTapOverride: _onBottomNavTapped,
      ),
    );
  }

  /// AppBar with horizontal filter chips using PopupMenuButton.
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: kDarkBlue, // THEME: App Bar
      pinned: true,
      floating: true,
      centerTitle: true,
      elevation: 0,
      leading: const BackButton(color: Colors.white), // THEME: Regular Text
      title: const Text(
        'Leaderboard',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24),
      ),
      // --- THIS IS THE MODIFIED PART ---
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(54), // Height for padding + chip row
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: 38, // Height of the chip row
            child: ListView( // Keep ListView for horizontal scrollability
              scrollDirection: Axis.horizontal,
              children: [
                _buildPopupMenuFilterChip( // Use the new widget
                    options: _areaOptions,
                    selectedValue: _selectedArea,
                    onSelected: (v) => setState(() => _selectedArea = v),
                ),
                const SizedBox(width: 8),
                _buildPopupMenuFilterChip(
                    options: _sportOptions,
                    selectedValue: _selectedSport,
                    onSelected: (v) => setState(() => _selectedSport = v),
                ),
                const SizedBox(width: 8),
                _buildPopupMenuFilterChip(
                    options: _roleOptions,
                    selectedValue: _selectedRole,
                    onSelected: (v) => setState(() => _selectedRole = v),
                ),
                const SizedBox(width: 8),
                _buildPopupMenuFilterChip(
                    options: _ageOptions,
                    selectedValue: _selectedAge,
                    onSelected: (v) => setState(() => _selectedAge = v),
                ),
              ],
            ),
          ),
        ),
      ),
      // --- END OF MODIFIED PART ---
    );
  }

 /// Builds a styled filter chip that uses PopupMenuButton for options.
  Widget _buildPopupMenuFilterChip({
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    // The first item is the category label (e.g., "Area")
    String categoryLabel = options.first;
    // Check if a specific option (not the category label) is selected
    bool isSelected = selectedValue != categoryLabel;

    return PopupMenuButton<String>(
      tooltip: '', // Disable default tooltip
      onSelected: onSelected,
      offset: const Offset(0, 45), // Position menu below the chip
      color: kFieldColor.withOpacity(0.95), // Themed background color for the menu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for the menu
        side: BorderSide(color: kNewAccentCyan.withOpacity(0.3), width: 1), // Optional border
      ),
      itemBuilder: (BuildContext context) {
        // Build menu items, skip the first item (category label)
        return options.sublist(1).map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(
              choice,
              style: TextStyle(
                color: choice == selectedValue ? kNewAccentCyan : kPrimaryText, // Highlight selected item in menu
                fontWeight: choice == selectedValue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList();
      },
      child: Container( // This is the chip UI displayed in the AppBar
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Adjusted padding
        decoration: BoxDecoration(
          color: kFieldColor.withOpacity(0.8), // Glassy background
          borderRadius: BorderRadius.circular(30), // Pill shape
          border: Border.all(
            color: isSelected ? kNewAccentCyan : kFieldColor.withOpacity(0.5),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [ BoxShadow( color: kNewAccentCyan.withOpacity(0.3), blurRadius: 8, spreadRadius: 1,) ] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Fit content
          children: [
            Text(
              selectedValue, // Display the currently selected value or category label
              style: TextStyle(
                color: isSelected ? kNewAccentCyan : Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 4), // Smaller space before icon
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isSelected ? kNewAccentCyan : Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

 // --- Search Bar, Podium, Player List, Buttons, Dialogs remain the same ---
  Widget _buildSearchBar() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search players',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: kFieldColor.withOpacity(0.8),
        prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
        border: OutlineInputBorder( borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: kFieldColor, width: 1.5),),
        focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kNewAccentCyan, width: 2),),
      ),
       onChanged: (value) { /* TODO: Implement search */ print("Searching for: $value"); },
    );
  }

  Widget _buildPodium(List<Player> players) {
     Widget player2Widget = players.isNotEmpty ? _buildPodiumPlayer(players[0], _slideAnimation1) : Container();
    Widget player1Widget = players.length > 1 ? _buildPodiumPlayer(players[1], _slideAnimation2) : Container();
    Widget player3Widget = players.length > 2 ? _buildPodiumPlayer(players[2], _slideAnimation3) : Container();

    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(child: player2Widget),
      Expanded(child: player1Widget),
      Expanded(child: player3Widget),
    ]);
  }

  Widget _buildPodiumPlayer(Player player, Animation<Offset> animation) {
    final isFirstPlace = player.rank == 1;
    final barHeight = isFirstPlace ? 120.0 : 70.0;
    final avatarRadius = isFirstPlace ? 50.0 : 40.0;
    final crownColor = const Color(0xFFFFD700);

    return GestureDetector(
      onTap: () => _showPlayerProfileDialog(player),
      child: SlideTransition(
        position: animation,
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
              Container(
                decoration: BoxDecoration( shape: BoxShape.circle, boxShadow: [ BoxShadow( color: isFirstPlace ? crownColor.withOpacity(0.5) : kNewAccentCyan.withOpacity(0.3), blurRadius: 15, spreadRadius: 2,)], ),
                child: CircleAvatar( radius: avatarRadius, backgroundColor: kFieldColor, child: CircleAvatar( radius: avatarRadius - 4, backgroundImage: AssetImage(player.avatar))),
              ),
              if (isFirstPlace) Positioned( top: -15, child: Icon(Icons.emoji_events, color: crownColor, size: 40)),
              Positioned( bottom: -10, child: Container( width: 28, height: 28, decoration: BoxDecoration( color: isFirstPlace ? crownColor : kNewAccentCyan, shape: BoxShape.circle, border: Border.all(color: kDarkBlue, width: 3)), child: Center( child: Text('${player.rank}', style: TextStyle( color: isFirstPlace ? kDarkBlue : Colors.white, fontWeight: FontWeight.bold))))),
            ]),
            const SizedBox(height: 20),
            Text(player.name, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('${player.score} pts', style: TextStyle(color: Colors.white.withOpacity(0.7))),
            const SizedBox(height: 12),
            Container( height: barHeight, margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient( colors: isFirstPlace ? [crownColor.withOpacity(0.8), crownColor.withOpacity(0.1)] : [kNewAccentCyan.withOpacity(0.8), kNewAccentCyan.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter,),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                border: Border.all( color: (isFirstPlace ? crownColor : kNewAccentCyan).withOpacity(0.5), width: 1,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerList(List<Player> players) {
     return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: players.length,
      itemBuilder: (context, index) => _buildListEntry(players[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget _buildListEntry(Player player) {
    return GestureDetector(
      onTap: () => _showPlayerProfileDialog(player),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient( colors: [kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight,),
          border: Border.all( color: kNewAccentCyan.withOpacity(0.15), width: 1.5,),
          boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.05), blurRadius: 10, spreadRadius: 1,), ],
        ),
        child: Row(
          children: [
            Text('${player.rank}', style: TextStyle( color: Colors.white.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(width: 16),
            CircleAvatar(radius: 22, backgroundImage: AssetImage(player.avatar)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(player.name, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('${player.score} pts', style: TextStyle(color: Colors.white.withOpacity(0.7))),
              ]),
            ),
            if (player.change != null) Row(children: [ const Icon(Icons.arrow_upward, color: kGreen, size: 16), Text('+${player.change}', style: const TextStyle( color: kGreen, fontWeight: FontWeight.bold)),])
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration( gradient: LinearGradient( begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [kDarkBlue, kDarkBlue.withOpacity(0.8)])),
        child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGlowButton( text: 'Refresh Leaderboard', onPressed: _refreshLeaderboard, isPrimary: true,),
            const SizedBox(height: 12),
            _buildGlowButton( text: 'Compare with Top Player', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CompareWithProPage())),),
            const SizedBox(height: 12),
            _buildGlowButton( text: 'View Personal Stats', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PersonalStatsPage())),),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowButton({required String text, required VoidCallback onPressed, bool isPrimary = false}) {
      return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary ? [ BoxShadow( color: kNewAccentCyan.withOpacity(0.4), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4),) ] : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? kNewAccentCyan : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16), side: isPrimary ? BorderSide.none : BorderSide(color: kNewAccentCyan.withOpacity(0.5), width: 1.5),),
          shadowColor: Colors.transparent,
        ),
        child: Text( text, style: TextStyle( color: isPrimary ? kDarkBlue : Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),),
      ),
    );
  }
} // End of _LeaderboardPageState


class PlayerProfileDialog extends StatelessWidget {
 final Player player;
  final bool showAddFriend;
  const PlayerProfileDialog(
      {super.key, required this.player, this.showAddFriend = true});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(24),
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
          decoration: BoxDecoration( borderRadius: BorderRadius.circular(24), gradient: LinearGradient( colors: [ kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.8),], begin: Alignment.topLeft, end: Alignment.bottomRight,), border: Border.all( color: kNewAccentCyan.withOpacity(0.3), width: 1.5,), boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.1), blurRadius: 20,),],),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(player.name, style: const TextStyle( color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(player.username, style: TextStyle(color: Colors.white.withOpacity(0.7))), const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ _StatItem(label: 'Total Points', value: player.points), _StatItem(label: 'Average Score', value: player.level.toString()),]), const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ _StatItem(label: 'Age', value: player.age), _StatItem(label: 'Sport', value: player.sport),]), const SizedBox(height: 20),
            _StatItem(label: 'Role', value: player.role), const SizedBox(height: 32), _buildDialogButtons(context),
          ]),
        ),
        Positioned( top: -50, child: Container( decoration: BoxDecoration( shape: BoxShape.circle, boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.5), blurRadius: 20, spreadRadius: 2,)]), child: CircleAvatar( radius: 50, backgroundColor: kFieldColor, child: CircleAvatar( radius: 46, backgroundImage: AssetImage(player.avatar))),)),
        Positioned( top: 8, right: 8, child: IconButton( icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7)), onPressed: () => Navigator.of(context).pop())),
      ]),
    );
  }

   Widget _buildDialogButtons(BuildContext context) {
    if (showAddFriend) {
      return SizedBox( width: double.infinity,
        child: ElevatedButton(
          onPressed: () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute( builder: (_) => FullProfilePage(player: player, showAddFriend: showAddFriend)));},
          style: ElevatedButton.styleFrom( backgroundColor: kNewAccentCyan, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16))),
          child: const Text('View Full Profile', style: TextStyle( color: kDarkBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
    } else {
      return Row(children: [
        Expanded( child: OutlinedButton(
            onPressed: () { Navigator.of(context).pop(); Navigator.of(context).push( MaterialPageRoute(builder: (_) => CompareWithProPage(initialSelected: player.name)));},
            style: OutlinedButton.styleFrom( side: BorderSide(color: kNewAccentCyan.withOpacity(0.5), width: 1.5), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16))),
            child: const Text('Compare', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),),
        const SizedBox(width: 12),
        Expanded( child: ElevatedButton(
            onPressed: () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute( builder: (_) => FullProfilePage( player: player, showAddFriend: showAddFriend)));},
            style: ElevatedButton.styleFrom( backgroundColor: kNewAccentCyan, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16))),
            child: const Text('View Full Profile', style: TextStyle( color: kDarkBlue, fontWeight: FontWeight.bold, fontSize: 16)),
          ),),
      ]);
    }
  }
}

class _StatItem extends StatelessWidget {
 final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)), const SizedBox(height: 6),
      Text(value, style: const TextStyle( color: kNewAccentCyan, fontSize: 22, fontWeight: FontWeight.bold)),
    ]);
  }
}