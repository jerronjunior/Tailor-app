import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/customer/providers/customer_providers.dart';

class TailorListScreen extends ConsumerStatefulWidget {
  const TailorListScreen({super.key});

  @override
  ConsumerState<TailorListScreen> createState() => _TailorListScreenState();
}

class _TailorListScreenState extends ConsumerState<TailorListScreen> {
  String _search = '';
  bool? _availableOnly;

  @override
  Widget build(BuildContext context) {
    final params = (search: _search.isEmpty ? null : _search, available: _availableOnly);
    final tailorsAsync = ref.watch(tailorsListProvider(params));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Tailors'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Available only'),
                      selected: _availableOnly == true,
                      onSelected: (v) =>
                          setState(() => _availableOnly = v ? true : null),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: tailorsAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('No tailors found'));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final t = list[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: t.profileImage != null
                            ? NetworkImage(t.profileImage!)
                            : null,
                        child: t.profileImage == null
                            ? Text(t.name.isNotEmpty ? t.name[0] : '?')
                            : null,
                      ),
                      title: Text(t.name),
                      subtitle: Text(t.phone ?? t.email),
                      trailing: t.isAvailable == true
                          ? Chip(
                              label: const Text('Available'),
                              backgroundColor: Colors.green.shade100,
                            )
                          : null,
                      onTap: () => context.push(
                        '/customer/tailor/${t.id}',
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
