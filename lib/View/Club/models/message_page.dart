import 'package:flutter/material.dart';
import '../messages_repository.dart';

class MessagePage extends StatefulWidget {
  final String conversationId;
  final String playerName;
  const MessagePage({
    Key? key,
    required this.conversationId,
    required this.playerName,
  }) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final ValueNotifier<List<ChatMessage>> _messages;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages = MessagesRepository.instance.conversation(widget.conversationId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final txt = _controller.text.trim();
    if (txt.isEmpty) return;
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: 'club',
      text: txt,
    );
    MessagesRepository.instance.send(widget.conversationId, msg);
    _controller.clear();
    // simulate player reply
    Future.delayed(const Duration(milliseconds: 700), () {
      final reply = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        from: 'player',
        text: 'Thanks, received: $txt',
      );
      MessagesRepository.instance.send(widget.conversationId, reply);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playerName),
        backgroundColor: const Color(0xFF1A2531),
      ),
      backgroundColor: const Color(0xFF0F1620),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<ChatMessage>>(
              valueListenable: _messages,
              builder: (context, msgs, _) {
                return ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[index];
                    final isMe = m.from == 'club';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.blueAccent
                                : const Color(0xFF23252B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${m.timestamp.hour.toString().padLeft(2, '0')}:${m.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF16181E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _send,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
