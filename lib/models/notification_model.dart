class PlayerNotification {
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // "invite", "feedback", "leaderboard", "follow", etc.
  bool isRead;

  PlayerNotification({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  String? get subtitle => null;
}
