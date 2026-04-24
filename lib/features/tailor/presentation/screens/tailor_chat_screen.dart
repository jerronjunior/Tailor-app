import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/data/models/message_model.dart';
import 'package:tailor_app/data/services/chat_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

const _kBg     = Color(0xFF0D1B2A);
const _kCard   = Color(0xFF1A2B3C);
const _kGold   = Color(0xFFD4AF37);
const _kBlue   = Color(0xFF4A90E2);
const _kMuted  = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class TailorChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  const TailorChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<TailorChatScreen> createState() => _TailorChatScreenState();
}

class _TailorChatScreenState extends ConsumerState<TailorChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatService   = ChatService();
    final messagesStream = chatService.streamMessages(widget.chatId);
    final currentUserId = ref.watch(currentUserProvider)?.id;
    final currentUser   = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
              decoration: BoxDecoration(
                color: _kCard,
                border: Border(bottom: BorderSide(color: _kBorder)),
              ),
              child: Row(children: [
                // Back button
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _kBorder),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 6),
                // Customer avatar
                Stack(children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(bottom: 1, right: 1, child: Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: _kCard, width: 1.5),
                    ),
                  )),
                ]),
                const SizedBox(width: 12),
                // Name & status
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Customer', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  Row(children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    const Text('Online', style: TextStyle(color: _kMuted, fontSize: 11)),
                  ]),
                ])),
                // Call & image buttons
                IconButton(icon: const Icon(Icons.call_outlined, color: _kMuted, size: 20), onPressed: () {}),
                IconButton(icon: const Icon(Icons.image_outlined, color: _kMuted, size: 20), onPressed: () {}),
              ]),
            ),

            // ── Context banner ─────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: _kGold.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kGold.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.receipt_long_outlined, color: _kGold, size: 14),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Chat ID: ${widget.chatId.length > 16 ? widget.chatId.substring(0, 16) + '…' : widget.chatId}',
                  style: const TextStyle(color: _kGold, fontSize: 11, fontWeight: FontWeight.w600),
                )),
                const Icon(Icons.open_in_new, color: _kGold, size: 13),
              ]),
            ),

            // ── Messages ──────────────────────────────────────
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: messagesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: _kGold, strokeWidth: 2),
                    );
                  }

                  final messages = snapshot.data!;

                  if (messages.isEmpty) {
                    return _EmptyChat();
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m    = messages[i];
                      final isMe = m.senderId == currentUserId;

                      // Date separator
                      final showDate = i == 0 ||
                          !_isSameDay(messages[i - 1].timestamp, m.timestamp);

                      return Column(
                        children: [
                          if (showDate) _DateDivider(date: m.timestamp),
                          _MessageBubble(message: m, isMe: isMe),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // ── Input bar ─────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(12, 10, 12, MediaQuery.of(context).viewInsets.bottom + 12),
              decoration: BoxDecoration(
                color: _kCard,
                border: Border(top: BorderSide(color: _kBorder)),
              ),
              child: Row(children: [
                // Attach button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kBorder),
                    ),
                    child: const Icon(Icons.attach_file_rounded, color: _kMuted, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                // Text field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white, fontSize: 13.5),
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      hintStyle: const TextStyle(color: _kMuted, fontSize: 13.5),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: _kBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: _kBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: _kGold, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    ),
                    onSubmitted: (_) => _send(ref, chatService),
                  ),
                ),
                const SizedBox(width: 10),
                // Send button
                GestureDetector(
                  onTap: () => _send(ref, chatService),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: _kGold, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _send(WidgetRef ref, ChatService chatService) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final uid = ref.read(currentUserProvider)?.id;
    if (uid == null) return;
    chatService.sendMessage(chatId: widget.chatId, senderId: uid, text: text);
    _textController.clear();
    _scrollToBottom();
  }
}

// ── Message bubble ────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? _kGold.withOpacity(0.14) : _kCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 3),
            bottomRight: Radius.circular(isMe ? 3 : 16),
          ),
          border: Border.all(color: isMe ? _kGold.withOpacity(0.3) : _kBorder),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                fontSize: 13.5,
                color: isMe ? Colors.white : Colors.white.withOpacity(0.9),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.Hm().format(message.timestamp),
                  style: const TextStyle(fontSize: 10, color: _kMuted),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all_rounded, size: 13, color: _kGold),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date divider ──────────────────────────────────────────────────────
class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  String _label() {
    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d     = DateTime(date.year, date.month, date.day);
    if (d == today)                                       return 'Today';
    if (d == today.subtract(const Duration(days: 1)))    return 'Yesterday';
    return DateFormat.MMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(child: Divider(color: _kBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _kCard, borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kBorder),
            ),
            child: Text(_label(), style: const TextStyle(color: _kMuted, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ),
        Expanded(child: Divider(color: _kBorder)),
      ]),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────
class _EmptyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(
          color: _kBlue.withOpacity(0.08), shape: BoxShape.circle,
          border: Border.all(color: _kBlue.withOpacity(0.25)),
        ),
        child: const Icon(Icons.chat_bubble_outline, color: _kBlue, size: 32),
      ),
      const SizedBox(height: 14),
      const Text('No messages yet', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 5),
      const Text('Start the conversation with your customer', style: TextStyle(color: _kMuted, fontSize: 12)),
    ]),
  );
}
