import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/services/chat_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/tailor/providers/tailor_providers.dart';

const _kBg     = Color(0xFF0D1B2A);
const _kCard   = Color(0xFF1A2B3C);
const _kGold   = Color(0xFFD4AF37);
const _kBlue   = Color(0xFF4A90E2);
const _kGreen  = Color(0xFF4CAF50);
const _kMuted  = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

class TailorOrdersScreen extends ConsumerWidget {
  const TailorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(tailorOrdersProvider);
    final tailorId    = ref.watch(currentUserProvider)?.id;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // ── Hero image ───────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Image.network(
              'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=1200&h=500&fit=crop&q=85',
              fit: BoxFit.cover,
              loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B)),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0, height: 240,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0],
            ))),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                  child: Row(children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 4),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('WORKSHOP', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                      SizedBox(height: 2),
                      Text('Incoming Orders', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                    ]),
                  ]),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.09),

                // ── Content ──────────────────────────────────────
                Expanded(
                  child: ordersAsync.when(
                    data: (orders) {
                      if (orders.isEmpty) {
                        return _EmptyOrders();
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: orders.length,
                        itemBuilder: (_, i) => _OrderCard(
                          order: orders[i],
                          tailorId: tailorId,
                          ref: ref,
                          context: context,
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: _kGold, strokeWidth: 2)),
                    error: (e, _) => Center(child: _ErrorCard(message: e.toString())),
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

// ── Order card ────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final String? tailorId;
  final WidgetRef ref;
  final BuildContext context;

  const _OrderCard({
    required this.order,
    required this.tailorId,
    required this.ref,
    required this.context,
  });

  Color get _statusColor {
    switch (order.status.toLowerCase()) {
      case 'pending':     return _kGold;
      case 'accepted':    return _kBlue;
      case 'in progress': return const Color(0xFF8B3A62);
      case 'ready':       return _kGreen;
      case 'delivered':   return _kGreen;
      case 'rejected':    return Colors.redAccent;
      default:            return _kMuted;
    }
  }

  IconData get _statusIcon {
    switch (order.status.toLowerCase()) {
      case 'pending':     return Icons.hourglass_top_rounded;
      case 'accepted':    return Icons.check_circle_outline;
      case 'in progress': return Icons.content_cut;
      case 'ready':       return Icons.inventory_2_outlined;
      case 'delivered':   return Icons.done_all_rounded;
      case 'rejected':    return Icons.cancel_outlined;
      default:            return Icons.receipt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Card header with image accent ──────────────────────
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            height: 5,
            color: _statusColor,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Title row
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _statusColor.withOpacity(0.3)),
                ),
                child: Icon(_statusIcon, color: _statusColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${order.dressType} — ${order.color}',
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('Order #${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(color: _kMuted, fontSize: 11)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor.withOpacity(0.35)),
                ),
                child: Text(order.status, style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ]),

            const SizedBox(height: 14),
            Divider(color: _kBorder, height: 1),
            const SizedBox(height: 12),

            // Details row
            Wrap(spacing: 16, runSpacing: 8, children: [
              _DetailChip(icon: Icons.calendar_today_outlined, label: DateFormat.yMMMd().format(order.deliveryDate), color: _kMuted),
              if (order.fabric != null && order.fabric!.isNotEmpty)
                _DetailChip(icon: Icons.layers_outlined, label: order.fabric!, color: _kMuted),
              if (order.notes != null && order.notes!.isNotEmpty)
                _DetailChip(icon: Icons.notes_outlined, label: 'Has notes', color: _kBlue),
              if (order.price != null)
                _DetailChip(icon: Icons.attach_money, label: '₹${order.price!.toStringAsFixed(0)}', color: _kGold),
            ]),

            // Notes preview
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kBorder),
                ),
                child: Row(children: [
                  const Icon(Icons.format_quote, color: _kMuted, size: 14),
                  const SizedBox(width: 6),
                  Expanded(child: Text(order.notes!, style: const TextStyle(color: _kMuted, fontSize: 12, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis)),
                ]),
              ),
            ],

            const SizedBox(height: 14),

            // ── Accept / Reject (pending) ──────────────────────
            if (order.status == AppConstants.statusPending) ...[
              Row(children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => _acceptOrder(ref, order),
                  icon: const Icon(Icons.check_rounded, size: 15),
                  label: const Text('Accept', style: TextStyle(fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGreen, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => _rejectOrder(ref, order),
                  icon: const Icon(Icons.close_rounded, size: 15),
                  label: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent, width: 0.8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                )),
              ]),
              const SizedBox(height: 10),
            ],

            // ── Status update chips (active orders) ───────────
            if (order.status != AppConstants.statusPending &&
                order.status != AppConstants.statusRejected) ...[
              const Text('Update Status', style: TextStyle(color: _kMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8,
                children: AppConstants.orderStatusList
                    .where((s) => s != AppConstants.statusPending && s != AppConstants.statusRejected)
                    .map((status) {
                      final isSelected = order.status == status;
                      final chipColor  = _chipColor(status);
                      return GestureDetector(
                        onTap: () => isSelected ? null : _updateStatus(ref, order.id, status),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? chipColor.withOpacity(0.18) : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? chipColor.withOpacity(0.6) : _kBorder),
                          ),
                          child: Text(status, style: TextStyle(
                            color: isSelected ? chipColor : _kMuted,
                            fontSize: 12, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                          )),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 10),
            ],

            // ── Chat button ────────────────────────────────────
            GestureDetector(
              onTap: tailorId != null
                  ? () {
                      final chatId = ChatService.chatId(order.customerId, order.tailorId);
                      context.push('/tailor/chat/$chatId');
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: _kBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kBlue.withOpacity(0.25)),
                ),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.chat_bubble_outline, color: _kBlue, size: 15),
                  SizedBox(width: 7),
                  Text('Chat with Customer', style: TextStyle(color: _kBlue, fontSize: 13, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Color _chipColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':    return _kBlue;
      case 'in progress': return const Color(0xFF8B3A62);
      case 'ready':       return _kGreen;
      case 'delivered':   return _kGreen;
      default:            return _kMuted;
    }
  }

  void _acceptOrder(WidgetRef ref, OrderModel order) async {
    await ref.read(tailorFirestoreProvider).acceptOrder(order.id, null);
    if (context.mounted) {
      _showSnack(context, 'Order accepted ✓', _kGreen);
    }
  }

  void _rejectOrder(WidgetRef ref, OrderModel order) async {
    await ref.read(tailorFirestoreProvider).rejectOrder(order.id);
    if (context.mounted) {
      _showSnack(context, 'Order rejected', Colors.redAccent);
    }
  }

  void _updateStatus(WidgetRef ref, String orderId, String status) async {
    await ref.read(tailorFirestoreProvider).updateOrderStatus(orderId, status);
    if (context.mounted) {
      _showSnack(context, 'Status updated: $status', _kBlue);
    }
  }

  void _showSnack(BuildContext ctx, String msg, Color color) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }
}

// ── Detail chip ───────────────────────────────────────────────────────
class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _DetailChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 13, color: color),
    const SizedBox(width: 4),
    Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
  ]);
}

// ── Empty & error states ──────────────────────────────────────────────
class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      width: 80, height: 80,
      decoration: BoxDecoration(color: _kGold.withOpacity(0.08), shape: BoxShape.circle, border: Border.all(color: _kGold.withOpacity(0.2))),
      child: const Icon(Icons.inbox_outlined, color: _kGold, size: 36),
    ),
    const SizedBox(height: 16),
    const Text('No orders yet', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
    const SizedBox(height: 6),
    const Text('New customer orders will appear here', style: TextStyle(color: _kMuted, fontSize: 13)),
  ]));
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withOpacity(0.25))),
      child: Row(children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text('Error: $message', style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
      ]),
    ),
  );
}
