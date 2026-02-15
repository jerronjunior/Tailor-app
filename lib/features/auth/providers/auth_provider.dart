import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Stream of auth user; we then resolve profile from Firestore.
final authStateProvider = StreamProvider<UserModel?>((ref) async* {
  final auth = ref.watch(authServiceProvider);
  await for (final user in auth.authStateChanges) {
    if (user == null) {
      yield null;
      continue;
    }
    final profile = await auth.getCurrentUserProfile();
    yield profile;
  }
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
