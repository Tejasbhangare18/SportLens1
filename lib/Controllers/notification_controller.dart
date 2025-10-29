import '../models/notification_model.dart';

class NotificationController {
  // Simulated notifications (later replace with Firebase fetch)
  List<PlayerNotification> getAllNotifications() {
    return [
      PlayerNotification(
        title: "Coach Feedback",
        message: "Coach Sarah reviewed your bowling action - 8.5/10",
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        type: "feedback",
      ),
      PlayerNotification(
        title: "Request Approved",
        message: "Your request to join Victory Academy was approved!",
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: "invite",
      ),
      PlayerNotification(
        title: "Leaderboard Update",
        message: "You moved up to #5 in Regional Bowling Rankings 🏆",
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: "leaderboard",
      ),
      PlayerNotification(
        title: "New Follower",
        message: "Aarav Singh started following you!",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: "follow",
      ),
    ];
  }
}
