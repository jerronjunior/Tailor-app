import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class _Message {
  final String text;
  final bool isMe;
  final String time;
  _Message({required this.text, required this.isMe, required this.time});
}

class _TailorThread {
  final String name;
  final String photoUrl;
  final Color avatarBg;
  final String orderInfo;
  final List<_Message> messages;
  _TailorThread({required this.name, required this.photoUrl, required this.avatarBg, required this.orderInfo, required this.messages});
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
      name: 'Ravi Kumar',
      photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&q=80',
      avatarBg: _kGold, orderInfo: 'Order #TA2048',
      messages: [
        _Message(text: 'Hello Jerron! Your suit fabric has been cut. Stitching starts tomorrow.', isMe: false, time: '10:23 AM'),
        _Message(text: 'Great! Can you do a slim fit around the chest?', isMe: true, time: '10:45 AM'),
        _Message(text: 'Yes, noted. I\'ll take it in by 1 inch at the chest seam. Any other changes?', isMe: false, time: '11:02 AM'),
        _Message(text: 'No, that\'s all. Thanks!', isMe: true, time: '11:05 AM'),
      ],
    ),
    _TailorThread(
      name: 'Priya Sharma',
      photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&h=200&fit=crop&q=80',
      avatarBg: const Color(0xFF8B3A62), orderInfo: 'Order #TA2049',
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
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _threads[_selectedThread].messages.add(_Message(text: "Thanks! I'll update you shortly.", isMe: false, time: TimeOfDay.now().format(context))));
      Future.delayed(const Duration(milliseconds: 100), () => _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut));
    });
  }

  @override
  Widget build(BuildContext context) {
    final thread = _threads[_selectedThread];
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('MESSAGES', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                      SizedBox(height: 2),
                      Text('Chat with Tailor', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ]),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.call_outlined, color: _kMuted), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.image_outlined, color: _kMuted), onPressed: () {}),
                  ]),
                  const SizedBox(height: 12),
                  // Thread tabs
                  Row(
                    children: List.generate(_threads.length, (i) {
                      final t = _threads[i];
                      final sel = _selectedThread == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedThread = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? _kGold.withOpacity(0.15) : _kCard,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: sel ? _kGold.withOpacity(0.5) : _kBorder),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(width: 22, height: 22,
                                  child: Image.network(t.photoUrl, fit: BoxFit.cover,
                                      loadingBuilder: (_, c, p) => p == null ? c : Container(color: t.avatarBg.withOpacity(0.3))),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(t.name.split(' ').first, style: TextStyle(fontSize: 12, color: sel ? _kGold : _kMuted, fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                            ]),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  // Chat partner info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: _kBorder)),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(width: 44, height: 44,
                          child: Image.network(thread.photoUrl, fit: BoxFit.cover,
                              loadingBuilder: (_, c, p) => p == null ? c : Container(color: thread.avatarBg.withOpacity(0.3)))),
                      ),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(thread.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                        Row(children: [
                          Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text('Online · ${thread.orderInfo}', style: const TextStyle(fontSize: 11, color: _kMuted)),
                        ]),
                      ]),
                    ]),
                  ),
                ],
              ),
            ),

            // ── Messages ────────────────────────────────────────
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
                        color: m.isMe ? _kGold.withOpacity(0.15) : _kCard,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(m.isMe ? 14 : 2),
                          bottomRight: Radius.circular(m.isMe ? 2 : 14),
                        ),
                        border: Border.all(color: m.isMe ? _kGold.withOpacity(0.3) : _kBorder),
                      ),
                      child: Column(crossAxisAlignment: m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                        Text(m.text, style: TextStyle(fontSize: 13, color: m.isMe ? Colors.white : Colors.white.withOpacity(0.9), height: 1.45)),
                        const SizedBox(height: 4),
                        Text(m.time, style: const TextStyle(fontSize: 10, color: _kMuted)),
                      ]),
                    ),
                  );
                },
              ),
            ),

            // ── Input ───────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).viewInsets.bottom + 12),
              decoration: BoxDecoration(color: _kCard, border: Border(top: BorderSide(color: _kBorder))),
              child: Row(children: [
                IconButton(icon: const Icon(Icons.image_outlined, color: _kMuted), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      hintStyle: const TextStyle(color: _kMuted, fontSize: 13),
                      filled: true, fillColor: Colors.white.withOpacity(0.06),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: _kBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: _kBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _kGold)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
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
}
