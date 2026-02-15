import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/router/app_router.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/tailor/providers/tailor_providers.dart';

class TailorHomeScreen extends ConsumerStatefulWidget {
  const TailorHomeScreen({super.key});

  @override
  ConsumerState<TailorHomeScreen> createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends ConsumerState<TailorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final ordersAsync = ref.watch(tailorOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tailor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go(AppRoutes.roleSelect);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null)
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  ),
                  SwitchListTile(
                    title: const Text('Available for orders'),
                    value: user.isAvailable ?? false,
                    onChanged: (v) async {
                      final uid = ref.read(currentUserProvider)?.id;
                      if (uid != null) {
                        await ref.read(authServiceProvider).updateAvailability(uid, v);
                      }
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('My Orders'),
            subtitle: ordersAsync.when(
              data: (orders) => Text('${orders.length} orders'),
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('Error'),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.tailorOrders),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
              title: const Text('Earnings summary'),
              subtitle: ordersAsync.when(
                data: (orders) {
                  final completed = orders
                      .where((o) => o.status == 'Ready' && o.price != null)
                      .toList();
                  final total = completed.fold<double>(
                    0,
                    (sum, o) => sum + (o.price ?? 0),
                  );
                  return Text('Completed: ${completed.length} • Total: \$${total.toStringAsFixed(2)}');
                },
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('Error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
