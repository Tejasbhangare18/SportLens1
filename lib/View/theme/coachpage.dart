import 'dart:math';
import 'package:flutter/material.dart';

// --- UI Constants for consistent styling ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);
const Color kTeal = Color(0xFF33C6A5);

class ClubSuccessPage extends StatelessWidget {
  const ClubSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main content column
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  // Image Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: kFieldColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: Image.asset(
                        'assets/player_success.png', // <-- Make sure you have this image
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Welcome Text
                  const Text(
                    'Welcome to\nclub Dashboard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle Text
                  const Text(
                    'Your registration was successful. Get ready to elevate your game!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(flex: 3),

                  // Dashboard Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to your actual Club Dashboard page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Go to Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
            // Decorative painter drawn on top of the content
            CustomPaint(
              painter: _DecorationPainter(),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A CustomPainter to draw the decorative lines and circles.
/// The positions are hardcoded to align with the centered UI.
class _DecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..color = kTeal..strokeWidth = 1.5;
    final solidCirclePaint = Paint()..color = kTeal;
    final fadedCirclePaint = Paint()..color = kTeal.withOpacity(0.3);
    final dashedCirclePaint = Paint()..color = kTeal..strokeWidth = 1.0..style = PaintingStyle.stroke;

    // Define the center points for the three circles relative to the screen size
    final topPoint = Offset(size.width / 2, size.height * 0.43);
    final middlePoint = Offset(size.width / 2, size.height * 0.48);
    final bottomPoint = Offset(size.width / 2, size.height * 0.53);

    // Draw the connecting line
    canvas.drawLine(topPoint, bottomPoint, linePaint);

    // Draw the top (magnifying glass) circle
    canvas.drawCircle(topPoint, 8, fadedCirclePaint);

    // Draw the small bottom circle
    canvas.drawCircle(bottomPoint, 5, solidCirclePaint);

    // Draw the middle dashed circle
    const double dashedRadius = 12.0;
    final Path dashedPath = Path();
    for (int i = 0; i < 360; i += 20) {
      dashedPath.addArc(
        Rect.fromCircle(center: middlePoint, radius: dashedRadius),
        i * (pi / 180),
        10 * (pi / 180),
      );
    }
    canvas.drawPath(dashedPath, dashedCirclePaint);
    
    // Draw the small solid circle inside the dashed one
    canvas.drawCircle(middlePoint, 4, solidCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}