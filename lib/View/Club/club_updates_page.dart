import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_announcement_page.dart';

class ClubUpdatesPage extends StatefulWidget {
  const ClubUpdatesPage({super.key});

  @override
  State<ClubUpdatesPage> createState() => _ClubUpdatesPageState();
}

class _ClubUpdatesPageState extends State<ClubUpdatesPage> {
  // --- THEME COLORS ---
  static const Color _kDarkBlue = Color(0xFF0D111C);
  static const Color _kCardStart = Color(0xFF1B2231);
  static const Color _kCardEnd = Color(0xFF121B26);
  static const Color _kCyanAccent = Color(0xFF00A8E8);

  final List<Map<String, String>> updates = [
    {
      'title': 'Upcoming Tournament',
      'date': '06 Oct 2025',
      'body':
          'Registration open for October Inter-Club Cricket Tournament. Apply before 12th October.',
    },
    {
      'title': 'New Training Schedule',
      'date': '04 Oct 2025',
      'body':
          'Weekly training for juniors starts from Wednesday, 7 PM. All are welcome.',
    },
    {
      'title': 'Trial Results Announced',
      'date': '30 Sep 2025',
      'body': 'Trial results for all age groups have been posted on the portal.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Club Updates",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_kDarkBlue, Color(0xFF121B26)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: updates.length,
          itemBuilder: (context, index) {
            final upd = updates[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_kCardStart.withOpacity(0.8), _kCardEnd.withOpacity(0.9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _kCyanAccent.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  upd['title']!,
                                  style: const TextStyle(
                                    color: _kCyanAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                upd['date']!,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            upd['body']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _kCyanAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Post Update',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAnnouncementPage()),
          );
          if (result != null && result is Map) {
            setState(() {
              updates.insert(0, {
                'title': result['title'] ?? 'Announcement',
                'date': result['scheduled'] == null
                    ? DateTime.now().toString().substring(0, 10)
                    : "${result['scheduled'].day.toString().padLeft(2, '0')} "
                        "${_monthText(result['scheduled'].month)} "
                        "${result['scheduled'].year}",
                'body': result['message'] ?? '',
              });
            });
          }
        },
      ),
    );
  }

  String _monthText(int monthNum) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[monthNum];
  }
}
