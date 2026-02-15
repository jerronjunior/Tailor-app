import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/services/chat_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/customer/providers/customer_providers.dart';
import 'package:uuid/uuid.dart';

class TailorProfileScreen extends ConsumerWidget {
  final String tailorId;

  const TailorProfileScreen({super.key, required this.tailorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreServiceProvider);
    return FutureBuilder<UserModel?>(
      future: firestore.getUser(tailorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tailor')),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final tailor = snapshot.data!;
        return _TailorProfileView(tailor: tailor);
      },
    );
  }
}

class _TailorProfileView extends ConsumerWidget {
  final UserModel tailor;

  const _TailorProfileView({required this.tailor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(tailorReviewsProvider(tailor.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(tailor.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              final uid = ref.read(currentUserProvider)?.id;
              if (uid != null) {
                final chatId = ChatService.chatId(uid, tailor.id);
                context.push('/customer/chat/$chatId');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                    tailor.profileImage != null
                        ? NetworkImage(tailor.profileImage!)
                        : null,
                child: tailor.profileImage == null
                    ? Text(
                        tailor.name.isNotEmpty ? tailor.name[0] : '?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                tailor.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (tailor.phone != null)
              Center(child: Text(tailor.phone!)),
            Center(child: Text(tailor.email)),
            if (tailor.isAvailable != null)
              Center(
                child: Chip(
                  label: Text(tailor.isAvailable! ? 'Available' : 'Not available'),
                  backgroundColor: tailor.isAvailable!
                      ? Colors.green.shade100
                      : Colors.grey.shade300,
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: () => context.push(
                    '/customer/place-order/${tailor.id}',
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Place Order'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    final uid = ref.read(currentUserProvider)?.id;
                    if (uid != null) {
                      final chatId = ChatService.chatId(uid, tailor.id);
                      context.push('/customer/chat/$chatId');
                    }
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () => _showReviewDialog(context, ref, tailor.id),
                icon: const Icon(Icons.star_border),
                label: const Text('Rate & Review'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            reviewsAsync.when(
              data: (reviews) {
                if (reviews.isEmpty) {
                  return const Text('No reviews yet.');
                }
                final avg = reviews.isEmpty
                    ? 0.0
                    : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                        reviews.length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Average: ${avg.toStringAsFixed(1)} / 5'),
                    ...reviews.take(5).map(
                          (r) => ListTile(
                            title: Text('${r.rating} stars'),
                            subtitle: Text(r.comment ?? ''),
                          ),
                        ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, WidgetRef ref, String tailorId) {
    final customerId = ref.read(currentUserProvider)?.id;
    if (customerId == null) return;
    int rating = 5;
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Rate this tailor'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return IconButton(
                      icon: Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => setState(() => rating = i + 1),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: 'Comment (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final review = ReviewModel(
                    id: const Uuid().v4(),
                    customerId: customerId,
                    tailorId: tailorId,
                    rating: rating,
                    comment: commentController.text.trim().isEmpty
                        ? null
                        : commentController.text.trim(),
                    createdAt: DateTime.now(),
                  );
                  await ref.read(firestoreServiceProvider).addReview(review);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for your review!')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
