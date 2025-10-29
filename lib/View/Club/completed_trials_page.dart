import 'package:flutter/material.dart';
import 'trial_results_page.dart';
import 'trials_repository.dart';
import 'trials_theme.dart';

class CompletedTrialsPage extends StatefulWidget {
  const CompletedTrialsPage({Key? key}) : super(key: key);

  @override
  State<CompletedTrialsPage> createState() => _CompletedTrialsPageState();
}

class _CompletedTrialsPageState extends State<CompletedTrialsPage> {
  String _searchQuery = '';

  void _updateSearch(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  // old string-based grouping removed; using dynamic grouping for repository-backed data

  String _convertToIsoDate(String input) {
    var parts = input.split('/');
    return "${parts[2]}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}";
  }

  String _monthName(int num) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[num - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTrialBackground,
      appBar: AppBar(
        backgroundColor: kTrialBackground,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text(
          'Completed',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _updateSearch,
              style: const TextStyle(color: Colors.white),
              decoration: kSearchFieldDecoration(hint: 'Search trials'),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: TrialsRepository.instance.completed,
              builder: (context, completed, _) {
                // Apply search filtering
                final filtered =
                    completed.where((t) {
                      final title = (t['title'] ?? '').toString().toLowerCase();
                      final date = (t['date'] ?? '').toString().toLowerCase();
                      if (_searchQuery.isEmpty) return true;
                      return title.contains(_searchQuery) ||
                          date.contains(_searchQuery);
                    }).toList();

                final grouped = _groupTrialsByMonthYearDynamic(filtered);
                final months = grouped.keys.toList();
                months.sort((a, b) {
                  final da = DateTime.parse(
                    "${b.split(' ')[1]}-${_monthNumber(b.split(' ')[0])}-01",
                  );
                  final db = DateTime.parse(
                    "${a.split(' ')[1]}-${_monthNumber(a.split(' ')[0])}-01",
                  );
                  return da.compareTo(db);
                });

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No completed trials',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final month = months[index];
                    final trials = grouped[month]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            month,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...trials.map(
                          (trial) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trial['title']?.toString() ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        trial['date']?.toString() ?? '',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => TrialResultsPage(
                                              trialTitle:
                                                  trial['title']?.toString() ??
                                                  'Trial',
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[800],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: const Text(
                                    'View Results',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index != months.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: DottedLine(color: Colors.white30, height: 1),
                          ),
                      ],
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

  Map<String, List<Map<String, dynamic>>> _groupTrialsByMonthYearDynamic(
    List<Map<String, dynamic>> trials,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var trial in trials) {
      final dt =
          DateTime.tryParse(
            _convertToIsoDate(trial['date']?.toString() ?? ''),
          ) ??
          DateTime.now();
      final monthYear = "${_monthName(dt.month)} ${dt.year}";
      grouped.putIfAbsent(monthYear, () => []);
      grouped[monthYear]!.add(trial);
    }
    return grouped;
  }

  String _monthNumber(String name) {
    const mapping = {
      'January': '01',
      'February': '02',
      'March': '03',
      'April': '04',
      'May': '05',
      'June': '06',
      'July': '07',
      'August': '08',
      'September': '09',
      'October': '10',
      'November': '11',
      'December': '12',
    };
    return mapping[name] ?? '01';
  }
}

class DottedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DottedLine({Key? key, this.height = 1, this.color = Colors.black})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedLinePainter(color),
      size: Size(double.infinity, height),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  _DottedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = size.height;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
