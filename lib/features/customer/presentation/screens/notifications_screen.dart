import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kBlue = Color(0xFF4A90E2);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class _Notif {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String text;
  final String time;
  bool read;
  _Notif({required this.icon, required this.iconColor, required this.iconBg, required this.text, required this.time, this.read = false});
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifs = [
    _Notif(icon: Icons.content_cut, iconColor: _kGold, iconBg: Color(0x22D4AF37), text: 'Your suit #TA2048 is now being stitched by Ravi Kumar.', time: '2 hours ago'),
    _Notif(icon: Icons.chat_bubble_outline, iconColor: _kBlue, iconBg: Color(0x224A90E2), text: 'New message from Tailor Priya S about your Kurta order.', time: '5 hours ago'),
    _Notif(icon: Icons.check_circle_outline, iconColor: Color(0xFF4CAF50), iconBg: Color(0x224CAF50), text: 'Slim Fit Trousers #TA2039 has been delivered successfully!', time: 'Apr 8 · 3:12 PM', read: true),
    _Notif(icon: Icons.notifications_outlined, iconColor: Color(0xFF8B3A62), iconBg: Color(0x228B3A62), text: 'Reminder: Your Kurta is expected to be ready by Apr 15.', time: 'Apr 7 · 9:00 AM', read: true),
    _Notif(icon: Icons.star_outline, iconColor: _kGold, iconBg: Color(0x22D4AF37), text: 'You haven\'t rated your last order yet. Share your feedback!', time: 'Apr 9 · 10:30 AM', read: true),
    _Notif(icon: Icons.local_shipping_outlined, iconColor: Color(0xFF4CAF50), iconBg: Color(0x224CAF50), text: 'Ravi Kumar has marked your suit as Ready for Pickup.', time: 'Apr 5 · 4:00 PM', read: true),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifs.where((n) => !n.read).length;
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 180,
            child: Image.network('https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200&h=400&fit=crop&q=80',
                fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B))),
          ),
          Positioned(top: 0, left: 0, right: 0, height: 220,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0])))),
          SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('UPDATES', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                    const SizedBox(height: 4),
                    Text('Notifications${unread > 0 ? '  ($unread)' : ''}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  ]),
                  const Spacer(),
                  if (unread > 0) GestureDetector(
                    onTap: () => setState(() { for (final n in _notifs) n.read = true; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(color: _kGold.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: _kGold.withOpacity(0.3))),
                      child: const Text('Mark all read', style: TextStyle(color: _kGold, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifs.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: _kBorder),
                  itemBuilder: (_, i) => _NotifTile(notif: _notifs[i], onTap: () => setState(() => _notifs[i].read = true)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onTap;
  const _NotifTile({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: notif.iconBg, shape: BoxShape.circle,
                border: Border.all(color: notif.iconColor.withOpacity(0.25))),
            child: Icon(notif.icon, size: 18, color: notif.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(notif.text, style: TextStyle(fontSize: 13, color: notif.read ? _kMuted : Colors.white, fontWeight: notif.read ? FontWeight.w400 : FontWeight.w500, height: 1.45)),
            const SizedBox(height: 4),
            Text(notif.time, style: const TextStyle(fontSize: 11, color: _kMuted)),
          ])),
          if (!notif.read)
            Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6, left: 8),
                decoration: const BoxDecoration(color: _kGold, shape: BoxShape.circle)),
        ]),
      ),
    );
  }
}
