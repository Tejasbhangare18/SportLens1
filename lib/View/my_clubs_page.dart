import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for AnnotatedRegion
import 'package:flutter_application_3/View/club_detail_page.dart';
import 'package:flutter_application_3/models/club_data.dart'; // Adjust path if needed

// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---


class MyClubsPage extends StatelessWidget {
  const MyClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- IMPORTANT: Get the ACTUAL list of joined clubs ---
    // This uses sample data. Replace with your state management.
    final List<Club> myClubs = Club.getSampleJoinedClubs(); // Use joined clubs data

     // THEME: Set status bar icons to light
    return AnnotatedRegion<SystemUiOverlayStyle>(
       value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kDarkBlue, // THEME
        appBar: AppBar(
          backgroundColor: kDarkBlue, // THEME
          elevation: 0,
          title: const Text(
              'My Clubs',
              style: TextStyle(
                  color: kNewAccentCyan, // THEME
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              )
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryText, size: 20), // THEME + Updated Icon
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true, // Center title on this page
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0), // Consistent padding
          itemCount: myClubs.length,
          itemBuilder: (context, index) {
            final club = myClubs[index];
            // Use the redesigned card
            return _MyClubListCard(club: club);
          },
        ),
      ),
    );
  }
}

/// Redesigned Card for the My Clubs page
class _MyClubListCard extends StatelessWidget {
  final Club club;
  const _MyClubListCard({required this.club});

   // Simple state simulation (you'll replace this with your actual state management)
   // Assuming items on this page are always 'joined' initially for demo
   static final Map<String, bool> _joinedState = { for (var c in Club.getSampleJoinedClubs()) c.id : true };


  @override
  Widget build(BuildContext context) {
     // Read state (or default to true for this page)
     bool isJoined = _joinedState[club.id] ?? true;

    return GestureDetector( // Make whole card tappable
       onTap: () {
          try {
             Navigator.push(context, MaterialPageRoute(builder: (context) => ClubDetailPage(club: club, isJoined: isJoined)));
          } catch(e) { print("Navigation Error: $e"); }
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // Spacing between cards
        padding: const EdgeInsets.all(12.0), // Internal padding
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(16), // Modern radius
           gradient: LinearGradient( // Glassy gradient
             colors: [ kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.6)],
             begin: Alignment.topLeft, end: Alignment.bottomRight,
           ),
           border: Border.all(color: kNewAccentCyan.withOpacity(0.15), width: 1.5), // Border glow
            boxShadow: [ // Soft shadow
                BoxShadow( color: kNewAccentCyan.withOpacity(0.05), blurRadius: 10, spreadRadius: 0),
            ],
         ),
        child: Row(
          children: [
             // Container for image with rounded corners
             ClipRRect(
                borderRadius: BorderRadius.circular(12), // Rounded corners for image
                child: Image.asset(
                   club.logoUrl,
                   width: 64, // Slightly larger
                   height: 64,
                   fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                       width: 64, height: 64, color: kDarkBlue.withOpacity(0.5),
                       child: Icon(Icons.group_work_rounded, color: kSecondaryText) // Placeholder icon
                   ),
                ),
             ),
            const SizedBox(width: 16), // Increased spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(club.name, style: const TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16)), // THEME
                  const SizedBox(height: 4),
                  Text('${club.city} • ${club.sport}', style: const TextStyle(color: kSecondaryText, fontSize: 14)), // THEME
                ],
              ),
            ),
            const SizedBox(width: 16),
             // Use Glow Button for "Leave" action
             _buildGlowButton(
                text: 'Leave',
                onPressed: () {
                   // TODO: Implement actual Leave logic using your state management
                    // This is just a HACK for visual feedback in the demo
                   (context as Element).markNeedsBuild(); // Force rebuild to show state change visually
                   _joinedState[club.id] = false; // Update local mock state
                   print('Left ${club.name}');
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Left ${club.name} (Demo)'), duration: Duration(seconds: 1)),
                   );
                    // Maybe pop back after leaving or refresh the list via state management?
                   // Navigator.of(context).pop();
                },
                isPrimary: false, // Use secondary style
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding
                fontSize: 13, // Smaller font size
                icon: Icons.exit_to_app_rounded, // Example icon
                colorOverride: Colors.redAccent.withOpacity(0.8), // Use Red accent for Leave
                borderColorOverride: Colors.redAccent.withOpacity(0.5), // Red border
             ),
          ],
        ),
      ),
    );
  }

   // --- Reusable Glow Button Helper ---
   // (Copied from previous examples, added color overrides)
   Widget _buildGlowButton({
      required String text,
      required VoidCallback onPressed,
      IconData? icon,
      bool isPrimary = false,
      EdgeInsetsGeometry? padding,
      double? fontSize,
      Color? colorOverride, // Allow overriding the main color (e.g., for Leave button)
      Color? borderColorOverride, // Allow overriding border color
      }) {
      final Color primaryColor = colorOverride ?? kNewAccentCyan;
      final Color secondaryColor = isPrimary ? kDarkBlue : kPrimaryText;
      final Color borderColor = borderColorOverride ?? primaryColor.withOpacity(0.5);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? primaryColor : Colors.transparent,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isPrimary
                  ? BorderSide.none
                  : BorderSide(color: borderColor, width: 1.5),
            ),
            shadowColor: Colors.transparent,
             elevation: 0,
             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(icon != null) Icon(icon, color: secondaryColor, size: (fontSize ?? 16) + 4),
              if(icon != null) const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
}