import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/tailor/providers/tailor_providers.dart';

// ── Theme constants ────────────────────────────────────────────────────
const _kBg     = Color(0xFF0D1B2A);
const _kCard   = Color(0xFF1A2B3C);
const _kGold   = Color(0xFFD4AF37);
const _kBlue   = Color(0xFF4A90E2);
const _kGreen  = Color(0xFF4CAF50);
const _kMuted  = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class TailorHomeScreen extends ConsumerStatefulWidget {
  const TailorHomeScreen({super.key});

  @override
  ConsumerState<TailorHomeScreen> createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends ConsumerState<TailorHomeScreen> {
  String _firstName(String? name) {
    final s = name?.trim();
    if (s == null || s.isEmpty) return 'Tailor';
    return s.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final user       = ref.watch(currentUserProvider);
    final ordersAsync = ref.watch(tailorOrdersProvider);
    final firstName  = _firstName(user?.name);
    final isAvailable = user?.isAvailable ?? false;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // ── Hero image ─────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0, height: 300,
            child: Image.network(
              'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200&h=700&fit=crop&q=85',
              fit: BoxFit.cover,
              loadingBuilder: (_, c, p) =>
                  p == null ? c : Container(color: const Color(0xFF1B2A3B)),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0, height: 340,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top bar ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 16, 0),
                    child: Row(children: [
                      // Brand badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _kGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _kGold.withOpacity(0.4)),
                        ),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.cut, color: _kGold, size: 12),
                          SizedBox(width: 6),
                          Text('TAILOR PORTAL', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                        ]),
                      ),
                      const Spacer(),
                      // Logout
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                        ),
                        onPressed: () async {
                          await ref.read(authServiceProvider).signOut();
                          if (context.mounted) context.go(AppRoutes.roleSelect);
                        },
                      ),
                    ]),
                  ),

                  // ── Hero headline ────────────────────────────────
                  const SizedBox(height: 170),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Hi $firstName ✂️', style: const TextStyle(color: _kMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      const Text('Your workshop,\nmanaged beautifully.', style: TextStyle(
                        color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800,
                        height: 1.1, letterSpacing: -0.8,
                      )),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  // ── Availability toggle card ──────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _AvailabilityCard(
                      isAvailable: isAvailable,
                      onChanged: (v) async {
                        final uid = ref.read(currentUserProvider)?.id;
                        if (uid != null) {
                          await ref.read(authServiceProvider).updateAvailability(uid, v);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Stat cards ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ordersAsync.when(
                      data: (orders) {
                        final pending    = orders.where((o) => o.status == 'Pending').length;
                        final inProgress = orders.where((o) => o.status == 'In Progress').length;
                        final completed  = orders.where((o) => o.status == 'Ready' && o.price != null).toList();
                        final earnings   = completed.fold<double>(0, (s, o) => s + (o.price ?? 0));
                        return Row(children: [
                          _StatChip(value: '$pending',    label: 'Pending',     color: _kGold),
                          const SizedBox(width: 10),
                          _StatChip(value: '$inProgress', label: 'In Progress', color: _kBlue),
                          const SizedBox(width: 10),
                          _StatChip(value: '₹${earnings.toStringAsFixed(0)}', label: 'Earned', color: _kGreen),
                        ]);
                      },
                      loading: () => _statsShimmer(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Style inspiration strip ───────────────────────
                  _SectionHeader(title: 'Your Craft'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: const [
                        _CraftCard(imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600&h=800&fit=crop&q=80', label: 'Bespoke Suits', color: _kGold),
                        SizedBox(width: 12),
                        _CraftCard(imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=600&h=800&fit=crop&q=80', label: 'Ethnic Wear', color: Color(0xFF8B3A62)),
                        SizedBox(width: 12),
                        _CraftCard(imageUrl: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=600&h=800&fit=crop&q=80', label: 'Formal Shirts', color: _kBlue),
                        SizedBox(width: 12),
                        _CraftCard(imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=600&h=800&fit=crop&q=80', label: 'Trousers', color: Color(0xFF3B6D11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Quick actions ─────────────────────────────────
                  _SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.1,
                      children: [
                        _ActionTile(icon: Icons.receipt_long_outlined, label: 'View Orders', color: _kGold, onTap: () => context.push(AppRoutes.tailorOrders)),
                        _ActionTile(icon: Icons.chat_bubble_outline, label: 'Messages', color: _kBlue, onTap: () {}),
                        _ActionTile(icon: Icons.bar_chart_rounded, label: 'Analytics', color: _kGreen, onTap: () {}),
                        _ActionTile(icon: Icons.settings_outlined, label: 'Settings', color: _kMuted, onTap: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Recent orders ─────────────────────────────────
                  _SectionHeader(title: 'Recent Orders', trailingLabel: 'View all', onTap: () => context.push(AppRoutes.tailorOrders)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ordersAsync.when(
                      data: (orders) {
                        if (orders.isEmpty) {
                          return _emptyOrders();
                        }
                        final recent = orders.take(3).toList();
                        return Column(
                          children: recent.map((o) {
                            final statusColor = _statusColor(o.status);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _OrderRow(
                                title: '${o.dressType} — ${o.color}',
                                sub: 'Customer · Est. ${o.deliveryDate.day}/${o.deliveryDate.month}/${o.deliveryDate.year}',
                                status: o.status,
                                statusColor: statusColor,
                                onTap: () => context.push(AppRoutes.tailorOrders),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => _ordersShimmer(),
                      error: (e, _) => _errorCard(e.toString()),
                    ),
                  ),

                  // ── Earnings summary ──────────────────────────────
                  const SizedBox(height: 20),
                  _SectionHeader(title: 'Earnings Summary'),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ordersAsync.when(
                      data: (orders) {
                        final completed = orders.where((o) => o.status == 'Ready' && o.price != null).toList();
                        final total = completed.fold<double>(0, (s, o) => s + (o.price ?? 0));
                        return _EarningsCard(completedCount: completed.length, total: total);
                      },
                      loading: () => Container(height: 90, decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16))),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':     return _kGold;
      case 'accepted':    return _kBlue;
      case 'in progress': return const Color(0xFF8B3A62);
      case 'ready':       return _kGreen;
      case 'delivered':   return _kGreen;
      case 'rejected':    return Colors.redAccent;
      default:            return _kMuted;
    }
  }

  Widget _statsShimmer() => Row(children: List.generate(3, (_) => Expanded(child: Container(
    margin: const EdgeInsets.only(right: 10),
    height: 72, decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16)),
  ))));

  Widget _ordersShimmer() => Column(children: List.generate(2, (_) => Container(
    margin: const EdgeInsets.only(bottom: 8), height: 64,
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14)),
  )));

  Widget _emptyOrders() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
    child: const Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.inbox_outlined, color: _kMuted, size: 36),
      SizedBox(height: 10),
      Text('No orders yet', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      SizedBox(height: 4),
      Text('New orders will appear here', style: TextStyle(color: _kMuted, fontSize: 12)),
    ]),
  );

  Widget _errorCard(String msg) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.red.withOpacity(0.2))),
    child: Row(children: [
      const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(msg, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
    ]),
  );
}

// ── Sub-widgets ────────────────────────────────────────────────────────

class _AvailabilityCard extends StatelessWidget {
  final bool isAvailable;
  final ValueChanged<bool> onChanged;
  const _AvailabilityCard({required this.isAvailable, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? _kGreen : _kMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3))),
          child: Icon(isAvailable ? Icons.storefront_outlined : Icons.store_outlined, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isAvailable ? 'Open for Orders' : 'Closed for Orders',
              style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
          Text(isAvailable ? 'Customers can find and book you' : 'You won\'t receive new orders',
              style: const TextStyle(color: _kMuted, fontSize: 11, height: 1.3)),
        ])),
        Switch(
          value: isAvailable,
          onChanged: onChanged,
          activeColor: _kGreen,
          activeTrackColor: _kGreen.withOpacity(0.25),
          inactiveThumbColor: _kMuted,
          inactiveTrackColor: _kMuted.withOpacity(0.15),
        ),
      ]),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatChip({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: _kCard, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: _kMuted, fontSize: 10.5, height: 1.2)),
      ]),
    ),
  );
}

class _CraftCard extends StatelessWidget {
  final String imageUrl, label;
  final Color color;
  const _CraftCard({required this.imageUrl, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: SizedBox(
      width: 120,
      child: Stack(fit: StackFit.expand, children: [
        Image.network(imageUrl, fit: BoxFit.cover,
            loadingBuilder: (_, c, p) => p == null ? c : Container(color: _kCard)),
        DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.transparent, color.withOpacity(0.85)], stops: const [0.5, 1.0],
        ))),
        Align(alignment: Alignment.bottomLeft, child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, height: 1.2)),
        )),
      ]),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
      ]),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTap;
  const _SectionHeader({required this.title, this.trailingLabel, this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(children: [
      Container(width: 3, height: 16, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
      const Spacer(),
      if (trailingLabel != null)
        GestureDetector(onTap: onTap,
          child: Text(trailingLabel!, style: const TextStyle(color: _kGold, fontSize: 12, fontWeight: FontWeight.w600))),
    ]),
  );
}

class _OrderRow extends StatelessWidget {
  final String title, sub, status;
  final Color statusColor;
  final VoidCallback onTap;
  const _OrderRow({required this.title, required this.sub, required this.status, required this.statusColor, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: _kBorder)),
      child: Row(children: [
        Container(width: 4, height: 36, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(color: _kMuted, fontSize: 11)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
          child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ]),
    ),
  );
}

class _EarningsCard extends StatelessWidget {
  final int completedCount;
  final double total;
  const _EarningsCard({required this.completedCount, required this.total});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(18), border: Border.all(color: _kGold.withOpacity(0.2)),
    ),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: _kGold.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: _kGold.withOpacity(0.3))),
        child: const Icon(Icons.account_balance_wallet_outlined, color: _kGold, size: 24),
      ),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Total Earnings', style: TextStyle(color: _kMuted, fontSize: 12)),
        const SizedBox(height: 2),
        Text('₹${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        Text('$completedCount orders completed', style: const TextStyle(color: _kMuted, fontSize: 11)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: _kGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: _kGreen.withOpacity(0.3))),
          child: const Text('This Month', style: TextStyle(color: _kGreen, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ]),
    ]),
  );
}
