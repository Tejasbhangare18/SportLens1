import 'package:flutter/material.dart';
import 'edit_trial_page.dart';
// --- INCORRECT/MISSING IMPORT (Corrected below) ---
// import 'models/full_profile_page.dart'; // This path is likely wrong

// +++ ADD CORRECT IMPORTS +++
import 'package:flutter_application_3/View/full_profile_page.dart'; // Correct path to FullProfilePage
import 'package:flutter_application_3/models/player.dart'; // Import the Player model

import 'trials_theme.dart'; // Assuming this contains your constants

class TrialDetailsPage extends StatefulWidget {
  final Map<String, dynamic> trial;
  final VoidCallback onEndTrial;
  final Function(Map<String, dynamic>) onUpdateTrial;

  const TrialDetailsPage({
    Key? key,
    required this.trial,
    required this.onEndTrial,
    required this.onUpdateTrial,
  }) : super(key: key);

  @override
  State<TrialDetailsPage> createState() => _TrialDetailsPageState();
}

class _TrialDetailsPageState extends State<TrialDetailsPage> {
  late Map<String, dynamic> trial;
  // --- Using Applicant Map directly, assumes structure matches Player কিছুটা ---
  late List<Map<String, dynamic>> applicants; // Changed type to dynamic for flexibility

  final Color primaryColor = kPrimaryAccent;
  final Color backgroundColor = kTrialBackground;

  @override
  void initState() {
    super.initState();
    trial = Map<String, dynamic>.from(widget.trial);

    // --- Safely cast and handle applicants list ---
    var applicantData = widget.trial['applicants'];
    if (applicantData is List && applicantData.isNotEmpty) {
       // Try casting each element, filter out invalid ones
      applicants = applicantData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      // Provide default mock data if applicants list is null, empty, or wrong type
      applicants = [
        // Using dynamic map, add fields needed by Player constructor later
        {
          'name': 'Ethan Carter',
          'role': 'Forward',
          'avatar': 'assets/images/user1.png', // Renamed 'image' to 'avatar'
          'status': 'Accepted',
          'username': '@ethanc', 'score': 985, 'points': '12k', 'level': 15, 'age': 'U18', 'sport': 'Basketball', 'team': 'ClubTeam' // Added missing Player fields
        },
        {
          'name': 'Liam Harper',
          'role': 'Midfielder',
          'avatar': 'assets/images/user2.png',
          'status': 'Pending',
           'username': '@liamh', 'score': 950, 'points': '11k', 'level': 13, 'age': 'U16', 'sport': 'Soccer', 'team': 'ClubTeam' // Added missing Player fields
        },
        {
          'name': 'Noah Bennett',
          'role': 'Defender',
          'avatar': 'assets/images/user3.png',
          'status': 'Accepted',
           'username': '@noahb', 'score': 970, 'points': '11.5k', 'level': 14, 'age': 'U18', 'sport': 'Basketball', 'team': 'ClubTeam' // Added missing Player fields
        },
        {
          'name': 'Oliver Hayes',
          'role': 'Goalkeeper',
          'avatar': 'assets/images/user4.png',
          'status': 'Declined',
           'username': '@oliverh', 'score': 920, 'points': '10k', 'level': 12, 'age': 'U16', 'sport': 'Soccer', 'team': 'ClubTeam' // Added missing Player fields
        },
      ];
    }
  }


  Future<void> _navigateToEditTrial() async {
    final updatedTrial = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => EditTrialPage(initialTrialData: trial)),
    );

    if (updatedTrial != null) {
      setState(() {
        trial = updatedTrial;
      });
      widget.onUpdateTrial(updatedTrial);
    }
  }

  void _endTrial() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // ... (Your existing Dialog code remains the same) ...
         return Dialog(
          backgroundColor: const Color(0xFF16181E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 26, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("End Trial?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20,)),
                const SizedBox(height: 12),
                const Text("Are you sure you want to end this trial? This action cannot be undone.", style: TextStyle(color: Colors.white70, fontSize: 15), textAlign: TextAlign.center,),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // ... (Your existing end trial logic) ...
                      if (!mounted) return;
                      Navigator.of(context).pop(); // Close dialog
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        widget.onEndTrial();
                        Navigator.of(context).pop(true); // Pop TrialDetailsPage
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: const Text("Trial ended"), backgroundColor: Colors.green[700], behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16),), margin: const EdgeInsets.symmetric( horizontal: 40, vertical: 20,),),);
                        }
                      });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                  child: const Text("End Trial", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                  child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70,),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Accepted": return Colors.greenAccent;
      case "Pending": return Colors.amberAccent;
      case "Declined": return Colors.redAccent;
      default: return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Trial Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22,)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  // ... (Header styling remains the same) ...
                   height: 140, width: double.infinity, decoration: BoxDecoration( color: const Color(0xFF16212A), borderRadius: BorderRadius.circular(16),), padding: const EdgeInsets.all(16),
                   child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [ Text( trial['title'] ?? 'Trial Title', style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22,),), const SizedBox(height: 4), Text( trial['date'] ?? '', style: const TextStyle( color: Colors.white70, fontSize: 14,),),],),
                ),
                const SizedBox(height: 20),
                // Location Row
                Row(
                  // ... (Location styling remains the same) ...
                   children: [ const Icon( Icons.location_on, color: Colors.white70, size: 20,), const SizedBox(width: 8), Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text( trial['location'] ?? "MCA Cricket Ground", style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15,),), Text( trial['address'] ?? 'Gahunje, Pune, Maharashtra', style: const TextStyle( color: Colors.white70, fontSize: 13,),),],), const Spacer(), Container( width: 44, height: 34, decoration: BoxDecoration( color: const Color(0xFF23303A), borderRadius: BorderRadius.circular(8),),),],
                ),
                const SizedBox(height: 24),
                // Description
                const Text("Description", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,)),
                const SizedBox(height: 8),
                Text( trial['description'] ?? "...", style: const TextStyle(color: Colors.white70, fontSize: 14),),
                const SizedBox(height: 24),
                // Applicants List Header
                Text("Applicants (${applicants.length})", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,)),
                const SizedBox(height: 14),
                // Applicants List
                Column(
                  children: applicants.map((applicant) {
                    final status = applicant['status']?.toString() ?? '';
                    final statusColor = _getStatusColor(status);

                    // +++ CREATE PLAYER OBJECT FROM APPLICANT MAP +++
                    // Ensure your Player constructor can handle potential nulls or provide defaults
                    final playerProfile = Player(
                      name: applicant['name']?.toString() ?? 'Unknown Player',
                      avatar: applicant['avatar']?.toString() ?? 'assets/images/defaultprofile.png', // Default avatar
                      score: int.tryParse(applicant['score']?.toString() ?? '0') ?? 0,
                      sport: applicant['sport']?.toString() ?? 'Unknown Sport',
                      role: applicant['role']?.toString() ?? 'Unknown Role',
                      age: applicant['age']?.toString() ?? 'N/A',
                      username: applicant['username']?.toString() ?? '@unknown',
                      points: applicant['points']?.toString() ?? '0',
                      level: int.tryParse(applicant['level']?.toString() ?? '1') ?? 1,
                      team: applicant['team']?.toString() ?? 'N/A',
                      rank: 0, // Rank might not be relevant here, provide default
                      // Add other fields if required by Player model, provide defaults
                    );
                    // +++ END OF PLAYER OBJECT CREATION +++

                    return Card(
                      color: kGrey900,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        onTap: () {
                          // +++ NAVIGATE WITH PLAYER OBJECT AND FLAGS +++
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullProfilePage(
                                player: playerProfile, // Use the created Player object
                                showAddFriend: false, // Club shouldn't add friend from here
                                isViewedByClub: true, // This is the club view
                              ),
                            ),
                          );
                          // +++ END OF NAVIGATION UPDATE +++
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFF22313B),
                          backgroundImage: AssetImage(playerProfile.avatar), // Use avatar from Player object
                          // Fallback Text if image fails (optional)
                          // child: Text( ... initials logic ... ),
                        ),
                        title: Text(
                          playerProfile.name, // Use name from Player object
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),
                        ),
                        subtitle: Text(
                          playerProfile.role, // Use role from Player object
                          style: const TextStyle(color: Colors.white70, fontSize: 14,),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12),),
                          child: Text( status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14,),),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 36),
                // Edit Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _navigateToEditTrial,
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),),
                        child: const Text('Edit Trial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,),),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 120), // Spacer for floating button
              ],
            ),
          ),
          // End Trial Floating Button
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: ElevatedButton(
                onPressed: _endTrial,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),),
                child: const Text("End Trial", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}