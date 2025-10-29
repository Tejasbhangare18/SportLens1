import 'package:flutter/material.dart';

const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kNewAccentCyan = Color(0xFF00A8E8);
const Color kPrimaryText = Colors.white;

class ChatPage extends StatelessWidget {
  final String? coachName;
  const ChatPage({super.key, this.coachName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        title: Text('Chat with ${coachName ?? 'Coach'}', style: const TextStyle(color: kPrimaryText)),
        iconTheme: const IconThemeData(color: kPrimaryText),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                // Placeholder messages
                Align(
                  alignment: Alignment.centerLeft,
                  child: _ChatBubble(text: 'Hi! This is a placeholder chat screen.', isMe: false),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _ChatBubble(text: 'Thanks — chat feature coming soon.', isMe: true),
                ),
              ],
            ),
          ),
          Container(
            color: kFieldColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: kPrimaryText),
                    decoration: const InputDecoration(hintText: 'Type a message...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send, color: kNewAccentCyan),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  const _ChatBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? kNewAccentCyan : Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: kPrimaryText)),
    );
  }
}
