import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class _Message {
  final String text;
  final bool isMe;
  final String time;
  _Message({required this.text, required this.isMe, required this.time});
}

class _TailorThread {
  final String name;
  final String initials;
  final Color avatarBg;
  final String orderInfo;
  final List<_Message> messages;
  _TailorThread({required this.name, required this.initials, required this.avatarBg, required this.orderInfo, required this.messages});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedThread = 0;
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_TailorThread> _threads = [
    _TailorThread(
      name: 'Ravi Kumar', initials: 'RK', avatarBg: AppColors.gold, orderInfo: 'Order #TA2048',
      messages: [
        _Message(text: 'Hello Jerron! Your suit fabric has been cut. Stitching starts tomorrow.', isMe: false, time: '10:23 AM'),
        _Message(text: 'Great! Can you do a slim fit around the chest?', isMe: true, time: '10:45 AM'),
        _Message(text: 'Yes, noted. I\'ll take it in by 1 inch at the chest seam. Any other changes?', isMe: false, time: '11:02 AM'),
        _Message(text: 'No, that\'s all. Thanks!', isMe: true, time: '11:05 AM'),
      ],
    ),
    _TailorThread(
      name: 'Priya Sharma', initials: 'PS', avatarBg: const Color(0xFF8B3A62), orderInfo: 'Order #TA2049',
      messages: [
        _Message(text: 'Hi! I received your kurta order. What shade of white do you prefer?', isMe: false, time: '9:15 AM'),
        _Message(text: 'Off-white please, not pure white.', isMe: true, time: '9:22 AM'),
        _Message(text: 'Perfect. Shall I add a Nehru collar or regular?', isMe: false, time: '9:25 AM'),
      ],
    ),
  ];

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    setState(() {
      _threads[_selectedThread].messages.add(_Message(text: _msgCtrl.text.trim(), isMe: true, time: TimeOfDay.now().format(context)));
      _msgCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () => _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() => _threads[_selectedThread].messages.add(_Message(text: "Thanks! I'll update you shortly.", isMe: false, time: TimeOfDay.now().format(context))));
      Future.delayed(const Duration(milliseconds: 100), () => _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut));
    });
  }

  @override
  Widget build(BuildContext context) {
    final thread = _threads[_selectedThread];
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Chat with Tailor'),
        backgroundColor: AppColors.thread,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: List.generate(_threads.length, (i) {
                final t = _threads[i];
                final sel = _selectedThread == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedThread = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.gold : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t.name, style: TextStyle(fontSize: 12, color: sel ? Colors.white : Colors.white70, fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Chat header ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(children: [
              AvatarCircle(initials: thread.initials, bg: thread.avatarBg, fg: Colors.white, size: 40, fontSize: 15),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(thread.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.thread)),
                Text('Online · ${thread.orderInfo}', style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
              ]),
              const Spacer(),
              IconButton(icon: const Icon(Icons.call_outlined, color: AppColors.taupe, size: 20), onPressed: () {}),
              IconButton(icon: const Icon(Icons.image_outlined, color: AppColors.taupe, size: 20), onPressed: () {}),
            ]),
          ),
          // ── Messages ─────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: thread.messages.length,
              itemBuilder: (_, i) {
                final m = thread.messages[i];
                return Align(
                  alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: m.isMe ? AppColors.thread : AppColors.sand,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(m.isMe ? 12 : 2),
                        bottomRight: Radius.circular(m.isMe ? 2 : 12),
                      ),
                    ),
                    child: Column(crossAxisAlignment: m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                      Text(m.text, style: TextStyle(fontSize: 13, color: m.isMe ? AppColors.cream : AppColors.thread, height: 1.4)),
                      const SizedBox(height: 3),
                      Text(m.time, style: TextStyle(fontSize: 10, color: m.isMe ? Colors.white54 : AppColors.taupe)),
                    ]),
                  ),
                );
              },
            ),
          ),
          // ── Input ─────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).viewInsets.bottom + 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black.withOpacity(0.08), width: 0.5)),
            ),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.image_outlined, color: AppColors.taupe), onPressed: () {}),
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  decoration: const InputDecoration(hintText: 'Type a message…', contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                  style: const TextStyle(fontSize: 13),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
