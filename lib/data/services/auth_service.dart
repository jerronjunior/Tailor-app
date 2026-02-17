import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/user_model.dart';

/// Mock Auth Service - Firebase removed. Requires backend integration.
/// TODO: Replace with real backend API calls or Firebase alternative.
class AuthService {
  static String? _currentUserId;
  static final Map<String, UserModel> _mockUsers = {};

  String? get currentUserId => _currentUserId;
  UserModel? get currentUser =>
      _currentUserId != null ? _mockUsers[_currentUserId] : null;

  Stream<UserModel?> get authStateChanges {
    return Stream.value(currentUser);
  }

  /// Register with email/password - mock implementation.
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
  }) async {
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final userModel = UserModel(
      id: userId,
      name: name,
      email: email,
      role: role,
      phone: phone,
      createdAt: DateTime.now(),
      isAvailable: role == AppConstants.roleTailor ? true : null,
    );
    _mockUsers[userId] = userModel;
    _currentUserId = userId;
    return userModel;
  }

  /// Sign in with email/password - mock implementation.
  Future<UserModel?> signIn(String email, String password) async {
    final user = _mockUsers.values.firstWhere(
      (u) => u.email == email,
      orElse: () => UserModel(
        id: '',
        name: '',
        email: '',
        role: '',
        createdAt: DateTime.now(),
      ),
    );
    if (user.id.isEmpty) return null;
    _currentUserId = user.id;
    return user;
  }

  /// Sign out.
  Future<void> signOut() async {
    _currentUserId = null;
  }

  /// Send password reset email - mock implementation.
  Future<void> sendPasswordResetEmail(String email) async {
    // Mock: would send email via backend
  }

  /// Get current user profile.
  Future<UserModel?> getCurrentUserProfile() async {
    return currentUser;
  }

  /// Stream current user profile.
  Stream<UserModel?> streamUserProfile(String uid) {
    return Stream.value(_mockUsers[uid]);
  }

  /// Update tailor availability.
  Future<void> updateAvailability(String uid, bool isAvailable) async {
    final user = _mockUsers[uid];
    if (user != null) {
      _mockUsers[uid] = user.copyWith(isAvailable: isAvailable);
    }
  }
}
