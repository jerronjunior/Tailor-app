import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kBlue = Color(0xFF4A90E2);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class _TailorCard {
  final String name;
  final String photoUrl;
  final Color avatarBg;
  final String distance;
  final String specialty;
  final double rating;
  final String startPrice;
  _TailorCard({required this.name, required this.photoUrl, required this.avatarBg, required this.distance, required this.specialty, required this.rating, required this.startPrice});
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _sortBy = 'Rating';
  String _specialty = 'All';
  final _searchCtrl = TextEditingController();
  String _search = '';

  final _allTailors = [
    _TailorCard(name: 'Ravi Kumar', photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&h=300&fit=crop&q=80', avatarBg: _kGold, distance: '0.8 km', specialty: 'Suits, Formal, Ethnic', rating: 4.9, startPrice: '₹1,200'),
    _TailorCard(name: 'Priya Sharma', photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&h=300&fit=crop&q=80', avatarBg: const Color(0xFF8B3A62), distance: '1.4 km', specialty: 'Traditional, Sarees', rating: 4.8, startPrice: '₹900'),
    _TailorCard(name: 'Amara Mensah', photoUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&h=300&fit=crop&q=80', avatarBg: const Color(0xFF2C5F8A), distance: '2.1 km', specialty: 'Ankara, Kente, African prints', rating: 4.7, startPrice: '₹1,500'),
    _TailorCard(name: 'Suresh Khatri', photoUrl: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=300&h=300&fit=crop&q=80', avatarBg: const Color(0xFF3B6D11), distance: '2.8 km', specialty: 'Shirts, Trousers', rating: 4.5, startPrice: '₹800'),
    _TailorCard(name: 'Fatima Osei', photoUrl: 'https://images.unsplash.com/photo-1598550874175-4d0ef436c909?w=300&h=300&fit=crop&q=80', avatarBg: const Color(0xFF993C1D), distance: '3.2 km', specialty: 'Bridal, Traditional', rating: 4.9, startPrice: '₹2,000'),
  ];

  List<_TailorCard> get _filtered {
    var list = _allTailors.where((t) {
      final ms = _search.isEmpty || t.name.toLowerCase().contains(_search.toLowerCase()) || t.specialty.toLowerCase().contains(_search.toLowerCase());
      final msp = _specialty == 'All' || t.specialty.toLowerCase().contains(_specialty.toLowerCase());
      return ms && msp;
    }).toList();
    if (_sortBy == 'Rating') list.sort((a, b) => b.rating.compareTo(a.rating));
    if (_sortBy == 'Distance') list.sort((a, b) => a.distance.compareTo(b.distance));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Hero image
          Positioned(
            top: 0, left: 0, right: 0, height: 240,
            child: Image.network(
              'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=1200&h=600&fit=crop&q=85',
              fit: BoxFit.cover,
              loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B)),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0, height: 280,
            child: const DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.35, 1.0]),
            )),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(children: [
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('NEARBY STUDIOS', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                      SizedBox(height: 4),
                      Text('Discover Tailors', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                    ]),
                  ]),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.13),

                // Filter card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _kCard, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _kBorder),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(children: [
                    // Search
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _search = v),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 18, color: _kMuted),
                        hintText: 'Search by name or specialty…',
                        hintStyle: const TextStyle(color: _kMuted, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kGold, width: 1.5)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: _DarkDropdown(label: 'Sort', value: _sortBy, items: const ['Rating', 'Distance', 'Price'], onChanged: (v) => setState(() => _sortBy = v))),
                      const SizedBox(width: 10),
                      Expanded(child: _DarkDropdown(label: 'Specialty', value: _specialty, items: const ['All', 'Suits', 'Traditional', 'Shirts', 'Bridal', 'Ethnic'], onChanged: (v) => setState(() => _specialty = v))),
                    ]),
                  ]),
                ),
                const SizedBox(height: 12),

                // Map strip
                Container(
                  height: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=900&h=300&fit=crop&q=80',
                        fit: BoxFit.cover, width: double.infinity,
                        loadingBuilder: (_, c, p) => p == null ? c : Container(color: _kCard),
                      ),
                      Container(color: const Color(0xAA0D1B2A)),
                      const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.map_outlined, color: _kGold, size: 20),
                        SizedBox(width: 8),
                        Text('Map View — Nearby Area', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ])),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),

                // Tailor list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _TailorListCard(tailor: _filtered[i]),
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

class _TailorListCard extends StatelessWidget {
  final _TailorCard tailor;
  const _TailorListCard({required this.tailor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 52, height: 52,
            child: Image.network(tailor.photoUrl, fit: BoxFit.cover,
                loadingBuilder: (_, c, p) => p == null ? c : Container(color: tailor.avatarBg.withOpacity(0.3))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tailor.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 2),
          Text('${tailor.distance} · ${tailor.specialty}', style: const TextStyle(fontSize: 11, color: _kMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star_rounded, size: 13, color: _kGold),
            const SizedBox(width: 3),
            Text('${tailor.rating}', style: const TextStyle(fontSize: 12, color: _kGold, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Text('· From ${tailor.startPrice}', style: const TextStyle(fontSize: 11, color: _kMuted)),
          ]),
        ])),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(12)),
            child: const Text('Order', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w800)),
          ),
        ),
      ]),
    );
  }
}

class _DarkDropdown extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DarkDropdown({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: _kCard,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      icon: const Icon(Icons.keyboard_arrow_down, color: _kMuted, size: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _kMuted, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kBorder)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: (v) => onChanged(v!),
    );
  }
}
