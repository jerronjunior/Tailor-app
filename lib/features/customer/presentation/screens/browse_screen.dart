import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class _Style {
  final String emoji;
  final String name;
  final String price;
  final String desc;
  final String cat;
  final Color bg;
  const _Style({required this.emoji, required this.name, required this.price, required this.desc, required this.cat, required this.bg});
}

const _styles = [
  _Style(emoji: '👔', name: 'Oxford Shirt', price: 'From ₹1,200', desc: 'Classic collar, slim or relaxed', cat: 'shirt', bg: Color(0xFFF5F0E8)),
  _Style(emoji: '🎽', name: 'Formal Dress Shirt', price: 'From ₹1,500', desc: 'Spread collar, French cuffs', cat: 'shirt', bg: Color(0xFFEEF2FA)),
  _Style(emoji: '👖', name: 'Slim Trousers', price: 'From ₹1,800', desc: 'Tapered leg, flat front', cat: 'trouser', bg: Color(0xFFF0EDE8)),
  _Style(emoji: '🤵', name: 'Two-Piece Suit', price: 'From ₹8,000', desc: 'Single breasted, notch lapel', cat: 'suit', bg: Color(0xFFEAF0EA)),
  _Style(emoji: '🧥', name: 'Three-Piece Suit', price: 'From ₹11,000', desc: 'Full waistcoat included', cat: 'suit', bg: Color(0xFFEDE8F0)),
  _Style(emoji: '👘', name: 'Kurta Pyjama', price: 'From ₹2,200', desc: 'Straight cut, embroidered collar', cat: 'traditional', bg: Color(0xFFFFF0E8)),
  _Style(emoji: '🌺', name: 'Saree Blouse', price: 'From ₹900', desc: 'Back neck design, custom fit', cat: 'traditional', bg: Color(0xFFFEF0F5)),
  _Style(emoji: '👗', name: 'Chino Pants', price: 'From ₹1,400', desc: 'Mid-rise, relaxed taper', cat: 'trouser', bg: Color(0xFFEDF5EE)),
  _Style(emoji: '🧣', name: 'Nehru Jacket', price: 'From ₹3,500', desc: 'Mandarin collar, festive wear', cat: 'traditional', bg: Color(0xFFF5EEE8)),
  _Style(emoji: '🎩', name: 'Blazer', price: 'From ₹5,000', desc: 'Smart casual, unstructured', cat: 'suit', bg: Color(0xFFEEF5EE)),
];

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selected = 'all';

  final _cats = [
    ('all', 'All'),
    ('shirt', 'Shirts'),
    ('trouser', 'Trousers'),
    ('suit', 'Suits'),
    ('traditional', 'Traditional'),
  ];

  List<_Style> get _filtered => _selected == 'all' ? _styles : _styles.where((s) => s.cat == _selected).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Browse Styles'), backgroundColor: AppColors.thread),
      body: Column(
        children: [
          // ── Category chips ───────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _cats.map((c) {
                  final sel = _selected == c.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = c.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.thread : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? AppColors.thread : Colors.black26, width: 0.5),
                        ),
                        child: Text(c.$2, style: TextStyle(fontSize: 13, color: sel ? AppColors.cream : AppColors.taupe, fontWeight: sel ? FontWeight.w500 : FontWeight.w400)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // ── Grid ─────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _StyleCard(style: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final _Style style;
  const _StyleCard({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomize(context, style),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(color: style.bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                child: Center(child: Text(style.emoji, style: const TextStyle(fontSize: 46))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(style.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.thread)),
                const SizedBox(height: 2),
                Text(style.price, style: const TextStyle(fontSize: 12, color: AppColors.gold, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(style.desc, style: const TextStyle(fontSize: 11, color: AppColors.taupe), maxLines: 2),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomize(BuildContext context, _Style s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(s.emoji, style: const TextStyle(fontSize: 28)))),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.thread)),
                Text(s.price, style: const TextStyle(fontSize: 13, color: AppColors.gold)),
              ]),
            ]),
            const SizedBox(height: 20),
            const SectionLabel('Customise Design'),
            _DropdownField(label: 'Color', items: ['Navy Blue', 'Off-White', 'Charcoal', 'Beige', 'Black', 'Forest Green']),
            const SizedBox(height: 10),
            _DropdownField(label: 'Collar Style', items: ['Classic', 'Spread', 'Mandarin', 'Button-down']),
            const SizedBox(height: 10),
            _DropdownField(label: 'Sleeve', items: ['Full Sleeve', 'Half Sleeve', 'Sleeveless', '3/4 Sleeve']),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Add to Order'))),
              const SizedBox(width: 10),
              OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _DropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  const _DropdownField({required this.label, required this.items});
  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  late String _val;
  @override
  void initState() { super.initState(); _val = widget.items.first; }
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: const TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
        value: _val,
        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
        items: widget.items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: (v) => setState(() => _val = v!),
      ),
    ]);
  }
}
