import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

// ── Theme constants ───────────────────────────────────────────────────
const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kBlue = Color(0xFF4A90E2);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _firstName(String? fullName) {
    final s = fullName?.trim();
    if (s == null || s.isEmpty) return 'there';
    return s.split(RegExp(r'\s+')).first;
  }

  String _initials(String? fullName) {
    final s = fullName?.trim();
    if (s == null || s.isEmpty) return 'NA';
    final parts = s.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'NA';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final firstName = _firstName(currentUser?.name);
    final initials = _initials(currentUser?.name);

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Hero image
          Positioned(
            top: 0, left: 0, right: 0,
            height: 300,
            child: Image.network(
              'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=1200&h=700&fit=crop&q=85',
              fit: BoxFit.cover,
              loadingBuilder: (_, child, p) => p == null ? child : Container(color: const Color(0xFF1B2A3B)),
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
                  // ── Top bar ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 16, 0),
                    child: Row(
                      children: [
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
                            Text('TAILOR APP', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                          ]),
                        ),
                        const Spacer(),
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
                      ],
                    ),
                  ),

                  // ── Hero text ──────────────────────────────────────
                  const SizedBox(height: 170),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi $firstName 👋', style: const TextStyle(color: _kMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        const Text('Your next look\nis waiting.', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.8)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── CTA row ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Expanded(child: _PrimaryBtn(
                        label: 'Find a Tailor', icon: Icons.search_rounded,
                        onTap: () => context.push(AppRoutes.tailorList),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: _SecondaryBtn(
                        label: 'Measurements', icon: Icons.straighten,
                        onTap: () => context.push(AppRoutes.measurementProfiles),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  // ── Stat cards ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      _StatChip(value: '3', label: 'Active Orders', color: _kGold),
                      const SizedBox(width: 10),
                      _StatChip(value: '12', label: 'Completed', color: _kBlue),
                      const SizedBox(width: 10),
                      _StatChip(value: '4.8', label: 'Avg Rating', color: const Color(0xFF4CAF50)),
                    ]),
                  ),
                  const SizedBox(height: 28),

                  // ── Style inspiration ──────────────────────────────
                  _SectionHeader(title: 'Style Inspiration', trailingLabel: 'See all', onTap: () {}),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _InspirationCard(
                          imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600&h=800&fit=crop&q=80',
                          label: 'Wedding Suits',
                          color: _kGold,
                        ),
                        const SizedBox(width: 12),
                        _InspirationCard(
                          imageUrl: 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=600&h=800&fit=crop&q=80',
                          label: 'Ethnic Wear',
                          color: const Color(0xFF8B3A62),
                        ),
                        const SizedBox(width: 12),
                        _InspirationCard(
                          imageUrl: 'https://images.unsplash.com/photo-1601762603339-fd61e28b698a?w=600&h=800&fit=crop&q=80',
                          label: 'Office Attire',
                          color: _kBlue,
                        ),
                        const SizedBox(width: 12),
                        _InspirationCard(
                          imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=600&h=800&fit=crop&q=80',
                          label: 'Casual Style',
                          color: const Color(0xFF3B6D11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Quick actions ──────────────────────────────────
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
                      childAspectRatio: 2.2,
                      children: [
                        _ActionTile(icon: Icons.add_circle_outline, label: 'Place Order', color: _kGold, onTap: () => context.push(AppRoutes.tailorList)),
                        _ActionTile(icon: Icons.style_outlined, label: 'Browse Styles', color: _kBlue, onTap: () => context.push(AppRoutes.tailorList)),
                        _ActionTile(icon: Icons.local_shipping_outlined, label: 'Track Order', color: const Color(0xFF4CAF50), onTap: () => context.push(AppRoutes.orderHistory)),
                        _ActionTile(icon: Icons.person_outline, label: 'Edit Profile', color: const Color(0xFF8B3A62), onTap: () => context.push(AppRoutes.editProfile)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Recent orders ──────────────────────────────────
                  _SectionHeader(title: 'Recent Orders', trailingLabel: 'View all', onTap: () => context.push(AppRoutes.orderHistory)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      _OrderRow(title: 'Custom Suit — Navy Blue', sub: 'Ravi Kumar · Est. Apr 20', status: 'In Progress', statusColor: _kGold),
                      const SizedBox(height: 8),
                      _OrderRow(title: 'White Linen Kurta', sub: 'Priya Sharma · Est. Apr 15', status: 'Accepted', statusColor: _kBlue),
                      const SizedBox(height: 8),
                      _OrderRow(title: 'Slim Fit Trousers', sub: 'Ravi Kumar · Apr 8', status: 'Delivered', statusColor: const Color(0xFF4CAF50)),
                    ]),
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
}

// ── Shared sub-widgets ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTap;
  const _SectionHeader({required this.title, this.trailingLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
        const Spacer(),
        if (trailingLabel != null)
          GestureDetector(
            onTap: onTap,
            child: Text(trailingLabel!, style: const TextStyle(color: _kGold, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ]),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatChip({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: _kMuted, fontSize: 10.5, height: 1.2)),
        ]),
      ),
    );
  }
}

class _InspirationCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final Color color;
  const _InspirationCard({required this.imageUrl, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover,
                loadingBuilder: (_, child, p) => p == null ? child : Container(color: _kCard)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, color.withOpacity(0.85)],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, height: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
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
}

class _OrderRow extends StatelessWidget {
  final String title;
  final String sub;
  final String status;
  final Color statusColor;
  const _OrderRow({required this.title, required this.sub, required this.status, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(14)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.black, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 13)),
        ]),
      ),
    );
  }
}

class _SecondaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: _kGold.withOpacity(0.4))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: _kGold, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: _kGold, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ),
    );
  }
}
