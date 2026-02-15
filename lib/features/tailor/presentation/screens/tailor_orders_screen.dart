import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/services/chat_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/tailor/providers/tailor_providers.dart';

class TailorOrdersScreen extends ConsumerWidget {
  const TailorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(tailorOrdersProvider);
    final tailorId = ref.watch(currentUserProvider)?.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Orders'),
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
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${order.dressType} - ${order.color}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Chip(label: Text(order.status)),
                        ],
                      ),
                      Text('Delivery: ${DateFormat.yMMMd().format(order.deliveryDate)}'),
                      if (order.status == AppConstants.statusPending) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            FilledButton(
                              onPressed: () => _acceptOrder(context, ref, order),
                              child: const Text('Accept'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => _rejectOrder(context, ref, order),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                      if (order.status != AppConstants.statusPending &&
                          order.status != AppConstants.statusRejected) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: AppConstants.orderStatusList
                              .where((s) =>
                                  s != AppConstants.statusPending &&
                                  s != AppConstants.statusRejected)
                              .map((status) {
                                return ChoiceChip(
                                  label: Text(status),
                                  selected: order.status == status,
                                  onSelected: (v) {
                                    if (v) _updateStatus(context, ref, order.id, status);
                                  },
                                );
                              })
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: tailorId != null
                            ? () {
                                final chatId = ChatService.chatId(
                                  order.customerId,
                                  order.tailorId,
                                );
                                context.push('/tailor/chat/$chatId');
                              }
                            : null,
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('Chat with customer'),
                      ),
                    ],
                  ),
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

  void _acceptOrder(BuildContext context, WidgetRef ref, OrderModel order) async {
    await ref.read(tailorFirestoreProvider).acceptOrder(order.id, null);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order accepted')),
      );
    }
  }

  void _rejectOrder(BuildContext context, WidgetRef ref, OrderModel order) async {
    await ref.read(tailorFirestoreProvider).rejectOrder(order.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order rejected')),
      );
    }
  }

  void _updateStatus(
    BuildContext context,
    WidgetRef ref,
    String orderId,
    String status,
  ) async {
    await ref.read(tailorFirestoreProvider).updateOrderStatus(orderId, status);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status: $status')),
      );
    }
  }
}
