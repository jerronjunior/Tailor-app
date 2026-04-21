import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/services/local_app_store.dart';

/// Handles local authentication and syncing user profile to the in-memory store.
class AuthService {
  final LocalAppStore _store = LocalAppStore.instance;

  UserModel? get currentUser => _store.currentUser;
  Stream<UserModel?> get authStateChanges => _store.authStateChanges;

  /// Register with email/password and create user document with [role].
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
  }) async {
    return _store.register(
      email: email,
      password: password,
      name: name,
      role: role,
      phone: phone,
    );
  }

  /// Sign in with email and password.
  Future<UserModel> signIn(String email, String password) async {
    return _store.signIn(email, password);
  }

  /// Sign out.
  Future<void> signOut() async {
    _store.signOut();
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _store.sendPasswordResetEmail(email);
  }

  /// Get the current user profile from the local store.
  Future<UserModel?> getCurrentUserProfile() async {
    return _store.getCurrentUserProfile();
  }

  /// Stream the current user profile.
  Stream<UserModel?> streamUserProfile(String uid) {
    return _store.authStateChanges.map((user) => user?.id == uid ? user : null);
  }

  /// Update tailor availability.
  Future<void> updateAvailability(String uid, bool isAvailable) async {
    final user = _store.getUser(uid);
    if (user == null) return;
    _store.updateUser(uid, {'isAvailable': isAvailable});
  }
}
