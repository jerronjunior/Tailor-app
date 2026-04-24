import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

const _kBg = Color(0xFF0D1B2A);
const _kCard = Color(0xFF1A2B3C);
const _kGold = Color(0xFFD4AF37);
const _kBlue = Color(0xFF4A90E2);
const _kGreen = Color(0xFF4CAF50);
const _kMuted = Color(0xFF8FA3B1);
const _kBorder = Color(0xFF243447);

enum OrderStatus { pending, accepted, inProgress, ready, delivered }

class _Order {
  final String id, name, tailor, estDate;
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
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Image.network('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200&h=500&fit=crop&q=80',
                fit: BoxFit.cover, loadingBuilder: (_, c, p) => p == null ? c : Container(color: const Color(0xFF1B2A3B))),
          ),
          Positioned(top: 0, left: 0, right: 0, height: 240,
            child: const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x220D1B2A), Color(0xFF0D1B2A)], stops: [0.3, 1.0])))),
          SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('LIVE STATUS', style: TextStyle(color: _kGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  SizedBox(height: 4),
                  Text('Track Orders', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                ]),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: _orders.length,
                  itemBuilder: (_, i) => _OrderTrackCard(order: _orders[i]),
                ),
              ),
            ]),
          ),
        ],
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

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered: return _kGreen;
      case OrderStatus.inProgress: return _kGold;
      case OrderStatus.ready: return const Color(0xFF8B3A62);
      default: return _kBlue;
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.accepted: return 'Accepted';
      case OrderStatus.inProgress: return 'In Progress';
      case OrderStatus.ready: return 'Ready';
      case OrderStatus.delivered: return 'Delivered';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: _kBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(order.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 3),
            Text('Order #${order.id} · ${order.tailor}', style: const TextStyle(fontSize: 11, color: _kMuted)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: _statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: _statusColor.withOpacity(0.3))),
            child: Text(_statusLabel, style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w800)),
          ),
        ]),
        const SizedBox(height: 16),
        // Progress steps
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          _StepLabel('Pending'), _StepLabel('Accepted'), _StepLabel('Stitching'), _StepLabel('Ready'), _StepLabel('Done'),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _progress, minHeight: 7,
            backgroundColor: Colors.white.withOpacity(0.07),
            valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.calendar_today_outlined, size: 13, color: _kMuted),
          const SizedBox(width: 5),
          Text('Est. delivery: ${order.estDate}', style: const TextStyle(fontSize: 11, color: _kMuted)),
        ]),
        if (order.status != OrderStatus.delivered) ...[
          Divider(color: _kBorder, height: 24),
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
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 8, color: _kMuted));
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
    return Column(children: List.generate(_steps.length, (i) {
      final isDone = i < _activeIdx;
      final isActive = i == _activeIdx;
      final dotColor = isDone ? _kGreen : isActive ? _kGold : Colors.white.withOpacity(0.1);
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(
            width: 13, height: 13,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor,
                border: Border.all(color: isActive ? _kGold : Colors.transparent, width: 1.5)),
            child: isDone ? const Icon(Icons.check, size: 8, color: Colors.white) : null,
          ),
          if (i < _steps.length - 1)
            Container(width: 1, height: 28, color: Colors.white.withOpacity(0.08)),
        ]),
        const SizedBox(width: 12),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_steps[i].$1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: (isDone || isActive) ? Colors.white : _kMuted)),
            const SizedBox(height: 2),
            Text(_steps[i].$2, style: const TextStyle(fontSize: 11, color: _kMuted)),
          ]),
        )),
      ]);
    }));
  }
}
