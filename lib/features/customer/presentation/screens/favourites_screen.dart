import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavStyle {
  final String emoji;
  final String name;
  final String price;
  final Color bg;
  bool saved;
  _FavStyle({required this.emoji, required this.name, required this.price, required this.bg, this.saved = true});
}

class _FavTailor {
  final String initials;
  final Color avatarBg;
  final String name;
  final String rating;
  final String specialty;
  bool saved;
  _FavTailor({required this.initials, required this.avatarBg, required this.name, required this.rating, required this.specialty, this.saved = true});
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _styles = [
    _FavStyle(emoji: '🧣', name: 'Nehru Jacket', price: 'From ₹3,500', bg: const Color(0xFFF5EEE8)),
    _FavStyle(emoji: '👔', name: 'Linen Shirt', price: 'From ₹1,200', bg: const Color(0xFFF5F0E8)),
    _FavStyle(emoji: '🧥', name: 'Three-Piece Suit', price: 'From ₹11,000', bg: const Color(0xFFEDE8F0)),
    _FavStyle(emoji: '👘', name: 'Kurta Pyjama', price: 'From ₹2,200', bg: const Color(0xFFFFF0E8)),
  ];
  final _tailors = [
    _FavTailor(initials: 'RK', avatarBg: AppColors.gold, name: 'Ravi Kumar', rating: '⭐ 4.9', specialty: 'Suits & Formal'),
    _FavTailor(initials: 'PS', avatarBg: const Color(0xFF8B3A62), name: 'Priya Sharma', rating: '⭐ 4.8', specialty: 'Traditional & Sarees'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Favourites'), backgroundColor: AppColors.thread),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Saved designs ──────────────────────────────────────
          const SectionLabel('Saved Designs'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.0),
            itemCount: _styles.length,
            itemBuilder: (_, i) {
              final s = _styles[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
                ),
                child: Column(children: [
                  Expanded(child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(color: s.bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                      child: Center(child: Text(s.emoji, style: const TextStyle(fontSize: 36))),
                    ),
                    Positioned(top: 8, right: 8, child: GestureDetector(
                      onTap: () => setState(() => s.saved = !s.saved),
                      child: Icon(s.saved ? Icons.favorite : Icons.favorite_border, color: s.saved ? Colors.red : Colors.white70, size: 20),
                    )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.thread)),
                      Text(s.price, style: const TextStyle(fontSize: 11, color: AppColors.gold)),
                    ]),
                  ),
                ]),
              );
            },
          ),
          const SizedBox(height: 20),

          // ── Saved tailors ──────────────────────────────────────
          const SectionLabel('Saved Tailors'),
          ..._tailors.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
            ),
            child: Row(children: [
              AvatarCircle(initials: t.initials, bg: t.avatarBg, fg: Colors.white, size: 48, fontSize: 17),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.thread)),
                Text('${t.rating} · ${t.specialty}', style: const TextStyle(fontSize: 12, color: AppColors.gold)),
              ])),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Message', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => t.saved = !t.saved),
                child: Icon(t.saved ? Icons.favorite : Icons.favorite_border, color: t.saved ? Colors.red : AppColors.taupe, size: 20),
              ),
            ]),
          )),
        ]),
      ),
    );
  }
}
