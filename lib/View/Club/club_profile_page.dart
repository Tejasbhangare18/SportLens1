import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'edit_club_profile_page.dart';
import 'settings_page.dart';

class ClubProfilePage extends StatefulWidget {
  const ClubProfilePage({Key? key}) : super(key: key);

  @override
  State<ClubProfilePage> createState() => _ClubProfilePageState();
}

class _ClubProfilePageState extends State<ClubProfilePage> {
  final List<String> clubPhotos = [
    'https://images.unsplash.com/photo-1507537509458-b8312d33e49a',
    'https://images.unsplash.com/photo-1517649763962-0c623066013b',
    'https://images.unsplash.com/photo-1494526585095-c41746248156',
  ];

  final List<String> achievements = [
    'Winner of Regional Championship 2023',
    'Best Youth Development 2022',
    '3-time National Finalists',
  ];

  final List<Map<String, String>> reviews = [
    {
      'reviewer': 'John D.',
      'comment': 'Excellent coaching and friendly environment!',
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'reviewer': 'Sarah K.',
      'comment': 'Great facilities and training programs.',
      'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
    },
  ];

  late PageController _photosController;
  late PageController _achievementsController;

  final String clubDescription = 'Multi-sport club • Established 2015';
  final String contactEmail = 'contact@elitesports.com';
  final String contactPhone = '+1 (555) 123-4567';
  final String clubLocation = 'New York City';

  @override
  void initState() {
    super.initState();
    _photosController = PageController();
    _achievementsController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _photosController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  static const bgColor = Color(0xFF121212);
  static const cardColor = Color(0xFF1E1E1E);
  static const sectionTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Club Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Club photos carousel
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _photosController,
              itemCount: clubPhotos.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(clubPhotos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: _photosController,
              count: clubPhotos.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.blueAccent,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Club description below photos carousel
          Center(
            child: Text(
              clubDescription,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Achievements
          Text('Achievements', style: sectionTextStyle),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _achievementsController,
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      achievements[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Contact info below achievements
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.white70),
            title: Text(
              clubLocation,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.white70),
            title: Text(
              contactEmail,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.white70),
            title: Text(
              contactPhone,
              style: const TextStyle(color: Colors.white70),
            ),
          ),

          const SizedBox(height: 24),

          // Reviews
          Text('Reviews', style: sectionTextStyle),
          const SizedBox(height: 12),
          ...reviews.map(
            (rev) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(rev['avatar']!),
                radius: 24,
              ),
              title: Text(
                rev['reviewer']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                rev['comment']!,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // View/Edit Profile button
          ElevatedButton(
            onPressed: () {
              // Navigate to the Edit Club Profile page with current values
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => EditClubProfilePage(
                        name: 'Elite Sports Club',
                        description: clubDescription,
                        year: '2015',
                        email: contactEmail,
                        phone: contactPhone,
                        location: clubLocation,
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
