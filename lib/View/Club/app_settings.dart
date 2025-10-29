import 'package:flutter/material.dart';

class AppSettings {
  AppSettings._();
  static final instance = AppSettings._();

  final ValueNotifier<bool> darkMode = ValueNotifier<bool>(true);
  final ValueNotifier<String> language = ValueNotifier<String>('English (US)');

  // Simple account fields
  final ValueNotifier<String> username = ValueNotifier<String>('club_admin');
  final ValueNotifier<String> email = ValueNotifier<String>('admin@club.com');
  final ValueNotifier<String> phone = ValueNotifier<String>('+1234567890');
  final ValueNotifier<bool> privateAccount = ValueNotifier<bool>(false);
}
