import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('Hi Jerron 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.thread)),
                    SizedBox(height: 2),
                    Text('Welcome back — here\'s your overview', style: TextStyle(fontSize: 13, color: AppColors.taupe)),
                  ]),
                  const AvatarCircle(initials: 'JK', size: 48, fontSize: 18),
                ],
              ),
              const SizedBox(height: 20),

              // ── Stats Grid ────────────────────────────────────
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
                children: const [
                  StatCard(value: '3', label: 'Active\nOrders'),
                  StatCard(value: '12', label: 'Completed'),
                  StatCard(value: '2', label: 'Awaiting\nPickup', valueColor: AppColors.gold),
                  StatCard(value: '4.8', label: 'Avg Rating', valueColor: AppColors.badgeGreenText),
                ],
              ),
              const SizedBox(height: 20),

              // ── Quick Actions ─────────────────────────────────
              const SectionLabel('Quick Actions'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Place New Order'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.straighten, size: 16),
                    label: const Text('Add Measurements'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.local_shipping_outlined, size: 16),
                    label: const Text('Track Order'),
                  ),
                  GoldButton(label: 'Browse Styles', icon: Icons.style, onPressed: () {}),
                ],
              ),
              const SizedBox(height: 20),

              // ── Recent Orders ─────────────────────────────────
              const SectionLabel('Recent Orders'),
              OrderTile(
                title: 'Custom Suit — Navy Blue',
                subtitle: 'Tailor Ravi Kumar · Est. Apr 20',
                badge: StatusBadge.inProgress(),
              ),
              OrderTile(
                title: 'White Linen Kurta',
                subtitle: 'Tailor Priya S · Est. Apr 15',
                badge: StatusBadge.accepted(),
              ),
              OrderTile(
                title: 'Slim Fit Trousers',
                subtitle: 'Tailor Ravi Kumar · Apr 8',
                badge: StatusBadge.delivered(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
