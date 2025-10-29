import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/View/video_analysis_page.dart';

// --- THEME COLORS ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- END THEME ---

class CompareWithProPage extends StatefulWidget {
  final String? initialSelected;
  const CompareWithProPage({super.key, this.initialSelected});

  @override
  State<CompareWithProPage> createState() => _CompareWithProPageState();
}

class _CompareWithProPageState extends State<CompareWithProPage> {
  bool _processing = false;
  double _progress = 0.0;
  Timer? _timer;

  String? _selectedPro;
  final List<String> _topPlayers = [
    // Use the top 4 players from the leaderboard mock data
    'Ethan Carter',
    'Olivia Bennett',
    'Noah Thompson',
    'Ava Harper',
  ];

  @override
  void initState() {
    super.initState();
    // If an initial selection is provided (e.g. coming from My Friends), use it
    // and ensure it's present in the dropdown items so the DropdownButton can
    // display it safely.
    if (widget.initialSelected != null) {
      _selectedPro = widget.initialSelected;
      if (!_topPlayers.contains(widget.initialSelected)) {
        _topPlayers.insert(0, widget.initialSelected!);
      }
    }
  }

  void _startProcessingThenNavigate() {
    setState(() {
      _processing = true;
      _progress = 0.0;
    });

    const totalMs = 5000;
    const tickMs = 100;
    int elapsed = 0;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: tickMs), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      elapsed += tickMs;
      final p = (elapsed / totalMs).clamp(0.0, 1.0);
      setState(() => _progress = p);

      if (elapsed >= totalMs) {
        t.cancel();
        if (mounted) {
          setState(() {
            _processing = false;
            _progress = 0.0;
          });
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => VideoAnalysisPage(initialSelected: _selectedPro)));
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kDarkBlue,
        appBar: AppBar(
          backgroundColor: kDarkBlue,
          elevation: 0,
          leading: const BackButton(color: kPrimaryText),
          centerTitle: false,
          title: const Text(
            'Pro Comparison Hub',
            style: TextStyle(
                color: kNewAccentCyan,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analyze your performance against a pro to find your edge.',
                  style: TextStyle(
                      color: kSecondaryText, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 32),

                // 🔹 UPDATED: Glowing Capsule Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: kFieldColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: kNewAccentCyan, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: kNewAccentCyan.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: kFieldColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(14),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: kNewAccentCyan, size: 24),
                      hint: const Text(
                        "Select Top Player",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _selectedPro,
                      items: _topPlayers.map((player) {
                        return DropdownMenuItem<String>(
                          value: player,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              player,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedPro = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 🔹 Selection Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildGlowButton(
                        text: 'Select My Video',
                        icon: Icons.video_library_outlined,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Select My Video Tapped (TODO)'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGlowButton(
                        text: 'Select Pro Video',
                        icon: Icons.person_search_outlined,
                        onPressed: () {
                          if (_selectedPro == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please select a Top Player first'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Pro Video: $_selectedPro selected'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 🔹 Compare via Video Card
                _buildOptionCard(
                  context: context,
                  title: 'Compare via Video',
                  description:
                      'Overlay your video with a pro to spot differences in technique, timing, and form.',
                  iconWidget: const Icon(Icons.play_circle_fill_rounded,
                      color: kPrimaryText, size: 30),
                  isVideo: true,
                  buttonText: 'Analyze Videos',
                  onPressed: _processing ? () {} : _startProcessingThenNavigate,
                ),
                const SizedBox(height: 16),

                if (_processing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: kFieldColor.withOpacity(0.5),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(kNewAccentCyan),
                        minHeight: 6,
                      ),
                    ),
                  ),
                if (_processing) const SizedBox(height: 8),
                if (_processing)
                  Center(
                    child: Text(
                      'Analyzing... ${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                          color: kNewAccentCyan, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Option Card
  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String description,
    required Widget iconWidget,
    required String buttonText,
    required VoidCallback onPressed,
    bool isVideo = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            kFieldColor.withOpacity(0.9),
            kFieldColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: kPrimaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: const TextStyle(
                          color: kSecondaryText, height: 1.5, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      kNewAccentCyan.withOpacity(0.4),
                      kNewAccentCyan.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                      color: kNewAccentCyan.withOpacity(0.5), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: kNewAccentCyan.withOpacity(0.3),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Center(child: iconWidget),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: _buildGlowButton(
              text: buttonText,
              onPressed: onPressed,
              isPrimary: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Glow Button
  Widget _buildGlowButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isPrimary = false,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: kNewAccentCyan.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? kNewAccentCyan : Colors.transparent,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: kNewAccentCyan.withOpacity(0.5), width: 1.5),
          ),
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon,
                  color: isPrimary ? kDarkBlue : Colors.white, size: 20),
            if (icon != null) const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isPrimary ? kDarkBlue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
