import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Notif {
  final IconData icon;
  final Color iconBg;
  final String text;
  final String time;
  bool read;
  _Notif({required this.icon, required this.iconBg, required this.text, required this.time, this.read = false});
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifs = [
    _Notif(icon: Icons.content_cut, iconBg: AppColors.badgeAmberBg, text: 'Your suit #TA2048 is now being stitched by Ravi Kumar.', time: '2 hours ago'),
    _Notif(icon: Icons.chat_bubble_outline, iconBg: AppColors.badgeBlueBg, text: 'New message from Tailor Priya S about your Kurta order.', time: '5 hours ago'),
    _Notif(icon: Icons.check_circle_outline, iconBg: AppColors.badgeGreenBg, text: 'Slim Fit Trousers #TA2039 has been delivered successfully!', time: 'Apr 8 · 3:12 PM', read: true),
    _Notif(icon: Icons.notifications_outlined, iconBg: const Color(0xFFFEF0F5), text: 'Reminder: Your Kurta is expected to be ready by Apr 15.', time: 'Apr 7 · 9:00 AM', read: true),
    _Notif(icon: Icons.star_outline, iconBg: const Color(0xFFEEEDFE), text: 'You haven\'t rated your last order yet. Share your feedback!', time: 'Apr 9 · 10:30 AM', read: true),
    _Notif(icon: Icons.local_shipping_outlined, iconBg: AppColors.badgeGreenBg, text: 'Ravi Kumar has marked your suit as Ready for Pickup.', time: 'Apr 5 · 4:00 PM', read: true),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifs.where((n) => !n.read).length;
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Notifications${unread > 0 ? ' ($unread)' : ''}'),
        backgroundColor: AppColors.thread,
        actions: [
          TextButton(
            onPressed: () => setState(() { for (final n in _notifs) n.read = true; }),
            child: const Text('Mark all read', style: TextStyle(color: AppColors.gold, fontSize: 13)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _notifs.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x14000000)),
        itemBuilder: (_, i) => _NotifTile(
          notif: _notifs[i],
          onTap: () => setState(() => _notifs[i].read = true),
        ),
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
        color: notif.read ? Colors.transparent : AppColors.gold.withOpacity(0.04),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: notif.iconBg, shape: BoxShape.circle),
            child: Icon(notif.icon, size: 18, color: AppColors.thread),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(notif.text, style: TextStyle(fontSize: 13, color: AppColors.thread, fontWeight: notif.read ? FontWeight.w400 : FontWeight.w500, height: 1.4)),
            const SizedBox(height: 4),
            Text(notif.time, style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
          ])),
          if (!notif.read)
            Container(width: 7, height: 7, margin: const EdgeInsets.only(top: 5, left: 8), decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
        ]),
      ),
    );
  }
}
