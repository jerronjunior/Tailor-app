import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/data/models/measurement_profile_model.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';
import 'package:tailor_app/features/customer/providers/customer_providers.dart';

/// Lists and allows adding measurement profiles for the current user.
final measurementProfilesListProvider = StreamProvider.autoDispose
    .family<List<MeasurementProfileModel>, String>((ref, userId) {
  return ref
      .read(firestoreServiceProvider)
      .streamMeasurementProfiles(userId);
});

class MeasurementProfilesScreen extends ConsumerWidget {
  const MeasurementProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUserProvider)?.id;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }
    final profilesAsync = ref.watch(measurementProfilesListProvider(uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement Profiles'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProfile(context, ref, uid),
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No saved profiles'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _showAddProfile(context, ref, uid),
                    icon: const Icon(Icons.add),
                    label: const Text('Add profile'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (_, i) {
              final p = profiles[i];
              return Card(
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text(
                    p.measurements.entries
                        .map((e) => '${e.key}: ${e.value}')
                        .join(', '),
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

  void _showAddProfile(BuildContext context, WidgetRef ref, String userId) {
    final nameController = TextEditingController();
    final chestController = TextEditingController();
    final waistController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Profile name'),
              ),
              TextField(
                controller: chestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Chest (cm)'),
              ),
              TextField(
                controller: waistController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Waist (cm)'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  final profile = MeasurementProfileModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: userId,
                    name: name,
                    measurements: {
                      'chest': double.tryParse(chestController.text) ?? 0,
                      'waist': double.tryParse(waistController.text) ?? 0,
                    },
                    createdAt: DateTime.now(),
                  );
                  ref.read(firestoreServiceProvider).saveMeasurementProfile(profile);
                  Navigator.pop(ctx);
                },
                child: const Text('Save profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
