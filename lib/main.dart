import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'main_customer.dart';
import 'screens/tailor/tailor_dashboard.dart';

void main() {
  runApp(const TailorApp());
}

class TailorApp extends StatelessWidget {
  const TailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RoleSelectScreen(),
    );
  }
}

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.thread,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.content_cut, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 20),
              const Text('Tailor', style: TextStyle(fontFamily: 'DM Sans', color: AppColors.cream, fontSize: 36, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Your smart stitching platform.', style: TextStyle(color: Color(0x88FAF7F2), fontSize: 16)),
              const Spacer(),
              const Text('SIGN IN AS', style: TextStyle(color: Color(0x55FAF7F2), fontSize: 11, letterSpacing: 2)),
              const SizedBox(height: 14),
              _RoleButton(
                icon: Icons.person_outline,
                title: 'Customer',
                subtitle: 'Browse styles, place & track orders',
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerDashboard())),
              ),
              const SizedBox(height: 12),
              _RoleButton(
                icon: Icons.content_cut,
                title: 'Tailor',
                subtitle: 'Manage orders, clients & earnings',
                accent: true,
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TailorDashboard())),
              ),
              const Spacer(),
              Center(child: Text('v1.0.0 · Tailor App', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11))),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool accent;
  final VoidCallback onTap;
  const _RoleButton({required this.icon, required this.title, required this.subtitle, required this.onTap, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: accent ? AppColors.gold : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent ? AppColors.gold : Colors.white.withOpacity(0.15), width: 0.5),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.55))),
          ])),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white.withOpacity(0.4)),
        ]),
      ),
    );
  }
}
