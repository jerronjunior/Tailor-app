import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/features/customer/providers/customer_providers.dart';
import 'package:tailor_app/data/services/chat_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider);
    final currentUserId = ref.watch(currentUserProvider)?.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              return Card(
                child: ListTile(
                  title: Text('${order.dressType} - ${order.color}'),
                  subtitle: Text(
                    'Status: ${order.status} • ${DateFormat.yMMMd().format(order.createdAt)}',
                  ),
                  trailing: Chip(label: Text(order.status)),
                  onTap: () => _showOrderDetail(context, order),
                  onLongPress: currentUserId != null
                      ? () {
                          final chatId = ChatService.chatId(
                            order.customerId,
                            order.tailorId,
                          );
                          context.push('/customer/chat/$chatId');
                        }
                      : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showOrderDetail(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Dress: ${order.dressType}'),
            Text('Color: ${order.color}'),
            Text('Delivery: ${DateFormat.yMMMd().format(order.deliveryDate)}'),
            Text('Status: ${order.status}'),
            if (order.price != null) Text('Price: \$${order.price!.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
