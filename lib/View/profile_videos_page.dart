import 'dart:io';
import 'package:flutter/material.dart';
import '../Controllers/controllers/profile_videos_controller.dart';
import '../models/models/profile_data.dart';
import 'package:path_provider/path_provider.dart';



// --- UI Constants ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);

class ProfileVideosPage extends StatelessWidget {
  // The View now holds a reference to its Controller.
  final ProfileVideosController controller;

  const ProfileVideosPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Top Row of Stat Cards ---
        Row(
          children: controller.stats.map((stat) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _StatCard(stat: stat),
              ),
            );
          }).toList(),
          // Remove default padding by adjusting the map
        ),
        const SizedBox(height: 30),

        // --- Videos Section Header ---
        const Text(
          'Videos',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // --- Videos GridView ---
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.videos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final video = controller.videos[index];
            return _VideoGridCard(
              video: video,
              onTap: () => controller.onVideoTapped(context, video.videoPath),
            );
          },
        ),
      ],
    );
  }
}

/// A simple, reusable stateless widget for the stat cards.
class _StatCard extends StatelessWidget {
  final StatModel stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: kFieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            stat.value,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// This stateful widget generates its own thumbnail from the video path.
class _VideoGridCard extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onTap;

  const _VideoGridCard({
    required this.video,
    required this.onTap,
  });

  @override
  State<_VideoGridCard> createState() => _VideoGridCardState();
}

class _VideoGridCardState extends State<_VideoGridCard> {
  String? _thumbnailPath;
  
  get VideoThumbnail => null;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = await VideoThumbnail.thumbnailFile(
        video: widget.video.videoPath,
        thumbnailPath: tempDir.path,
       
        quality: 50,
      );
      if (mounted) {
        setState(() {
          _thumbnailPath = path;
        });
      }
    } catch (e) {
      print("Error generating thumbnail: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: double.infinity,
                color: kFieldColor, // Placeholder color
                child: _thumbnailPath == null
                    ? const Center(
                        child: CircularProgressIndicator(color: kAccentBlue),
                      )
                    : Image.file(
                        File(_thumbnailPath!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.video.title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Score: ${widget.video.score}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}