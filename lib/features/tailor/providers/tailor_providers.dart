import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/services/firestore_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

final tailorFirestoreProvider = Provider<FirestoreService>((ref) => FirestoreService());

/// Orders for current tailor
final tailorOrdersProvider = StreamProvider.autoDispose<List<OrderModel>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id;
  if (uid == null) return Stream.value([]);
  return ref.watch(tailorFirestoreProvider).streamOrdersByTailor(uid);
});
