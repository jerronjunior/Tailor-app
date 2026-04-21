import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/user_model.dart';

/// Handles Firebase Auth and syncing user profile to Firestore.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Register with email/password and create user document with [role].
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
  }) async {
    late final UserCredential cred;
    try {
      cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
    final user = cred.user;
    if (user == null) throw Exception('Registration failed');
    final userModel = UserModel(
      id: user.uid,
      name: name,
      email: email,
      role: role,
      phone: phone,
      createdAt: DateTime.now(),
      isAvailable: role == AppConstants.roleTailor ? true : null,
    );
    await _firestore.collection(AppConstants.usersCollection).doc(user.uid).set(
          userModel.toMap(),
        );
    return userModel;
  }

  /// Sign in with email and password.
  Future<User?> signIn(String email, String password) async {
    late final UserCredential cred;
    try {
      cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
    return cred.user;
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
  }

  /// Get current user profile from Firestore.
  Future<UserModel?> getCurrentUserProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  /// Stream current user profile.
  Stream<UserModel?> streamUserProfile(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    });
  }

  /// Update tailor availability.
  Future<void> updateAvailability(String uid, bool isAvailable) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update({'isAvailable': isAvailable});
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-not-found':
        return 'No account found for that email. Please register first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'That email is already registered. Please log in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'invalid-credential':
        return 'Firebase rejected the credential. If you are logging in, check your email/password. If you are registering, make sure Email/Password sign-in is enabled in Firebase and the app is configured for this platform.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
