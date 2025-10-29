import 'package:flutter/material.dart';


import '../../models/notification_model.dart';

// --- THEME COLORS (From your image's theme) ---
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---

class NotificationCard extends StatelessWidget {
  final PlayerNotification notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // Determine if this is a "special" card, like the Pro Tip
    final bool isSpecial = notification.type == 'invite';
    
    // The new "Glow" decoration
    final glowDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      // Glassy gradient background
      gradient: LinearGradient(
        colors: [
          kFieldColor.withOpacity(0.9),
          kFieldColor.withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      // Subtle border glow, brighter for special items
      border: Border.all(
        color: kNewAccentCyan.withOpacity(isSpecial ? 0.4 : 0.2),
        width: 1.0,
      ),
      // Soft "3D Glow" shadow effect
      boxShadow: [
        BoxShadow(
          color: kNewAccentCyan.withOpacity(isSpecial ? 0.25 : 0.1),
          blurRadius: 20.0,
          spreadRadius: 2.0,
        ),
      ],
    );

    // Your existing animation builder
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20), // slide up animation
            child: child,
          ),
        );
      },
      // Apply 'isRead' opacity to the entire animated widget
      child: Opacity(
        opacity: notification.isRead ? 0.65 : 1.0,
        // REPLACED Card/ListTile with the new design
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0), // Replaces Card's margin
          child: Container(
            decoration: glowDecoration,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              // Add the inner radial light for special cards
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: isSpecial
                    ? RadialGradient(
                        colors: [
                          kNewAccentCyan.withOpacity(0.15),
                          Colors.transparent,
                        ],
                        center: Alignment.topLeft,
                        radius: 1.5,
                      )
                    : null,
              ),
              // New layout using Row
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Icon (using your function)
                  Icon(_getIcon(notification.type), color: kNewAccentCyan, size: 24),
                  const SizedBox(width: 16),
                  
                  // 2. Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            color: isSpecial ? kNewAccentCyan : kPrimaryText, // Highlight special title
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Use .message from your model
                        Text(
                          notification.message,
                          style: const TextStyle(
                            color: kSecondaryText,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 3. Timestamp (using your function)
                  Text(
                    _formatTime(notification.timestamp),
                    style: const TextStyle(
                      color: kSecondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // YOUR EXISTING HELPER FUNCTIONS (Unchanged)
  IconData _getIcon(String type) {
    switch (type) {
      case 'invite':
        return Icons.sports_soccer;
      case 'feedback':
        return Icons.chat_bubble_outline;
      case 'leaderboard':
        return Icons.emoji_events_outlined;
      case 'follow':
        return Icons.person_add_alt_1_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  String _formatTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}