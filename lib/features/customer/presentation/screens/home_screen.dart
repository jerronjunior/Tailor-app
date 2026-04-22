import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/router/app_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _firstName(String? fullName) {
    final safeName = fullName?.trim();
    if (safeName == null || safeName.isEmpty) return 'there';
    return safeName.split(RegExp(r'\s+')).first;
  }

  String _initials(String? fullName) {
    final safeName = fullName?.trim();
    if (safeName == null || safeName.isEmpty) return 'NA';
    final parts = safeName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'NA';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final firstName = _firstName(currentUser?.name);
    final initials = _initials(currentUser?.name);

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
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Hi $firstName 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.thread)),
                    const SizedBox(height: 2),
                    const Text('Welcome back — here\'s your overview', style: TextStyle(fontSize: 13, color: AppColors.taupe)),
                  ]),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          final authService = ref.read(authServiceProvider);
                          await authService.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                        tooltip: 'Logout',
                      ),
                      AvatarCircle(initials: initials, size: 48, fontSize: 18),
                    ],
                  ),
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
                    onPressed: () => context.push(AppRoutes.tailorList),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Place New Order'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.measurementProfiles),
                    icon: const Icon(Icons.straighten, size: 16),
                    label: const Text('Add Measurements'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.orderHistory),
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
