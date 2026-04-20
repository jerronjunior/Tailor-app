import 'package:flutter/material.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

// ── Status Badge ──────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const StatusBadge({super.key, required this.label, required this.bg, required this.textColor});

  factory StatusBadge.pending() => const StatusBadge(label: 'Pending', bg: AppColors.badgeAmberBg, textColor: AppColors.badgeAmberText);
  factory StatusBadge.accepted() => const StatusBadge(label: 'Accepted', bg: AppColors.badgeBlueBg, textColor: AppColors.badgeBlueText);
  factory StatusBadge.inProgress() => const StatusBadge(label: 'In Progress', bg: AppColors.badgeAmberBg, textColor: AppColors.badgeAmberText);
  factory StatusBadge.ready() => const StatusBadge(label: 'Ready', bg: Color(0xFFEEEDFE), textColor: Color(0xFF534AB7));
  factory StatusBadge.delivered() => const StatusBadge(label: 'Delivered', bg: AppColors.badgeGreenBg, textColor: AppColors.badgeGreenText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor, letterSpacing: 0.3)),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const StatCard({super.key, required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(value, style: TextStyle(fontFamily: 'DM Sans', fontSize: 26, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.thread)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.taupe, letterSpacing: 0.8), textAlign: TextAlign.center),
      ]),
    );
  }
}

// ── Section Label ──────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.taupe, letterSpacing: 1.5)),
    );
  }
}

// ── App Card ──────────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: child,
      ),
    );
  }
}

// ── Avatar Circle ──────────────────────────────────────────────
class AvatarCircle extends StatelessWidget {
  final String initials;
  final Color bg;
  final Color fg;
  final double size;
  final double fontSize;

  const AvatarCircle({super.key, required this.initials, this.bg = AppColors.thread, this.fg = AppColors.accent, this.size = 44, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(child: Text(initials, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: fontSize))),
    );
  }
}

// ── Order List Tile ──────────────────────────────────────────────
class OrderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget badge;

  const OrderTile({super.key, required this.title, required this.subtitle, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.thread)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
        ])),
        badge,
      ]),
    );
  }
}

// ── Gold Button ──────────────────────────────────────────────
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GoldButton({super.key, required this.label, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontFamily: 'DM Sans', fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ── Divider ──────────────────────────────────────────────
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});
  @override
  Widget build(BuildContext context) => Divider(color: Colors.black.withOpacity(0.08), thickness: 0.5, height: 24);
}
