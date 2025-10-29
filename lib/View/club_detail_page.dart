import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for AnnotatedRegion
import 'package:flutter_application_3/models/club_data.dart'; // Adjust path if needed

// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---

class ClubDetailPage extends StatelessWidget {
  final Club club;
  final bool isJoined; // Keep track if the user is already a member

  const ClubDetailPage({super.key, required this.club, this.isJoined = false});

  @override
  Widget build(BuildContext context) {
    // THEME: Set status bar icons to light
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: DefaultTabController(
        length: 4, // Overview | Challenges | Trials | Members
        child: Scaffold(
          backgroundColor: kDarkBlue, // THEME
          body: NestedScrollView( // Allows AppBar to collapse with scrollable tabs
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: kDarkBlue, // THEME
                expandedHeight: 250, // Increased Height for banner + info
                pinned: true, // Keep tabs visible
                stretch: true, // Allow stretch effect
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryText, size: 20), // Updated Icon
                  onPressed: () => Navigator.of(context).pop(),
                ),
                 flexibleSpace: FlexibleSpaceBar(
                   // title: Text(club.name, style: TextStyle(color: Colors.white)), // Removed title from here
                    titlePadding: EdgeInsets.zero, // Remove default padding
                    centerTitle: false,
                   background: Stack(
                     fit: StackFit.expand,
                     children: [
                       // Banner Image with blend
                       Image.asset(
                         club.bannerUrl, fit: BoxFit.cover,
                         color: kDarkBlue.withOpacity(0.5), // Blend effect
                         colorBlendMode: BlendMode.darken,
                         errorBuilder: (ctx, err, st) => Container(color: kFieldColor),
                       ),
                       // Darker Gradient Overlay for contrast
                       Container(
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topCenter,
                             end: Alignment.bottomCenter,
                             colors: [Colors.transparent, kDarkBlue.withOpacity(0.95), kDarkBlue], // Fade to dark blue
                             stops: const [0.4, 0.8, 1.0] // Adjust stops for gradient
                           )
                         ),
                       ),
                       // Club Logo & Name positioned lower
                       Positioned(
                         bottom: 65, // Position above the TabBar
                         left: 16,
                         right: 16, // Allow name to take space
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
                           children: [
                             // Logo Container
                             Container(
                               padding: const EdgeInsets.all(4), // White border effect
                               decoration: BoxDecoration(
                                 color: kFieldColor.withOpacity(0.5), // Semi-transparent border bg
                                 borderRadius: BorderRadius.circular(16), // Rounded border bg
                                 border: Border.all(color: kSecondaryText.withOpacity(0.5), width: 1)
                               ),
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(12), // Rounded logo corners
                                 child: Image.asset(club.logoUrl, width: 64, height: 64, fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, st) => Container(width: 64, height: 64, color: kFieldColor, child: Icon(Icons.shield_outlined, color: kSecondaryText)),
                                 ),
                               ),
                             ),
                             const SizedBox(width: 16),
                             // Club Name Text (Expanded to wrap)
                             Expanded(
                               child: Text(
                                 club.name,
                                 style: const TextStyle(
                                   color: kPrimaryText, // THEME
                                   fontSize: 24, // Larger font
                                   fontWeight: FontWeight.bold,
                                   shadows: [Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(0,1))] // Text shadow
                                 ),
                                 overflow: TextOverflow.ellipsis,
                                 maxLines: 2, // Allow wrapping
                               ),
                             )
                           ],
                         )
                       ),
                     ],
                   )
                 ),
                 // Redesigned TabBar
                bottom: TabBar(
                   isScrollable: true,
                   indicatorColor: kNewAccentCyan, // THEME
                   indicatorWeight: 3.0,
                   labelColor: kNewAccentCyan, // THEME - Highlight selected label
                   unselectedLabelColor: kSecondaryText, // THEME
                   labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                   unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                   padding: const EdgeInsets.symmetric(horizontal: 16), // Padding for tabs container
                   indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
                   labelPadding: const EdgeInsets.symmetric(horizontal: 20), // Space between tab labels
                   tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Challenges'),
                      Tab(text: 'Trials'),
                      Tab(text: 'Members'),
                   ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
                _buildOverviewTab(context),
                _buildChallengesTab(context),
                _buildTrialsTab(context),
                _buildMembersTab(context),
              ],
            ),
          ),
           // Use the redesigned Bottom Action Button
            bottomNavigationBar: _buildBottomActionButton(context),
        ),
      ),
    );
  }

 // --- Tab Builders ---

  /// Redesigned Overview Tab
  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20), // Consistent padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Row using helper
          _buildInfoRow(Icons.location_city_outlined, 'Location', club.city),
          _buildInfoRow(Icons.sports_soccer_outlined, 'Sport', club.sport), // Example sport icon
          _buildInfoRow(Icons.group_outlined, 'Members', '${club.followers}'), // Just the number, label clarifies

           const SizedBox(height: 24), // Increased spacing
           const Text('Description', style: TextStyle(color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold)), // THEME + Size
           const SizedBox(height: 12),
           Text(
             club.description ?? 'Club mission, vision, and focus on ${club.sport}. This club operates in ${club.city} and welcomes players of various skill levels. Join us for regular practice sessions and competitive matches.', // Use club.description or default
             style: const TextStyle(color: kSecondaryText, fontSize: 16, height: 1.5), // THEME + Size + Line Height
           ),
           const SizedBox(height: 32), // More spacing before button if shown

           // Join button is now potentially in the bottomNavigationBar
           // Keep logic here if button should ONLY appear in this tab when not joined AND no bottom bar is used
           // if (!isJoined && _buildBottomActionButton(context) == null) // Example condition
           //    SizedBox(
           //      width: double.infinity,
           //      child: _buildGlowButton(
           //         text: 'Join Club',
           //         onPressed: () { /* TODO: Implement Join/Leave logic */ },
           //         isPrimary: true,
           //         icon: Icons.add_rounded
           //      ),
           //    )
        ],
      ),
    );
  }

  /// Helper for Info Rows in Overview
   Widget _buildInfoRow(IconData icon, String label, String value) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 12.0),
       child: Row(
         children: [
           Icon(icon, color: kNewAccentCyan, size: 20), // THEME
           const SizedBox(width: 12),
           Text('$label:', style: const TextStyle(color: kSecondaryText, fontSize: 16)), // THEME
           const SizedBox(width: 8),
           Expanded(child: Text(value, style: const TextStyle(color: kPrimaryText, fontSize: 16, fontWeight: FontWeight.w600))), // THEME
         ],
       ),
     );
   }

  /// Redesigned Challenges Tab
   Widget _buildChallengesTab(BuildContext context) {
    // Show "Join to see" placeholder if not joined
    if (!isJoined) {
      return Center(
        child: Container( // Wrap in glassy container
           margin: const EdgeInsets.all(24.0),
           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20),
             gradient: LinearGradient( colors: [ kFieldColor.withOpacity(0.9), kFieldColor.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
             border: Border.all(color: kNewAccentCyan.withOpacity(0.2), width: 1.5),
             boxShadow: [ BoxShadow( color: kNewAccentCyan.withOpacity(0.08), blurRadius: 12, spreadRadius: 1)],
           ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded, color: kSecondaryText, size: 48), // Updated icon
              const SizedBox(height: 16),
              const Text(
                  'Join the club to see and participate in its challenges',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kSecondaryText, fontSize: 16, height: 1.4) // THEME
              ),
              const SizedBox(height: 20),
              // Use Glow Button
              _buildGlowButton(
                 text: 'Join Club',
                 isPrimary: true,
                 icon: Icons.add_rounded,
                 onPressed: () { /* TODO: Implement Join/Leave logic via callback or state */
                    print('Join Club Tapped from Placeholder');
                 },
                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                 fontSize: 15,
              )
            ],
          ),
        ),
      );
    }

    // User is a member: show the list of challenges
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Consistent padding
      itemCount: 4, // Example count
      itemBuilder: (context, index) {
          // Use Glassy List Item
          return _buildGlassyListItem(
             title: 'Challenge #${index+1}: Skill Test',
             subtitle: 'Status: Ongoing - Ends in 3 days',
             leadingIcon: Icons.emoji_events_outlined, // Example icon
             trailingWidget: _buildGlowButton( // Button as trailing widget
                text: 'View', // Changed from 'Join'
                onPressed: (){ print("View Challenge ${index+1}");},
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                fontSize: 13,
                isPrimary: false, // Secondary style
             ),
             onTap: (){ print("Tapped Challenge ${index+1}"); } // Tapping item also works
          );
       }
    );
  }

  /// Redesigned Trials Tab
   Widget _buildTrialsTab(BuildContext context) {
     // Replace with actual trial data
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Consistent padding
      itemCount: 2, // Example count
      itemBuilder: (context, index) {
          // Use Glassy List Item
          return _buildGlassyListItem(
             title: 'U18 Tryout - ${DateTime.now().add(Duration(days: index*7)).toLocal().toString().split(' ')[0]}',
             subtitle: 'Location: Main Ground | Arrive by 9 AM',
             leadingIcon: Icons.calendar_today_outlined, // Example icon
             trailingWidget: _buildGlowButton( // Button as trailing widget
                text: 'Apply',
                onPressed: (){ print("Apply Trial ${index+1}");},
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                fontSize: 13,
                isPrimary: true, // Primary style for Apply
             ),
             onTap: (){ print("Tapped Trial ${index+1}"); }
          );
       }
    );
  }

  /// Redesigned Members Tab
    Widget _buildMembersTab(BuildContext context) {
      // Replace with actual member data
     return GridView.builder(
        padding: const EdgeInsets.all(16), // Consistent padding
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Grid for member avatars
          crossAxisSpacing: 16, // Increased spacing
          mainAxisSpacing: 16,  // Increased spacing
          childAspectRatio: 0.8, // Adjust aspect ratio for text below avatar
        ),
        itemCount: 15, // Example count
        itemBuilder: (context, index) {
          // Wrap each item in a glassy container
          return Container(
            padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
               gradient: LinearGradient( colors: [ kFieldColor.withOpacity(0.8), kFieldColor.withOpacity(0.5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
               border: Border.all(color: kNewAccentCyan.withOpacity(0.1), width: 1),
                boxShadow: [ // Optional: very subtle shadow for depth
                    BoxShadow( color: kDarkBlue.withOpacity(0.2), blurRadius: 4, spreadRadius: 0),
                ],
             ),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
               mainAxisSize: MainAxisSize.min,
               children: [
                  CircleAvatar(
                     radius: 28, // Slightly larger
                     backgroundColor: kDarkBlue.withOpacity(0.5), // Background
                      // backgroundImage: AssetImage('path/to/member_avatar_${index+1}.png'), // TODO: Add actual avatars
                     child: Text('P${index+1}', style: const TextStyle(color: kSecondaryText, fontWeight: FontWeight.bold)), // Placeholder
                  ),
                  const SizedBox(height: 8), // Increased spacing
                  Text(
                    'Player ${index+1}',
                    style: const TextStyle(color: kSecondaryText, fontSize: 11), // THEME
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  )
               ],
            ),
          );
        }
    );
  }

   /// Helper Widget for Glassy List Items (Used in Drills, Trials, etc.)
   Widget _buildGlassyListItem({
      required String title,
      String? subtitle,
      IconData? leadingIcon,
      Widget? leadingWidget, // Allow custom leading widget (like Avatar)
      Widget? trailingWidget, // Allow custom trailing widget (like Button)
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
              leadingWidget ?? Icon(leadingIcon ?? Icons.info_outline_rounded, color: kNewAccentCyan, size: 24), // Use custom widget or icon
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
               if (trailingWidget != null) const SizedBox(width: 12), // Space before trailing
              if (trailingWidget != null) trailingWidget else const Icon(Icons.chevron_right_rounded, color: kSecondaryText, size: 24), // Default trailing or custom
            ],
          ),
        ),
      );
   }

  /// Optional Bottom Action Button (Join/Leave/Chat etc.)
  Widget _buildBottomActionButton(BuildContext context) {
    // Determine button text, action, style based on join status
    final String buttonText = isJoined ? 'Leave Club' : 'Join Club';
    final IconData buttonIcon = isJoined ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded;
    final bool isPrimaryAction = !isJoined; // "Join" is primary, "Leave" is secondary (or warning)
     final Color? colorOverride = isJoined ? Colors.redAccent.withOpacity(0.8) : null; // Red for leave
     final Color? borderColorOverride = isJoined ? Colors.redAccent.withOpacity(0.5) : null;

    return Container(
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
          text: buttonText,
          onPressed: () {
             // TODO: Implement Join/Leave logic using setState or provider
             print(isJoined ? 'Leave Club Tapped' : 'Join Club Tapped');
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('${isJoined ? 'Leave' : 'Join'} Club action (TODO)')),
             );
              // Example state change (requires StatefulWidget if managed locally)
             // setState(() { isJoined = !isJoined; });
          },
          isPrimary: isPrimaryAction,
          icon: buttonIcon,
          colorOverride: colorOverride, // Pass color override for Leave
          borderColorOverride: borderColorOverride, // Pass border override for Leave
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
      double? fontSize,
      Color? colorOverride, // Allow overriding the main color (e.g., for Leave button)
      Color? borderColorOverride, // Allow overriding border color
      }) {
      final Color primaryColor = colorOverride ?? kNewAccentCyan;
      final Color secondaryColor = isPrimary ? kDarkBlue : (colorOverride ?? kPrimaryText); // Use override for text if provided
      final Color borderColor = borderColorOverride ?? primaryColor.withOpacity(0.5);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // Consistent radius
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
            padding: padding ?? const EdgeInsets.symmetric(vertical: 14), // Default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Consistent radius
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
            mainAxisSize: MainAxisSize.min, // Fit content unless expanded
            children: [
              if(icon != null) Icon(icon, color: secondaryColor, size: (fontSize ?? 16) + 4), // Icon size based on font
              if(icon != null) const SizedBox(width: 10), // Increased spacing
              Text(
                text,
                style: TextStyle(
                  color: secondaryColor, // Use determined secondary color
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 16, // Use default or custom font size
                ),
              ),
            ],
          ),
        ),
      );
    }

} // End of ClubDetailPage StatelessWidget