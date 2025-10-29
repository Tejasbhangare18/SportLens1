import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/View/leaderboard_page.dart';
import 'package:flutter_application_3/View/my_friends_page.dart';
import 'package:flutter_application_3/View/player_notification_page.dart'; // ✅ Added
import 'record_performance_page.dart';
import 'profile_page.dart';
import 'widgets/app_bottom_navigation.dart';

// --- UI Constants ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;

class PlayerDashboardPage extends StatefulWidget {
  const PlayerDashboardPage({super.key});
  @override
  State<PlayerDashboardPage> createState() => _PlayerDashboardPageState();
}

class _PlayerDashboardPageState extends State<PlayerDashboardPage> {
  int _selectedIndex = 0;

  late PageController _pageController;
  int _currentPageIndex = 0;

  late PageController _leaderboardPageController;
  int _leaderboardPageIndex = 0;

  final List<Map<String, String>> topCarouselDrills = [
    {'title': 'Discover My Talent', 'category': 'Enter Now', 'imagePath': 'assets/home4.png'},
    {'title': 'My Friends', 'category': 'Connect and compete with your friends', 'imagePath': 'assets/home3.png'},
    {'title': 'Profile', 'category': 'Check your progress and journey', 'imagePath': 'assets/home4.png'},
  ];

  final List<Map<String, String>> leaderboardData = [
    {'rank': '1', 'name': 'Ethan Carter', 'score': '985 pts', 'imagePath': 'assets/tejas2.png'},
    {'rank': '2', 'name': 'Olivia Bennett', 'score': '972 pts', 'imagePath': 'assets/tejas1.png'},
    {'rank': '3', 'name': 'Noah Thompson', 'score': '968 pts', 'imagePath': 'assets/profile8.png'},
    {'rank': '4', 'name': 'Ava Harper', 'score': '955 pts', 'imagePath': 'assets/profile4.png'},
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.9);
    _pageController.addListener(() {
      if (!_pageController.hasClients) return;
      int nextPageIndex = _pageController.page!.round();
      if (_currentPageIndex != nextPageIndex && mounted) {
        setState(() {
          _currentPageIndex = nextPageIndex;
        });
      }
    });

    _leaderboardPageController = PageController(viewportFraction: 0.9);
    _leaderboardPageController.addListener(() {
      if (!_leaderboardPageController.hasClients) return;
      int nextPageIndex = _leaderboardPageController.page!.round();
      if (_leaderboardPageIndex != nextPageIndex && mounted) {
        setState(() {
          _leaderboardPageIndex = nextPageIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _leaderboardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kDarkBlue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            // ✅ Notification Button
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PlayerNotificationPage()),
                );
              },
              icon: const Icon(Icons.notifications_outlined, color: kPrimaryText),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // --- Top Carousel ---
                SizedBox(
                  height: 500,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: topCarouselDrills.length,
                    itemBuilder: (context, index) {
                      final drill = topCarouselDrills[index];
                      return _buildTopDrillCard(drill: drill);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(topCarouselDrills.length, (index) => _buildDot(index: index)),
                ),
                const SizedBox(height: 40),
                _buildSectionHeader('Leaderboard', 'See where you rank against others.'),
                const SizedBox(height: 16),
                // --- Leaderboard Cards ---
                SizedBox(
                  height: 190,
                  child: PageView.builder(
                    controller: _leaderboardPageController,
                    itemCount: leaderboardData.length,
                    itemBuilder: (context, index) {
                      final player = leaderboardData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildNewLeaderboardCard(player: player),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    leaderboardData.length,
                    (index) => _buildLeaderboardDot(index: index),
                  ),
                ),
                const SizedBox(height: 28),
                // --- View All Button ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const LeaderboardPage())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentBlue,
                        foregroundColor: kPrimaryText,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      ),
                      child: const Text('View All',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(currentIndex: _selectedIndex),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: kPrimaryText, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 18, color: kSecondaryText)),
        ],
      ),
    );
  }

  Widget _buildNewLeaderboardCard({required Map<String, String> player}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: kNewAccentCyan.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(color: kNewAccentCyan.withOpacity(0.1), blurRadius: 15, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Rank #${player['rank']}',
                    style: const TextStyle(
                        color: kPrimaryText, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(player['name']!,
                    style: const TextStyle(color: kSecondaryText, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kNewAccentCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kNewAccentCyan.withOpacity(0.3), width: 1),
                  ),
                  child: Text(player['score']!,
                      style: const TextStyle(
                          color: kNewAccentCyan, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: kNewAccentCyan.withOpacity(0.3), blurRadius: 15, spreadRadius: 1),
              ],
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: kDarkBlue.withOpacity(0.5),
              backgroundImage: AssetImage(player['imagePath']!),
              onBackgroundImageError: (_, __) => const Icon(Icons.person, color: kSecondaryText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDrillCard({required Map<String, String> drill}) {
    return GestureDetector(
      onTap: () {
        final title = (drill['title'] ?? '').toLowerCase();
        if (title.contains('friends')) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyFriendsPage()));
        } else if (title.contains('profile')) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const RecordPerformancePage()));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(drill['imagePath']!), fit: BoxFit.cover),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                stops: const [0.0, 0.5],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (drill['category']!.isNotEmpty)
                    Text(drill['category']!, style: const TextStyle(color: kSecondaryText)),
                  const SizedBox(height: 8),
                  Text(drill['title']!,
                      style: const TextStyle(
                          color: kPrimaryText, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPageIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPageIndex == index ? kAccentBlue : kFieldColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLeaderboardDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _leaderboardPageIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _leaderboardPageIndex == index ? kNewAccentCyan : kFieldColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
