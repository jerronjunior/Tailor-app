import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/user_model.dart';

/// Handles Firebase authentication and user profile sync with Firestore.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPermissionDenied(Object error) {
    return error is FirebaseException && error.code == 'permission-denied';
  }

  bool _isFirestoreOffline(Object error) {
    if (error is! FirebaseException) return false;
    if (error.code == 'unavailable') return true;
    final message = (error.message ?? '').toLowerCase();
    return message.contains('client is offline');
  }

  DocumentReference<Map<String, dynamic>> _userRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Exception _authException(
    FirebaseAuthException e, {
    String fallback = 'Authentication failed.',
  }) {
    switch (e.code) {
      case 'invalid-email':
        return Exception('Invalid email address.');
      case 'user-not-found':
      case 'invalid-credential':
        return Exception('No account found for this email. Please register first.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'email-already-in-use':
        return Exception('This email is already registered. Please log in instead.');
      case 'network-request-failed':
        return Exception('Network error. Check your internet connection and try again.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please wait a moment and try again.');
      case 'user-disabled':
        return Exception('This account has been disabled. Contact support.');
      case 'operation-not-allowed':
        return Exception('Email/password sign-in is not enabled in Firebase Authentication.');
      default:
        return Exception(e.message ?? fallback);
    }
  }

  UserModel _profileFromAuthUser(
    User user, {
    String role = AppConstants.roleCustomer,
  }) {
    return UserModel(
      id: user.uid,
      name: (user.displayName ?? '').trim(),
      email: (user.email ?? '').trim().toLowerCase(),
      role: role,
      createdAt: DateTime.now(),
      isAvailable: role == AppConstants.roleTailor ? true : null,
    );
  }

  Future<UserModel> _ensureUserProfile(
    User user, {
    String role = AppConstants.roleCustomer,
  }) async {
    try {
      final snapshot = await _userRef(user.uid).get();
      final data = snapshot.data();
      if (snapshot.exists && data != null) {
        return UserModel.fromMap(data, snapshot.id);
      }

      final profile = _profileFromAuthUser(user, role: role);
      await _userRef(user.uid).set(profile.toMap(), SetOptions(merge: true));
      return profile;
    } catch (e) {
      if (_isPermissionDenied(e) || _isFirestoreOffline(e)) {
        // Keep auth working even if Firestore is unavailable or rules are stricter.
        return _profileFromAuthUser(user, role: role);
      }
      rethrow;
    }
  }

  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      role: AppConstants.roleCustomer,
      createdAt: DateTime.now(),
    );
  }

  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        return await _ensureUserProfile(user);
      } catch (e) {
        if (_isPermissionDenied(e) || _isFirestoreOffline(e)) {
          return _profileFromAuthUser(user);
        }
        rethrow;
      }
    });
  }

  /// Register with email/password and create user document with [role].
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Unable to create account. Please try again.');
      }

      await user.updateDisplayName(name.trim());

      final profile = UserModel(
        id: user.uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        role: role,
        phone: phone,
        createdAt: DateTime.now(),
        isAvailable: role == AppConstants.roleTailor ? true : null,
      );

      try {
        await _userRef(user.uid).set(profile.toMap());
      } catch (e) {
        if (!_isPermissionDenied(e)) {
          rethrow;
        }
      }
      return profile;
    } on FirebaseAuthException catch (e) {
      throw _authException(e, fallback: 'Failed to register. Please try again.');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('Firestore access denied. Update Firestore rules for users collection.');
      }
      throw Exception(e.message ?? 'Failed to save user profile. Please try again.');
    }
  }

  /// Sign in with email and password.
  Future<UserModel> signIn(
    String email,
    String password, {
    String? expectedRole,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Unable to sign in. Please try again.');
      }

      final profile = await _ensureUserProfile(
        user,
        role: expectedRole ?? AppConstants.roleCustomer,
      );

      if (expectedRole != null && profile.role != expectedRole) {
        await signOut();
        throw Exception('This account is registered as ${profile.role}. Please use the correct login.');
      }

      return profile;
    } on FirebaseAuthException catch (e) {
      throw _authException(e, fallback: 'Failed to sign in. Please try again.');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied' || _isFirestoreOffline(e)) {
        final user = _auth.currentUser;
        if (user != null) {
          final fallback = _profileFromAuthUser(
            user,
            role: expectedRole ?? AppConstants.roleCustomer,
          );
          if (expectedRole != null && fallback.role != expectedRole) {
            await signOut();
            throw Exception('This account is registered as ${fallback.role}. Please use the correct login.');
          }
          return fallback;
        }
        throw Exception('Sign-in completed but profile access is denied by Firestore rules.');
      }
      throw Exception(e.message ?? 'Failed to load user profile. Please try again.');
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _authException(
        e,
        fallback: 'Failed to send password reset email. Please try again.',
      );
    }
  }

  /// Get the current user profile from the local store.
  Future<UserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    try {
      return await _ensureUserProfile(user);
    } catch (e) {
      if (_isPermissionDenied(e) || _isFirestoreOffline(e)) {
        return _profileFromAuthUser(user);
      }
      rethrow;
    }
  }

  /// Stream the current user profile.
  Stream<UserModel?> streamUserProfile(String uid) {
    return Stream<UserModel?>.multi((controller) {
      final sub = _userRef(uid).snapshots().listen((snapshot) async {
        final data = snapshot.data();
        if (!snapshot.exists || data == null) {
          final user = _auth.currentUser;
          if (user != null && user.uid == uid) {
            controller.add(await _ensureUserProfile(user));
            return;
          }
          controller.add(null);
          return;
        }
        controller.add(UserModel.fromMap(data, snapshot.id));
      }, onError: (error) {
        final user = _auth.currentUser;
        if (user != null &&
            user.uid == uid &&
            (_isPermissionDenied(error) || _isFirestoreOffline(error))) {
          controller.add(_profileFromAuthUser(user));
        } else {
          controller.addError(error);
        }
      });

      controller.onCancel = () => sub.cancel();
    });
  }

  /// Update tailor availability.
  Future<void> updateAvailability(String uid, bool isAvailable) async {
    await _userRef(uid).update({'isAvailable': isAvailable});
  }
}
