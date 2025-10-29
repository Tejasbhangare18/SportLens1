import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'trials_page.dart';
import 'scouting_page.dart';
import 'pending_approval_page.dart';
import 'top_trial_applicants_page.dart';
import 'completed_trials_page.dart';
import 'new_trial_page.dart';
import 'trials_repository.dart';
import 'pending_repository.dart';
import 'club_updates_page.dart';
import 'add_drill_page.dart';
import 'drills_repository.dart';
import 'completed_drills_page.dart';
import 'notifications_page.dart';
import 'Club_leaderboard_page.dart';
import 'club_profile_page.dart';
import 'Widget/bottomNavigationbar.dart';
import 'my_players_page.dart';
import 'player_requests_page.dart';
import 'reviews_page.dart';

class ClubDashboardScreen extends StatefulWidget {
  const ClubDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ClubDashboardScreen> createState() => _ClubDashboardScreenState();
}

class _ClubDashboardScreenState extends State<ClubDashboardScreen> {
  final Color primaryColor = const Color(0xFF348AFF);
  final Color borderColor = Colors.white24;

  int _selectedIndex = 0;
  int currentIndex = 0;
  int _dashboardIndex = 0;

  late PageController _pageController;
  late PageController _dashboardController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    _dashboardController = PageController(
      initialPage: _dashboardIndex,
      viewportFraction: 0.62,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dashboardController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> players = [
    {
      'imageUrl': 'assets/images/scoutplayers.jpg',
      'headline': 'Discover Talent',
      'subheadline': 'Swipe through players',
    },
    {
      'imageUrl': 'https://picsum.photos/seed/1/800/1200',
      'headline': 'Top Applicants',
      'subheadline': 'Check applications',
    },
    {
      'imageUrl': 'assets/images/defaultprofile.png',
      'headline': 'Your Club',
      'subheadline': 'Manage teams and trials',
    },
  ];

  final List<Map<String, dynamic>> dashboardBlocks = [
    {
      'title': 'My Players',
      'subtitle': 'Manage your squad',
      'color': Colors.deepPurple,
      'icon': Icons.people,
    },
    {
      'title': 'Requests',
      'subtitle': 'Player requests & invites',
      'color': Colors.orangeAccent,
      'icon': Icons.person_add,
    },
    {
      'title': 'Reviews',
      'subtitle': 'Check player feedback and ratings',
      'color': Colors.greenAccent,
      'icon': Icons.star_half,
    },
  ];

  Widget _buildHomeContent(double reducedTopPadding) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22, reducedTopPadding, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Player carousel
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: PageView.builder(
                  itemCount: players.length,
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() => currentIndex = i);
                  },
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Builder(
                          builder: (context) {
                            final img = player['imageUrl']!;
                            if (img.startsWith('assets/')) {
                              return Image.asset(img, fit: BoxFit.cover);
                            }
                            return Image.network(
                              img,
                              fit: BoxFit.cover,
                              loadingBuilder: (ctx, child, progress) =>
                                  progress == null
                                      ? child
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            );
                          },
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black54,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(28, 0, 28, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player['headline'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  player['subheadline'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              onTap: () {
                                // Navigate based on carousel index
                                switch (index) {
                                  case 0:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ScoutingPage(
                                          showBackButton: true,
                                        ),
                                      ),
                                    );
                                    break;
                                  case 1:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const TopTrialApplicantsPage(),
                                      ),
                                    );
                                    break;
                                  case 2:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const ClubUpdatesPage(),
                                      ),
                                    );
                                    break;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _pageController,
              count: players.length,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                expansionFactor: 3,
                activeDotColor: primaryColor,
                dotColor: borderColor.withOpacity(0.5),
                spacing: 8,
              ),
              onDotClicked: (index) {
                setState(() {
                  currentIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trials',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Trials pills
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TrialsPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: TrialsRepository.instance.ongoing,
                      builder: (context, ongoing, _) {
                        return _buildStatusPill(
                          'Trials Open',
                          ongoing.length.toString(),
                          Colors.greenAccent,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PendingApprovalPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: PendingRepository.instance.pending,
                      builder: (context, pending, _) {
                        return _buildStatusPill(
                          'Pending Approval',
                          pending.length.toString(),
                          Colors.amberAccent,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CompletedTrialsPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: TrialsRepository.instance.completed,
                      builder: (context, completed, _) {
                        return _buildStatusPill(
                          'Completed',
                          completed.length.toString(),
                          Colors.blueAccent,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.of(context)
                      .push<Map<String, dynamic>>(
                    MaterialPageRoute(builder: (_) => const NewTrialPage()),
                  );
                  if (result != null) {
                    TrialsRepository.instance.addTrial(result);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white24,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/team_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Create New Trials',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            shadows: const [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.black87,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Challenges',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Challenges pills (Removed ongoing)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddDrillPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: _buildStatusPill(
                      'Add challenges',
                      '',
                      Colors.greenAccent,
                      Icons.add,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CompletedDrillsPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: DrillsRepository.instance.completed,
                      builder: (context, completed, _) {
                        return _buildStatusPill(
                          'Completed',
                          completed.length.toString(),
                          Colors.blueAccent,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Dashboard blocks
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _dashboardController,
                itemCount: dashboardBlocks.length,
                padEnds: false,
                onPageChanged: (index) {
                  setState(() {
                    _dashboardIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final block = dashboardBlocks[index];
                  final Color blockColor = (block['color'] is Color)
                      ? block['color'] as Color
                      : primaryColor;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MyPlayersPage(),
                              ),
                            );
                            break;
                          case 1:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PlayerRequestsPage(),
                              ),
                            );
                            break;
                          case 2:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ClubReviewsPage(),
                              ),
                            );
                            break;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: blockColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: blockColor.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                block['icon'],
                                color: Colors.white,
                                size: 34,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                block['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                block['subtitle'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(
    String label,
    String countOrStatus,
    Color color, [
    IconData? icon,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          if (icon != null)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 16, color: Colors.black),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                countOrStatus,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF121B26);
    final fullTopPadding = MediaQuery.of(context).padding.top;
    final reducedTopPadding = math.max(8.0, fullTopPadding - 8.0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(reducedTopPadding),
            ScoutingPage(),
            const LeaderboardPage(),
            const ClubProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: ClubBottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: (idx) {
          setState(() => _selectedIndex = idx);
        },
      ),
    );
  }
}
