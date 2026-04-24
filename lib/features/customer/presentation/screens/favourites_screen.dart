// favourites_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavStyle {
  final String imageUrl;
  final String name;
  final String price;
  final Color accent;
  bool saved;
  _FavStyle({required this.imageUrl, required this.name, required this.price, required this.accent}) : saved = true;
}

class _FavTailor {
  final String name;
  final String photoUrl;
  final Color avatarBg;
  final String rating;
  final String specialty;
  bool saved;
  _FavTailor({required this.name, required this.photoUrl, required this.avatarBg, required this.rating, required this.specialty}) : saved = true;
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _styles = [
    _FavStyle(imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400&h=500&fit=crop&q=80', name: 'Nehru Jacket', price: 'From ₹3,500', accent: const Color(0xFF993C1D)),
    _FavStyle(imageUrl: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=400&h=500&fit=crop&q=80', name: 'Linen Shirt', price: 'From ₹1,200', accent: const Color(0xFF4A90E2)),
    _FavStyle(imageUrl: 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=400&h=500&fit=crop&q=80', name: 'Three-Piece Suit', price: 'From ₹11,000', accent: _kGold),
    _FavStyle(imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=400&h=500&fit=crop&q=80', name: 'Kurta Pyjama', price: 'From ₹2,200', accent: const Color(0xFF8B3A62)),
  ];
  final _tailors = [
    _FavTailor(name: 'Ravi Kumar', photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&q=80', avatarBg: _kGold, rating: '4.9', specialty: 'Suits & Formal'),
    _FavTailor(name: 'Priya Sharma', photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&h=200&fit=crop&q=80', avatarBg: const Color(0xFF8B3A62), rating: '4.8', specialty: 'Traditional & Sarees'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Image.network('https://images.unsplash.com/photo-1445205170230-053b83016050?w=1200&h=500&fit=crop&q=80',
                fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B))),
          ),
          Positioned(
            top: 0, left: 0, right: 0, height: 240,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0]))),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('MY COLLECTION', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                const SizedBox(height: 4),
                const Text('Favourites', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                _darkSectionLabel('Saved Designs'),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.82),
                  itemCount: _styles.length,
                  itemBuilder: (_, i) {
                    final s = _styles[i];
                    return Container(
                      decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
                      child: Column(children: [
                        Expanded(child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Stack(fit: StackFit.expand, children: [
                            Image.network(s.imageUrl, fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: s.accent.withOpacity(0.1))),
                            Positioned(top: 8, right: 8, child: GestureDetector(
                              onTap: () => setState(() => s.saved = !s.saved),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                child: Icon(s.saved ? Icons.favorite : Icons.favorite_border, color: s.saved ? Colors.red : Colors.white70, size: 16),
                              ),
                            )),
                          ]),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                            Text(s.price, style: TextStyle(fontSize: 11, color: s.accent, fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      ]),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _darkSectionLabel('Saved Tailors'),
                const SizedBox(height: 12),
                ..._tailors.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: _kBorder)),
                  child: Row(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(12),
                      child: SizedBox(width: 50, height: 50, child: Image.network(t.photoUrl, fit: BoxFit.cover,
                          loadingBuilder: (_, c, p) => p == null ? c : Container(color: t.avatarBg.withOpacity(0.3))))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                      Row(children: [
                        const Icon(Icons.star_rounded, size: 13, color: _kGold),
                        const SizedBox(width: 3),
                        Text('${t.rating} · ${t.specialty}', style: const TextStyle(fontSize: 11, color: _kMuted)),
                      ]),
                    ])),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(color: _kGold.withOpacity(0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: _kGold.withOpacity(0.3))),
                        child: const Text('Message', style: TextStyle(color: _kGold, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => t.saved = !t.saved),
                      child: Icon(t.saved ? Icons.favorite : Icons.favorite_border, color: t.saved ? Colors.red : _kMuted, size: 20),
                    ),
                  ]),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkSectionLabel(String text) {
    return Row(children: [
      Container(width: 3, height: 16, decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
    ]);
  }
}
