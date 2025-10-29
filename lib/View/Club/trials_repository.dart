import 'package:flutter/foundation.dart';

class TrialsRepository {
  TrialsRepository._privateConstructor();
  static final TrialsRepository instance =
      TrialsRepository._privateConstructor();

  // ongoing and completed lists as ValueNotifiers so UI can listen
  final ValueNotifier<List<Map<String, dynamic>>> ongoing = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> completed = ValueNotifier([]);

  void addTrial(Map<String, dynamic> trial) {
    final t = Map<String, dynamic>.from(trial);
    if (!t.containsKey('id')) {
      t['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    if (!t.containsKey('applicants')) t['applicants'] = [];
    ongoing.value = [...ongoing.value, t];
  }

  void updateTrialById(String id, Map<String, dynamic> updated) {
    final list =
        ongoing.value.map((t) {
          if (t['id'] == id) return {...t, ...updated};
          return t;
        }).toList();
    ongoing.value = list;
  }

  void endTrialById(String id) {
    final idx = ongoing.value.indexWhere((t) => t['id'] == id);
    if (idx == -1) return;
    final trial = ongoing.value[idx];
    final finished = Map<String, dynamic>.from(trial);
    finished['completedAt'] = DateTime.now().toIso8601String();
    // remove from ongoing
    final newOngoing = List<Map<String, dynamic>>.from(ongoing.value)
      ..removeAt(idx);
    ongoing.value = newOngoing;
    completed.value = [...completed.value, finished];
  }

  // optional: remove trial
  void removeTrialById(String id) {
    ongoing.value = ongoing.value.where((t) => t['id'] != id).toList();
  }
}
