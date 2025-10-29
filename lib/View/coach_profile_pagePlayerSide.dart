import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for AnnotatedRegion
import 'package:flutter_application_3/models/coach_data.dart'; // Import your Coach model
import 'chat_page.dart';

// Assuming these pages exist for navigation placeholders
// import 'record_performance_page.dart';

// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---

class CoachProfilePage extends StatelessWidget {
  final Coach coach;
  final bool isFollowing; // Already added this parameter

  const CoachProfilePage({
    super.key,
    required this.coach,
    required this.isFollowing, // Make sure it's passed during navigation
  });

  @override
  Widget build(BuildContext context) {
    // Determine tabs dynamically
    final int tabCount = isFollowing ? 4 : 3;
    final List<Widget> tabs = [
      const Tab(text: 'About'),
      if (isFollowing) const Tab(text: 'Drills'), // Conditionally add Drills
      const Tab(text: 'Videos'),
      const Tab(text: 'Players Trained'),
    ];
    final List<Widget> tabViews = [
       _buildAboutTab(context),
       if (isFollowing) _buildDrillsTab(context), // Conditionally add Drills View
       _buildVideosTab(context),
       _buildPlayersTrainedTab(context),
    ];

     // THEME: Set status bar icons to light
    return AnnotatedRegion<SystemUiOverlayStyle>(
       value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: DefaultTabController(
        length: tabCount, // Use dynamic length
        child: Scaffold(
          backgroundColor: kDarkBlue, // THEME
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: kDarkBlue, // THEME
                expandedHeight: 280, // Slightly more height
                pinned: true,
                stretch: true, // Allow stretch effect
                leading: IconButton(
                   icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryText, size: 20), // Updated Icon
                   onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 72, bottom: 16 + 48), // Adjust padding for centered title below avatar
                  // Center title text below avatar when collapsed
                  centerTitle: false, // Keep title left-aligned when expanded
                   title: Text(
                     coach.name,
                     style: const TextStyle(
                       fontSize: 20, // Larger title
                       color: kPrimaryText, // THEME
                       fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0,1))] // Text shadow
                       )
                    ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                       // Banner Image with blend
                       Image.asset(
                          coach.bannerImageUrl,
                          fit: BoxFit.cover,
                           color: kDarkBlue.withOpacity(0.4), // Blend effect
                          colorBlendMode: BlendMode.darken,
                           errorBuilder: (context, error, stackTrace) => Container(color: kFieldColor),
                        ),
                        // Darker Gradient Overlay
                         Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, kDarkBlue.withOpacity(0.9)], // Darker fade
                              stops: const [0.5, 1.0] // Gradient stops
                            ),
                          ),
                        ),
                        // Positioned Avatar with Glow
                        Positioned(
                          bottom: 16 + 48, // Position above the TabBar (TabBar height ~48 + padding)
                          left: 16,
                          child: Container(
                             decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: kDarkBlue, width: 3), // Border to lift avatar
                                boxShadow: [ // Glow effect
                                   BoxShadow(
                                      color: kNewAccentCyan.withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                   )
                                ]
                             ),
                            child: CircleAvatar(
                               radius: 40,
                               backgroundImage: AssetImage(coach.profileImageUrl),
                               backgroundColor: kFieldColor,
                            ),
                          )
                        )
                    ],
                  ),
                ),
                 // Redesigned TabBar
                bottom: TabBar(
                   tabs: tabs, // Use dynamic list
                   isScrollable: true, // Allow scrolling if many tabs
                   indicatorColor: kNewAccentCyan, // THEME
                   indicatorWeight: 3.0,
                   labelColor: kNewAccentCyan, // THEME - Highlight selected label
                   unselectedLabelColor: kSecondaryText, // THEME
                   labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                   unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                   padding: const EdgeInsets.symmetric(horizontal: 16), // Padding for tabs
                   indicatorPadding: const EdgeInsets.symmetric(horizontal: 4), // Padding for indicator
                   labelPadding: const EdgeInsets.symmetric(horizontal: 20), // Space between tab labels
                ),
              ),
              // TabBarView wrapped in SliverFillRemaining
              SliverFillRemaining(
                // hasScrollBody: false, // Important if TabBarView children are scrollable themselves
                child: TabBarView(
                   children: tabViews, // Use dynamic list
                ),
              )
            ],
          ),
          // Redesigned Bottom Chat Button Area
          bottomNavigationBar: Container(
             padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 30.0), // Adjust padding
             decoration: BoxDecoration( // Add gradient fade for smooth transition
               gradient: LinearGradient(
                 colors: [kDarkBlue.withOpacity(0.0), kDarkBlue.withOpacity(0.9), kDarkBlue],
                 stops: const [0.0, 0.3, 1.0],
                 begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
               ),
             ),
             child: _buildGlowButton( // Use Glow Button
                icon: Icons.chat_bubble_outline_rounded,
                text: 'Chat with ${coach.name.split(' ')[0]}',
           onPressed: () {
             // Navigate to the chat page and pass the coach name
             Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatPage(coachName: coach.name)));
           },
                isPrimary: true, // Make it the primary action button
             ),
          ),
        ),
      ),
    );
  }

  // --- Tab Builders ---

  Widget _buildAboutTab(BuildContext context) {
    // Improved styling and structure
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20), // Consistent padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Coach Details', style: TextStyle(color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.sports_basketball_outlined, 'Sport', coach.sport), // Example Icon
          _buildInfoRow(Icons.star_border_rounded, 'Rating', '${coach.rating} ⭐'),
          _buildInfoRow(Icons.timeline_rounded, 'Experience', coach.experience),
          _buildInfoRow(Icons.track_changes_rounded, 'Specialization', coach.specialization),
          const SizedBox(height: 24),
          Text('Bio', style: TextStyle(color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            coach.id, // Use coach.bio or provide default
            style: const TextStyle(color: kSecondaryText, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

   Widget _buildInfoRow(IconData icon, String label, String value) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 12.0),
       child: Row(
         children: [
           Icon(icon, color: kNewAccentCyan, size: 20),
           const SizedBox(width: 12),
           Text('$label:', style: const TextStyle(color: kSecondaryText, fontSize: 16)),
           const SizedBox(width: 8),
           Expanded(child: Text(value, style: const TextStyle(color: kPrimaryText, fontSize: 16, fontWeight: FontWeight.w600))),
         ],
       ),
     );
   }

   Widget _buildDrillsTab(BuildContext context) {
    // This will now only be built if the user IS following the coach
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Consistent padding
       itemCount: 5, // Example count
       itemBuilder: (context, index) {
          // Use the Glassy List Item builder
          return _buildGlassyListItem(
            title: 'Drill #${index + 1}',
            subtitle: 'Description for Drill ${index + 1}',
            leadingIcon: Icons.fitness_center_rounded, // Updated icon
            onTap: () {
                 print('Tapped Drill ${index+1}');
                 // TODO: Maybe navigate to the drill detail page?
            }
          );
       },
    );
  }

   Widget _buildVideosTab(BuildContext context) {
    // Redesigned GridView items
    return GridView.builder(
        padding: const EdgeInsets.all(16), // Consistent padding
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16, // Increased spacing
          mainAxisSpacing: 16,  // Increased spacing
          childAspectRatio: 16/10, // Adjust aspect ratio slightly
        ),
        itemCount: 6, // Example count
        itemBuilder: (context, index) {
          return _buildVideoGridItem(index); // Use helper widget
        },
    );
  }

   /// Helper for Video Grid Item with Glassy Glow
   Widget _buildVideoGridItem(int index) {
       return GestureDetector(
         onTap: () => print('Tapped Video ${index+1}'),
         child: Container(
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
           child: Stack( // Use stack for overlay icon
             fit: StackFit.expand,
              children: [
                // TODO: Add actual video thumbnail image here
                // Image.asset(...)
                 Center(
                   child: Icon(
                     Icons.play_circle_outline_rounded, // Updated icon
                     color: kSecondaryText.withOpacity(0.8), // THEME
                     size: 44 // Larger icon
                    ),
                 ),
                 // Optional: Add video title overlay if needed
                 Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Text(
                       'Video Title ${index+1}',
                       style: const TextStyle(color: kPrimaryText, fontSize: 13, fontWeight: FontWeight.w500),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                    ),
                 )
              ],
           ),
         ),
       );
   }

    Widget _buildPlayersTrainedTab(BuildContext context) {
     return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Consistent padding
       itemCount: 8, // Example count
       itemBuilder: (context, index) {
           // Use the Glassy List Item builder
          return _buildGlassyListItem(
            title: 'Player Name ${index + 1}',
            subtitle: 'Achievement/Level ${index + 1}',
            leadingWidget: CircleAvatar( // Use CircleAvatar directly
                radius: 24, // Consistent size
                backgroundColor: kFieldColor.withOpacity(0.9),
                child: Icon(Icons.person_outline_rounded, color: kSecondaryText) // Updated icon
            ),
            onTap: () {
                 print('Tapped Player ${index+1}');
                 // TODO: Maybe navigate to player profile?
            }
          );
       },
    );
  }

   /// Helper Widget for Glassy List Items (Drills, Players)
   Widget _buildGlassyListItem({
      required String title,
      String? subtitle,
      IconData? leadingIcon,
      Widget? leadingWidget, // Allow custom leading widget (like Avatar)
      required VoidCallback onTap,
   }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Consistent padding
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
              leadingWidget ?? Icon(leadingIcon ?? Icons.info_outline, color: kNewAccentCyan, size: 24), // Use custom widget or icon
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: kPrimaryText, fontSize: 16, fontWeight: FontWeight.w600)),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: kSecondaryText, fontSize: 14)),
                    ]
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: kSecondaryText, size: 24), // Updated icon
            ],
          ),
        ),
      );
   }

   /// Reusable Glow Button Helper (copied from previous examples)
    Widget _buildGlowButton({
      required String text,
      required VoidCallback onPressed,
      IconData? icon,
      bool isPrimary = false,
      EdgeInsetsGeometry? padding,
      double? fontSize
      }) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Match chat button shape
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: kNewAccentCyan.withOpacity(0.4),
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
            backgroundColor: isPrimary ? kNewAccentCyan : Colors.transparent,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 14), // Default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Match chat button shape
              side: isPrimary
                  ? BorderSide.none
                  : BorderSide(color: kNewAccentCyan.withOpacity(0.5), width: 1.5),
            ),
            shadowColor: Colors.transparent,
             elevation: 0,
             // tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Can make tap area small
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Fit content unless expanded
            children: [
              if(icon != null) Icon(icon, color: isPrimary ? kDarkBlue : kPrimaryText, size: (fontSize ?? 16) + 4), // Icon size based on font
              if(icon != null) const SizedBox(width: 10), // Increased spacing
              Text(
                text,
                style: TextStyle(
                  color: isPrimary ? kDarkBlue : kPrimaryText, // THEME
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 16, // Use default or custom font size
                ),
              ),
            ],
          ),
        ),
      );
    }
} // End of CoachProfilePage StatelessWidget (Helper functions remain)