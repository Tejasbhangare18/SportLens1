import 'package:flutter/material.dart';

// StarRow same as before (uses Material Icons)
class StarRow extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final Color emptyColor;

  const StarRow({
    super.key,
    required this.rating,
    this.size = 16,
    this.color = Colors.amber,
    this.emptyColor = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData icon;
      if (rating >= i) {
        icon = Icons.star_rounded;
      } else if (rating > i - 1 && rating < i) {
        icon = Icons.star_half_rounded;
      } else {
        icon = Icons.star_border_rounded;
      }
      stars.add(
        Icon(
          icon,
          size: size,
          color: icon == Icons.star_border_rounded ? emptyColor : color,
        ),
      );
    }
    return Row(children: stars);
  }
}

class ClubReviewsPage extends StatefulWidget {
  const ClubReviewsPage({super.key});

  @override
  State<ClubReviewsPage> createState() => _ClubReviewsPageState();
}

class _ClubReviewsPageState extends State<ClubReviewsPage> {
  final Color bg = const Color(0xFF121B26);
  final Color card = const Color(0xFF0D1318);
  final Color primary = const Color(0xFF348AFF);

  String query = '';
  String selectedFilter = 'All';
  String selectedSort = 'Newest';

  // Mock club-level reviews sample
  final List<Map<String, dynamic>> reviews = [
    {
      'author': 'Priya M.',
      'rating': 5.0,
      'date': DateTime(2025, 9, 25),
      'text': 'Great organisation, clear communication and friendly coaches.',
      'status': 'visible', // visible | hidden | pending
      'reply': 'Thanks Priya! Glad you enjoyed the session.',
      'id': 'R001',
    },
    {
      'author': 'Rahul D.',
      'rating': 4.0,
      'date': DateTime(2025, 9, 20),
      'text': 'Good experience overall, facilities could improve.',
      'status': 'visible',
      'reply': null,
      'id': 'R002',
    },
    {
      'author': 'Anita S.',
      'rating': 2.5,
      'date': DateTime(2025, 8, 30),
      'text': 'Long waiting times to join trials, response slow.',
      'status': 'pending',
      'reply': null,
      'id': 'R003',
    },
  ];

  List<Map<String, dynamic>> get filtered {
    var list =
        reviews.where((r) {
          final q = query.toLowerCase();
          return r['author'].toString().toLowerCase().contains(q) ||
              r['text'].toString().toLowerCase().contains(q);
        }).toList();

    if (selectedFilter != 'All') {
      if (selectedFilter == 'Visible') {
        list = list.where((r) => r['status'] == 'visible').toList();
      } else if (selectedFilter == 'Hidden') {
        list = list.where((r) => r['status'] == 'hidden').toList();
      } else if (selectedFilter == 'Pending') {
        list = list.where((r) => r['status'] == 'pending').toList();
      } else {
        final star = int.tryParse(selectedFilter[0]) ?? 0;
        list =
            list.where((r) => (r['rating'] as double).floor() == star).toList();
      }
    }

    list.sort((a, b) {
      final da = a['date'] as DateTime;
      final db = b['date'] as DateTime;
      if (selectedSort == 'Newest') return db.compareTo(da);
      if (selectedSort == 'Oldest') return da.compareTo(db);
      final ra = a['rating'] as double;
      final rb = b['rating'] as double;
      if (selectedSort == 'Highest') return rb.compareTo(ra);
      return ra.compareTo(rb);
    });

    return list;
  }

  double get average {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<double>(
      0,
      (acc, r) => acc + (r['rating'] as double),
    );
    return double.parse((sum / reviews.length).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'Club Reviews',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _summaryCard(),
          const SizedBox(height: 12),
          _searchAndFilters(),
          const SizedBox(height: 12),
          ...filtered.map(_reviewTile).toList(),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: const [
                  Icon(
                    Icons.rate_review_outlined,
                    color: Colors.white38,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No reviews yet',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    final breakdown = _breakdown();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    average.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StarRow(rating: average, size: 16),
                  const SizedBox(height: 4),
                  Text(
                    '${reviews.length} ratings',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = breakdown[star] ?? 0;
                final pct = reviews.isEmpty ? 0.0 : count / reviews.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 48,
                        child: Row(
                          children: [
                            Text(
                              '$star',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 10,
                            backgroundColor: Colors.white12,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 28,
                        child: Text(
                          count.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Map<int, int> _breakdown() {
    final map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      map[(r['rating'] as double).round()] =
          (map[(r['rating'] as double).round()] ?? 0) + 1;
    }
    return map;
  }

  Widget _searchAndFilters() {
    final filterChips = [
      'All',
      'Visible',
      'Hidden',
      'Pending',
      '5★',
      '4★',
      '3★',
      '2★',
      '1★',
    ];
    final sortChips = ['Newest', 'Oldest', 'Highest', 'Lowest'];
    return Column(
      children: [
        TextField(
          onChanged: (v) => setState(() => query = v),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search reviews or authors',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: card,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary.withOpacity(0.6)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filterChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final label = filterChips[i];
              final selected = selectedFilter == label;
              return ChoiceChip(
                label: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                  ),
                ),
                selected: selected,
                onSelected: (_) => setState(() => selectedFilter = label),
                selectedColor: Colors.blueAccent,
                backgroundColor: card,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: selected ? Colors.blueAccent : Colors.white24,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sortChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final label = sortChips[i];
              final selected = selectedSort == label;
              return ChoiceChip(
                label: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                  ),
                ),
                selected: selected,
                onSelected: (_) => setState(() => selectedSort = label),
                selectedColor: primary,
                backgroundColor: card,
                shape: StadiumBorder(
                  side: BorderSide(color: selected ? primary : Colors.white24),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _reviewTile(Map<String, dynamic> r) {
    final author = r['author'] as String;
    final rating = r['rating'] as double;
    final date = r['date'] as DateTime;
    final text = r['text'] as String;
    final status = r['status'] as String;
    final reply = r['reply'] as String?;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white10,
                child: Text(
                  author
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join()
                      .toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _friendlyDate(date),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      status == 'visible'
                          ? Colors.green.withOpacity(0.12)
                          : status == 'hidden'
                          ? Colors.red.withOpacity(0.12)
                          : Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white70),
                color: card,
                onSelected: (v) {
                  if (v == 'delete') {
                    setState(
                      () => reviews.removeWhere((e) => e['id'] == r['id']),
                    );
                  } else if (v == 'hide') {
                    setState(() => r['status'] = 'hidden');
                  } else if (v == 'approve') {
                    setState(() => r['status'] = 'visible');
                  }
                },
                itemBuilder:
                    (_) => [
                      const PopupMenuItem(
                        value: 'approve',
                        child: Text('Approve'),
                      ),
                      const PopupMenuItem(value: 'hide', child: Text('Hide')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          StarRow(rating: rating, size: 18),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: Colors.white70)),
          if (reply != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.reply_rounded,
                    size: 18,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reply,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _openReplySheet(r),
                icon: const Icon(Icons.reply, color: Colors.white70),
                label: const Text(
                  'Reply',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed:
                    () => setState(
                      () =>
                          r['status'] =
                              r['status'] == 'visible' ? 'hidden' : 'visible',
                    ),
                icon: Icon(
                  r['status'] == 'visible'
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white70,
                ),
                label: Text(
                  r['status'] == 'visible' ? 'Hide' : 'Unhide',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openReplySheet(Map<String, dynamic> r) {
    final ctrl = TextEditingController(text: r['reply'] as String?);
    showModalBottomSheet(
      context: context,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Reply to Review',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write a response...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          r['reply'] = ctrl.text.trim();
                          r['status'] = 'visible';
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      child: const Text('Send Reply'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _friendlyDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
