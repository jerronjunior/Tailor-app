import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

enum OrderStatus { pending, accepted, inProgress, ready, delivered }

class _Order {
  final String id;
  final String name;
  final String tailor;
  final String estDate;
  final OrderStatus status;
  _Order({required this.id, required this.name, required this.tailor, required this.estDate, required this.status});
}

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  static final _orders = [
    _Order(id: 'TA2048', name: 'Custom Suit — Navy Blue', tailor: 'Ravi Kumar', estDate: 'April 20, 2026', status: OrderStatus.inProgress),
    _Order(id: 'TA2049', name: 'White Linen Kurta', tailor: 'Priya Sharma', estDate: 'April 15, 2026', status: OrderStatus.accepted),
    _Order(id: 'TA2039', name: 'Slim Fit Trousers', tailor: 'Ravi Kumar', estDate: 'April 8, 2026', status: OrderStatus.delivered),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Track Orders'), backgroundColor: AppColors.thread),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _orders.length,
        itemBuilder: (_, i) => _OrderTrackCard(order: _orders[i]),
      ),
    );
  }
}

class _OrderTrackCard extends StatelessWidget {
  final _Order order;
  const _OrderTrackCard({required this.order});

  double get _progress {
    switch (order.status) {
      case OrderStatus.pending: return 0.1;
      case OrderStatus.accepted: return 0.3;
      case OrderStatus.inProgress: return 0.6;
      case OrderStatus.ready: return 0.85;
      case OrderStatus.delivered: return 1.0;
    }
  }

  Widget get _badge {
    switch (order.status) {
      case OrderStatus.pending: return StatusBadge.pending();
      case OrderStatus.accepted: return StatusBadge.accepted();
      case OrderStatus.inProgress: return StatusBadge.inProgress();
      case OrderStatus.ready: return StatusBadge.ready();
      case OrderStatus.delivered: return StatusBadge.delivered();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.thread)),
              const SizedBox(height: 3),
              Text('Order #${order.id} · ${order.tailor}', style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
            ])),
            _badge,
          ],
        ),
        const SizedBox(height: 14),
        // Progress label strip
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _StepLabel('Pending'), _StepLabel('Accepted'), _StepLabel('In Progress'), _StepLabel('Ready'), _StepLabel('Delivered'),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 6,
            backgroundColor: Colors.black.withOpacity(0.07),
            valueColor: AlwaysStoppedAnimation<Color>(order.status == OrderStatus.delivered ? AppColors.badgeGreenText : AppColors.gold),
          ),
        ),
        const SizedBox(height: 8),
        Text('Est. delivery: ${order.estDate}', style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
        if (order.status != OrderStatus.delivered) ...[
          const AppDivider(),
          const SectionLabel('Timeline'),
          _Timeline(status: order.status),
        ],
      ]),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String text;
  const _StepLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 8.5, color: AppColors.taupe));
}

class _Timeline extends StatelessWidget {
  final OrderStatus status;
  const _Timeline({required this.status});

  static const _steps = [
    ('Order Placed', 'Apr 10 · 10:23 AM'),
    ('Accepted by Tailor', 'Apr 11 · 2:05 PM'),
    ('Cutting & Stitching', 'Apr 12 · In progress'),
    ('Ready for Pickup', '—'),
    ('Delivered', '—'),
  ];

  int get _activeIdx => status.index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_steps.length, (i) {
        final isDone = i < _activeIdx;
        final isActive = i == _activeIdx;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.badgeGreenText : isActive ? AppColors.gold : Colors.black12,
                ),
                child: isDone ? const Icon(Icons.check, size: 8, color: Colors.white) : null,
              ),
              if (i < _steps.length - 1)
                Container(width: 1, height: 28, color: Colors.black.withOpacity(0.1)),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_steps[i].$1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: (isDone || isActive) ? AppColors.thread : AppColors.taupe)),
                const SizedBox(height: 2),
                Text(_steps[i].$2, style: const TextStyle(fontSize: 11, color: AppColors.taupe)),
              ]),
            )),
          ],
        );
      }),
    );
  }
}
