import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

/// First screen: choose to login/register as Customer or Tailor.
class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B2A), Color(0xFF1B2A3B), Color(0xFF0D1B2A)],
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero banner — bleeds under status bar for full-bleed effect
                _HeroBanner(),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section label
                      Row(
                        children: [
                          Container(width: 32, height: 2, color: const Color(0xFFD4AF37)),
                          const SizedBox(width: 10),
                          const Text(
                            'CHOOSE YOUR ROLE',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your tailoring\njourney starts here.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pick the path that matches how you want to use the app.',
                        style: TextStyle(color: Color(0xFF8FA3B1), height: 1.5, fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Customer card
                      _RoleCard(
                        title: 'Customer',
                        subtitle: 'Find tailors, place orders, track work, and chat in real time.',
                        icon: Icons.person_rounded,
                        imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=900&h=500&fit=crop&q=80',
                        accentColor: const Color(0xFF4A90E2),
                        tag: 'FOR SHOPPERS',
                        onLogin: () => context.push('${AppRoutes.login}?role=${AppConstants.roleCustomer}'),
                        onRegister: () => context.push('${AppRoutes.register}?role=${AppConstants.roleCustomer}'),
                      ),
                      const SizedBox(height: 16),

                      // Tailor card
                      _RoleCard(
                        title: 'Tailor',
                        subtitle: 'Manage orders, update progress, and grow your business.',
                        icon: Icons.design_services_rounded,
                        imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=900&h=500&fit=crop&q=80',
                        accentColor: const Color(0xFFD4AF37),
                        tag: 'FOR CRAFTSPEOPLE',
                        onLogin: () => context.push('${AppRoutes.login}?role=${AppConstants.roleTailor}'),
                        onRegister: () => context.push('${AppRoutes.register}?role=${AppConstants.roleTailor}'),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use full screen width and a tall fixed height so image is always prominent
    final screenHeight = MediaQuery.of(context).size.height;
    final bannerHeight = (screenHeight * 0.48).clamp(320.0, 460.0);

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed image — no clipping, fills the stack
          Image.network(
            'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=1200&h=900&fit=crop&q=90',
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: const Color(0xFF1B2A3B),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              );
            },
          ),
          // Very light vignette — only bottom 30% fades to background color
          // Top 70% stays fully transparent so the image shines
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x000D1B2A), // fully transparent
                  Color(0x000D1B2A), // fully transparent
                  Color(0x880D1B2A), // subtle mid fade
                  Color(0xFF0D1B2A), // solid at very bottom edge only
                ],
                stops: [0.0, 0.55, 0.82, 1.0],
              ),
            ),
          ),
          // Text content pinned to bottom
          Positioned(
            bottom: 22,
            left: 22,
            right: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pill badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cut, color: Colors.black, size: 12),
                      SizedBox(width: 6),
                      Text(
                        'TAILOR APP',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Main headline
                const Text(
                  'Dress with\nconfidence.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -1,
                    shadows: [
                      Shadow(color: Color(0x99000000), blurRadius: 12, offset: Offset(0, 3)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A modern tailoring experience, all in one place.',
                  style: TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 13.5,
                    height: 1.4,
                    shadows: [Shadow(color: Color(0x88000000), blurRadius: 8)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String imageUrl;
  final Color accentColor;
  final String tag;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imageUrl,
    required this.accentColor,
    required this.tag,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 160,
                        color: const Color(0xFF1A2B3C),
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD4AF37))),
                      );
                    },
                  ),
                ),
                // Dark overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                ),
                // Tag chip
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                // Title over image
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accentColor.withOpacity(0.4)),
                        ),
                        child: Icon(icon, color: accentColor, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body section
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF8FA3B1), height: 1.5, fontSize: 13.5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onLogin,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentColor,
                          side: BorderSide(color: accentColor.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}