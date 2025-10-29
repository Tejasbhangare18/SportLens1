import 'package:flutter/foundation.dart';

class PendingRepository {
  PendingRepository._();
  static final PendingRepository instance = PendingRepository._();

  final ValueNotifier<List<Map<String, dynamic>>> pending = ValueNotifier([]);

  void addApplication(Map<String, dynamic> app) {
    final a = Map<String, dynamic>.from(app);
    pending.value = [...pending.value, a];
  }

  void removeApplicationWhere(bool Function(Map<String, dynamic>) test) {
    pending.value = pending.value.where((p) => !test(p)).toList();
  }

  void clear() => pending.value = [];
}
