import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/widgets/feature_image_banner.dart';

/// First screen: choose to login/register as Customer or Tailor.
class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                FeatureImageBanner(
                  imageUrl: 'https://picsum.photos/seed/customer-hero/1200/800',
                  eyebrow: 'Tailored Fashion',
                  title: 'Dress with confidence.',
                  subtitle: 'A modern tailoring experience for customers and tailors in one place.',
                  height: 280,
                  action: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => context.push('${AppRoutes.register}?role=${AppConstants.roleCustomer}'),
                          child: const Text('Start as Customer'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('${AppRoutes.register}?role=${AppConstants.roleTailor}'),
                          child: const Text('Start as Tailor'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Choose your role',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.thread,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pick the path that matches how you want to use the app.',
                  style: TextStyle(color: AppColors.taupe, height: 1.4),
                ),
                const SizedBox(height: 18),
                _RoleCard(
                  title: 'Customer',
                  subtitle: 'Find tailors, place orders, track work, and chat in real time.',
                  icon: Icons.person_rounded,
                  imageUrl: 'https://picsum.photos/seed/customer-card/900/600',
                  onLogin: () => context.push('${AppRoutes.login}?role=${AppConstants.roleCustomer}'),
                  onRegister: () => context.push('${AppRoutes.register}?role=${AppConstants.roleCustomer}'),
                ),
                const SizedBox(height: 14),
                _RoleCard(
                  title: 'Tailor',
                  subtitle: 'Manage orders, update progress, and grow your business.',
                  icon: Icons.design_services_rounded,
                  imageUrl: 'https://picsum.photos/seed/tailor-card/900/600',
                  onLogin: () => context.push('${AppRoutes.login}?role=${AppConstants.roleTailor}'),
                  onRegister: () => context.push('${AppRoutes.register}?role=${AppConstants.roleTailor}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String imageUrl;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imageUrl,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 22, offset: const Offset(0, 12))],
        border: Border.all(color: Colors.black.withOpacity(0.04), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x3310223E), Color(0xB310223E)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.taupe, height: 1.45),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: onLogin,
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: onRegister,
                        child: const Text('Register'),
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

