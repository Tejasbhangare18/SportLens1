// File: views/profile_page.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the chart package
import 'package:flutter_application_3/View/edit_profile_page.dart';
import 'profile_videos_page.dart';
import '../Controllers/controllers/profile_videos_controller.dart';
// --- THIS IMPORT IS UPDATED ---
import 'profile_history_page.dart';

import 'settings_page.dart';

// --- UI Constants for "Electric Indigo" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // THEME: App Bar & Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // THEME: Bottom Nav Bar, UI Fields
const Color kAccentBlue = Color(0xFF4A90E2); // THEME: "View All" Button
const Color kActiveCyan = Color(0xFF00F0FF); // THEME: Active Icon/Text
// (Gradient colors not used on this page, but added for theme consistency)
const Color kLeaderboardGradientStart = Color(0xFF7B8FFD);
const Color kLeaderboardGradientEnd = Color(0xFF917DFB);
// --- End of Theme Colors ---


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State for the selected tab (Overview, History, etc.)
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Videos', 'History'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue, // THEME: Page Background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // (Shows kDarkBlue)
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white), // THEME: Regular Text
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // THEME: Regular Text
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
            icon: const Icon(Icons.settings_outlined, color: Colors.white), // THEME: Regular Text
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- User Info Header ---
              _buildProfileHeader(),
              const SizedBox(height: 30),
              // --- Custom Tab Bar ---
              _buildTabBar(),
              const SizedBox(height: 30),
              // Tab-specific content (Overview / Videos / Challenges)
              _buildTabContent(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- THIS METHOD IS UPDATED ---
  Widget _buildTabContent() {
    if (_selectedTabIndex == 0) {
      // Overview
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Highlights', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), // THEME: Regular Text
          const SizedBox(height: 16),
          _buildHighlights(), // <-- THIS WIDGET IS NOW UPDATED
          const SizedBox(height: 30),
          const Text('Progress Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), // THEME: Regular Text
          const SizedBox(height: 16),
          _buildProgressSummary(),
          const SizedBox(height: 16),
          _buildProgressChart(),
          const SizedBox(height: 30),
          const Text('Achievements / Badges', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), // THEME: Regular Text
          const SizedBox(height: 16),
          _buildAchievements(),
        ],
      );
    }

    if (_selectedTabIndex == 1) {
      // Videos (extracted to separate file)
      // Create controller, load data and pass to the ProfileVideosPage
      final controller = ProfileVideosController();
      controller.loadData();
      return ProfileVideosPage(controller: controller);
    }

    // History tab
    if (_selectedTabIndex == 2) {
      // --- UPDATED to use the new HistoryItem model ---
      final history = [
        HistoryItem(
          title: 'Drill Updated: Dribbling Drill',
          date: 'Oct 26, 2025',
          description: 'Score: 88',
          type: HistoryItemType.session,
        ),
        HistoryItem(
          title: "Coach's Feedback",
          date: 'Oct 25, 2025',
          description: 'Great work on the form. Need to focus on speed next time.',
          type: HistoryItemType.note,
        ),
         HistoryItem(
          title: 'Drill Updated: Shooting Practice',
          date: 'Oct 22, 2025',
          description: 'Score: 75',
          type: HistoryItemType.session,
        ),
      ];
      return ProfileHistoryPage(history: history);
    }

    // Fallback
    return Container();
  }
  // --- END OF UPDATED METHOD ---

  // --- THIS IS THE REBUILT PROFILE HEADER WIDGET ---
  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar without the edit icon overlay
            const CircleAvatar(radius: 44, backgroundImage: AssetImage('assets/profile1.png')),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Ethan Carter', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), // THEME: Regular Text
                      const SizedBox(width: 8),
                      // Edit icon next to the name
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfilePage()));
                        },
                        child: const Icon(Icons.edit, color: Colors.white70, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('@ethan_carter', style: TextStyle(color: Colors.white70)), // THEME: Regular Text
                  const SizedBox(height: 8),
                  const Text('Level: Pro • Team: Redhawks', style: TextStyle(color: Colors.white60)), // THEME: Regular Text
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Buttons row
        Row(
          children: [
            // Expanded makes the buttons fill the available space
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfilePage()));
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentBlue, // THEME: "View All" Button
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  foregroundColor: Colors.white, // THEME: Regular Text
                  padding: const EdgeInsets.symmetric(vertical: 12),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Share Profile'),
              ),
            ),
          ],
        ),
      ],
    );
  }


  // --- The rest of your helper widgets remain the same ---

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_tabs.length, (index) {
        bool isSelected = _selectedTabIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedTabIndex = index),
          child: Column(
            children: [
              Text(
                _tabs[index],
                style: TextStyle(
                  // --- THIS IS THE MODIFIED PART ---
                  color: isSelected ? kActiveCyan : Colors.white70, // THEME: Active Color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  // --- THIS IS THE MODIFIED PART ---
                  color: isSelected ? kActiveCyan : Colors.transparent, // THEME: Active Color
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  // --- THIS IS THE MODIFIED PART ---
  Widget _buildHighlights() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: _HighlightCard(title: 'Average Score', value: '92')),
            SizedBox(width: 16),
            // --- CHANGED THIS WIDGET ---
            Expanded(child: _HighlightCard(title: 'Total Points', value: '985')),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
            color: const Color.fromRGBO(250, 204, 21, 0.1), // Yellowish color
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.emoji_events, color: Color(0xFFFACC15), size: 28),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Best Performance', style: TextStyle(color: Color(0xFFFACC15), fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Reached 95 in Dribbling Drill', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _ProgressStat(value: '25', label: 'Sessions'),
        _ProgressStat(value: '15W - 5L', label: 'Challenges'),
        _ProgressStat(value: '+8%', label: '30d Change', isHighlight: true),
      ],
    );
  }

  Widget _buildProgressChart() {
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: _bottomTitleWidgets,
              ))),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 5),
              ],
              isCurved: true,
              // --- THIS IS THE MODIFIED PART ---
              color: kActiveCyan, // THEME: Active Color
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    // THEME: Gradient from Active Color
                    colors: [kActiveCyan.withOpacity(0.3), kActiveCyan.withOpacity(0.0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _AchievementBadge(asset: 'assets/trophy1.png', label: 'Top Scorer'),
        _AchievementBadge(asset: 'assets/trophy2.png', label: 'Most Improved'),
        _AchievementBadge(asset: 'assets/trophy3.png', label: 'Team MVP'),
      ],
    );
  }
}

// --- Helper Classes for UI Components ---

class _HighlightCard extends StatelessWidget {
  final String title;
  final String value;
  const _HighlightCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kFieldColor, borderRadius: BorderRadius.circular(12)), // THEME: UI Field
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)), // THEME: Regular Text
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), // THEME: Regular Text
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String label;
  final bool isHighlight;
  const _ProgressStat({required this.value, required this.label, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: isHighlight ? const Color(0xFF34D399) : Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), // THEME: Regular Text
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)), // THEME: Regular Text
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String asset;
  final String label;
  const _AchievementBadge({required this.asset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 40, backgroundImage: AssetImage(asset)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)), // THEME: Regular Text
      ],
    );
  }
}

// Helper function for the bottom titles of the chart
Widget _bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(color: Colors.white54, fontSize: 12); // THEME: Regular Text
  Widget text;
  switch (value.toInt()) {
    case 0: text = const Text('Jan', style: style); break;
    case 1: text = const Text('Feb', style: style); break;
    case 2: text = const Text('Mar', style: style); break;
    case 3: text = const Text('Apr', style: style); break;
    case 4: text = const Text('May', style: style); break;
    default: text = const Text('', style: style); break;
  }
  // THIS IS THE CORRECTED PART
  return text;
}