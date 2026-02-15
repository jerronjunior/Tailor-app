import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/data/models/message_model.dart';
import 'package:tailor_app/data/services/chat_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

/// Same chat UI as customer chat; tailor uses this route.
class TailorChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const TailorChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<TailorChatScreen> createState() => _TailorChatScreenState();
}

class _TailorChatScreenState extends ConsumerState<TailorChatScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();
    final messagesStream = chatService.streamMessages(widget.chatId);
    final currentUserId = ref.watch(currentUserProvider)?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Say hello!'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final m = messages[i];
                    final isMe = m.senderId == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(m.message),
                            Text(
                              DateFormat.Hm().format(m.timestamp),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(ref, chatService),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _send(ref, chatService),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _send(WidgetRef ref, ChatService chatService) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final uid = ref.read(currentUserProvider)?.id;
    if (uid == null) return;
    chatService.sendMessage(
      chatId: widget.chatId,
      senderId: uid,
      text: text,
    );
    _textController.clear();
  }
}
