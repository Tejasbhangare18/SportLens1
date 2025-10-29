import 'package:flutter/material.dart';

const Color _kFieldColor = Color(0xFF2A3A4A);
const Color _kTextWhite = Colors.white;

class VideoItem {
  final String thumbnail; // asset path
  final String title;
  final int score;

  VideoItem({required this.thumbnail, required this.title, required this.score});
}

class VideosSection extends StatelessWidget {
  final List<VideoItem> items;
  final int crossAxisCount;

  const VideosSection({super.key, required this.items, this.crossAxisCount = 2});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final v = items[index];
        return _VideoCard(item: v);
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoItem item;
  const _VideoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.thumbnail,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _kFieldColor,
                child: const Center(child: Icon(Icons.videocam, color: Colors.white24, size: 36)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(item.title, style: const TextStyle(color: _kTextWhite, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Score: ${0}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}
