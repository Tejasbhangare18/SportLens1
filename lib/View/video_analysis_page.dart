import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for AnnotatedRegion
import 'package:flutter_application_3/View/record_performance_page.dart'; // Make sure you have this file in your project


// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---


// --- The UI is now inside the VideoAnalysisPage widget ---
class VideoAnalysisPage extends StatefulWidget {
  final String? initialSelected;
  const VideoAnalysisPage({super.key, this.initialSelected});

  @override
  State<VideoAnalysisPage> createState() => _VideoAnalysisPageState();
}

class _VideoAnalysisPageState extends State<VideoAnalysisPage> {
  // --- List of players for the dropdown ---
  final List<String> _players = ['Mike Trout', 'Shohei Ohtani', 'Mookie Betts'];
  String? _selectedPlayer;

  @override
  void initState() {
    super.initState();
    // --- Set the default selected player ---
    // Add initialSelected to the list if it's not already there and not null/empty
    if (widget.initialSelected != null && widget.initialSelected!.isNotEmpty) {
      if (!_players.contains(widget.initialSelected)) {
        _players.insert(0, widget.initialSelected!);
      }
      _selectedPlayer = widget.initialSelected;
    } else if (_players.isNotEmpty) {
      // Select the first player if no initial selection is provided
      _selectedPlayer = _players.first;
    }
    // If _players is empty and no initialSelected, _selectedPlayer remains null
  }


  @override
  Widget build(BuildContext context) {
     // THEME: Set status bar icons to light for dark background
    return AnnotatedRegion<SystemUiOverlayStyle>(
       value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent, // For iOS
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.dark, // For iOS
      ),
      child: Scaffold(
        backgroundColor: kDarkBlue, // THEME
        appBar: AppBar(
          backgroundColor: kDarkBlue, // THEME
          elevation: 0,
          leading: const BackButton(color: kPrimaryText), // THEME
          centerTitle: true, // Center title
          title: const Text(
            'Compare with Pro',
            style: TextStyle(
                color: kNewAccentCyan, // THEME
                fontWeight: FontWeight.bold,
                fontSize: 22
            )
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Consistent padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildVideoPlayerPlaceholder(),
                const SizedBox(height: 32), // Increased spacing
                Text('Compare With', style: TextStyle(color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold)), // Larger title
                const SizedBox(height: 16), // Increased spacing
                _buildDropdown(),
                const SizedBox(height: 32), // Increased spacing
                Text('Metric Comparison', style: TextStyle(color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold)), // Larger title
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildScoreCard('Player', '85'),
                    const SizedBox(width: 16),
                    // Ensure _selectedPlayer has a fallback if null (though initState should prevent this)
                    _buildScoreCard(_selectedPlayer ?? 'Pro', '92'),
                  ],
                ),
                const SizedBox(height: 24), // Increased spacing
                _buildStatRow('Bat Speed', 85),
                _buildStatRow('Elbow Angle', 78),
                _buildStatRow('Reaction Time', 92),
                _buildStatRow('Swing Path', 88),
                const SizedBox(height: 32), // Increased spacing
                Text('AI Feedback', style: TextStyle(color: kPrimaryText, fontSize: 20, fontWeight: FontWeight.bold)), // Larger title
                const SizedBox(height: 12), // Increased spacing
                const Text(
                  'Your bat speed is slightly lower than Mike Trout\'s, and your elbow angle could be more consistent. However, your reaction time is commendable. Focus on refining your swing path for better results.',
                  style: TextStyle(color: kSecondaryText, fontSize: 15, height: 1.5), // THEME + Line height
                ),
                const SizedBox(height: 32), // Increased spacing
                Row(
                  children: [
                    Expanded(
                      // THEME: Use Glow Button
                      child: _buildGlowButton(
                        text: 'Practice Again',
                        icon: Icons.refresh, // Added icon
                        onPressed: () {
                           // Navigate only if the page exists
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecordPerformancePage()));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                       // THEME: Use Glow Button (Primary)
                      child: _buildGlowButton(
                        text: 'Save Comparison',
                        icon: Icons.save_alt_rounded, // Added icon
                        isPrimary: true,
                        onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Comparison Saved (Placeholder)'), duration: Duration(seconds: 1)),
                           );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                   // THEME: Use Glow Button (Text style)
                  child: _buildGlowButton(
                      text: 'Share with Coach',
                      icon: Icons.share_rounded, // Added icon
                      onPressed: _shareWithCoach,
                      isPrimary: false, // Make it look like the text button
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10) // Less padding
                    )
                ),
                const SizedBox(height: 16), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Redesigned Dropdown with Glassy Glow
  Widget _buildDropdown() {
    // Check if _selectedPlayer is valid, provide fallback if needed
    String? currentSelection = _selectedPlayer;
    if (currentSelection == null || !_players.contains(currentSelection)) {
      currentSelection = _players.isNotEmpty ? _players.first : null;
    }


    if (currentSelection == null) {
      // Handle the case where there are no players and no initial selection
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
         decoration: BoxDecoration(
            color: kFieldColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: kFieldColor, width: 1.5),
         ),
        child: const Text('No players available', style: TextStyle(color: kSecondaryText, fontSize: 14)),
      );
    }

// Dropdown always looks "selected" when a value exists
    // If this page was opened with an initialSelected player (from the
    // top page), show a non-interactive selected label so the same player
    // remains fixed for the analysis. Otherwise show the interactive dropdown.
    if (widget.initialSelected != null && widget.initialSelected!.isNotEmpty) {
      final fixed = widget.initialSelected!;
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: kFieldColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: kNewAccentCyan,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: kNewAccentCyan.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(fixed, style: const TextStyle(color: kNewAccentCyan, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Icon(Icons.check_circle, color: kNewAccentCyan.withOpacity(0.9), size: 20),
          ],
        ),
      );
    }

    return Container(
      height: 48, // Consistent height
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // Adjusted padding
      decoration: BoxDecoration(
        color: kFieldColor.withOpacity(0.8), // Glassy background
        borderRadius: BorderRadius.circular(30), // Pill shape
        // Gradient glow border
        border: Border.all(
          color: kNewAccentCyan,
          width: 2.0,
        ),
        boxShadow: [
                BoxShadow(
                  color: kNewAccentCyan.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSelection,
          isExpanded: true,
          dropdownColor: kFieldColor, // Dark dropdown background
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kNewAccentCyan, // Icon color matches selection state
          ),
          style: TextStyle( // Text style within the dropdown button
            color: kNewAccentCyan,
            fontSize: 16, // Larger font
            fontWeight: FontWeight.w600, // Slightly bolder
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPlayer = newValue;
            });
          },
          items: _players.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                  value,
                  style: const TextStyle( // Style for items in the dropdown list
                      color: kPrimaryText,
                      fontSize: 16
                  )
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Video Placeholder with modern radius
  Widget _buildVideoPlayerPlaceholder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16), // Modern radius
          image: const DecorationImage(
            image: NetworkImage('https://placehold.co/600x400/1a2531/FFF?text=Video'), // Placeholder image
            fit: BoxFit.cover,
            opacity: 0.6, // Slightly more visible placeholder image
          ),
           // Optional: Add a subtle border
           border: Border.all(color: kFieldColor, width: 1.5)
        ),
        child: const Center(
          child: Icon(Icons.play_circle_fill_rounded, color: kPrimaryText, size: 60), // Larger icon
        ),
      ),
    );
  }

  /// Redesigned Score Card with Glassy Glow
  Widget _buildScoreCard(String title, String score) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Adjusted padding
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20), // Modern radius
          // Gradient background
          gradient: LinearGradient(
            colors: [
              kFieldColor.withOpacity(0.9),
              kFieldColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Subtle border glow
          border: Border.all(
            color: kNewAccentCyan.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: kNewAccentCyan.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: kSecondaryText, fontSize: 16)), // THEME
            const SizedBox(height: 12), // Increased spacing
            Text(
                score,
                style: const TextStyle(
                    color: kNewAccentCyan, // THEME
                    fontSize: 48,
                    fontWeight: FontWeight.bold
                )
            ),
          ],
        ),
      ),
    );
  }

   /// Redesigned Stat Row
  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Increased spacing
      child: Row(
        children: [
          Expanded(
            flex: 3, // Give label slightly more space
            child: Text(label, style: const TextStyle(color: kPrimaryText, fontSize: 16)), // THEME
          ),
          const SizedBox(width: 12), // Space between label and bar
          Expanded(
            flex: 5, // Give bar more space
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value / 100.0,
                backgroundColor: kFieldColor.withOpacity(0.7), // THEME - slightly transparent background
                valueColor: const AlwaysStoppedAnimation<Color>(kNewAccentCyan), // THEME
                minHeight: 12, // Thicker bar
              ),
            ),
          ),
           const SizedBox(width: 12), // Space between bar and value
          SizedBox( // Constrain width of the value text
            width: 35,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: kPrimaryText, // THEME
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              )
            ),
          ),
        ],
      ),
    );
  }

  /// Show themed Share Dialog
  void _shareWithCoach() {
    final selected = _selectedPlayer ?? 'Pro';
    final report = _buildReportText(selected);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kFieldColor.withOpacity(0.95), // Glassy background
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Modern radius
            side: BorderSide(color: kNewAccentCyan.withOpacity(0.3), width: 1) // Subtle border
        ),
        title: const Text('Share Report', style: TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold)), // THEME
        content: SingleChildScrollView(
            child: Text(report, style: const TextStyle(color: kSecondaryText, height: 1.4)) // THEME
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Adjust padding
        actions: [
           // Use Glow Buttons for actions
          _buildGlowButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          ),
           const SizedBox(width: 8),
          _buildGlowButton(
             text: 'Send',
            isPrimary: true,
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Report sent to coach'),
                    backgroundColor: kNewAccentCyan, // Themed snackbar
                    duration: Duration(seconds: 2)
                )
              );
            },
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10)
          ),
        ],
      ),
    );
  }

  // --- Helper to build report text (no UI changes needed here) ---
  String _buildReportText(String proName) {
    final buffer = StringBuffer();
    buffer.writeln('Comparison Report vs. $proName');
    buffer.writeln('--------------------------------');
    buffer.writeln('Overall Score (Player): 85');
    buffer.writeln('Overall Score ($proName): 92'); // Use proName dynamically
    buffer.writeln('');
    buffer.writeln('Metrics:');
    buffer.writeln('  - Bat Speed: 85');
    buffer.writeln('  - Elbow Angle: 78');
    buffer.writeln('  - Reaction Time: 92');
    buffer.writeln('  - Swing Path: 88');
    buffer.writeln('');
    buffer.writeln('AI Feedback:');
    buffer.writeln('Your bat speed is slightly lower than $proName\'s, and your elbow angle could be more consistent. However, your reaction time is commendable. Focus on refining your swing path for better results.'); // Use proName dynamically
    return buffer.toString();
  }

   /// Reusable Glow Button Helper (copied from LeaderboardPage redesign)
  Widget _buildGlowButton(
      {required String text,
      required VoidCallback onPressed,
      IconData? icon, // Optional icon
      bool isPrimary = false,
      EdgeInsetsGeometry? padding}) { // Allow custom padding
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16), // Use default or custom padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: kNewAccentCyan.withOpacity(0.5), width: 1.5),
          ),
          shadowColor: Colors.transparent,
        ),
        child: Row( // Use Row for icon + text
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Fit content
          children: [
            if(icon != null) Icon(icon, color: isPrimary ? kDarkBlue : Colors.white, size: 20),
            if(icon != null) const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isPrimary ? kDarkBlue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15, // Slightly smaller text for row/dialog buttons
              ),
            ),
          ],
        ),
      ),
    );
  }
}