import 'package:flutter/material.dart';
import 'trial_details_page.dart';
import 'trials_repository.dart';

import 'trials_theme.dart';

class TrialsPage extends StatefulWidget {
  const TrialsPage({Key? key}) : super(key: key);

  @override
  State<TrialsPage> createState() => _TrialsPageState();
}

class _TrialsPageState extends State<TrialsPage> {
  // Theme via shared constants
  final Color primaryColor = kPrimaryAccent;
  final Color backgroundColor = kTrialBackground;
  final Color borderColor = Colors.grey[400]!;

  TextEditingController searchController = TextEditingController();

  // Use repository for trials
  final repo = TrialsRepository.instance;
  List<Map<String, dynamic>> filteredTrials = [];

  @override
  void initState() {
    super.initState();
    filteredTrials = List<Map<String, dynamic>>.from(repo.ongoing.value);
    searchController.addListener(_onSearchChanged);
    // listen for changes
    repo.ongoing.addListener(() {
      setState(() {
        filteredTrials = List<Map<String, dynamic>>.from(repo.ongoing.value);
      });
    });
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTrials = repo.ongoing.value.where((trial) {
        return (trial['title'] ?? '').toLowerCase().contains(query) ||
            (trial['date'] ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  void _updateTrial(String id, Map<String, dynamic> updatedTrial) {
    repo.updateTrialById(id, updatedTrial);
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToTrialDetails(Map<String, dynamic> trial) async {
    final String id = trial['id'] ?? '';
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TrialDetailsPage(
          trial: trial,
          onEndTrial: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (id.isNotEmpty) repo.endTrialById(id);
            });
          },
          onUpdateTrial: (updatedTrial) {
            if (!mounted) return;
            if (id.isNotEmpty) _updateTrial(id, updatedTrial);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Trials Open',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: kSearchFieldDecoration(hint: 'Search trials'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTrials.length,
                itemBuilder: (context, index) {
                  final trial = filteredTrials[index];
                  return Container(
                    decoration: kCardDecoration(
                      color: backgroundColor.withOpacity(0.78),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          // image intentionally omitted — placeholder
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trial['title'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  trial['date'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _navigateToTrialDetails(trial),
                            style: kPrimaryButtonStyle(radius: 14),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
