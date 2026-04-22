import 'package:tailor_app/data/models/user_model.dart';
import 'package:tailor_app/data/services/local_app_store.dart';

/// Handles app authentication through the local in-memory store.
class AuthService {
  final LocalAppStore _store = LocalAppStore.instance;

  UserModel? get currentUser => _store.currentUser;

  Stream<UserModel?> get authStateChanges {
    return _store.authStateChanges;
  }

  /// Register with email/password and create user document with [role].
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw Exception('Enter email.');
    }
    if (password.isEmpty) {
      throw Exception('Enter password.');
    }

    return _store.register(
      email: normalizedEmail,
      password: password,
      name: name.trim(),
      role: role,
      phone: phone,
    );
  }

  /// Sign in with email and password.
  Future<UserModel> signIn(
    String email,
    String password, {
    String? expectedRole,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw Exception('Enter email.');
    }
    if (password.isEmpty) {
      throw Exception('Enter password.');
    }

    final user = _store.signIn(normalizedEmail, password);
    if (expectedRole != null && user.role != expectedRole) {
      throw Exception('This account is registered as ${user.role}. Please use the correct login.');
    }
    return user;
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
    await _store.updateUser(uid, {'isAvailable': isAvailable});
  }
}
