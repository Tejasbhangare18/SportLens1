import 'package:flutter/material.dart';

class DrillsRepository {
  DrillsRepository._();
  static final instance = DrillsRepository._();

  // Each drill is a Map<String, dynamic> with keys: id, title, sport, skill, dateFrom, dateTo, description, players
  final ValueNotifier<List<Map<String, dynamic>>> ongoing = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> completed = ValueNotifier([]);

  void addDrill(Map<String, dynamic> drill) {
    ongoing.value = [...ongoing.value, drill];
  }

  void markFinished(String id) {
    final idx = ongoing.value.indexWhere((d) => d['id'] == id);
    if (idx == -1) return;
    final drill = ongoing.value[idx];
    final newOngoing = [...ongoing.value]..removeAt(idx);
    ongoing.value = newOngoing;
    completed.value = [...completed.value, drill];
  }

  void addPlayerToDrill(String id, Map<String, dynamic> player) {
    final idx = ongoing.value.indexWhere((d) => d['id'] == id);
    if (idx == -1) return;
    final d = Map<String, dynamic>.from(ongoing.value[idx]);
    final players = List<Map<String, dynamic>>.from(d['players'] ?? []);
    players.add(player);
    d['players'] = players;
    final copy = [...ongoing.value];
    copy[idx] = d;
    ongoing.value = copy;
  }
}
