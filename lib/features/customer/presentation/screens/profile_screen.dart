import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:tailor_app/widgets/feature_image_banner.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Jerron Kollie');
  final _phoneCtrl = TextEditingController(text: '+234 801 234 5678');
  final _emailCtrl = TextEditingController(text: 'jerron@email.com');
  final _cityCtrl = TextEditingController(text: 'Lagos');
  final _addressCtrl = TextEditingController(text: '12 Marina Street, Lagos Island, Lagos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Profile'), backgroundColor: AppColors.thread),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FeatureImageBanner(
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&h=800&fit=crop',
            eyebrow: 'Your profile',
            title: 'Keep your fit details stylish and organized.',
            subtitle: 'Save your measurements, addresses, and payment options in one polished profile.',
            height: 220,
          ),
          const SizedBox(height: 16),
          // ── Avatar & name ──────────────────────────────────────
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 14, offset: const Offset(0, 6))],
                  ),
                ),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Jerron Kollie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.thread)),
                  const Text('Customer since Jan 2025', style: TextStyle(fontSize: 12, color: AppColors.taupe)),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined, size: 14),
                    label: const Text('Edit Photo', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ]),
              ]),
              const AppDivider(),
              _LabeledField(label: 'Full Name', controller: _nameCtrl),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _LabeledField(label: 'Phone', controller: _phoneCtrl)),
                const SizedBox(width: 14),
                Expanded(child: _LabeledField(label: 'Email', controller: _emailCtrl)),
              ]),
              const SizedBox(height: 10),
              _LabeledField(label: 'City', controller: _cityCtrl),
              const SizedBox(height: 10),
              const Text('Delivery Address', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(controller: _addressCtrl, maxLines: 2, style: const TextStyle(fontSize: 13), decoration: const InputDecoration()),
              const SizedBox(height: 16),
              Row(children: [
                ElevatedButton(onPressed: () => _saved(context), child: const Text('Save Profile')),
                const SizedBox(width: 10),
                OutlinedButton(onPressed: () {}, child: const Text('Change Password')),
              ]),
            ]),
          ),

          // ── Saved measurements ─────────────────────────────────
          const SectionLabel('Saved Measurement Profiles'),
          AppCard(
            child: Column(children: [
              _MeasureProfileRow(name: 'Casual Fit', count: 6, isDefault: true),
              const Divider(height: 1, color: Color(0x14000000)),
              _MeasureProfileRow(name: 'Formal Fit', count: 6),
            ]),
          ),

          // ── Payment methods ────────────────────────────────────
          const SectionLabel('Payment Methods'),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _PaymentRow(label: 'Cash on Delivery', icon: Icons.payments_outlined, isDefault: true),
              const Divider(height: 1, color: Color(0x14000000)),
              _PaymentRow(label: 'UPI — jerron@upi', icon: Icons.phone_iphone_outlined),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Payment Method', style: TextStyle(fontSize: 13)),
              ),
            ]),
          ),

          // ── Order history ──────────────────────────────────────
          const SectionLabel('Order History'),
          AppCard(
            child: Column(children: [
              _HistoryRow(name: 'Custom Suit — Navy Blue', date: 'Apr 10, 2026', amount: '₹8,500'),
              const Divider(height: 1, color: Color(0x14000000)),
              _HistoryRow(name: 'White Linen Kurta', date: 'Mar 28, 2026', amount: '₹2,200'),
              const Divider(height: 1, color: Color(0x14000000)),
              _HistoryRow(name: 'Slim Fit Trousers', date: 'Apr 1, 2026', amount: '₹1,800'),
            ]),
          ),
        ]),
      ),
    );
  }

  void _saved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!'), backgroundColor: AppColors.badgeGreenText, behavior: SnackBarBehavior.floating, margin: EdgeInsets.all(16)));
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _LabeledField({required this.label, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      TextField(controller: controller, style: const TextStyle(fontSize: 13), decoration: const InputDecoration()),
    ]);
  }
}

class _MeasureProfileRow extends StatelessWidget {
  final String name;
  final int count;
  final bool isDefault;
  const _MeasureProfileRow({required this.name, required this.count, this.isDefault = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        const Icon(Icons.straighten_outlined, size: 18, color: AppColors.taupe),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.thread)),
            if (isDefault) ...[const SizedBox(width: 6), const StatusBadge(label: 'Default', bg: AppColors.badgeGreenBg, textColor: AppColors.badgeGreenText)],
          ]),
          Text('$count measurements saved', style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
        ])),
        TextButton(onPressed: () {}, child: const Text('Edit', style: TextStyle(fontSize: 12, color: AppColors.gold))),
      ]),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDefault;
  const _PaymentRow({required this.label, required this.icon, this.isDefault = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.taupe),
        const SizedBox(width: 10),
        Expanded(child: Row(children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.thread)),
          if (isDefault) ...[const SizedBox(width: 8), const StatusBadge(label: 'Default', bg: AppColors.badgeGreenBg, textColor: AppColors.badgeGreenText)],
        ])),
        if (!isDefault) TextButton(onPressed: () {}, child: const Text('Remove', style: TextStyle(fontSize: 12, color: AppColors.badgeRedText))),
      ]),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String name;
  final String date;
  final String amount;
  const _HistoryRow({required this.name, required this.date, required this.amount});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.thread)),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
        ])),
        Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.silk)),
      ]),
    );
  }
}
