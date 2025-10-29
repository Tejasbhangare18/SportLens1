import 'package:flutter/material.dart';

class VideoItem {
  final String thumbnail;
  final String title;
  final int score;

  const VideoItem({
    required this.thumbnail,
    required this.title,
    required this.score,
  });
}

class VideosSection extends StatelessWidget {
  final List<VideoItem> items;

  const VideosSection({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final it = items[index];
          return _VideoCard(item: it);
        },
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoItem item;
  const _VideoCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumb = item.thumbnail;
    Widget thumbWidget;

    if (thumb.startsWith('http')) {
      thumbWidget = Image.network(
        thumb,
        width: 180,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _placeholder(),
      );
    } else {
      thumbWidget = Image.asset(
        thumb,
        width: 180,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _placeholder(),
      );
    }

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 180,
              height: 100,
              color: const Color(0xFF1E1E1E),
              child: thumbWidget,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${item.score} pts',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 180,
      height: 100,
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Icon(Icons.videocam, color: Colors.white38, size: 36),
      ),
    );
  }
}
