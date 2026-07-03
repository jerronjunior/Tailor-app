import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/core/widgets/premium_card.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      backgroundImage: const NetworkImage(
                          'https://ui-avatars.com/api/?name=Customer&background=random'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            currentUser?.name ?? 'Customer Name',
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          style: IconButton.styleFrom(
                            backgroundColor: isDark 
                                ? AppColors.darkCardBackground 
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: theme.dividerColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tailors, dress styles...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),

              // Promotional Banner
              const SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 160,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 4),
                ),
                items: [
                  _buildPromoBanner(
                    context,
                    'New Summer Collection',
                    'Up to 30% off on custom dresses',
                    'https://images.unsplash.com/photo-1550614000-4b95d4662fb2?w=800&q=80',
                    AppColors.primary,
                  ),
                  _buildPromoBanner(
                    context,
                    'Wedding Season',
                    'Premium tailoring for your big day',
                    'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&q=80',
                    AppColors.accent,
                  ),
                ],
              ),

              // Categories
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Categories', 'See All'),
              const SizedBox(height: 16),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategoryItem(context, 'Men\'s Wear', Icons.checkroom, [const Color(0xFF4F46E5), const Color(0xFF818CF8)]),
                    _buildCategoryItem(context, 'Women\'s', Icons.dry_cleaning, [const Color(0xFFE11D48), const Color(0xFFFB7185)]),
                    _buildCategoryItem(context, 'Kids Wear', Icons.child_care, [const Color(0xFF059669), const Color(0xFF34D399)]),
                    _buildCategoryItem(context, 'Wedding', Icons.favorite, [const Color(0xFFD97706), const Color(0xFFFBBF24)]),
                    _buildCategoryItem(context, 'Alterations', Icons.cut, [const Color(0xFF475569), const Color(0xFF94A3B8)]),
                  ],
                ),
              ),

              // Featured Tailors
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Featured Tailors', 'View All'),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildTailorCard(context, 'Master Stitch', '10+ yrs exp', '4.9', '\$50', 'https://images.unsplash.com/photo-1556828559-0f666f772428?w=400&q=80'),
                    const SizedBox(width: 16),
                    _buildTailorCard(context, 'Elegant Fits', '8 yrs exp', '4.8', '\$40', 'https://images.unsplash.com/photo-1579503841516-e0bd7fca5faa?w=400&q=80'),
                    const SizedBox(width: 16),
                    _buildTailorCard(context, 'Royal Tailors', '15 yrs exp', '4.9', '\$80', 'https://images.unsplash.com/photo-1549439602-43ebca2327af?w=400&q=80'),
                  ],
                ),
              ),

              // Quick Actions
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Quick Actions', null),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildQuickAction(context, 'New Order', Icons.add_circle, AppColors.primary, () => context.push(AppRoutes.tailorList)),
                    _buildQuickAction(context, 'Measurements', Icons.straighten, AppColors.accent, () => context.push(AppRoutes.measurementProfiles)),
                    _buildQuickAction(context, 'Saved', Icons.bookmark, AppColors.secondary, () {}),
                    _buildQuickAction(context, 'My Orders', Icons.shopping_bag, const Color(0xFFF59E0B), () => context.push(AppRoutes.orderHistory)),
                  ],
                ),
              ),

              // Popular Dress Designs
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Popular Designs', 'More'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final designs = [
                      {'name': 'Classic Tuxedo', 'cat': 'Men\'s Wear', 'price': 'est. \$120', 'img': 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e5?w=400&q=80'},
                      {'name': 'Summer Dress', 'cat': 'Women\'s Wear', 'price': 'est. \$60', 'img': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400&q=80'},
                      {'name': 'Linen Kurta', 'cat': 'Men\'s Wear', 'price': 'est. \$45', 'img': 'https://images.unsplash.com/photo-1596755094514-f87e32f6b717?w=400&q=80'},
                      {'name': 'Evening Gown', 'cat': 'Women\'s Wear', 'price': 'est. \$150', 'img': 'https://images.unsplash.com/photo-1566160983933-4f96408bc882?w=400&q=80'},
                    ];
                    return _buildDesignCard(context, designs[index]);
                  },
                ),
              ),
              
              // Recent Orders
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Recent Orders', 'History'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildRecentOrder(context, '#ORD-001', 'Master Stitch', 'Fitting Scheduled', 'Oct 24, 2026', 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e5?w=200&q=80', AppColors.warning),
                    const SizedBox(height: 12),
                    _buildRecentOrder(context, '#ORD-002', 'Elegant Fits', 'Completed', 'Oct 10, 2026', 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=200&q=80', AppColors.success),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.tailorList),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String? action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (action != null)
            TextButton(
              onPressed: () {},
              child: Text(action),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, String title, String subtitle, String imageUrl, Color overlayColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  overlayColor.withOpacity(0.8),
                  overlayColor.withOpacity(0.3),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Explore Now', style: TextStyle(color: overlayColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon, List<Color> gradientColors) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: gradientColors[0].withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTailorCard(BuildContext context, String name, String exp, String rating, String price, String img) {
    final theme = Theme.of(context);
    return PremiumCard(
      width: 260,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Image.network(img, width: 100, height: double.infinity, fit: BoxFit.cover),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(rating, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('· $exp', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Starts from', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
                          Text(price, style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Text('View', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDesignCard(BuildContext context, Map<String, String> data) {
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(data['img']!, fit: BoxFit.cover),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['name']!, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(data['cat']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                const SizedBox(height: 6),
                Text(data['price']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrder(BuildContext context, String orderId, String tailor, String status, String date, String img, Color statusColor) {
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(img, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(orderId, style: Theme.of(context).textTheme.titleSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(tailor, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('Est. Delivery: $date', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
