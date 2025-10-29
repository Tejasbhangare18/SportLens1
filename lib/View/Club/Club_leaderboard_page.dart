// File: leaderboard_page.dart (Club's version)

import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/full_profile_page.dart'; // Make sure this path is correct
import 'package:flutter_application_3/models/player.dart';

// --- UI Constants ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kGreen = Color(0xFF34D399);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with TickerProviderStateMixin {

  // --- Filter bar state ---
  String _selectedArea = 'Area';
  String _selectedSport = 'Sport';
  String _selectedRole = 'Roll';
  String _selectedAge = 'Age';

  final List<String> _areaOptions = ['Area', 'All', 'Local', 'Regional', 'National'];
  final List<String> _sportOptions = ['Sport', 'All', 'Basketball', 'Soccer', 'Tennis'];
  final List<String> _roleOptions = ['Roll', 'All', 'Point Guard', 'Center', 'Forward'];
  final List<String> _ageOptions = ['Age', 'All', 'U12', 'U14', 'U16', 'U18', 'Adult'];

  // Animation controllers
  late AnimationController _podiumAnimationController;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<Offset> _slideAnimation3;

  // Mock Data
  final List<Player> _leaderboardData = [
    Player(rank: 1, name: 'Ethan Carter', username: '@ethancarter', score: 985, avatar: 'assets/tejas2.png', points: '12,580', level: 15, age: 'U18', sport: 'Basketball', role: 'Point Guard', team: 'Lakers'),
    Player(rank: 2, name: 'Olivia Bennett', username: '@oliviab', score: 972, avatar: 'assets/tejas1.png', points: '11,980', level: 14, age: 'U18', sport: 'Basketball', role: 'Shooting Guard', team: 'Warriors'),
    Player(rank: 3, name: 'Noah Thompson', username: '@noaht', score: 968, avatar: 'assets/profile8.png', points: '11,550', level: 14, age: 'U16', sport: 'Basketball', role: 'Small Forward', team: 'Clippers'),
    Player(rank: 4, name: 'Ava Harper', username: '@avaharper', score: 955, avatar: 'assets/profile4.png', change: 12, points: '11,200', level: 13, age: 'U16', sport: 'Basketball', role: 'Power Forward', team: 'Suns'),
    Player(rank: 5, name: 'Liam Foster', username: '@liamf', score: 948, avatar: 'assets/profile3.png', points: '10,900', level: 12, age: 'U14', sport: 'Basketball', role: 'Center', team: 'Bulls'),
  ];

  @override
  void initState() {
    super.initState();
    _podiumAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _slideAnimation1 = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(CurvedAnimation(parent: _podiumAnimationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    _slideAnimation2 = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(CurvedAnimation(parent: _podiumAnimationController, curve: const Interval(0.2, 0.8, curve: Curves.easeOut)));
    _slideAnimation3 = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(CurvedAnimation(parent: _podiumAnimationController, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));
    _podiumAnimationController.forward();
  }

  @override
  void dispose() {
    _podiumAnimationController.dispose();
    super.dispose();
  }

  void _refreshLeaderboard() {
     _podiumAnimationController.reset();
     _podiumAnimationController.forward();
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Leaderboard refreshed (Placeholder)'), duration: Duration(seconds: 1)),
     );
  }

  void _showPlayerProfileDialog(Player player) {
    showDialog(
        context: context,
        barrierColor: kDarkBlue.withOpacity(0.85),
        builder: (context) => PlayerProfileDialog(player: player, showAddFriend: false)); // Club probably doesn't "add friend"
  }


  @override
  Widget build(BuildContext context) {
    // Filtering logic
    final displayedData = _leaderboardData; // Use filtering logic in real app

    final topThree = displayedData.where((p) => p.rank <= 3).toList();
    final rest = displayedData.where((p) => p.rank > 3).toList();

    Player? player1, player2, player3;
    List<Player> orderedTopThree = [];

    // Safely get top three
    if(topThree.length >= 1) player1 = topThree.firstWhere((p) => p.rank == 1, orElse: () => topThree[0]);
    if(topThree.length >= 2) player2 = topThree.firstWhere((p) => p.rank == 2, orElse: () => topThree[1]);
    if(topThree.length >= 3) player3 = topThree.firstWhere((p) => p.rank == 3, orElse: () => topThree[2]);

    // Build ordered list for podium display
    if (player2 != null) orderedTopThree.add(player2);
    if (player1 != null) orderedTopThree.add(player1);
    if (player3 != null) orderedTopThree.add(player3);

    return Scaffold(
      backgroundColor: kDarkBlue,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(), // AppBar without back button
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    if (orderedTopThree.isNotEmpty) _buildPodium(orderedTopThree),
                    if (orderedTopThree.isEmpty) const Center(child: Text("No top players found.", style: TextStyle(color: kSecondaryText))),
                    const SizedBox(height: 32),
                    const Text(
                      'All Players',
                      style: TextStyle( color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (rest.isNotEmpty) _buildPlayerList(rest),
                    if (rest.isEmpty && displayedData.isNotEmpty) const Center(child: Text("No other players found.", style: TextStyle(color: kSecondaryText))),
                    if (displayedData.isEmpty) const Center(child: Text("Leaderboard is empty.", style: TextStyle(color: kSecondaryText))),
                  ]),
                ),
              ),
            ],
          ),
          _buildFloatingActionButtons(),
        ],
      ),
    );
  }

  /// AppBar with horizontal filter chips.
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: kDarkBlue,
      pinned: true,
      floating: true,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false, // <-- REMOVED BACK BUTTON IMPLICITLY
      // leading: const BackButton(color: Colors.white), // <-- REMOVED THIS LINE
      title: const Text(
        'Leaderboard',
        style: TextStyle(
            color: kPrimaryText,
            fontWeight: FontWeight.bold,
            fontSize: 24),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(54),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPopupMenuFilterChip(options: _areaOptions, selectedValue: _selectedArea, onSelected: (v) => setState(() => _selectedArea = v)),
                const SizedBox(width: 8),
                _buildPopupMenuFilterChip(options: _sportOptions, selectedValue: _selectedSport, onSelected: (v) => setState(() => _selectedSport = v)),
                const SizedBox(width: 8),
                _buildPopupMenuFilterChip(options: _roleOptions, selectedValue: _selectedRole, onSelected: (v) => setState(() => _selectedRole = v)),
                const SizedBox(width: 8),
                _buildPopupMenuFilterChip(options: _ageOptions, selectedValue: _selectedAge, onSelected: (v) => setState(() => _selectedAge = v)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 /// Filter chip using PopupMenuButton.
  Widget _buildPopupMenuFilterChip({ required List<String> options, required String selectedValue, required ValueChanged<String> onSelected, }) {
    // ... (Filter chip code remains the same) ...
     String categoryLabel = options.first;
    bool isSelected = selectedValue != categoryLabel;

    return PopupMenuButton<String>(
      tooltip: '',
      onSelected: onSelected,
      offset: const Offset(0, 45),
      color: kFieldColor.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kNewAccentCyan.withOpacity(0.3), width: 1),
      ),
      itemBuilder: (BuildContext context) {
        return options.sublist(1).map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(
              choice,
              style: TextStyle(
                color: choice == selectedValue ? kNewAccentCyan : kPrimaryText,
                fontWeight: choice == selectedValue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: kFieldColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? kNewAccentCyan : kFieldColor.withOpacity(0.5),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected ? [ BoxShadow( color: kNewAccentCyan.withOpacity(0.3), blurRadius: 8, spreadRadius: 1,) ] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedValue, style: TextStyle(color: isSelected ? kNewAccentCyan : Colors.white, fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,), overflow: TextOverflow.ellipsis,),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, color: isSelected ? kNewAccentCyan : Colors.white70, size: 20,),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    // ... (Search bar code remains the same) ...
     return TextFormField(
      style: const TextStyle(color: kPrimaryText),
      decoration: InputDecoration(
        hintText: 'Search players',
        hintStyle: TextStyle(color: kSecondaryText.withOpacity(0.6)),
        filled: true,
        fillColor: kFieldColor.withOpacity(0.8),
        prefixIcon: Icon(Icons.search, color: kSecondaryText.withOpacity(0.6)),
        border: OutlineInputBorder( borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: kFieldColor, width: 1.5),),
        focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kNewAccentCyan, width: 2),),
      ),
       onChanged: (value) { /* TODO: Implement search */ },
    );
  }

  Widget _buildPodium(List<Player> players) {
    // ... (Podium code remains the same) ...
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
    // ... (Podium player code remains the same) ...
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
                Container( decoration: BoxDecoration( shape: BoxShape.circle, boxShadow: [ BoxShadow( color: isFirstPlace ? crownColor.withOpacity(0.5) : kNewAccentCyan.withOpacity(0.3), blurRadius: 15, spreadRadius: 2,)], ), child: CircleAvatar( radius: avatarRadius, backgroundColor: kFieldColor, child: CircleAvatar( radius: avatarRadius - 4, backgroundImage: AssetImage(player.avatar)))),
                if (isFirstPlace) Positioned( top: -15, child: Icon(Icons.emoji_events, color: crownColor, size: 40)),
                Positioned( bottom: -10, child: Container( width: 28, height: 28, decoration: BoxDecoration( color: isFirstPlace ? crownColor : kNewAccentCyan, shape: BoxShape.circle, border: Border.all(color: kDarkBlue, width: 3)), child: Center( child: Text('${player.rank}', style: TextStyle( color: isFirstPlace ? kDarkBlue : Colors.white, fontWeight: FontWeight.bold))))),
              ]),
              const SizedBox(height: 20),
              Text(player.name, style: const TextStyle( color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('${player.score} pts', style: TextStyle(color: kSecondaryText.withOpacity(0.7))),
              const SizedBox(height: 12),
              Container( height: barHeight, margin: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration( gradient: LinearGradient( colors: isFirstPlace ? [crownColor.withOpacity(0.8), crownColor.withOpacity(0.1)] : [kNewAccentCyan.withOpacity(0.8), kNewAccentCyan.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter,), borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), border: Border.all( color: (isFirstPlace ? crownColor : kNewAccentCyan).withOpacity(0.5), width: 1,),),),
            ],
          ),
        ),
      );
  }

  Widget _buildPlayerList(List<Player> players) {
    // ... (Player list code remains the same) ...
       return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: players.length,
        itemBuilder: (context, index) => _buildListEntry(players[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      );
  }

  Widget _buildListEntry(Player player) {
    // ... (List entry code remains the same) ...
     return GestureDetector(
        onTap: () => _showPlayerProfileDialog(player),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration( borderRadius: BorderRadius.circular(16), gradient: LinearGradient( colors: [kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight,), border: Border.all( color: kNewAccentCyan.withOpacity(0.15), width: 1.5,), boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.05), blurRadius: 10, spreadRadius: 1,), ],),
          child: Row(
            children: [
              Text('${player.rank}', style: TextStyle( color: kSecondaryText.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              CircleAvatar(radius: 22, backgroundImage: AssetImage(player.avatar)),
              const SizedBox(width: 12),
              Expanded( child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(player.name, style: const TextStyle( color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text('${player.score} pts', style: TextStyle(color: kSecondaryText.withOpacity(0.7))),]),),
              if (player.change != null) Row(children: [ const Icon(Icons.arrow_upward, color: kGreen, size: 16), Text('+${player.change}', style: const TextStyle( color: kGreen, fontWeight: FontWeight.bold)),])
            ],
          ),
        ),
      );
  }

  Widget _buildFloatingActionButtons() {
    // ... (Floating action button code remains the same) ...
     return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration( gradient: LinearGradient( begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [kDarkBlue, kDarkBlue.withOpacity(0.0)])),
        child: SizedBox(
          width: double.infinity,
          child: _buildGlowButton(
            text: 'Refresh Leaderboard',
            onPressed: _refreshLeaderboard,
            isPrimary: true,
          ),
        ),
      ),
    );
  }

  Widget _buildGlowButton({required String text, required VoidCallback onPressed, bool isPrimary = false}) {
    // ... (Glow button code remains the same) ...
      return Container(
      decoration: BoxDecoration( borderRadius: BorderRadius.circular(16), boxShadow: isPrimary ? [ BoxShadow( color: kNewAccentCyan.withOpacity(0.4), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4),) ] : [],),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom( backgroundColor: isPrimary ? kNewAccentCyan : Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16), side: isPrimary ? BorderSide.none : BorderSide(color: kNewAccentCyan.withOpacity(0.5), width: 1.5),), shadowColor: Colors.transparent,),
        child: Text( text, style: TextStyle( color: isPrimary ? kDarkBlue : Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),),
      ),
    );
  }
} // End of _LeaderboardPageState


// --- Player Profile Dialog ---
class PlayerProfileDialog extends StatelessWidget {
 final Player player;
  final bool showAddFriend;
  const PlayerProfileDialog(
      {super.key, required this.player, this.showAddFriend = true});

  @override
  Widget build(BuildContext context) {
    // Calculate Average Ai Score
    double drillsScore = double.tryParse(player.score.toString()) ?? 0.0;
    double rating = drillsScore / 10.0;
    String displayRating = rating.round().toString();

    return Dialog(
      backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(24),
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
          decoration: BoxDecoration( borderRadius: BorderRadius.circular(24), gradient: LinearGradient( colors: [ kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.8),], begin: Alignment.topLeft, end: Alignment.bottomRight,), border: Border.all( color: kNewAccentCyan.withOpacity(0.3), width: 1.5,), boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.1), blurRadius: 20,),],),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(player.name, style: const TextStyle( color: kPrimaryText, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${player.username} • Total Points: ${player.points}',
              style: TextStyle(color: kSecondaryText.withOpacity(0.7), fontSize: 14)
            ),
            const SizedBox(height: 24),
             Row( // Stat Row 1
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatItem(label: 'Average Ai Score', value: displayRating),
                _StatItem(label: 'Sport', value: player.sport),
            ]),
            const SizedBox(height: 20),
            Row( // Stat Row 2
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatItem(label: 'Age', value: player.age), // Use null-aware operator
                _StatItem(label: 'Role', value: player.role),
            ]),
            const SizedBox(height: 32),
            _buildDialogButtons(context),
          ]),
        ),
        Positioned( top: -50, child: Container( decoration: BoxDecoration( shape: BoxShape.circle, boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.5), blurRadius: 20, spreadRadius: 2,)]), child: CircleAvatar( radius: 50, backgroundColor: kFieldColor, child: CircleAvatar( radius: 46, backgroundImage: AssetImage(player.avatar))),)),
        Positioned( top: 8, right: 8, child: IconButton( icon: Icon(Icons.close, color: kSecondaryText.withOpacity(0.7)), onPressed: () => Navigator.of(context).pop())),
      ]),
    );
  }

   Widget _buildDialogButtons(BuildContext context) {
     return SizedBox( width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
             Navigator.of(context).pop();
             Navigator.of(context).push(MaterialPageRoute(
               builder: (_) => FullProfilePage(
                 player: player,
                 showAddFriend: showAddFriend,
                 isViewedByClub: true
               )
             ));
          },
          style: ElevatedButton.styleFrom( backgroundColor: kNewAccentCyan, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16))),
          child: const Text('View Full Profile', style: TextStyle( color: kDarkBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
   }
}

// --- _StatItem Widget ---
class _StatItem extends StatelessWidget {
 final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: kSecondaryText.withOpacity(0.7), fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle( color: kNewAccentCyan, fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ]
      ),
    );
  }
}