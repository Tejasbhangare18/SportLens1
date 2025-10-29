import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/player_dashboard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom typography

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  // Colors sampled from your reference
  final Color buttonGreen = const Color(0xFF86C836);
  final Color page1Background = const Color(0xFFF1F4F1);
  final Color page2Background = const Color(0xFFE6F3D4);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: page1Background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56), // exact AppBar height
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Welcome",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.info_outline, color: Colors.black, size: 24),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => isLastPage = (index == 2));
              },
              children: [
                OnboardingPageWidget(
                  color: page1Background,
                  imagePath: 'assets/images/discover.png',
                  title: "Discover Trials",
                  subtitle:
                      "Enter trials for clubs all over the world, including the best teams across the Premier League and MLS.",
                ),
                OnboardingPageWidget(
                  color: page2Background,
                  imagePath: 'assets/images/complete_drills.png',
                  title: "Complete trial drills",
                  subtitle:
                      "Get a score for each drill within a trial to analyse your skills.",
                ),
                OnboardingPageWidget(
                  color: page2Background,
                  imagePath: 'assets/images/submit.png',
                  title: "Submit to clubs",
                  subtitle:
                      "Once you're happy, submit your trials to get scouted by the world's best teams.",
                ),
              ],
            ),

            // Bottom Section (Indicator + Button)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: WormEffect(
                        dotColor: Colors.grey.shade400,
                        activeDotColor: buttonGreen,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonGreen,
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                        ),
                        onPressed: () {
                          if (isLastPage) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlayerDashboardPage()),
                            );
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          isLastPage ? "Go to Trials" : "Next",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color color;

  const OnboardingPageWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card wrapping the image for rounded corner look
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imagePath,
                height: 280,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
