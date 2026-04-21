import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Stream of the local auth user.
final authStateProvider = StreamProvider<UserModel?>((ref) async* {
  final auth = ref.watch(authServiceProvider);
  yield auth.currentUser;
  yield* auth.authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
