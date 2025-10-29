import 'package:flutter/material.dart';
import 'drills_repository.dart';

class CompletedDrillsPage extends StatelessWidget {
  const CompletedDrillsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1318),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1318),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Completed Challenges',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: DrillsRepository.instance.completed,
        builder: (context, completed, _) {
          if (completed.isEmpty) {
            return const Center(
              child: Text(
                'No completed challenges yet',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: completed.length,
            itemBuilder: (context, index) {
              final drill = completed[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C2431), Color(0xFF10151C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  title: Text(
                    drill['title'] ?? 'Untitled Challenge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      '${drill['sport'] ?? 'Unknown Sport'} • ${drill['dateLabel'] ?? 'No Date'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amberAccent,
                    size: 26,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
