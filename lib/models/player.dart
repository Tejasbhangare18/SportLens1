class Player {
  final int rank;
  final String name;
  final String username;
  final int score;
  final String avatar;
  final String points;
  final int level;
  final String age;
  final String sport;
  final String role;
  final int? change;

  Player({
    required this.rank,
    required this.name,
    required this.username,
    required this.score,
    required this.avatar,
    required this.points,
    required this.level,
    required this.age,
    required this.sport,
    required this.role,
    this.change, required String team,
  });

  bool? get isEmpty => null;

  bool? get isNotEmpty => null;

  // Keep a typed getter if other code expects `.age` as a property (already defined above)
  String getAge() => age;
}
