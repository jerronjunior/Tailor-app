import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class _Style {
  final String imageUrl;
  final String name;
  final String price;
  final String desc;
  final String cat;
  final Color accent;
  const _Style({required this.imageUrl, required this.name, required this.price, required this.desc, required this.cat, required this.accent});
}

const _styles = [
  _Style(imageUrl: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=600&h=700&fit=crop&q=80', name: 'Oxford Shirt', price: 'From ₹1,200', desc: 'Classic collar, slim or relaxed', cat: 'shirt', accent: Color(0xFF4A90E2)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1506629082632-2cecf5b67c9b?w=600&h=700&fit=crop&q=80', name: 'Formal Dress Shirt', price: 'From ₹1,500', desc: 'Spread collar, French cuffs', cat: 'shirt', accent: Color(0xFF4A90E2)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=600&h=700&fit=crop&q=80', name: 'Slim Trousers', price: 'From ₹1,800', desc: 'Tapered leg, flat front', cat: 'trouser', accent: Color(0xFF8B6914)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600&h=700&fit=crop&q=80', name: 'Two-Piece Suit', price: 'From ₹8,000', desc: 'Single breasted, notch lapel', cat: 'suit', accent: _kGold),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=600&h=700&fit=crop&q=80', name: 'Three-Piece Suit', price: 'From ₹11,000', desc: 'Full waistcoat included', cat: 'suit', accent: _kGold),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=600&h=700&fit=crop&q=80', name: 'Kurta Pyjama', price: 'From ₹2,200', desc: 'Straight cut, embroidered collar', cat: 'traditional', accent: Color(0xFF993C1D)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1610189352649-6c947e0a8c91?w=600&h=700&fit=crop&q=80', name: 'Saree Blouse', price: 'From ₹900', desc: 'Back neck design, custom fit', cat: 'traditional', accent: Color(0xFF8B3A62)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600&h=700&fit=crop&q=80', name: 'Chino Pants', price: 'From ₹1,400', desc: 'Mid-rise, relaxed taper', cat: 'trouser', accent: Color(0xFF3B6D11)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=600&h=700&fit=crop&q=80', name: 'Nehru Jacket', price: 'From ₹3,500', desc: 'Mandarin collar, festive wear', cat: 'traditional', accent: Color(0xFF993C1D)),
  _Style(imageUrl: 'https://images.unsplash.com/photo-1588731234527-a07f15d50c71?w=600&h=700&fit=crop&q=80', name: 'Blazer', price: 'From ₹5,000', desc: 'Smart casual, unstructured', cat: 'suit', accent: _kGold),
];

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});
  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selected = 'all';

  final _cats = [('all', 'All'), ('shirt', 'Shirts'), ('trouser', 'Trousers'), ('suit', 'Suits'), ('traditional', 'Traditional')];
  List<_Style> get _filtered => _selected == 'all' ? _styles : _styles.where((s) => s.cat == _selected).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Hero
          Positioned(
            top: 0, left: 0, right: 0, height: 220,
            child: Image.network(
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&h=600&fit=crop&q=85',
              fit: BoxFit.cover,
              loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B)),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0, height: 260,
            child: const DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0]),
            )),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('COLLECTIONS', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                    SizedBox(height: 4),
                    Text('Browse Styles', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                  ]),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                // Category chips
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: _cats.map((c) {
                      final sel = _selected == c.$1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = c.$1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: sel ? _kGold : _kCard,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: sel ? _kGold : _kBorder),
                            ),
                            child: Text(c.$2, style: TextStyle(fontSize: 13, color: sel ? Colors.black : _kMuted, fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _StyleCard(style: _filtered[i]),
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

class _StyleCard extends StatelessWidget {
  final _Style style;
  const _StyleCard({required this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomize(context, style),
      child: Container(
        decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(18), border: Border.all(color: _kBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(style.imageUrl, fit: BoxFit.cover,
                    loadingBuilder: (_, c, p) => p == null ? c : Container(color: style.accent.withOpacity(0.1))),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)], stops: const [0.6, 1.0]),
                  ),
                ),
                Positioned(top: 10, right: 10, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: style.accent.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                  child: Text(style.price, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                )),
              ]),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(style.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 3),
              Text(style.desc, style: const TextStyle(fontSize: 11, color: _kMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(color: style.accent, borderRadius: BorderRadius.circular(10)),
                  child: const Text('Customize', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                )),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showCustomize(BuildContext context, _Style s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _kCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(width: 56, height: 56, child: Image.network(s.imageUrl, fit: BoxFit.cover)),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                Text(s.price, style: TextStyle(fontSize: 13, color: s.accent, fontWeight: FontWeight.w600)),
              ]),
            ]),
            const SizedBox(height: 20),
            _sheetLabel('Customise Design'),
            _DarkSheet(label: 'Color', items: ['Navy Blue', 'Off-White', 'Charcoal', 'Beige', 'Black', 'Forest Green']),
            const SizedBox(height: 10),
            _DarkSheet(label: 'Collar Style', items: ['Classic', 'Spread', 'Mandarin', 'Button-down']),
            const SizedBox(height: 10),
            _DarkSheet(label: 'Sleeve', items: ['Full Sleeve', 'Half Sleeve', 'Sleeveless', '3/4 Sleeve']),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: s.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Add to Order', style: TextStyle(fontWeight: FontWeight.w800)),
              )),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(foregroundColor: _kMuted, side: BorderSide(color: _kBorder), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20)),
                child: const Text('Save'),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _sheetLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      Container(width: 3, height: 14, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(text.toUpperCase(), style: const TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
    ]),
  );
}

class _DarkSheet extends StatefulWidget {
  final String label;
  final List<String> items;
  const _DarkSheet({required this.label, required this.items});
  @override
  State<_DarkSheet> createState() => _DarkSheetState();
}

class _DarkSheetState extends State<_DarkSheet> {
  late String _val;
  @override
  void initState() { super.initState(); _val = widget.items.first; }
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: const TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
        value: _val,
        dropdownColor: _kCard,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        icon: const Icon(Icons.keyboard_arrow_down, color: _kMuted),
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold)),
        ),
        items: widget.items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: (v) => setState(() => _val = v!),
      ),
    ]);
  }
}
