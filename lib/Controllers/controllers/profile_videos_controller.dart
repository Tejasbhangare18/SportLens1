// File: controllers/profile_videos_controller.dart

import 'package:flutter/material.dart';
import '../../View/video_player_screen.dart';
import '../../models/models/profile_data.dart';
// We'll create this view next

class ProfileVideosController {
  // --- Data ---
  List<VideoModel> videos = [];
  List<StatModel> stats = [];

  // --- Logic ---

  /// Loads all data and calculates stats.
  void loadData() {
    // 1. Load mock video data
    videos = _loadMockVideos();
    
    // 2. Calculate stats based on video data
    stats = _calculateStats(videos);
  }

  /// Calculates the average score from the list of videos.
  double _calculateAverageScore(List<VideoModel> videos) {
    if (videos.isEmpty) return 0.0;
    double totalScore = videos.fold(0, (sum, item) => sum + item.score);
    return totalScore / videos.length;
  }

  /// Populates the list of stat cards.
  List<StatModel> _calculateStats(List<VideoModel> videos) {
    double avgScore = _calculateAverageScore(videos);
    
    return [
      StatModel(value: avgScore.round().toString(), label: 'Overall'),
      StatModel(value: videos.length.toString(), label: 'Videos'),
      StatModel(value: '3', label: 'Coaches'), // Hardcoded as in original
    ];
  }

  /// Handles navigation to the video player.
  void onVideoTapped(BuildContext context, String videoPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(videoPath: videoPath),
      ),
    );
  }

  // --- Mock Data Source ---
  /// In a real app, this would fetch from a database or API.
  List<VideoModel> _loadMockVideos() {
    return [
      VideoModel(title: 'Dribbling Drill', score: 88, videoPath: 'assets/output_cricket_ball.mp4'),
      VideoModel(title: 'Shooting Practice', score: 75, videoPath: 'assets/fielding_1_fielding_output.mp4'),
      VideoModel(title: 'Game Highlights', score: 92, videoPath: 'assets/batting_1_output.mp4'),
      VideoModel(title: 'Defensive Drills', score: 80, videoPath: 'assets/batting_1_output.mp4'),
    ];
  }
}