import 'package:flutter/material.dart';
// Make sure these paths are correct for your project
import 'package:flutter_application_3/View/coach_profile_pagePlayerSide.dart';
import 'package:flutter_application_3/View/viewCoaches.dart';
import 'package:flutter_application_3/View/widgets/app_bottom_navigation.dart';
import 'package:flutter_application_3/models/coach_data.dart';

import 'package:flutter_application_3/models/club_data.dart';
import 'package:flutter_application_3/View/my_clubs_page.dart';
import 'package:flutter_application_3/View/club_detail_page.dart';

// --- UI Constants for "Electric Indigo" Theme ---
const Color kDarkBlue = Color(0xFF1A2531); // THEME: App Bar & Page Background
const Color kFieldColor = Color(0xFF2A3A4A); // THEME: Bottom Nav Bar, UI Fields
const Color kAccentBlue = Color(0xFF4A90E2); // THEME: "View All" Button
const Color kActiveCyan = Color(0xFF00F0FF); // THEME: Active Icon/Text
// --- End of Theme Colors ---
const Color kSearchBarColor = Color(0xFF2C3A47);
const Color kSegmentControlBackground = Color(0xFF2C3A47);
const Color kFilterButtonBorder = Colors.white38;
// const Color kFilterButtonSelectedBorder = kAccentBlue; // Replaced with kActiveCyan
const Color kFilterButtonTextColor = Colors.white70;


class CoachesAndClubsPage extends StatelessWidget {
  const CoachesAndClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kDarkBlue, // THEME: Page Background
        body: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context);
            return SafeArea(
              child: _CoachesClubsBody(tabController: tabController),
            );
          },
        ),
        // THEME: Ensure your AppBottomNavigation widget uses
        // kFieldColor for its background and kActiveCyan for the active item.
        bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
      ),
    );
  }
}

class _CoachesClubsBody extends StatefulWidget {
  final TabController tabController;
  const _CoachesClubsBody({required this.tabController});

  @override
  State<_CoachesClubsBody> createState() => _CoachesClubsBodyState();
}

class _CoachesClubsBodyState extends State<_CoachesClubsBody> {
  // --- Coach Filter State ---
  String? _selectedCoachSport = 'All Sports';
  String? _selectedCoachArea = 'All Areas';
  String? _selectedCoachStars = 'All';

  final List<String> _coachSportOptions = ['All Sports', 'Cricket', 'Basketball', 'Football'];
  final List<String> _coachAreaOptions = ['All Areas', 'Pune', 'Nashik', 'Delhi', 'Mumbai'];
  final List<String> _coachStarOptions = ['All', '3★+', '4★+', 'New', '5★+'];

  // --- Club Filter State ---
  String? _selectedClubSport = 'All Sports';
  String? _selectedClubArea = 'All Areas';
  String? _selectedClubTrials = 'Any Trials';

  final List<String> _clubSportOptions = ['All Sports', 'Football', 'Cricket', 'Basketball'];
  final List<String> _clubAreaOptions = ['All Areas', 'Mumbai', 'Delhi', 'Pune', 'Nashik'];
  final List<String> _clubTrialOptions = ['Any Trials', 'Active Trials', 'Upcoming Trials'];


  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
     if (widget.tabController.indexIsChanging || widget.tabController.animation?.value != widget.tabController.index.toDouble()) {
       if (mounted) {
         setState(() {});
       }
    }
     widget.tabController.animation?.addListener(() {
      if (mounted && widget.tabController.animation?.value == widget.tabController.index.toDouble()) {
        setState(() {});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSegmentedControl(widget.tabController),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              _buildCoachesTab(context),
              _buildClubsTab(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(TabController tabController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: kSegmentControlBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          _buildSegment(
            text: 'Personal Coaches',
            index: 0,
            isSelected: tabController.index == 0,
            onTap: () => tabController.animateTo(0),
          ),
          _buildSegment(
            text: 'Clubs',
            index: 1,
            isSelected: tabController.index == 1,
            onTap: () => tabController.animateTo(1),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required String text,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            // --- THIS IS THE MODIFIED PART ---
            color: isSelected ? kActiveCyan : Colors.transparent, // THEME: Active Color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              // THEME: Dark text on active, white on inactive
              color: isSelected ? kDarkBlue : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // --- Coaches Tab ---
  Widget _buildCoachesTab(BuildContext context) {
    final List<Coach> followedCoaches = Coach.getSampleFollowedCoaches();
    final List<Coach> featuredCoaches = Coach.getSampleFeaturedCoaches();
    final List<Coach> allCoaches = Coach.getSampleAllCoaches();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
         const SizedBox(height: 16),
        const Text('Find Your Coach',
            style: TextStyle(
                color: Colors.white, // THEME: Regular Text
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          style: const TextStyle(color: Colors.white70), // THEME: Regular Text
          decoration: InputDecoration(
            hintText: 'Search by name, sport, or skill',
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            filled: true,
            fillColor: kSearchBarColor, // (Fits theme)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'My Coaches', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FollowedCoachesPage()),
          );
        }),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: followedCoaches.length,
              itemBuilder: (context, index) {
                return _FollowedCoachCard(coach: followedCoaches[index], isFollowing: true);
              },
          ),
        ),
        const SizedBox(height: 24),
        const Text('Featured Coaches',
            style: TextStyle(
                color: Colors.white, // THEME: Regular Text
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredCoaches.length,
            itemBuilder: (context, index) {
              bool isFollowing = _CoachListCard._followingState[featuredCoaches[index].id] ?? false;
              return _FeaturedCoachCard(coach: featuredCoaches[index], isFollowing: isFollowing);
            },
          ),
        ),
        const SizedBox(height: 24),

        // --- All Coaches Section ---
        const Text('All Coaches',
            style: TextStyle(
                color: Colors.white, // THEME: Regular Text
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12), // Space between title and filters

        // --- Filters Bar Moved Here ---
        _buildCoachFiltersBar(),
        const SizedBox(height: 20), // Space between filters and list
        // --- End Filter Bar ---

        Column( // The actual list
           children: allCoaches.map((coach) => _CoachListCard(coach: coach)).toList(),
        ),
        // --- Filters Bar REMOVED FROM HERE ---

        const SizedBox(height: 16), // Padding at the end
      ],
    );
  }

  // --- Coach Filters Bar ---
  Widget _buildCoachFiltersBar() {
     bool isSportSelected = _selectedCoachSport != _coachSportOptions[0];
    bool isAreaSelected = _selectedCoachArea != _coachAreaOptions[0];
    bool isStarsSelected = _selectedCoachStars != _coachStarOptions[0];

    return Row(
      children: [
        Flexible(
          child: _buildFilterDropdownButton(
            label: _selectedCoachSport ?? _coachSportOptions[0],
            isSelected: isSportSelected,
            onTap: () {
               setState(() {
                 int currentIndex = _coachSportOptions.indexOf(_selectedCoachSport ?? _coachSportOptions[0]);
                 _selectedCoachSport = _coachSportOptions[(currentIndex + 1) % _coachSportOptions.length];
               });
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildFilterDropdownButton(
            label: _selectedCoachArea ?? _coachAreaOptions[0],
            isSelected: isAreaSelected,
            onTap: () {
               setState(() {
                 int currentIndex = _coachAreaOptions.indexOf(_selectedCoachArea ?? _coachAreaOptions[0]);
                 _selectedCoachArea = _coachAreaOptions[(currentIndex + 1) % _coachAreaOptions.length];
               });
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildFilterDropdownButton(
            label: _selectedCoachStars ?? _coachStarOptions[0],
            isSelected: isStarsSelected, // Use dynamic selection
             onTap: () {
               setState(() {
                 int currentIndex = _coachStarOptions.indexOf(_selectedCoachStars ?? _coachStarOptions[0]);
                 _selectedCoachStars = _coachStarOptions[(currentIndex + 1) % _coachStarOptions.length];
               });
            },
          ),
        ),
      ],
    );
  }


  // --- Clubs Tab ---
  Widget _buildClubsTab(BuildContext context) {
      final List<Club> joinedClubs = Club.getSampleJoinedClubs();
      final List<Club> featuredClubs = Club.getSampleFeaturedClubs();
      final List<Club> allClubs = Club.getSampleAllClubs();

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
           const SizedBox(height: 16),
           Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 const Text('Discover Clubs',
                   style: TextStyle(
                       color: Colors.white, // THEME: Regular Text
                       fontSize: 24,
                       fontWeight: FontWeight.bold)),
                 IconButton(
                    icon: const Icon(Icons.filter_list_rounded, color: Colors.white70),
                    onPressed: () {
                      print("Club filter tapped");
                    },
                 ),
              ],
           ),
           const SizedBox(height: 16),
           TextField(
             style: const TextStyle(color: Colors.white70), // THEME: Regular Text
             decoration: InputDecoration(
               hintText: 'Search by club name, location, or sport',
               hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
               prefixIcon: const Icon(Icons.search, color: Colors.white54),
               filled: true,
               fillColor: kSearchBarColor, // (Fits theme)
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
                 borderSide: BorderSide.none,
               ),
               contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
             ),
           ),
           const SizedBox(height: 24),
            _buildSectionHeader(context, 'My Clubs', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyClubsPage()),
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: joinedClubs.length,
                itemBuilder: (context, index) {
                  return _JoinedClubCard(club: joinedClubs[index], isJoined: true);
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('Featured Clubs',
               style: TextStyle(
                   color: Colors.white, // THEME: Regular Text
                   fontSize: 18,
                   fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredClubs.length,
                itemBuilder: (context, index) {
                  return _FeaturedClubCard(club: featuredClubs[index]);
                },
              ),
            ),
           const SizedBox(height: 24),

           // --- All Clubs Section ---
            const Text('All Clubs',
               style: TextStyle(
                   color: Colors.white, // THEME: Regular Text
                   fontSize: 18,
                   fontWeight: FontWeight.bold)),
            const SizedBox(height: 12), // Space between title and filters

           // --- Club Filters Bar Moved Here ---
           _buildClubFiltersBar(),
           const SizedBox(height: 20), // Space between filters and list
           // --- END Club Filters ---

            Column( // The actual list
              children: allClubs.map((club) => _ClubListCard(club: club)).toList(),
            ),
            // --- Filters REMOVED FROM HERE ---

           const SizedBox(height: 16), // Padding at the end
        ],
      );
  }

  // --- Club Filters Bar Widget ---
  Widget _buildClubFiltersBar() {
     bool isSportSelected = _selectedClubSport != _clubSportOptions[0];
    bool isAreaSelected = _selectedClubArea != _clubAreaOptions[0];
    bool isTrialsSelected = _selectedClubTrials != _clubTrialOptions[0];

    return Row(
      children: [
        Flexible(
          child: _buildFilterDropdownButton(
            label: _selectedClubSport ?? _clubSportOptions[0],
            isSelected: isSportSelected,
            onTap: () {
               setState(() {
                 int currentIndex = _clubSportOptions.indexOf(_selectedClubSport ?? _clubSportOptions[0]);
                 _selectedClubSport = _clubSportOptions[(currentIndex + 1) % _clubSportOptions.length];
               });
               // TODO: Filter club list
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildFilterDropdownButton(
            label: _selectedClubArea ?? _clubAreaOptions[0],
            isSelected: isAreaSelected,
            onTap: () {
               setState(() {
                 int currentIndex = _clubAreaOptions.indexOf(_selectedClubArea ?? _clubAreaOptions[0]);
                 _selectedClubArea = _clubAreaOptions[(currentIndex + 1) % _clubAreaOptions.length];
               });
               // TODO: Filter club list
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildFilterDropdownButton(
            label: _selectedClubTrials ?? _clubTrialOptions[0],
            isSelected: isTrialsSelected,
            onTap: () {
               setState(() {
                 int currentIndex = _clubTrialOptions.indexOf(_selectedClubTrials ?? _clubTrialOptions[0]);
                 _selectedClubTrials = _clubTrialOptions[(currentIndex + 1) % _clubTrialOptions.length];
               });
                // TODO: Filter club list
            },
          ),
        ),
      ],
    );
  }


  // --- Helper for Filter Buttons ---
  Widget _buildFilterDropdownButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
     return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        backgroundColor: Colors.transparent,
        // --- THIS IS THE MODIFIED PART ---
        foregroundColor: isSelected ? kActiveCyan : kFilterButtonTextColor, // THEME: Active Color
        side: BorderSide(
          color: isSelected ? kActiveCyan : kFilterButtonBorder, // THEME: Active Color
          width: isSelected ? 1.5 : 1.0,
        ),
        // --- END OF MODIFIED PART ---
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
          ),
        ],
      ),
    );
  }

  // --- Section Header Helper ---
  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onViewAll) {
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white, // THEME: Regular Text
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text('View All', style: TextStyle(color: kAccentBlue)), // THEME: "View All"
        ),
      ],
    );
  }
} // End of _CoachesClubsBodyState

// --- Card Widgets ---
// (All card widgets remain the same, as they fit the dark theme)
class _FollowedCoachCard extends StatelessWidget {
  final Coach coach;
  final bool isFollowing;
  const _FollowedCoachCard({required this.coach, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoachProfilePage(coach: coach, isFollowing: isFollowing)),
        );
      },
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(coach.profileImageUrl),
              backgroundColor: kFieldColor,
            ),
            const SizedBox(height: 6),
            Text(
              coach.name.split(' ')[0],
              style: const TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
             Text(
              coach.sport,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCoachCard extends StatelessWidget {
   final Coach coach;
   final bool isFollowing;
   const _FeaturedCoachCard({required this.coach, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoachProfilePage(coach: coach, isFollowing: isFollowing)),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
           image: DecorationImage(
             image: AssetImage(coach.bannerImageUrl),
             fit: BoxFit.cover,
           ),
        ),
        child: Stack(
          children: [
            Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 gradient: LinearGradient(
                   begin: Alignment.bottomCenter,
                   end: Alignment.center,
                   colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                   stops: const [0.0, 0.6]
                 )
               ),
            ),
            Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(coach.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 2),
                     Text(coach.specialization, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                     const SizedBox(height: 4),
                     Row(
                        children: [
                           const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                           const SizedBox(width: 4),
                           Text(coach.rating.toString(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                     )
                  ],
               ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachListCard extends StatelessWidget {
  final Coach coach;
  const _CoachListCard({required this.coach});

  static final Map<String, bool> _followingState = {}; // Simple state simulation

  @override
  Widget build(BuildContext context) {
     bool isFollowing = _followingState[coach.id] ?? false;

    return Card(
      color: kFieldColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
         onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CoachProfilePage(coach: coach, isFollowing: isFollowing)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(coach.profileImageUrl),
                backgroundColor: kDarkBlue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coach.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 3),
                    Text(coach.sport, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 3),
                    Text(coach.experience, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
               ElevatedButton(
                  onPressed: () {
                     (context as Element).markNeedsBuild();
                     _followingState[coach.id] = !isFollowing;
                     print('${isFollowing ? 'Unfollowed' : 'Followed'} ${coach.name}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.transparent : kAccentBlue,
                    foregroundColor: Colors.white,
                    side: isFollowing ? const BorderSide(color: Colors.white54) : null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: const Size(80, 34)
                  ),
                  child: Text(isFollowing ? 'Following' : 'Follow', style: const TextStyle(fontSize: 13)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class _JoinedClubCard extends StatelessWidget {
  final Club club;
  final bool isJoined;
  const _JoinedClubCard({required this.club, this.isJoined = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubDetailPage(club: club, isJoined: isJoined)),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
               width: 70,
               height: 70,
               decoration: BoxDecoration(
                  color: kFieldColor,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                     image: AssetImage(club.logoUrl),
                     fit: BoxFit.contain,
                  ),
               ),
            ),
            const SizedBox(height: 8),
            Text(
              club.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
             Text(
              club.city,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedClubCard extends StatelessWidget {
   final Club club;
   const _FeaturedClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubDetailPage(club: club)),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
           image: DecorationImage(
             image: AssetImage(club.bannerUrl),
             fit: BoxFit.cover,
           ),
        ),
        child: Stack(
          children: [
            Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 gradient: LinearGradient(
                   begin: Alignment.bottomCenter,
                   end: Alignment.center,
                   colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                   stops: const [0.0, 0.7]
                 )
               ),
            ),
            Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(club.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 4),
                     Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(club.city, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(width: 12),
                          const Icon(Icons.group_outlined, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                           Text('${club.followers} followers', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                     ),
                      const SizedBox(height: 8),
                     SizedBox(
                       height: 30,
                       child: ElevatedButton(
                          onPressed: () { print("Join ${club.name}");},
                          style: ElevatedButton.styleFrom(
                             backgroundColor: kAccentBlue,
                             foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                          ),
                          child: const Text('Join'),
                       ),
                     )
                  ],
               ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClubListCard extends StatelessWidget {
  final Club club;
  const _ClubListCard({required this.club});

   static final Map<String, bool> _joinedState = {}; // Simple state simulation

  @override
  Widget build(BuildContext context) {
      bool isJoined = _joinedState[club.id] ?? false;

    return Card(
      color: kFieldColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
         onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClubDetailPage(club: club)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
               Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8),
                     color: kDarkBlue,
                     image: DecorationImage(
                        image: AssetImage(club.logoUrl),
                        fit: BoxFit.cover,
                     ),
                  ),
               ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${club.city} • ${club.sport}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
               ElevatedButton(
                  onPressed: () {
                     (context as Element).markNeedsBuild();
                     _joinedState[club.id] = !isJoined;
                     print('${isJoined ? 'Left' : 'Joined'} ${club.name}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isJoined ? Colors.transparent : kAccentBlue,
                    foregroundColor: Colors.white,
                    side: isJoined ? const BorderSide(color: Colors.white54) : null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(80, 34)
                  ),
                  child: Text(isJoined ? 'Joined' : 'Join', style: const TextStyle(fontSize: 13)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}