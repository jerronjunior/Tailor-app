import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';
import 'package:tailor_app/widgets/feature_image_banner.dart';

class _TailorCard {
  final String initials;
  final Color avatarBg;
  final String name;
  final String distance;
  final String specialty;
  final double rating;
  final String startPrice;
  _TailorCard({required this.initials, required this.avatarBg, required this.name, required this.distance, required this.specialty, required this.rating, required this.startPrice});
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
    _TailorCard(initials: 'RK', avatarBg: AppColors.gold, name: 'Ravi Kumar', distance: '0.8 km', specialty: 'Suits, Formal, Ethnic', rating: 4.9, startPrice: '₹1,200'),
    _TailorCard(initials: 'PS', avatarBg: const Color(0xFF8B3A62), name: 'Priya Sharma', distance: '1.4 km', specialty: 'Traditional, Sarees', rating: 4.8, startPrice: '₹900'),
    _TailorCard(initials: 'AM', avatarBg: const Color(0xFF2C5F8A), name: 'Amara Mensah', distance: '2.1 km', specialty: 'Ankara, Kente, African prints', rating: 4.7, startPrice: '₹1,500'),
    _TailorCard(initials: 'SK', avatarBg: const Color(0xFF3B6D11), name: 'Suresh Khatri', distance: '2.8 km', specialty: 'Shirts, Trousers', rating: 4.5, startPrice: '₹800'),
    _TailorCard(initials: 'FO', avatarBg: const Color(0xFF993C1D), name: 'Fatima Osei', distance: '3.2 km', specialty: 'Bridal, Traditional', rating: 4.9, startPrice: '₹2,000'),
  ];

  List<_TailorCard> get _filtered {
    var list = _allTailors.where((t) {
      final matchSearch = _search.isEmpty || t.name.toLowerCase().contains(_search.toLowerCase()) || t.specialty.toLowerCase().contains(_search.toLowerCase());
      final matchSpec = _specialty == 'All' || t.specialty.toLowerCase().contains(_specialty.toLowerCase());
      return matchSearch && matchSpec;
    }).toList();
    if (_sortBy == 'Rating') list.sort((a, b) => b.rating.compareTo(a.rating));
    if (_sortBy == 'Distance') list.sort((a, b) => a.distance.compareTo(b.distance));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Discover Tailors'), backgroundColor: AppColors.thread),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: FeatureImageBanner(
              imageUrl: 'https://picsum.photos/seed/discover-hero/1200/800',
              eyebrow: 'Nearby studios',
              title: 'Find a tailor whose style matches yours.',
              subtitle: 'Browse carefully curated tailors and see who is closest, fastest, and best rated.',
              height: 200,
            ),
          ),
          const SizedBox(height: 12),
          // ── Filters ───────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _search = v),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search, size: 18, color: AppColors.taupe), hintText: 'Search by name or specialty…', contentPadding: EdgeInsets.symmetric(vertical: 10)),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _DropSelect(
                  label: 'Sort by',
                  value: _sortBy,
                  items: const ['Rating', 'Distance', 'Price'],
                  onChanged: (v) => setState(() => _sortBy = v),
                )),
                const SizedBox(width: 10),
                Expanded(child: _DropSelect(
                  label: 'Specialty',
                  value: _specialty,
                  items: const ['All', 'Suits', 'Traditional', 'Shirts', 'Bridal', 'Ethnic'],
                  onChanged: (v) => setState(() => _specialty = v),
                )),
              ]),
            ]),
          ),
          // ── Map placeholder ───────────────────────────────────
          Container(
            height: 140,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFFE8F0E0), Color(0xFFD4E8C8), Color(0xFFC8D4A0)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
            ),
            child: Stack(children: [
              const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.map_outlined, size: 32, color: AppColors.taupe),
                SizedBox(height: 6),
                Text('Map view — Lagos Area', style: TextStyle(fontSize: 13, color: AppColors.taupe)),
                Text('Showing nearby tailors', style: TextStyle(fontSize: 11, color: AppColors.taupe)),
              ])),
              ..._allTailors.take(3).toList().asMap().entries.map((e) => Positioned(
                left: 40.0 + e.key * 80,
                top: 20.0 + (e.key % 2) * 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.thread, borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.location_on, color: AppColors.gold, size: 10),
                    const SizedBox(width: 2),
                    Text(e.value.name.split(' ').first, style: const TextStyle(color: Colors.white, fontSize: 9)),
                  ]),
                ),
              )),
            ]),
          ),
          // ── Tailor list ───────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _TailorListCard(tailor: _filtered[i]),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
      ),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(
                tailor.initials == 'RK'
                ? 'https://picsum.photos/seed/tailor-rk/300/300'
                : tailor.initials == 'PS'
                  ? 'https://picsum.photos/seed/tailor-ps/300/300'
                  : tailor.initials == 'AM'
                    ? 'https://picsum.photos/seed/tailor-am/300/300'
                    : tailor.initials == 'SK'
                      ? 'https://picsum.photos/seed/tailor-sk/300/300'
                      : 'https://picsum.photos/seed/tailor-default/300/300',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tailor.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.thread)),
          const SizedBox(height: 2),
          Text('${tailor.distance} · ${tailor.specialty}', style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
          const SizedBox(height: 3),
          Row(children: [
            const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
            const SizedBox(width: 3),
            Text('${tailor.rating} · From ${tailor.startPrice}', style: const TextStyle(fontSize: 12, color: AppColors.gold, fontWeight: FontWeight.w500)),
          ]),
        ])),
        GoldButton(label: 'Order', onPressed: () {}),
      ]),
    );
  }
}

class _DropSelect extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DropSelect({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: (v) => onChanged(v!),
    );
  }
}
