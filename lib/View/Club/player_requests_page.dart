import 'package:flutter/material.dart';

// --- Modern Gradient Glow Theme ---
const Color kDarkBlue = Color(0xFF1A2531);    // Page Background
const Color kFieldColor = Color(0xFF2A3A4A);   // Card/Field Background
const Color kNewAccentCyan = Color(0xFF00A8E8); // Glow & Accent Color
const Color kPrimaryText = Colors.white;    // Primary Text
const Color kSecondaryText = Colors.white70; // Secondary Text
const Color kErrorRed = Color(0xFFEF4444);      // Error/Decline Color
// --- End Theme ---

class PlayerRequestsPage extends StatefulWidget {
  const PlayerRequestsPage({Key? key}) : super(key: key);

  @override
  State<PlayerRequestsPage> createState() => _PlayerRequestsPageState();
}

class _PlayerRequestsPageState extends State<PlayerRequestsPage> {
  // Using late initialization and making it mutable
  late List<Map<String, String>> requests;

  @override
  void initState() {
    super.initState();
    // Initialize requests in initState
    requests = [
      {
        'name': 'James Wilson',
        'position': 'Midfielder',
        'age': '20',
        'avatar': 'https://randomuser.me/api/portraits/men/34.jpg',
      },
      {
        'name': 'Emily Clark',
        'position': 'Defender',
        'age': '22',
        'avatar': 'https://randomuser.me/api/portraits/women/45.jpg',
      },
      {
        'name': 'Michael Brown',
        'position': 'Forward',
        'age': '19',
        'avatar': 'https://randomuser.me/api/portraits/men/56.jpg',
      },
      // Add more requests as needed
    ];
  }


  void _acceptRequest(int index) {
    final name = requests[index]['name'];
    setState(() {
      requests.removeAt(index); // Remove item from the mutable list
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Accepted $name'),
          backgroundColor: Colors.green, // Success feedback color
          behavior: SnackBarBehavior.floating, // Consistent snackbar style
        )
    );
  }

  void _declineRequest(int index) {
    final name = requests[index]['name'];
    setState(() {
      requests.removeAt(index); // Remove item from the mutable list
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Declined $name'),
          backgroundColor: kErrorRed, // Error feedback color
          behavior: SnackBarBehavior.floating,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue, // Theme background
      appBar: AppBar(
        backgroundColor: kDarkBlue, // Theme background
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: kPrimaryText), // Theme icon color
        title: const Text(
          'Player Requests',
          style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 20), // Theme text
        ),
      ),
      body: requests.isEmpty
          ? const Center(
              child: Text(
                'No pending requests',
                style: TextStyle(color: kSecondaryText, fontSize: 16), // Theme text
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16), // Consistent padding
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16), // Increased spacing
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildRequestCard(request, index); // Use helper widget
              },
            ),
    );
  }

  // --- NEW: Helper Widget for Request Card ---
  Widget _buildRequestCard(Map<String, String> request, int index) {
    return Container(
      decoration: BoxDecoration(
        // Subtle Gradient Background
        gradient: LinearGradient(
           colors: [ kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.6) ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16), // Modern radius
        // Glow Effect Border & Shadow
        border: Border.all(color: kNewAccentCyan.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kNewAccentCyan.withOpacity(0.08), // Softer glow
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16), // Consistent internal padding
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(request['avatar']!),
            radius: 30, // Slightly larger avatar
            backgroundColor: kDarkBlue, // Fallback color matching theme
          ),
          const SizedBox(width: 16), // Increased spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['name']!,
                  style: const TextStyle(
                    color: kPrimaryText, // Theme text
                    fontWeight: FontWeight.bold,
                    fontSize: 17, // Adjusted size
                  ),
                   maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6), // Spacing
                Text(
                  '${request['position'] ?? 'N/A'}, Age: ${request['age'] ?? 'N/A'}',
                  style: const TextStyle(color: kSecondaryText, fontSize: 14), // Theme text
                   maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // Spacing before buttons
          // --- Themed Buttons ---
          Row(
            mainAxisSize: MainAxisSize.min, // Prevent excessive width
            children: [
              // Decline Button (Outlined, Red Accent)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: kErrorRed,
                  side: BorderSide(color: kErrorRed.withOpacity(0.7), width: 1.5), // Themed border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Modern radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // Adjusted padding
                ),
                onPressed: () => _declineRequest(index),
                child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10), // Spacing between buttons
              // Accept Button (Elevated, Cyan Accent)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNewAccentCyan, // Theme accent
                  foregroundColor: kDarkBlue, // High contrast text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Modern radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9), // Adjusted padding
                   elevation: 4, // Subtle shadow
                   shadowColor: kNewAccentCyan.withOpacity(0.3), // Glow shadow
                ),
                onPressed: () => _acceptRequest(index),
                child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}