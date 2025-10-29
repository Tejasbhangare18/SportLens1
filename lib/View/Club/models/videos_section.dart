import 'package:flutter/material.dart';

class VideoItem {
  final String thumbnail;
  final String title;
  final int score;
  VideoItem({
    required this.thumbnail,
    required this.title,
    required this.score,
  });
}

class VideosSection extends StatelessWidget {
  final List<VideoItem> items;
  const VideosSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Videos & Drills',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final v = items[index];
              return Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3A4A),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          color: Colors.grey[800],
                          child:
                              v.thumbnail.startsWith('http')
                                  ? Image.network(
                                    v.thumbnail,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (ctx, err, st) => Container(
                                          color: Colors.grey[800],
                                          child: const Icon(
                                            Icons.videocam,
                                            color: Colors.white38,
                                            size: 36,
                                          ),
                                        ),
                                  )
                                  : Image.asset(
                                    v.thumbnail,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (ctx, err, st) => Container(
                                          color: Colors.grey[800],
                                          child: const Icon(
                                            Icons.videocam,
                                            color: Colors.white38,
                                            size: 36,
                                          ),
                                        ),
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(v.title, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}
