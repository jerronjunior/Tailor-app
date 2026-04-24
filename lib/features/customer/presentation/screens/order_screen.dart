// order_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:flutter/services.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

// ══════════════════════════════════════════════════════
// ORDER SCREEN
// ══════════════════════════════════════════════════════
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _dressType = 'Oxford Shirt';
  String _fabric = 'Select fabric';
  String _profile = 'Casual Fit';
  String _sleeve = 'Full Sleeve';
  String _payment = 'Cash on Delivery';
  DateTime? _deliveryDate;
  final _colorCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Image.network('https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=1200&h=500&fit=crop&q=80',
                fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B))),
          ),
          Positioned(top: 0, left: 0, right: 0, height: 240,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0])))),
          SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('NEW ORDER', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  const Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                  _darkSection('Garment Details'),
                  const SizedBox(height: 12),
                  _darkCard(Column(children: [
                    _DarkDropRow(label: 'Dress Type', value: _dressType,
                      items: ['Oxford Shirt', 'Formal Dress Shirt', 'Two-Piece Suit', 'Three-Piece Suit', 'Kurta Pyjama', 'Saree Blouse', 'Slim Trousers', 'Chino Pants', 'Nehru Jacket', 'Blazer'],
                      onChanged: (v) => setState(() => _dressType = v)),
                    Divider(color: _kBorder, height: 20),
                    Row(children: [
                      Expanded(child: _DarkDropRow(label: 'Fabric', value: _fabric,
                        items: ['Select fabric', 'Cotton', 'Linen', 'Silk', 'Polyester blend', 'Wool', 'Denim'],
                        onChanged: (v) => setState(() => _fabric = v))),
                      const SizedBox(width: 14),
                      Expanded(child: _DarkDropRow(label: 'Fit Profile', value: _profile,
                        items: ['Casual Fit', 'Formal Fit'],
                        onChanged: (v) => setState(() => _profile = v))),
                    ]),
                    Divider(color: _kBorder, height: 20),
                    Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Color Preference', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        _darkTextField(_colorCtrl, 'e.g. Navy Blue…'),
                      ])),
                      const SizedBox(width: 14),
                      Expanded(child: _DarkDropRow(label: 'Sleeve Style', value: _sleeve,
                        items: ['Full Sleeve', 'Half Sleeve', 'Sleeveless', '3/4 Sleeve'],
                        onChanged: (v) => setState(() => _sleeve = v))),
                    ]),
                  ])),
                  const SizedBox(height: 16),

                  _darkSection('Notes & Delivery'),
                  const SizedBox(height: 12),
                  _darkCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Additional Notes', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesCtrl, maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: _darkInputDec('e.g. Slim fit, add chest pocket, extra lining…'),
                    ),
                    Divider(color: _kBorder, height: 20),
                    const Text('Required By Date', style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                          builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.dark(primary: _kGold, surface: _kCard)), child: child!),
                        );
                        if (d != null) setState(() => _deliveryDate = d);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: _kBorder)),
                        child: Row(children: [
                          const Icon(Icons.calendar_today_outlined, size: 16, color: _kGold),
                          const SizedBox(width: 8),
                          Text(
                            _deliveryDate == null ? 'Select date…' : '${_deliveryDate!.day}/${_deliveryDate!.month}/${_deliveryDate!.year}',
                            style: TextStyle(fontSize: 13, color: _deliveryDate == null ? _kMuted : Colors.white),
                          ),
                        ]),
                      ),
                    ),
                    Divider(color: _kBorder, height: 20),
                    _DarkDropRow(label: 'Payment Method', value: _payment,
                      items: ['Cash on Delivery', 'Online Payment', 'UPI', 'Card'],
                      onChanged: (v) => setState(() => _payment = v)),
                  ])),
                  const SizedBox(height: 20),

                  Row(children: [
                    Expanded(child: ElevatedButton(
                      onPressed: () => _submit(context),
                      style: ElevatedButton.styleFrom(backgroundColor: _kGold, foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Submit Order', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    )),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(foregroundColor: _kMuted, side: BorderSide(color: _kBorder),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                      child: const Text('Save Draft'),
                    ),
                  ]),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkSection(String title) => Row(children: [
    Container(width: 3, height: 16, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(title.toUpperCase(), style: const TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
  ]);

  Widget _darkCard(Widget child) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: _kBorder)),
    child: child,
  );

  Widget _darkTextField(TextEditingController ctrl, String hint) => TextField(
    controller: ctrl, style: const TextStyle(color: Colors.white, fontSize: 13),
    decoration: _darkInputDec(hint),
  );

  InputDecoration _darkInputDec(String hint) => InputDecoration(
    hintText: hint, hintStyle: const TextStyle(color: _kMuted, fontSize: 13),
    filled: true, fillColor: Colors.white.withOpacity(0.05),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  void _submit(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: _kCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0x224CAF50), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Color(0xFF4CAF50), size: 30)),
        const SizedBox(height: 16),
        const Text('Order Placed!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 6),
        const Text('Your order has been submitted.\nYour tailor will accept it shortly.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: _kMuted, height: 1.5)),
      ]),
      actions: [ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(backgroundColor: _kGold, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text('Track Order', style: TextStyle(fontWeight: FontWeight.w800)),
      )],
    ));
  }
}

class _DarkDropRow extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DarkDropRow({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        dropdownColor: _kCard,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        icon: const Icon(Icons.keyboard_arrow_down, color: _kMuted, size: 18),
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold)),
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    ]);
  }
}
