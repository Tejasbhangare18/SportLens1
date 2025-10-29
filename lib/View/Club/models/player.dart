class Player {
  final String avatar;
  final String name;
  final String username;
  final String points; // display-friendly points (e.g. "1200")
  final int score; // numeric drills score or similar

  Player({
    required this.avatar,
    required this.name,
    required this.username,
    required this.points,
    required this.score,
  });

  factory Player.fromMap(Map<String, dynamic> m) => Player(
    avatar: m['avatar'] as String? ?? 'assets/avatar_placeholder.png',
    name: m['name'] as String? ?? '',
    username: m['username'] as String? ?? '',
    points: (m['points']?.toString() ?? '${m['score'] ?? ''}'),
    score:
        (m['score'] is int)
            ? (m['score'] as int)
            : int.tryParse('${m['score'] ?? 0}') ?? 0,
  );
}
