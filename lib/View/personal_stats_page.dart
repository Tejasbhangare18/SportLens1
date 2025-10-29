import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this import for the chart

// --- NEW THEME COLORS (Based on your description) ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8); // This is the "cyan glow"
const Color kActiveCyan = Color(0xFF00F0FF);   // <-- 1. ADDED YOUR NEW COLOR
const Color kGreen = Color(0xFF34D399);       // For "up" arrows
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---

class PersonalStatsPage extends StatelessWidget {
  const PersonalStatsPage({super.key});

  // --- This is the new "Glassy Glow" card decoration ---
  BoxDecoration _glassyGlowDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
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
        color: kNewAccentCyan.withOpacity(0.2),
        width: 1.0,
      ),
      // Soft "3D Glow" shadow effect
      boxShadow: [
        BoxShadow(
          color: kNewAccentCyan.withOpacity(0.1),
          blurRadius: 20.0,
          spreadRadius: 1.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue, // Changed to kDarkBlue for consistency
        elevation: 0,
        leading: const BackButton(color: kPrimaryText),
        title: const Text(
          'Personal Stats',
          style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildOverallScoreCard(),
              const SizedBox(height: 24),
              _buildLeaderboardCard(),
              const SizedBox(height: 24),
              _buildPerformanceChartCard(),
              const SizedBox(height: 24),
              _buildActionableInsightsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your AI-Powered Journey',
          style: TextStyle(
              color: kPrimaryText, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Track your progress and climb the leaderboards.',
          style: TextStyle(color: kSecondaryText, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildOverallScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _glassyGlowDecoration(), // <-- THEME APPLIED
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Performance Score',
                      style: TextStyle(color: kPrimaryText, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Powered by AI Analysis',
                      style: TextStyle(color: kSecondaryText, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Text(
                    '88',
                    style: TextStyle(
                        color: kNewAccentCyan, // <-- THEME COLOR
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '↑+5',
                    style: TextStyle(
                        color: kGreen, // <-- THEME COLOR
                        fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.88,
              minHeight: 8,
              backgroundColor: kDarkBlue,
              valueColor: AlwaysStoppedAnimation<Color>(
                  kNewAccentCyan), // <-- THEME COLOR
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('Next Level: 90',
                style: TextStyle(color: kSecondaryText, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Leaderboard Ranking',
            style: TextStyle(
                color: kPrimaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: _glassyGlowDecoration(), // <-- THEME APPLIED
          child: Column(
            children: [
              _buildLeaderboardRow(Icons.emoji_events, 'Global Batting Speed',
                  'Top 10%', '#1,204'),
              Divider(color: kDarkBlue.withOpacity(0.5)), // Tweaked divider
              _buildLeaderboardRow(Icons.military_tech, 'Regional Accuracy',
                  'Top 5%', '#89'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardRow(
      IconData icon, String title, String subtitle, String rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: kNewAccentCyan, size: 30), // <-- THEME COLOR
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: kPrimaryText, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: kSecondaryText)),
              ],
            ),
          ),
          Text(
            rank,
            style: const TextStyle(
                color: kNewAccentCyan, // <-- THEME COLOR
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChartCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Performance Breakdown',
            style: TextStyle(
                color: kPrimaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _glassyGlowDecoration(), // <-- THEME APPLIED
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('Batting Speed Over Time',
                      style: TextStyle(
                          color: kPrimaryText, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text('85 mph',
                      style: TextStyle(
                          color: kPrimaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Text(
                    '↑5%',
                    style: TextStyle(color: kGreen), // <-- THEME COLOR
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                child: LineChart(
                  _mainData(), // This function is now themed
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionableInsightsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Actionable Insights',
            style: TextStyle(
                color: kPrimaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          decoration: _glassyGlowDecoration(), // <-- THEME APPLIED
          // Use clipBehavior to make InkWell ripples conform to border radius
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _buildInsightRow(Icons.track_changes, 'Improve Bat Swing',
                  'New personalized drill available.'),
              Divider(color: kDarkBlue.withOpacity(0.5), height: 1),
              _buildInsightRow(Icons.videocam, 'Review Last Session',
                  'AI has identified 3 key moments.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightRow(IconData icon, String title, String subtitle) {
    // This InkWell provides the "smooth press animation"
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: kNewAccentCyan, size: 28), // <-- THEME COLOR
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: kPrimaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: kSecondaryText)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: kSecondaryText, size: 16),
          ],
        ),
      ),
    );
  }

  // --- Chart Data (THEMED) ---
  LineChartData _mainData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(0.5, 4),
            FlSpot(1, 2.5),
            FlSpot(1.5, 5),
            FlSpot(2, 3),
            FlSpot(2.5, 4),
            FlSpot(3, 3.5),
            FlSpot(3.5, 2),
            FlSpot(4, 5.5),
            FlSpot(4.5, 3),
            FlSpot(5, 4.5),
          ],
          isCurved: true,
          color: kActiveCyan, // <-- 2. CHANGED THE LINE COLOR
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                kActiveCyan.withOpacity(0.3), // <-- 3. CHANGED THE GRADIENT
                kActiveCyan.withOpacity(0.0)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: kSecondaryText, fontSize: 12); // THEME
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return text;
  }
}