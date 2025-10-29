// File: models/profile_data.dart

class StatModel {
  final String value;
  final String label;

  StatModel({required this.value, required this.label});
}

class VideoModel {
  final String title;
  final int score;
  final String videoPath;

  VideoModel({
    required this.title,
    required this.score,
    required this.videoPath,
  });
}