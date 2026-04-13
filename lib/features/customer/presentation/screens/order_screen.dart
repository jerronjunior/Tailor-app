import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _dressType = 'Oxford Shirt';
  String _fabric = '';
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
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Place Order'), backgroundColor: AppColors.thread),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Dress Type
                _DropdownRow(
                  label: 'Dress Type',
                  value: _dressType,
                  items: ['Oxford Shirt', 'Formal Dress Shirt', 'Two-Piece Suit', 'Three-Piece Suit', 'Kurta Pyjama', 'Saree Blouse', 'Slim Trousers', 'Chino Pants', 'Nehru Jacket', 'Blazer'],
                  onChanged: (v) => setState(() => _dressType = v),
                ),
                const AppDivider(),
                // Fabric & Measurement Profile
                Row(children: [
                  Expanded(child: _DropdownRow(
                    label: 'Fabric',
                    value: _fabric.isEmpty ? 'Select fabric' : _fabric,
                    items: ['Select fabric', 'Cotton', 'Linen', 'Silk', 'Polyester blend', 'Wool', 'Denim'],
                    onChanged: (v) => setState(() => _fabric = v == 'Select fabric' ? '' : v),
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _DropdownRow(
                    label: 'Measurement Profile',
                    value: _profile,
                    items: ['Casual Fit', 'Formal Fit'],
                    onChanged: (v) => setState(() => _profile = v),
                  )),
                ]),
                const AppDivider(),
                // Color & Sleeve
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Color Preference', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(controller: _colorCtrl, decoration: const InputDecoration(hintText: 'e.g. Navy Blue…'), style: const TextStyle(fontSize: 13)),
                  ])),
                  const SizedBox(width: 16),
                  Expanded(child: _DropdownRow(
                    label: 'Sleeve Style',
                    value: _sleeve,
                    items: ['Full Sleeve', 'Half Sleeve', 'Sleeveless', '3/4 Sleeve'],
                    onChanged: (v) => setState(() => _sleeve = v),
                  )),
                ]),
                const AppDivider(),
                // Notes
                const Text('Additional Notes', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'e.g. Slim fit, add chest pocket, extra lining…'),
                  style: const TextStyle(fontSize: 13),
                ),
                const AppDivider(),
                // Delivery Date
                const Text('Required By Date', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                      builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.gold)), child: child!),
                    );
                    if (d != null) setState(() => _deliveryDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26, width: 0.5),
                    ),
                    child: Row(children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.taupe),
                      const SizedBox(width: 8),
                      Text(
                        _deliveryDate == null ? 'Select date…' : '${_deliveryDate!.day}/${_deliveryDate!.month}/${_deliveryDate!.year}',
                        style: TextStyle(fontSize: 13, color: _deliveryDate == null ? AppColors.taupe : AppColors.thread),
                      ),
                    ]),
                  ),
                ),
                const AppDivider(),
                // Payment
                _DropdownRow(
                  label: 'Payment Method',
                  value: _payment,
                  items: ['Cash on Delivery', 'Online Payment', 'UPI', 'Card'],
                  onChanged: (v) => setState(() => _payment = v),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: ElevatedButton(
                onPressed: () => _submit(context),
                child: const Text('Submit Order'),
              )),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () {}, child: const Text('Save Draft')),
            ]),
          ]),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 56, height: 56, decoration: const BoxDecoration(color: AppColors.badgeGreenBg, shape: BoxShape.circle), child: const Icon(Icons.check, color: AppColors.badgeGreenText, size: 28)),
          const SizedBox(height: 16),
          const Text('Order Placed!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.thread)),
          const SizedBox(height: 6),
          const Text('Your order has been submitted.\nYour tailor will accept it shortly.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColors.taupe)),
        ]),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Track Order'))],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownRow({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    ]);
  }
}
