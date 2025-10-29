import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    DateTime? createdAt,
    this.read = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'read': read,
  };
}

class NotificationsRepository {
  NotificationsRepository._();
  static final instance = NotificationsRepository._();

  final ValueNotifier<List<NotificationItem>> notifications =
      ValueNotifier<List<NotificationItem>>([]);

  void add(NotificationItem item) {
    notifications.value = [...notifications.value, item];
  }

  void markRead(String id, {bool read = true}) {
    final idx = notifications.value.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    final copy = [...notifications.value];
    final item = copy[idx];
    copy[idx] = NotificationItem(
      id: item.id,
      title: item.title,
      body: item.body,
      createdAt: item.createdAt,
      read: read,
    );
    notifications.value = copy;
  }

  void remove(String id) {
    notifications.value = notifications.value.where((n) => n.id != id).toList();
  }

  void clear() {
    notifications.value = [];
  }

  int unreadCount() => notifications.value.where((n) => !n.read).length;
}
