// reviews_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:tailor_app/widgets/feature_image_banner.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

// ══════════════════════════════════════════════════════
// REVIEWS SCREEN
// ══════════════════════════════════════════════════════
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _rating = 4;
  final _feedbackCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Image.network('https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200&h=500&fit=crop&q=80',
                fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B))),
          ),
          Positioned(top: 0, left: 0, right: 0, height: 240,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0])))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('FEEDBACK', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                const SizedBox(height: 4),
                const Text('Reviews & Ratings', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                // Rate new order
                _darkCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(14),
                      child: SizedBox(width: 48, height: 48,
                        child: Image.network('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&q=80', fit: BoxFit.cover))),
                    const SizedBox(width: 12),
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Ravi Kumar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('Order: Custom Suit — Navy Blue', style: TextStyle(fontSize: 11, color: _kMuted)),
                    ]),
                  ]),
                  const SizedBox(height: 18),
                  _sLabel('Your Rating'),
                  const SizedBox(height: 10),
                  Row(children: List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(padding: const EdgeInsets.only(right: 8),
                      child: Icon(i < _rating ? Icons.star_rounded : Icons.star_outline_rounded, size: 34, color: i < _rating ? _kGold : Colors.white.withOpacity(0.15))),
                  ))),
                  const SizedBox(height: 16),
                  const Text('Write your feedback', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _feedbackCtrl, maxLines: 3,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Share your experience — fit, quality, communication…',
                      hintStyle: const TextStyle(color: _kMuted, fontSize: 13),
                      filled: true, fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold)),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(
                    onPressed: () => _submitReview(context),
                    icon: const Icon(Icons.send_outlined, size: 16),
                    label: const Text('Submit Review', style: TextStyle(fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(backgroundColor: _kGold, foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  )),
                ])),
                const SizedBox(height: 24),

                _sLabel('Past Reviews'),
                const SizedBox(height: 12),
                ...[
                  ('Ravi Kumar', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&q=80', 5, '"Perfect fit, excellent stitching quality. Will order again for the wedding suits!"', 'Apr 8 · Slim Fit Trousers'),
                  ('Priya Sharma', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&h=200&fit=crop&q=80', 5, '"Beautiful saree blouse, exactly as I described. Fit was flawless."', 'Mar 22 · Saree Blouse'),
                  ('Ravi Kumar', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&q=80', 4, '"Good quality but delivery was one day late. Will still order again."', 'Feb 14 · Kurta Pyjama'),
                ].map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      ClipRRect(borderRadius: BorderRadius.circular(10),
                        child: SizedBox(width: 36, height: 36,
                          child: Image.network(r.$2, fit: BoxFit.cover))),
                      const SizedBox(width: 10),
                      Expanded(child: Text(r.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
                      Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) =>
                          Icon(i < r.$3 ? Icons.star_rounded : Icons.star_outline_rounded, size: 14, color: i < r.$3 ? _kGold : Colors.white.withOpacity(0.15)))),
                    ]),
                    const SizedBox(height: 10),
                    Text(r.$4, style: const TextStyle(fontSize: 13, color: _kMuted, height: 1.5, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 6),
                    Text(r.$5, style: const TextStyle(fontSize: 11, color: _kMuted)),
                  ]),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkCard(Widget child) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: _kBorder)),
    child: child,
  );

  Widget _sLabel(String text) => Row(children: [
    Container(width: 3, height: 14, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(text.toUpperCase(), style: const TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
  ]);

  void _submitReview(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Review submitted! Thank you.'),
      backgroundColor: const Color(0xFF4CAF50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    ));
    setState(() { _rating = 0; _feedbackCtrl.clear(); });
  }
}

// ══════════════════════════════════════════════════════
// PROFILE SCREEN
// ══════════════════════════════════════════════════════
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
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 220,
            child: Image.network('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&h=600&fit=crop&q=80',
                fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B))),
          ),
          Positioned(top: 0, left: 0, right: 0, height: 260,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0])))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('ACCOUNT', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                const SizedBox(height: 4),
                const Text('Your Profile', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                // Avatar & name
                _darkCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Stack(children: [
                      ClipRRect(borderRadius: BorderRadius.circular(20),
                        child: SizedBox(width: 68, height: 68,
                          child: Image.network('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&q=80', fit: BoxFit.cover))),
                      Positioned(bottom: 0, right: 0, child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: _kGold, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 12, color: Colors.black),
                      )),
                    ]),
                    const SizedBox(width: 16),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Jerron Kollie', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                      const Text('Customer since Jan 2025', style: TextStyle(fontSize: 12, color: _kMuted)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: _kGold.withOpacity(0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: _kGold.withOpacity(0.3))),
                        child: const Text('Edit Photo', style: TextStyle(color: _kGold, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ]),
                  Divider(color: _kBorder, height: 24),
                  _darkField('Full Name', _nameCtrl),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _darkField('Phone', _phoneCtrl)),
                    const SizedBox(width: 14),
                    Expanded(child: _darkField('Email', _emailCtrl)),
                  ]),
                  const SizedBox(height: 12),
                  _darkField('City', _cityCtrl),
                  const SizedBox(height: 12),
                  const Text('Delivery Address', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(controller: _addressCtrl, maxLines: 2, style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold)),
                      contentPadding: const EdgeInsets.all(12))),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: ElevatedButton(onPressed: () => _saved(context),
                        style: ElevatedButton.styleFrom(backgroundColor: _kGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 13)),
                        child: const Text('Save Profile', style: TextStyle(fontWeight: FontWeight.w800)))),
                    const SizedBox(width: 10),
                    OutlinedButton(onPressed: () {},
                        style: OutlinedButton.styleFrom(foregroundColor: _kMuted, side: BorderSide(color: _kBorder), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16)),
                        child: const Text('Change Password')),
                  ]),
                ])),
                const SizedBox(height: 20),

                _sLabel('Saved Measurement Profiles'),
                const SizedBox(height: 12),
                _darkCard(Column(children: [
                  _measureRow('Casual Fit', 6, true),
                  Divider(color: _kBorder, height: 1),
                  _measureRow('Formal Fit', 6, false),
                ])),
                const SizedBox(height: 20),

                _sLabel('Payment Methods'),
                const SizedBox(height: 12),
                _darkCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _payRow('Cash on Delivery', Icons.payments_outlined, true),
                  Divider(color: _kBorder, height: 1),
                  _payRow('UPI — jerron@upi', Icons.phone_iphone_outlined, false),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(onPressed: () {},
                      icon: const Icon(Icons.add, size: 14, color: _kGold),
                      label: const Text('Add Payment Method', style: TextStyle(color: _kGold, fontSize: 12)),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: _kGold.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                ])),
                const SizedBox(height: 20),

                _sLabel('Order History'),
                const SizedBox(height: 12),
                _darkCard(Column(children: [
                  _histRow('Custom Suit — Navy Blue', 'Apr 10, 2026', '₹8,500'),
                  Divider(color: _kBorder, height: 1),
                  _histRow('White Linen Kurta', 'Mar 28, 2026', '₹2,200'),
                  Divider(color: _kBorder, height: 1),
                  _histRow('Slim Fit Trousers', 'Apr 1, 2026', '₹1,800'),
                ])),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkCard(Widget child) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: _kBorder)), child: child);

  Widget _sLabel(String text) => Row(children: [
    Container(width: 3, height: 14, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(text.toUpperCase(), style: const TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
  ]);

  Widget _darkField(String label, TextEditingController ctrl) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
    const SizedBox(height: 4),
    TextField(controller: ctrl, style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(filled: true, fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
  ]);

  Widget _measureRow(String name, int count, bool isDefault) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(children: [
      const Icon(Icons.straighten_outlined, size: 18, color: _kMuted),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          if (isDefault) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: const Color(0x224CAF50), borderRadius: BorderRadius.circular(8)), child: const Text('Default', style: TextStyle(fontSize: 10, color: Color(0xFF4CAF50), fontWeight: FontWeight.w700)))],
        ]),
        Text('$count measurements saved', style: const TextStyle(fontSize: 11, color: _kMuted)),
      ])),
      GestureDetector(onTap: () {}, child: const Text('Edit', style: TextStyle(fontSize: 12, color: _kGold, fontWeight: FontWeight.w600))),
    ]),
  );

  Widget _payRow(String label, IconData icon, bool isDefault) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(children: [
      Icon(icon, size: 20, color: _kMuted),
      const SizedBox(width: 10),
      Expanded(child: Row(children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.white)),
        if (isDefault) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: const Color(0x224CAF50), borderRadius: BorderRadius.circular(8)), child: const Text('Default', style: TextStyle(fontSize: 10, color: Color(0xFF4CAF50), fontWeight: FontWeight.w700)))],
      ])),
      if (!isDefault) GestureDetector(onTap: () {}, child: const Text('Remove', style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.w600))),
    ]),
  );

  Widget _histRow(String name, String date, String amount) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
        Text(date, style: const TextStyle(fontSize: 11, color: _kMuted)),
      ])),
      Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kGold)),
    ]),
  );

  void _saved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Profile saved!'), backgroundColor: Color(0xFF4CAF50),
      behavior: SnackBarBehavior.floating, margin: EdgeInsets.all(16),
    ));
  }
}
