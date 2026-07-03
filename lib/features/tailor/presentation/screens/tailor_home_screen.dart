import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/core/widgets/premium_card.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

class TailorHomeScreen extends ConsumerStatefulWidget {
  const TailorHomeScreen({super.key});

  @override
  ConsumerState<TailorHomeScreen> createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends ConsumerState<TailorHomeScreen> {
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
                          'https://ui-avatars.com/api/?name=Master+Tailor&background=random'),
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
                            currentUser?.name ?? 'Master Tailor',
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

              // Business Summary Cards
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: [
                    _buildSummaryCard(context, 'Total Orders', '142', '+12%', Icons.receipt_long, AppColors.primary),
                    _buildSummaryCard(context, 'Active Orders', '15', '+3', Icons.pending_actions, AppColors.secondary),
                    _buildSummaryCard(context, 'Completed', '120', '+8', Icons.task_alt, AppColors.accent),
                    _buildSummaryCard(context, 'Earnings', '\$4.2k', '+15%', Icons.attach_money, const Color(0xFFF59E0B)),
                  ],
                ),
              ),

              // New Orders
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'New Orders', 'View All'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildNewOrderCard(context, 'Jane Doe', 'Evening Gown', 'Oct 28', 'https://ui-avatars.com/api/?name=Jane+Doe'),
                    const SizedBox(height: 12),
                    _buildNewOrderCard(context, 'John Smith', 'Custom Suit', 'Nov 2', 'https://ui-avatars.com/api/?name=John+Smith'),
                  ],
                ),
              ),

              // Today's Schedule
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Today\'s Schedule', null),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PremiumCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTimelineItem(context, '10:00 AM', 'Measurements', 'Jane Doe (Wedding Dress)', true),
                      _buildTimelineItem(context, '12:30 PM', 'Dress Fitting', 'Emily Rose', true),
                      _buildTimelineItem(context, '03:00 PM', 'Customer Meeting', 'Alex (Suit Alteration)', false),
                      _buildTimelineItem(context, '05:00 PM', 'Delivery', 'Mike T. (Linen Kurta)', false, isLast: true),
                    ],
                  ),
                ),
              ),

              // Earnings Overview Chart
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Earnings Overview', 'Details'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PremiumCard(
                  height: 250,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weekly Income', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 20),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(days[value.toInt()], style: theme.textTheme.bodySmall),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              _makeBarData(0, 40, AppColors.primary),
                              _makeBarData(1, 60, AppColors.primary),
                              _makeBarData(2, 80, AppColors.primary),
                              _makeBarData(3, 30, AppColors.primary),
                              _makeBarData(4, 90, AppColors.primary),
                              _makeBarData(5, 50, AppColors.primary),
                              _makeBarData(6, 70, AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    _buildQuickAction(context, 'Add Design', Icons.add_photo_alternate, AppColors.primary, () {}),
                    _buildQuickAction(context, 'Orders', Icons.receipt_long, AppColors.secondary, () => context.push(AppRoutes.tailorOrders)),
                    _buildQuickAction(context, 'Customers', Icons.people, AppColors.accent, () {}),
                    _buildQuickAction(context, 'Analytics', Icons.bar_chart, const Color(0xFFF59E0B), () {}),
                  ],
                ),
              ),

              // Customer Reviews
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Recent Reviews', 'All'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildReviewCard(context, 'Sarah L.', 'Perfect fit and delivered on time!', '5.0', '2 days ago', 'https://ui-avatars.com/api/?name=Sarah+L'),
                    const SizedBox(height: 12),
                    _buildReviewCard(context, 'Mark Z.', 'Great attention to detail on my suit.', '4.8', '1 week ago', 'https://ui-avatars.com/api/?name=Mark+Z'),
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
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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

  Widget _buildSummaryCard(BuildContext context, String title, String value, String trend, IconData icon, Color color) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Row(
                children: [
                  Icon(Icons.arrow_upward, size: 12, color: AppColors.accent),
                  Text(trend, style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrderCard(BuildContext context, String name, String type, String date, String avatar) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatar),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text('$type • By $date', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.close, color: AppColors.error),
                style: IconButton.styleFrom(backgroundColor: AppColors.error.withOpacity(0.1)),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.check, color: AppColors.success),
                style: IconButton.styleFrom(backgroundColor: AppColors.success.withOpacity(0.1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String time, String title, String subtitle, bool isCompleted, {bool isLast = false}) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(time, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primary : theme.dividerColor,
                border: Border.all(color: isCompleted ? AppColors.primary : theme.dividerColor, width: 2),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.primary.withOpacity(0.5) : theme.dividerColor,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _makeBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
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

  Widget _buildReviewCard(BuildContext context, String name, String comment, String rating, String date, String avatar) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatar),
                radius: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleSmall),
                    Text(date, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
