import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/data/models/order_model.dart';
import 'package:tailor_app/data/models/review_model.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/services/firestore_service.dart';
import 'package:tailor_app/data/services/storage_service.dart';
import 'package:tailor_app/features/auth/providers/auth_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

/// Tailors list (with optional name filter and availability)
final tailorsListProvider = StreamProvider.autoDispose
    .family<List<UserModel>, ({String? search, bool? available})>((ref, params) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.streamTailors(
    searchName: params.search,
    available: params.available,
  );
});

/// Orders for current customer
final customerOrdersProvider = StreamProvider.autoDispose<List<OrderModel>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id;
  if (uid == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).streamOrdersByCustomer(uid);
});

/// Reviews for a given tailor
final tailorReviewsProvider = StreamProvider.autoDispose
    .family<List<ReviewModel>, String>((ref, tailorId) {
  return ref.watch(firestoreServiceProvider).streamReviewsForTailor(tailorId);
});
