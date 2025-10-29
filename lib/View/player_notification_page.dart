import 'package:flutter/material.dart';
import '../Controllers/notification_controller.dart';
import 'widgets/notification_card.dart';
import '../models/notification_model.dart'; // <-- REQUIRED IMPORT (PlayerNotification)

// --- THEME COLORS ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A); // Added for refresh background
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;

// (Your StatefulWidget code is unchanged...)
class PlayerNotificationPage extends StatefulWidget {
  const PlayerNotificationPage({super.key});

  @override
  State<PlayerNotificationPage> createState() => _PlayerNotificationPageState();
}

class _PlayerNotificationPageState extends State<PlayerNotificationPage> {
  final NotificationController _controller = NotificationController();
  late Future<List<PlayerNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<PlayerNotification>> _fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final notifications = _controller.getAllNotifications()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notifications;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _notificationsFuture = _fetchNotifications();
    });
    await _notificationsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPrimaryText, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<PlayerNotification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          // --- LOADING STATE ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kNewAccentCyan));
          }

          // --- ERROR STATE ---
          if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              backgroundColor: kFieldColor,
              color: kNewAccentCyan,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      'Error loading notifications',
                      style: TextStyle(color: kSecondaryText.withOpacity(0.8)),
                    ),
                  ),
                ),
              ),
            );
          }

          // --- DATA STATE (Success) ---
          final notifications = snapshot.data ?? <PlayerNotification>[];

          // --- EMPTY STATE ---
          if (notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              backgroundColor: kFieldColor,
              color: kNewAccentCyan,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const _EmptyNotificationState(), // Using updated empty state
                ),
              ),
            );
          }

          // --- LIST STATE ---
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            backgroundColor: kFieldColor,
            color: kNewAccentCyan,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                // Reduce the icon size for notification-type icons (chat, drill, etc.)
                // only on this page by applying an IconTheme around the card.
                return IconTheme.merge(
                  data: const IconThemeData(size: 20),
                  child: NotificationCard(notification: notifications[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// --- Empty State Widget (REDESIGNED) ---
class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // UPDATED: Icon is now themed
          Icon(
            Icons.notifications_off_outlined,
            color: kNewAccentCyan.withOpacity(0.7), // THEME
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notifications Yet',
            style: TextStyle(color: kSecondaryText, fontSize: 18),
          ),
          const Text(
            'Invites and updates will appear here.',
            style: TextStyle(color: kSecondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}