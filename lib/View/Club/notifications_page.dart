import 'package:flutter/material.dart';
import 'notifications_repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showOnlyUnread = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() => showOnlyUnread = !showOnlyUnread);
            },
            tooltip: showOnlyUnread ? 'Show all' : 'Show unread',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Clear all notifications'),
                      content: const Text(
                        'Are you sure you want to clear all notifications?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
              );
              if (ok == true) NotificationsRepository.instance.clear();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<NotificationItem>>(
        valueListenable: NotificationsRepository.instance.notifications,
        builder: (context, list, _) {
          final items =
              showOnlyUnread ? list.where((n) => !n.read).toList() : list;
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No notifications',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final n = items[index];
              return Dismissible(
                key: ValueKey(n.id),
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed:
                    (_) => NotificationsRepository.instance.remove(n.id),
                child: ListTile(
                  tileColor:
                      n.read
                          ? const Color(0xFF23252B)
                          : const Color(0xFF2C3137),
                  title: Text(
                    n.title,
                    style: TextStyle(
                      color: n.read ? Colors.white70 : Colors.white,
                      fontWeight: n.read ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    n.body,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'toggle')
                        NotificationsRepository.instance.markRead(
                          n.id,
                          read: !n.read,
                        );
                      if (v == 'delete')
                        NotificationsRepository.instance.remove(n.id);
                    },
                    itemBuilder:
                        (_) => [
                          PopupMenuItem(
                            value: 'toggle',
                            child: Text(
                              n.read ? 'Mark as unread' : 'Mark as read',
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                  ),
                  onTap: () {
                    // Mark read on open
                    if (!n.read)
                      NotificationsRepository.instance.markRead(
                        n.id,
                        read: true,
                      );
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text(n.title),
                            content: Text(n.body),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // No FAB as per requested (no add option in notifications page)
    );
  }

  // helper removed: no add option in notifications page per request
}
