import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String from; // 'club' or 'player' or user id
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.from,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class MessagesRepository {
  MessagesRepository._();
  static final instance = MessagesRepository._();

  // Map of conversationId -> ValueNotifier<List<ChatMessage>>
  final Map<String, ValueNotifier<List<ChatMessage>>> _conversations = {};

  ValueNotifier<List<ChatMessage>> conversation(String id) {
    return _conversations.putIfAbsent(
      id,
      () => ValueNotifier<List<ChatMessage>>([]),
    );
  }

  void send(String conversationId, ChatMessage message) {
    final conv = conversation(conversationId);
    conv.value = [...conv.value, message];
  }
}
