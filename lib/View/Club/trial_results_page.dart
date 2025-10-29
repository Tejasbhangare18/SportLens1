import 'package:flutter/material.dart';
import 'trials_theme.dart';

class TrialResultsPage extends StatelessWidget {
  final String trialTitle;
  const TrialResultsPage({Key? key, required this.trialTitle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example demo data
    final selectedPlayers = [
      {
        'name': 'Ethan Carter',
        'role': 'Forward',
        'image': 'assets/images/user1.png',
      },
      {
        'name': 'Liam Harper',
        'role': 'Midfielder',
        'image': 'assets/images/user2.png',
      },
      {
        'name': 'Noah Bennett',
        'role': 'Defender',
        'image': 'assets/images/user3.png',
      },
    ];
    final rejectedPlayers = [
      {
        'name': 'Oliver Hayes',
        'role': 'Goalkeeper',
        'image': 'assets/images/user4.png',
      },
      {
        'name': 'Elijah Foster',
        'role': 'Forward',
        'image': 'assets/images/user5.png',
      },
    ];

    Widget buildPlayerCard(Map<String, String> player, bool isSelected) {
      return Card(
        color: const Color(0xFF1E232D),
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage:
                player['image'] != null
                    ? AssetImage(player['image']!)
                    : const AssetImage('assets/images/default_profile.png'),
            backgroundColor: Colors.grey[700],
          ),
          title: Text(
            player['name'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            player['role'] ?? '',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.cancel,
            color: isSelected ? Colors.greenAccent : Colors.redAccent,
            size: 28,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        backgroundColor: kTrialBackground,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: Text(
          'Results: $trialTitle',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Players',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              ...selectedPlayers.map((player) => buildPlayerCard(player, true)),
              const SizedBox(height: 30),
              const Text(
                'Rejected Players',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              ...rejectedPlayers.map(
                (player) => buildPlayerCard(player, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
