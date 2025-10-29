// lib/View/followed_coaches_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for AnnotatedRegion
import 'package:flutter_application_3/models/coach_data.dart'; // Adjust path if needed
import 'package:flutter_application_3/View/coach_profile_pagePlayerSide.dart'; // Adjust path if needed

// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---


class FollowedCoachesPage extends StatelessWidget {
  const FollowedCoachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- IMPORTANT: Get the ACTUAL list of followed coaches ---
    // This uses sample data for now. Replace with your state management logic.
    final List<Coach> followedCoaches = Coach.getSampleFollowedCoaches(); // Use followed coaches data

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
              'My Coaches',
               style: TextStyle(
                  color: kNewAccentCyan, // THEME
                  fontWeight: FontWeight.bold,
                  fontSize: 22
               )
          ),
          leading: IconButton( // Back button
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryText, size: 20), // THEME + Updated Icon
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true, // Center title on this page
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0), // Consistent padding
          itemCount: followedCoaches.length,
          itemBuilder: (context, index) {
            final coach = followedCoaches[index];
            // Use the redesigned card
            return _FollowedCoachListCard(coach: coach);
          },
        ),
      ),
    );
  }
}

// --- Redesigned Card Widget for Followed Coaches ---
class _FollowedCoachListCard extends StatelessWidget {
  final Coach coach;
  const _FollowedCoachListCard({required this.coach});

   // TODO: If you add unfollow functionality directly here, manage state appropriately
   // static final Map<String, bool> _followingState = { for (var c in Coach.getSampleFollowedCoaches()) c.id : true };


  @override
  Widget build(BuildContext context) {
    // Since this page ONLY shows followed coaches, we assume true
    const bool isFollowing = true;
     // bool isFollowing = _followingState[coach.id] ?? true; // Example if state is managed here

    return GestureDetector( // Make the whole card tappable
       onTap: () {
          try {
             Navigator.push(
               context,
               // Pass the known following status
               MaterialPageRoute(builder: (context) => CoachProfilePage(coach: coach, isFollowing: isFollowing)),
             );
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
            CircleAvatar(
              radius: 30, // Slightly larger
              backgroundImage: AssetImage(coach.profileImageUrl),
              backgroundColor: kDarkBlue, // Background color for image loading
            ),
            const SizedBox(width: 16), // Increased spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coach.name, style: const TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16)), // THEME
                  const SizedBox(height: 4), // Consistent spacing
                  Text(coach.sport, style: const TextStyle(color: kSecondaryText, fontSize: 14)), // THEME
                  const SizedBox(height: 4),
                  Text(coach.experience, style: TextStyle(color: kSecondaryText.withOpacity(0.8), fontSize: 13)), // THEME
                ],
              ),
            ),
            const SizedBox(width: 12),
             // Use Glow Button for "Following" (or "Unfollow")
             _buildGlowButton(
                text: 'Following', // Or dynamically change to 'Unfollow'
                onPressed: () {
                   // TODO: Implement Unfollow logic using proper state management
                   // Example: Call a provider method, update state, show confirmation
                   print('Unfollow tapped for ${coach.name}');
                    ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Unfollow action for ${coach.name} (TODO)'), duration: Duration(seconds: 1)),
                   );
                   // If managing state here (not recommended for real apps):
                   // (context as Element).markNeedsBuild();
                   // _followingState[coach.id] = false;
                   // Maybe pop back or refresh list via provider/bloc
                },
                isPrimary: false, // Use secondary style for 'Following'
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // Adjust padding
                fontSize: 13, // Smaller font size
                icon: Icons.check_circle_outline_rounded // Example icon
             ),
          ],
        ),
      ),
    );
  }

   // --- Reusable Glow Button Helper ---
   // (Copied from previous examples)
   Widget _buildGlowButton({
      required String text,
      required VoidCallback onPressed,
      IconData? icon,
      bool isPrimary = false,
      EdgeInsetsGeometry? padding,
      double? fontSize,
      Color? colorOverride,
      Color? borderColorOverride,
      }) {
      final Color primaryColor = colorOverride ?? kNewAccentCyan;
      final Color secondaryColor = isPrimary ? kDarkBlue : (colorOverride ?? kPrimaryText);
      final Color borderColor = borderColorOverride ?? primaryColor.withOpacity(0.5);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isPrimary && colorOverride == null // Only show shadow for default primary
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