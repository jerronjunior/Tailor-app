import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/widgets/feature_image_banner.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FC), Color(0xFFEAF0F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeatureImageBanner(
                  imageUrl: 'https://picsum.photos/seed/home-hero/1200/800',
                  eyebrow: 'Your dashboard',
                  title: 'Hi $firstName, your next look is waiting.',
                  subtitle: 'Browse inspiration, manage orders, and keep every measurement in one place.',
                  height: 250,
                  action: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => context.push(AppRoutes.tailorList),
                          child: const Text('Find a tailor'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push(AppRoutes.measurementProfiles),
                          child: const Text('Measurements'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8))],
                      ),
                      child: Row(
                        children: [
                          AvatarCircle(initials: initials, size: 46, fontSize: 16),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hi $firstName 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.thread)),
                              const SizedBox(height: 2),
                              const Text('Welcome back — here\'s your overview', style: TextStyle(fontSize: 13, color: AppColors.taupe)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () async {
                        final authService = ref.read(authServiceProvider);
                        await authService.signOut();
                        if (context.mounted) {
                          context.go(AppRoutes.roleSelect);
                        }
                      },
                      tooltip: 'Logout',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

              // ── Stats Grid ────────────────────────────────────
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: const [
                    StatCard(value: '3', label: 'Active\nOrders'),
                    StatCard(value: '12', label: 'Completed'),
                    StatCard(value: '2', label: 'Awaiting\nPickup', valueColor: AppColors.gold),
                    StatCard(value: '4.8', label: 'Avg Rating', valueColor: AppColors.badgeGreenText),
                  ],
                ),
                const SizedBox(height: 20),

                const SectionLabel('Style Inspiration'),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      final images = [
                        'https://picsum.photos/seed/style-1/900/600',
                        'https://picsum.photos/seed/style-2/900/600',
                        'https://picsum.photos/seed/style-3/900/600',
                      ];
                      final titles = ['Wedding edit', 'Casual edit', 'Office edit'];
                      return Container(
                        width: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 10))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0x1A10223E), Color(0xCC10223E)],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                                      const SizedBox(height: 8),
                                      Text(titles[index], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
                    GoldButton(label: 'Browse Styles', icon: Icons.style, onPressed: () => context.push(AppRoutes.tailorList)),
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
      ),
    );
  }
}
