// main.dart or your app's entry point
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// --- ADD THESE IMPORTS ---
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// --- END OF ADDED IMPORTS ---
import 'package:flutter_application_3/View/widgets/app_bottom_navigation.dart';
import 'package:flutter_application_3/models/drill.dart';

// Assuming drill_detail_page.dart exists and is correctly imported
import 'drill_detail_page.dart';


// --- UI Constants for "Modern Gradient Glow" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // Base Card/Field Color
const Color kNewAccentCyan = Color(0xFF00A8E8); // Unified Accent Color
// --- Text Colors ---
const Color kPrimaryText = Colors.white;
const Color kSecondaryText = Colors.white70;
// --- End of Theme ---


// --- Data Model for Drills ---
// Drill model is defined in models/drill.dart

class DrillsPage extends StatefulWidget {
  const DrillsPage({super.key});

  @override
  State<DrillsPage> createState() => _DrillsPageState();
}

class _DrillsPageState extends State<DrillsPage> {
  // --- MODIFIED STATE FOR SWIPER ---
  final CardSwiperController _swiperController = CardSwiperController();
  int _currentIndex = 0;
  // --- END OF MODIFIED STATE ---

  final int _bottomNavIndex = 2;

  // --- State for the filter views ---
  String? _activeFilterCategory;
  String _selectedSubFilter = 'All';
  // To track selection for styling

  // --- Mock Data ---
  final List<String> _mainFilters = ['All Drills', 'Athleticism', 'Technical'];
  final Map<String, List<String>> _subFilters = {
    'All Drills': ['All', 'Athleticism', 'Technical'],
    'Athleticism': ['All', 'Agility', 'Strength', 'Speed'],
    'Technical': ['All', 'Dribbling', 'Passing', 'Shooting'],
  };

  final List<Drill> _allDrills = [
    Drill('10m Sprint', category: 'Athleticism', subCategory: 'Speed', attributes: 'Power • Speed', imagePath: 'assets/coach.png', title: '10m Sprint'),
    Drill('30s Press Up', category: 'Athleticism', subCategory: 'Strength', attributes: 'Strength', imagePath: 'assets/Dri1.png', title: '30s Press Up'),
    Drill('30s Rebound Jump', category: 'Athleticism', subCategory: 'Strength', attributes: 'Coordination • Power • Strength', imagePath: 'assets/Dri2.png', title: '30s Rebound Jump'),
    Drill('5-0-5 | Left Turn', category: 'Athleticism', subCategory: 'Agility', attributes: 'Agility • Power • Speed', imagePath: 'assets/Dri3.png', title: '5-0-5 | Left Turn'),
    Drill('5-0-5 | Right Turn', category: 'Athleticism', subCategory: 'Agility', attributes: 'Agility • Power • Speed', imagePath: 'assets/Dri4.png', title: '5-0-5 | Right Turn'),
    Drill('Diamond Dribble', category: 'Technical', subCategory: 'Dribbling', attributes: 'Control • Agility', imagePath: 'assets/Dri5.png', title: 'Diamond Dribble'),
    Drill('Passing Gates', category: 'Technical', subCategory: 'Passing', attributes: 'Accuracy • Vision', imagePath: 'assets/Dri6.png', title: 'Passing Gates'),
    Drill('Finishing Drill', category: 'Technical', subCategory: 'Shooting', attributes: 'Power • Accuracy', imagePath: 'assets/Dri7.png', title: 'Finishing Drill'),
  ];

  // This list will now power the CardSwiper
  final List<Map<String, String>> topCarouselDrills = [
    {'title': '30s Press Up', 'category': 'Athleticism'},
    {'title': '5-0-5 | Left Turn', 'category': 'Athleticism'},
    {'title': '30s Rebound Jump', 'category': 'Athleticism'},
    {'title': '10m Sprint', 'category': 'Athleticism'},
  ];

  final List<Drill> clubDrills = [
    Drill('20s Strong Foot Kick Ups', category: 'Technical', subCategory: '', attributes: '', imagePath: 'assets/Dri8.png', title: '20s Strong Foot Kick Ups'),
    Drill('Diamond Dribble', category: 'Technical', subCategory: 'Dribbling', attributes: 'Control • Agility', imagePath: 'assets/Dri9.png', title: 'Diamond Dribble'),
    Drill('Figure of 8', category: 'Technical', subCategory: 'Dribbling', attributes: 'Agility', imagePath: 'assets/Dri10.png', title: 'Figure of 8'),
    Drill('10m Dribble', category: 'Technical', subCategory: 'Dribbling', attributes: 'Speed • Control', imagePath: 'assets/Drill2.png', title: '10m Dribble'),
  ];

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  // --- CORRECTED: Callback for the swiper now returns bool ---
  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    setState(() {
      _currentIndex = currentIndex ?? 0;
    });
    return true; // Allow the swipe to complete
  }

  void _showRandomizerDialog() {
    final dialogDrills = _allDrills.map((d) => {'title': d.title, 'category': d.category, 'image': d.imagePath}).toList();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      transitionDuration: const Duration(milliseconds: 300),
      // THEME: Use themed dialog
      pageBuilder: (context, anim1, anim2) {
        return DrillRandomizerDialog(allDrills: dialogDrills);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
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
        backgroundColor: kDarkBlue, // THEME: Page Background
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _activeFilterCategory == null
                ? _buildMainDrillsView()
                : _buildFilteredDrillView(),
          ),
        ),
        // THEME: Ensure AppBottomNavigation uses kFieldColor and kNewAccentCyan
        bottomNavigationBar: AppBottomNavigation(currentIndex: _bottomNavIndex),
      ),
    );
  }

  // --- Main View Builder (Your original UI) ---
  Widget _buildMainDrillsView() {
    return SingleChildScrollView(
      key: const ValueKey('main_view'),
      child: Padding( // Added overall padding
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips Bar
            SizedBox(
              height: 40, // Keep height compact
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
                itemCount: _mainFilters.length,
                itemBuilder: (context, index) => _buildMainFilterChip(index),
              ),
            ),
            const SizedBox(height: 24), // Increased spacing

            // Card Swiper Section
            SizedBox(
              height: 500, // Maintain height//480 hhota adhi 
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: topCarouselDrills.length,
                onSwipe: _onSwipe,
                isLoop: true,
                duration: const Duration(milliseconds: 500),
                threshold: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjusted padding
                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                  final drillData = topCarouselDrills[index];
                  final drillObject = _allDrills.firstWhere(
                    (d) => d.title == drillData['title'],
                    orElse: () => Drill(
                      drillData['title']!,
                      category: drillData['category']!,
                      subCategory: '',
                      attributes: '',
                      imagePath: 'assets/Drill2.png', // Default image
                      title: drillData['title']!,
                    ),
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DrillDetailPage(drill: drillObject),
                      ));
                    },
                    // THEME: Use redesigned DrillCard
                    child: DrillCard(
                      imagePath: drillObject.imagePath,
                      title: drillObject.title,
                      category: drillObject.category,
                    ),
                  );
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0), // Increased spacing
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: topCarouselDrills.length,
                  onDotClicked: (index) {
                    _swiperController.swipeTo(index);
                  },
                  effect: ExpandingDotsEffect( // Use ExpandingDotsEffect for modern feel
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: kNewAccentCyan, // THEME: Active Color
                    dotColor: kFieldColor,       // THEME: UI Field Color
                    expansionFactor: 3,
                    spacing: 6,
                  ),
                ),
              ),
            ),

            // Couch Drills Section
            _buildSectionHeader('Couch Drills', 'Try the most frequently used drills'),
            const SizedBox(height: 16),
            SizedBox(
              height: 280, // Adjusted height for new card design
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
                itemCount: clubDrills.length,
                itemBuilder: (context, index) {
                  final drillObj = clubDrills[index];
                  return Padding( // Add padding between cards
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DrillDetailPage(drill: drillObj))),
                      // THEME: Use redesigned card
                      child: _buildGlowDrillCard(drill: drillObj),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32), // Increased spacing

            // View All Button - Restored Original Style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Use slightly less padding than original 20
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _activeFilterCategory = 'All Drills';
                      _selectedSubFilter = 'All';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNewAccentCyan, // THEME: Use new accent color
                    padding: const EdgeInsets.symmetric(vertical: 18), // Original padding
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)), // Original shape
                    elevation: 5, // Add some elevation for pop
                    shadowColor: kNewAccentCyan.withOpacity(0.4), // Glow effect
                    minimumSize: const Size.fromHeight(54), // Original minimum size
                  ),
                  child: const Text('View All', style: TextStyle(color: kPrimaryText, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 32), // Increased spacing

            // Try Next Section
            _buildSectionHeader('Try Next', 'Randomly select your next drill'),
            const SizedBox(height: 16),
            SizedBox(
              height: 240, // Adjusted height for new card design
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
                itemCount: clubDrills.reversed.length,
                itemBuilder: (context, index) {
                  final drillObj = clubDrills.reversed.toList()[index];
                  return Padding( // Add padding between cards
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DrillDetailPage(drill: drillObj))),
                      // THEME: Use redesigned card
                      child: _buildGlowDrillCard(drill: drillObj, width: 160), // Smaller width
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }

  // --- Filtered Drill List View Builder ---
  Widget _buildFilteredDrillView() {
    final currentSubFilters = _subFilters[_activeFilterCategory] ?? ['All'];
    List<Drill> filteredList;
    // ... (Filtering logic remains the same) ...
     if (_activeFilterCategory == 'All Drills') {
      final combined = <Drill>[]..addAll(_allDrills);
      for (final cd in clubDrills) {
        if (!combined.any((d) => d.title == cd.title)) combined.add(cd);
      }
      for (final m in topCarouselDrills) {
        final title = m['title'] ?? '';
        final category = m['category'] ?? '';
        if (title.isEmpty) continue;
        if (!combined.any((d) => d.title == title)) {
          combined.add(Drill(title, title: title, category: category, subCategory: '', attributes: '', imagePath: ''));
        }
      }
      if (_selectedSubFilter == 'All') {
        filteredList = combined;
      } else {
        filteredList = combined.where((drill) => drill.category == _selectedSubFilter).toList();
      }
    } else {
      filteredList = _allDrills.where((drill) {
        bool categoryMatch = drill.category == _activeFilterCategory;
        bool subCategoryMatch = _selectedSubFilter == 'All' || drill.subCategory == _selectedSubFilter;
        return categoryMatch && subCategoryMatch;
      }).toList();
    }


    return Container(
      key: ValueKey(_activeFilterCategory),
      padding: const EdgeInsets.only(top: 16), // Add top padding
      child: Column(
        children: [
          // Filter Chips Bar
          SizedBox(
             height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
              itemCount: currentSubFilters.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildCloseFilterButton();
                final subFilter = currentSubFilters[index - 1];
                return _buildSubFilterChip(subFilter);
              },
            ),
          ),
          const SizedBox(height: 20), // Spacing below filters

          // Filtered List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Padding for list items
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final d = filteredList[index];
                // THEME: Use redesigned list tile
                return _buildDrillListTile(d);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  /// Redesigned Filter Chip
  Widget _buildMainFilterChip(int index) {
    final filterName = _mainFilters[index];
    final isSelected = _activeFilterCategory == filterName;
    return Padding( // Added padding between chips
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeFilterCategory = filterName;
            _selectedSubFilter = 'All';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Adjusted padding
          decoration: BoxDecoration(
            color: isSelected ? kNewAccentCyan : kFieldColor.withOpacity(0.8), // THEME
            borderRadius: BorderRadius.circular(30), // Pill shape
            border: isSelected ? null : Border.all(color: kFieldColor, width: 1.5),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kNewAccentCyan.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Text(
            filterName,
            style: TextStyle(
              color: isSelected ? kDarkBlue : kPrimaryText, // THEME
              fontWeight: FontWeight.bold,
              fontSize: 14, // Slightly larger font
            ),
          ),
        ),
      ),
    );
  }

  /// Redesigned Close Button
  Widget _buildCloseFilterButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => setState(() => _activeFilterCategory = null),
        child: Container(
          width: 40,
          decoration: BoxDecoration(color: kFieldColor.withOpacity(0.8), shape: BoxShape.circle), // THEME
          child: const Icon(Icons.close, color: kPrimaryText, size: 20), // THEME
        ),
      ),
    );
  }

  /// Redesigned Sub-Filter Chip
  Widget _buildSubFilterChip(String subFilter) {
    final isSelected = _selectedSubFilter == subFilter;
    return Padding( // Added padding between chips
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => setState(() {
          if (_activeFilterCategory == 'All Drills' && subFilter != 'All') {
            _activeFilterCategory = subFilter;
            _selectedSubFilter = 'All';
          } else {
            _selectedSubFilter = subFilter;
          }
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Adjusted padding
          decoration: BoxDecoration(
            color: isSelected ? kNewAccentCyan : kFieldColor.withOpacity(0.8), // THEME
            borderRadius: BorderRadius.circular(30), // Pill shape
            border: isSelected ? null : Border.all(color: kFieldColor, width: 1.5),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kNewAccentCyan.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Text(
            subFilter,
            style: TextStyle(
              color: isSelected ? kDarkBlue : kPrimaryText, // THEME
              fontWeight: FontWeight.bold,
              fontSize: 14, // Slightly larger font
            ),
          ),
        ),
      ),
    );
  }

  /// Redesigned List Tile for Filtered View
  Widget _buildDrillListTile(Drill drill) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DrillDetailPage(drill: drill))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12), // Spacing between items
          padding: const EdgeInsets.all(12), // Internal padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // Modern radius
            // Gradient background
            gradient: LinearGradient(
              colors: [
                kFieldColor.withOpacity(0.9),
                kFieldColor.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // Subtle border glow
            border: Border.all(
              color: kNewAccentCyan.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Rounded image
                child: Image.asset(
                  drill.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: kDarkBlue,
                    child: const Icon(Icons.image_not_supported_outlined, color: kSecondaryText),
                  )
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(drill.title, style: const TextStyle(color: kPrimaryText, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(drill.attributes, style: const TextStyle(color: kSecondaryText, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kSecondaryText),
            ],
          ),
        ),
      );
  }


  /// Redesigned Glow Card for Horizontal Lists
  Widget _buildGlowDrillCard({required Drill drill, double width = 180}) {
    return Container(
      width: width,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              drill.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: kDarkBlue),
            ),
            // Soft gradient overlay at the bottom for text contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [kDarkBlue.withOpacity(0.9), Colors.transparent],
                  stops: const [0.0, 0.7]
                ),
              ),
            ),
            // Text Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container( // Logo Placeholder
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('A', style: TextStyle(color: kDarkBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    drill.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kPrimaryText,
                      fontSize: 18, // Slightly larger title
                      fontWeight: FontWeight.bold,
                      height: 1.2, // Tighter line spacing
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drill.category,
                    style: const TextStyle(
                      color: kSecondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // --- Helper Widgets from Leaderboard Redesign ---
  // --- This Button is NOT used for "View All" anymore ---


  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjusted padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  title,
                  style: const TextStyle(
                      color: kPrimaryText,
                      fontSize: 20, // Larger title
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                  subtitle,
                  style: const TextStyle(
                      color: kSecondaryText,
                      fontSize: 14)), // Slightly larger subtitle
            ],
          ),
          IconButton(
              onPressed: _showRandomizerDialog,
              icon: const Icon(Icons.shuffle_rounded, color: kSecondaryText, size: 28)), // Updated icon
        ],
      ),
    );
  }

  // --- Removed _buildClubLogos ---
}

// --- CardSwiper Controller Extension ---
extension on CardSwiperController {
  void swipeTo(int index) {}
}


// --- Redesigned Drill Card for CardSwiper ---
class DrillCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String category;

  const DrillCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24), // Modern radius
        // Gradient background for the glow effect base
        gradient: LinearGradient(
          colors: [
            kFieldColor.withOpacity(0.9),
            kFieldColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
         // Removed border
        // Removed Soft outer glow
         // --- THIS IS THE MODIFIED PART ---
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              // Add a color filter to blend image with the background
              color: kDarkBlue.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) => Container(color: kDarkBlue),
            ),
             // Soft gradient overlay at the bottom for text contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [kDarkBlue.withOpacity(0.9), Colors.transparent],
                  stops: const [0.0, 0.6] // Adjust stops for desired effect
                ),
              ),
            ),
            // Text Content
            Positioned(
              left: 24, // Increased padding
              right: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container( // Logo Placeholder
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjusted padding
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95), // Brighter white
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: const Text('A', style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(height: 16), // Increased spacing
                  Text(
                    title,
                    style: const TextStyle(
                      color: kPrimaryText,
                      fontSize: 34, // Larger title
                      fontWeight: FontWeight.bold,
                      height: 1.1, // Tighter line spacing
                       shadows: [ // Subtle text shadow for depth
                        Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 1))
                      ]
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category,
                    style: const TextStyle(
                      color: kSecondaryText,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- Redesigned Glassmorphism Randomizer Dialog ---
class DrillRandomizerDialog extends StatefulWidget {
  const DrillRandomizerDialog({super.key, required this.allDrills});
  final List<Map<String, String>> allDrills;

  @override
  State<DrillRandomizerDialog> createState() => _DrillRandomizerDialogState();
}

class _DrillRandomizerDialogState extends State<DrillRandomizerDialog> {
  late Map<String, String> _currentDrill;
  Timer? _shuffleTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentDrill = widget.allDrills[_random.nextInt(widget.allDrills.length)];
    _startShuffling();
  }

  void _startShuffling() {
    _shuffleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentDrill = widget.allDrills[_random.nextInt(widget.allDrills.length)];
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      _shuffleTimer?.cancel();
      if (!mounted) return;

      final selected = widget.allDrills[_random.nextInt(widget.allDrills.length)];
      setState(() {
        _currentDrill = selected;
      });

      final drill = Drill(
        selected['title'] ?? '',
        title: selected['title'] ?? '',
        category: selected['category'] ?? '',
        subCategory: '',
        attributes: '',
        imagePath: selected['image'] ?? '',
      );
      // Ensure DrillDetailPage exists and is correctly imported
       if (mounted) {
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DrillDetailPage(drill: drill)));
       }
    });
  }

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue.withOpacity(0.85), // Darker overlay
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glassy Card Container
              Container(
                height: 480, // Increased height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24), // Modern radius
                  // Gradient background
                  gradient: LinearGradient(
                    colors: [
                      kFieldColor.withOpacity(0.9),
                      kFieldColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                   // Removed border
                   // --- THIS IS THE MODIFIED PART ---
                   // Removed box shadow
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Animated Image Background
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Image.asset(
                          _currentDrill['image'] ?? 'assets/Drill2.png', // Fallback image
                          key: ValueKey(_currentDrill['image']), // Key for smooth transition
                          fit: BoxFit.cover,
                          width: double.infinity, // Explicitly fill width
                          height: double.infinity, // Explicitly fill height
                          color: kDarkBlue.withOpacity(0.3), // Blend effect
                          colorBlendMode: BlendMode.darken,
                          errorBuilder: (context, error, stackTrace) => Container(color: kDarkBlue),
                        ),
                      ),
                      // Gradient Overlay for Text Contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [kDarkBlue.withOpacity(0.9), Colors.transparent],
                             stops: const [0.0, 0.7]
                          ),
                        ),
                      ),
                      // Text Content
                      Padding(
                        padding: const EdgeInsets.all(24.0), // Increased padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container( // Logo Placeholder
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('A', style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                            const SizedBox(height: 12),
                            // Animated Text Title
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              child: Text(
                                _currentDrill['title']!,
                                key: ValueKey(_currentDrill['title']), // Key for animation
                                style: const TextStyle(
                                  color: kPrimaryText,
                                  fontSize: 34, // Larger title
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                   shadows: [ // Subtle text shadow for depth
                                    Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 1))
                                  ]
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _currentDrill['category']!,
                              style: const TextStyle(color: kSecondaryText, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Close Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kFieldColor.withOpacity(0.9), // Glassy button
                      border: Border.all(color: kNewAccentCyan.withOpacity(0.3), width: 1) // Keep border on close button
                  ),
                  child: const Icon(Icons.close, color: kPrimaryText, size: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}