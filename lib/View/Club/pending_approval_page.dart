import 'package:flutter/material.dart';
import 'pending_repository.dart';
import 'trials_theme.dart';
import 'package:flutter/services.dart';

class PendingApprovalPage extends StatefulWidget {
  final Function(Map<String, String>)? onApplicantApproved;

  const PendingApprovalPage({Key? key, this.onApplicantApproved})
    : super(key: key);

  @override
  State<PendingApprovalPage> createState() => _PendingApprovalPageState();
}

class _PendingApprovalPageState extends State<PendingApprovalPage> {
  TextEditingController searchController = TextEditingController();

  // Use the shared pending repository as the source of truth
  // seed some sample data if empty (keeps behavior consistent)
  @override
  void initState() {
    super.initState();
    if (PendingRepository.instance.pending.value.isEmpty) {
      PendingRepository.instance.pending.value = [
        {
          'name': 'Ethan Carter',
          'trial': 'Batsman',
          'area': 'West Side',
          'image': 'assets/images/user1.png',
        },
        {
          'name': 'Liam Harper',
          'trial': 'Bowler',
          'area': 'East End',
          'image': 'assets/images/user2.png',
        },
        {
          'name': 'Noah Bennett',
          'trial': 'Wicketkeeper',
          'area': 'North Zone',
          'image': 'assets/images/user3.png',
        },
      ];
    }
    searchController.addListener(_filterApplications);
  }

  String selectedRole = 'All';
  String selectedArea = 'All';

  // Expanded state for capsule headers
  bool _rolesExpanded = false;
  bool _areasExpanded = false;

  // Expanded roles list
  final List<String> roles = [
    'All',
    'Batsman',
    'Bowler',
    'Wicketkeeper',
    'All-Rounder',
  ];

  // Expanded areas list
  final List<String> areas = [
    'All',
    'West Side',
    'East End',
    'North Zone',
    'South Park',
    'Central City',
  ];

  void _filterApplications() {
    setState(() {
      // trigger rebuild; actual filtering is computed in _visibleApplications
    });
  }

  // Note: clear filters was removed; use the capsule headers to reset selections.

  List<Map<String, String>> _visibleApplications() {
    final query = searchController.text.toLowerCase();
    final apps =
        PendingRepository.instance.pending.value
            .map((e) => Map<String, String>.from(e.cast<String, String>()))
            .toList();

    return apps.where((app) {
      final matchesSearch =
          app['name']!.toLowerCase().contains(query) ||
          app['trial']!.toLowerCase().contains(query) ||
          (app['area'] ?? '').toLowerCase().contains(query);

      final matchesRole = selectedRole == 'All' || app['trial'] == selectedRole;
      final matchesArea = selectedArea == 'All' || app['area'] == selectedArea;

      return matchesSearch && matchesRole && matchesArea;
    }).toList();
  }

  void _approve(int index) {
    final visible = _visibleApplications();
    if (index < 0 || index >= visible.length) return;
    final approvedApplicant = visible[index];

    widget.onApplicantApproved?.call(approvedApplicant);

    // remove from repository
    PendingRepository.instance.removeApplicationWhere((app) {
      return app['name'] == approvedApplicant['name'] &&
          app['trial'] == approvedApplicant['trial'] &&
          app['area'] == approvedApplicant['area'];
    });

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${approvedApplicant['name']} approved'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  void _reject(int index) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF16181E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Confirm Rejection",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Provide a reason for rejection (optional):",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  minLines: 2,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter reason...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF22242B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    final visible = _visibleApplications();
                    final rejectedApplicant = visible[index];
                    PendingRepository.instance.removeApplicationWhere((app) {
                      return app['name'] == rejectedApplicant['name'] &&
                          app['trial'] == rejectedApplicant['trial'] &&
                          app['area'] == rejectedApplicant['area'];
                    });
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Rejection confirmed'),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Confirm Reject",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOptionsRow(
    List<String> options,
    String selected,
    Function(String) onSelected,
  ) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          final option = options[idx];
          final isSelected = option == selected;
          return GestureDetector(
            onTap: () {
              onSelected(option);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryAccent : kGrey800,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: options.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = kPrimaryAccent;

    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        backgroundColor: kTrialBackground,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kTrialBackground,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Pending Approval',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: kSearchFieldDecoration(hint: 'Search applications'),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => _filterApplications(),
            ),
          ),
          // Capsule-style horizontal tab row (compact, scrollable)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Role capsule
                  GestureDetector(
                    onTap:
                        () => setState(() {
                          _rolesExpanded = !_rolesExpanded;
                          if (_rolesExpanded) _areasExpanded = false;
                        }),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kGrey900,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Role: ${selectedRole}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _rolesExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sport capsule (visual placeholder; currently non-filtering)
                  GestureDetector(
                    onTap:
                        () => setState(() {
                          // keep compact behavior; open roles panel as placeholder
                          _rolesExpanded = !_rolesExpanded;
                          if (_rolesExpanded) _areasExpanded = false;
                        }),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kGrey900,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Sport: All',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Area capsule
                  GestureDetector(
                    onTap:
                        () => setState(() {
                          _areasExpanded = !_areasExpanded;
                          if (_areasExpanded) _rolesExpanded = false;
                        }),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kGrey900,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Area: ${selectedArea}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _areasExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded options (roles)
          if (_rolesExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: _buildFilterOptionsRow(roles, selectedRole, (val) {
                setState(() {
                  selectedRole = val;
                  _filterApplications();
                });
              }),
            ),
          // Expanded options (areas)
          if (_areasExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: _buildFilterOptionsRow(areas, selectedArea, (val) {
                setState(() {
                  selectedArea = val;
                  _filterApplications();
                });
              }),
            ),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: PendingRepository.instance.pending,
              builder: (context, pending, _) {
                final visible = _visibleApplications();
                return ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final app = visible[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Card(
                        color: const Color(0xFF1B2231),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    (app['image'] != null &&
                                            app['image']!.startsWith('assets/'))
                                        ? AssetImage(app['image']!)
                                        : null,
                                backgroundColor: Colors.grey[800],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app['name'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      app['trial'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _approve(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(70, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Approve',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _reject(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(70, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
