import 'package:flutter/material.dart';
import 'dart:ui'; // Import this for BackdropFilter

// Your theme colors - these are perfect for the glow effect
const Color kDarkBlue = Color(0xFF0D111C);
const Color kFieldColor = Color(0xFF171D2B);
const Color kAccentBlue = Color(0xFF00A8E8);
const Color kGreen = Color(0xFF34D399);

class TopTrialApplicantsPage extends StatefulWidget {
  const TopTrialApplicantsPage({super.key});

  @override
  State<TopTrialApplicantsPage> createState() => _TopTrialApplicantsPageState();
}

class _TopTrialApplicantsPageState extends State<TopTrialApplicantsPage> {
  int _selectedIndex = 0;
  bool _dropdownVisible = false;

  final List<GlobalKey> _tabKeys = List.generate(3, (_) => GlobalKey());
  double? _dropdownLeft;
  double? _dropdownTop;
  double? _dropdownWidth;

  String _searchQuery = '';

  // --- Your Data (Unchanged) ---
  final List<Map<String, String>> applicants = [
    {
      'name': 'Ethan Carter',
      'role': 'Forward',
      'ageGroup': '18-25',
      'area': 'North',
      'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'Liam Bennett',
      'role': 'Midfielder',
      'ageGroup': '18-25',
      'area': 'Central',
      'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'name': 'Noah Thompson',
      'role': 'Defender',
      'ageGroup': '16-18',
      'area': 'West',
      'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'name': 'Oliver Hayes',
      'role': 'Goalkeeper',
      'ageGroup': 'U17',
      'area': 'Central',
      'avatar': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'name': 'Lucas Harper',
      'role': 'Forward',
      'ageGroup': '16-18',
      'area': 'South',
      'avatar': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
  ];

  final Map<int, List<String>> filterOptions = {
    0: ['All', 'U15', 'U17', '16-18', '18-25', 'Open Age'],
    1: ['All', 'Forward', 'Midfielder', 'Defender', 'Goalkeeper'],
    2: ['All', 'North', 'Central', 'South', 'West', 'East'],
  };

  Map<int, String> _selectedFilters = {0: 'All', 1: 'All', 2: 'All'};

  // --- All Functionality (Unchanged) ---
  @override
  void initState() {
    super.initState();
    _selectedFilters = {for (var i = 0; i < 3; i++) i: filterOptions[i]!.first};
  }

  void _onTabTap(int i) {
    final key = _tabKeys[i];
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final rootBox = context.findRenderObject() as RenderBox?;
    double left = 16.0;
    double top = 78.0;
    double width = MediaQuery.of(context).size.width - 32;
    if (renderBox != null && rootBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero, ancestor: rootBox);
      left = offset.dx;
      top = offset.dy + renderBox.size.height;
      width = renderBox.size.width;
    }
    setState(() {
      _selectedIndex = i;
      _dropdownLeft = left;
      _dropdownTop = top;
      _dropdownWidth = width;
      _dropdownVisible =
          !_dropdownVisible || _selectedIndex == i ? !_dropdownVisible : true;
    });
  }

  List<Map<String, String>> get _filteredApplicants {
    final filterFields = ['ageGroup', 'role', 'area'];
    return applicants.where((p) {
      for (var i = 0; i < 3; i++) {
        final selected = _selectedFilters[i] ?? 'All';
        if (selected != 'All' && (p[filterFields[i]] ?? '') != selected) {
          return false;
        }
      }
      if (_searchQuery.isNotEmpty &&
          !(p['name'] ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              )) {
        return false;
      }
      return true;
    }).toList();
  }

  // --- End Functionality ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: kAccentBlue),
        title: const Text(
          "Top Trial Applicants",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => setState(() => _dropdownVisible = false),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // --- 💫 Redesigned Horizontal List ---
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "AI Recommended Players",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16, right: 10),
                          itemCount: applicants.length > 5
                              ? 5
                              : applicants.length,
                          itemBuilder: (context, index) {
                            final appl = applicants[index];
                            // Glass Card Wrapper
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kFieldColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: kAccentBlue.withOpacity(0.2)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kAccentBlue.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundImage:
                                              NetworkImage(appl['avatar'] ?? ''),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          appl['name']!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          appl['role']!,
                                          style: const TextStyle(
                                              color: Colors.white70, fontSize: 12),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: kAccentBlue.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            "AI Match 90%",
                                            style: TextStyle(
                                                color: kAccentBlue,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- 💫 Redesigned Search Bar ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kFieldColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: kAccentBlue.withOpacity(0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: kAccentBlue.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                onChanged: (val) => setState(() {
                                  _searchQuery = val;
                                }),
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Search players...',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  prefixIcon:
                                      Icon(Icons.search, color: kAccentBlue), // Accent icon
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- 💫 Redesigned Filter Tabs ---
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: List.generate(3, (i) {
                            final bool isSelected = _selectedIndex == i && _dropdownVisible;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: GestureDetector(
                                key: _tabKeys[i],
                                onTap: () => _onTabTap(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isSelected
                                          ? [
                                              kAccentBlue.withOpacity(0.7),
                                              kAccentBlue
                                            ]
                                          : [
                                              kFieldColor.withOpacity(0.6),
                                              kFieldColor.withOpacity(0.4)
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isSelected ? kAccentBlue : kAccentBlue.withOpacity(0.2)
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: kAccentBlue.withOpacity(0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        ["Age", "Role", "Area"][i],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        _dropdownVisible &&
                                                _selectedIndex == i
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 💫 Redesigned Applicants List ---
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final appl = _filteredApplicants[index];
                      final isTop = index < 3;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        // Glass Card Wrapper
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kFieldColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: isTop
                                        ? kAccentBlue // Bright border for Top 3
                                        : kAccentBlue.withOpacity(0.2), // Subtle border for others
                                    width: isTop ? 1.5 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kAccentBlue.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(appl['avatar'] ?? ''),
                                    ),
                                    if (isTop)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: Container(
                                          height: 22,
                                          width: 22,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                kAccentBlue,
                                                kAccentBlue.withOpacity(0.6)
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: kAccentBlue.withOpacity(0.5),
                                                blurRadius: 5,
                                              )
                                            ]
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                title: Text(
                                  appl['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  '${appl['role']} • ${appl['ageGroup']} • ${appl['area']}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        kAccentBlue.withOpacity(0.15),
                                    foregroundColor: kAccentBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "View",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: _filteredApplicants.length),
                  ),
                ),
              ],
            ),

            // --- 💫 Redesigned Dropdown Menu ---
            if (_dropdownVisible)
              Positioned(
                left: _dropdownLeft ?? 16,
                top: _dropdownTop ?? 78,
                width: _dropdownWidth ??
                    MediaQuery.of(context).size.width - 32,
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // More blur
                      child: Container(
                        decoration: BoxDecoration(
                          color: kFieldColor.withOpacity(0.75), // More glassy
                          border: Border.all(color: kAccentBlue.withOpacity(0.5), width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: filterOptions[_selectedIndex]!
                              .map((option) {
                            final selected =
                                option == _selectedFilters[_selectedIndex];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedFilters[_selectedIndex] = option;
                                  _dropdownVisible = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? kAccentBlue.withOpacity(0.25)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}