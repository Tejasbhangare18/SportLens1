// File: views/profile_history_page.dart

import 'package:flutter/material.dart';

// --- UI Constants from your theme ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8); // For Sessions
const Color kAccentBlue = Color(0xFF4A90E2); // For Notes

/// Enum to define what type of event the history item is.
enum HistoryItemType { session, note }

/// A Model for a single item in the history timeline.
class HistoryItem {
  final String title;
  final String date;
  final String? description;
  final HistoryItemType type;

  HistoryItem({
    required this.title,
    required this.date,
    this.description,
    required this.type,
  });
}

class ProfileHistoryPage extends StatelessWidget {
  // Your ProfilePage will pass this list of items
  final List<HistoryItem> history;

  const ProfileHistoryPage({super.key, required this.history});

  // --- Helper to get the right icon based on type ---
  IconData _getIconForType(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.session:
        return Icons.video_camera_back_outlined;
      case HistoryItemType.note:
        return Icons.edit_note_rounded;
    }
  }

  // --- Helper to get the right color based on type ---
  Color _getColorForType(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.session:
        return kNewAccentCyan;
      case HistoryItemType.note:
        return kAccentBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Text(
          'No activity history yet.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    // A simple list, no complex charts or stats
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final icon = _getIconForType(item.type);
        final color = _getColorForType(item.type);

        return _buildTimelineTile(
          item: item,
          icon: icon,
          iconColor: color,
          isFirst: index == 0,
          isLast: index == history.length - 1,
        );
      },
    );
  }

  /// Builds a single tile in our timeline.
  Widget _buildTimelineTile({
    required HistoryItem item,
    required IconData icon,
    required Color iconColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- The Timeline V-Line and Icon ---
          SizedBox(
            width: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top line (invisible if first)
                Container(
                  width: 2,
                  height: 12, // Space from top to icon
                  color: isFirst ? Colors.transparent : kFieldColor,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kFieldColor,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                // Bottom line (invisible if last)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : kFieldColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // --- The Event Content ---
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0, top: 12.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kFieldColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.date,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    if (item.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          item.description!,
                          style: TextStyle(
                            color: item.type == HistoryItemType.session
                                ? kNewAccentCyan // Highlight score
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: item.type == HistoryItemType.session
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}