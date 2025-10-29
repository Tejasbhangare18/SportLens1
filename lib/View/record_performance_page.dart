import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for AnnotatedRegion
 // Make sure you have this file in your project

// --- UI Constants for consistent styling (as provided) ---
const Color kDarkBlue = Color(0xFF0D1B2A);
const Color kCardOverlay = Color(0xFF1B263B);
const Color kAccentBlue = Color(0xFF00A8E8); // Although named kAccentBlue, it's the cyan color
const Color kTextWhite = Colors.white;
const Color kTextSecondary = Colors.white70;

// --- CHANGED: Converted to StatefulWidget ---
class RecordPerformancePage extends StatefulWidget {
  const RecordPerformancePage({super.key});

  @override
  State<RecordPerformancePage> createState() => _RecordPerformancePageState();
}

// --- CHANGED: Added State class with SingleTickerProviderStateMixin ---
class _RecordPerformancePageState extends State<RecordPerformancePage> with SingleTickerProviderStateMixin {

  // --- Animation Controller and Animations ---
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation1, _fadeAnimation2, _fadeAnimation3;
  late Animation<Offset> _slideAnimation1, _slideAnimation2, _slideAnimation3;
  // ---

   @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900), // Adjust duration as needed
    );

    // Staggered Animations (Fade + Slide Up)
    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut)), // Start early
    );
    _slideAnimation1 = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOut)), // Start slightly later
    );
     _slideAnimation2 = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
    );


    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)), // Start latest
    );
     _slideAnimation3 = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    _animationController.forward(); // Start animation on page load
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose controller
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
     // Keep status bar light
     return AnnotatedRegion<SystemUiOverlayStyle>(
       value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
       child: Scaffold(
         backgroundColor: kDarkBlue, // Original Color
         appBar: AppBar(
           backgroundColor: Colors.transparent, // Original Style
           elevation: 0,
           centerTitle: true,
           leading: IconButton(
             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), // Original Style
             onPressed: () => Navigator.pop(context),
           ),
           title: const Text(
             'Record Performance',
             style: TextStyle(
               color: kTextWhite, // Original Color
               fontWeight: FontWeight.bold,
               fontSize: 20,
             ),
           ),
         ),
         body: Padding(
           padding: const EdgeInsets.all(20.0),
           child: SingleChildScrollView( // Keep scrollable
             child: Column(
               children: [
                 const SizedBox(height: 10),

                 // --- CHANGED: Wrapped Record New Video in Animations ---
                 FadeTransition(
                   opacity: _fadeAnimation1,
                   child: SlideTransition(
                     position: _slideAnimation1,
                     child: _buildOptionCard( // Original Card Call
                       context,
                       icon: Icons.videocam_rounded,
                       title: 'Record New Video',
                       subtitle: 'Start a new recording session',
                       imagePath: 'assets/record_bg.png', // Ensure this asset exists
                       onTap: () {
                         // TODO: Handle record video action
                          ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Record Video Tapped (TODO)'), duration: Duration(seconds: 1)),
                           );
                       },
                     ),
                   ),
                 ),
                 const SizedBox(height: 20),

                 // --- CHANGED: Wrapped Upload Existing Video in Animations ---
                 FadeTransition(
                   opacity: _fadeAnimation2,
                   child: SlideTransition(
                     position: _slideAnimation2,
                     child: _buildOptionCard( // Original Card Call
                       context,
                       icon: Icons.upload_file_rounded,
                       title: 'Upload Existing Video',
                       subtitle: 'Select a video from your gallery',
                       imagePath: 'assets/upload_bg.png', // Ensure this asset exists
                       onTap: () {
                         // TODO: Handle upload video action
                          ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Upload Video Tapped (TODO)'), duration: Duration(seconds: 1)),
                           );
                       },
                     ),
                   ),
                 ),
                 const SizedBox(height: 25),

                 // --- CHANGED: Wrapped Pro Tip Card in Animations ---
                 FadeTransition(
                   opacity: _fadeAnimation3,
                   child: SlideTransition(
                     position: _slideAnimation3,
                     child: _buildProTipCard(), // Original Card Call
                   ),
                 ),
                  const SizedBox(height: 20), // Bottom padding
               ],
             ),
           ),
         ),
       ),
     );
  }

  /// --- Original option card (No UI changes) ---
  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: kAccentBlue.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.darken,
            ),
             onError:(exception, stackTrace) { // Handle image errors
                 print("Error loading image: $imagePath");
             },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Glowing circular icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [kAccentBlue, Color(0xFF0077B6)], // Original Gradient
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kAccentBlue.withOpacity(0.6), // Original Shadow
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26), // Original Icon Style
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: kTextWhite, // Original Color
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: kTextSecondary, // Original Color
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --- Original Pro Tip card (No UI changes) ---
  Widget _buildProTipCard() {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kCardOverlay.withOpacity(0.9), // Original Color
        border: Border.all(color: kAccentBlue.withOpacity(0.3)), // Original Border
        boxShadow: [
          BoxShadow(
            color: kAccentBlue.withOpacity(0.25), // Original Shadow
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: kAccentBlue, // Original Color
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 26), // Original Style
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pro Tip',
                  style: TextStyle(
                    color: kTextWhite, // Original Color
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Ensure your full body is visible in the frame for the best analysis results.',
                  style: TextStyle(
                    color: kTextSecondary, // Original Color
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}