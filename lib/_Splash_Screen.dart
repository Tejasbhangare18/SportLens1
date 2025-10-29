import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_application_3/View/signup/signup_page.dart';
 // Onboarding screen import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const SignUpPage(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
              child: child,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---- Animated Gradient Background ----
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ---- Rotating Glow Ring ----
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * math.pi * 2,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.25),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.3),
                          blurRadius: 60,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ---- Floating Glows ----
          _floatingCircle(top: 80, left: 50, size: 100, color: Colors.blueAccent),
          _floatingCircle(bottom: 120, right: 60, size: 140, color: Colors.cyanAccent),

          // ---- Center Content ----
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Custom Animated Logo ---
                _buildDynamicLogo(),

                const SizedBox(height: 35),

                // --- App Name ---
                Text(
                  "SPORTLENS",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: Colors.white,
                  ).copyWith(shadows: [
                    const Shadow(
                      color: Colors.cyanAccent,
                      blurRadius: 20,
                      offset: Offset(0, 0),
                    ),
                  ]),
                )
                    .animate()
                    .fadeIn(duration: 1000.ms)
                    .slide(begin: const Offset(0, 0.2))
                    .then(delay: 800.ms)
                    .shimmer(duration: 1600.ms),

                const SizedBox(height: 10),

                // --- Tagline with AI Typing Effect ---
                _typingText("AI-Powered Talent Discovery"),

                const SizedBox(height: 50),

                // --- Progress Bar ---
                Container(
                  width: 130,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent],
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleX(duration: 800.ms, begin: 0.6, end: 1.2)
                    .shimmer(duration: 1600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Floating Glow Circles ----
  Widget _floatingCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(begin: -10, end: 10, duration: 4000.ms, curve: Curves.easeInOut)
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1)),
    );
  }

  // ---- Dynamic Futuristic Logo ----
  Widget _buildDynamicLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glow Ring
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Colors.cyanAccent,
                Colors.blueAccent,
                Colors.transparent,
              ],
              stops: [0.3, 0.7, 1],
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            duration: 2000.ms,
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.05, 1.05)),

        // Center Neon Circle
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.cyanAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Inner Lens Effect
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.8),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
        ),

        // Rotating Line (to mimic AI scan)
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final angle = _controller.value * 2 * math.pi;
            return Transform.rotate(
              angle: angle,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border(
                    top: BorderSide(color: Colors.cyanAccent.withOpacity(0.8), width: 2),
                    left: BorderSide(color: Colors.transparent, width: 2),
                    right: BorderSide(color: Colors.transparent, width: 2),
                    bottom: BorderSide(color: Colors.transparent, width: 2),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 1200.ms)
        .scale(duration: 1200.ms, curve: Curves.easeOutBack);
  }

  // ---- Typing Text Animation ----
  Widget _typingText(String text) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: text.length),
      duration: const Duration(milliseconds: 1800),
      builder: (context, value, child) {
        return Text(
          text.substring(0, value),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 1,
          ),
        );
      },
    ).animate().fadeIn(duration: 1200.ms);
  }
}
