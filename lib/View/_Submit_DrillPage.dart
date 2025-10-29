import 'dart:async';
import 'package:flutter/material.dart';

// Replace with your actual drills page import
import 'package:flutter_application_3/View/drills_page.dart';

class UploadProgressPage extends StatefulWidget {
  const UploadProgressPage({super.key});

  @override
  State<UploadProgressPage> createState() => _UploadProgressPageState();
}

class _UploadProgressPageState extends State<UploadProgressPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  bool _uploadComplete = false;

  @override
  void initState() {
    super.initState();
    // Animate progress from 0 to 1 over 10 seconds
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _uploadComplete = true;
          });
          _onUploadComplete();
        }
      });

    _animationController.forward();
  }

  void _onUploadComplete() {
    // Show success message for 2 seconds then navigate
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DrillsPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercent = (_progressAnimation.value * 100).toInt();

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/Submit.png', // Your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Dim overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_uploadComplete)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Your file is uploading right now.\nDo not navigate away from the app.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Text(
                      'Video Uploaded Successfully!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreenAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black54,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 60),

                  // Larger circular progress bar
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow circle
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.lightGreenAccent.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                        ),

                        // Progress ring
                        CircularProgressIndicator(
                          value: _progressAnimation.value,
                          strokeWidth: 12,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.lightGreenAccent),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),

                        // Text inside circle
                        Text(
                          _uploadComplete ? '100%' : '$progressPercent%',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
