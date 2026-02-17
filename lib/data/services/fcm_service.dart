/// Mock FCM Service - Firebase removed. Requires backend integration.
/// TODO: Replace with real push notification backend.
class FcmService {
  Future<void> initialize() async {
    // Mock: request permission would happen here
  }

  Future<String?> getToken() async {
    // Mock: return a placeholder token
    return 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Call from main.dart to setup foreground message handler
  static void setupForegroundHandler() {
    // Mock: would listen to messages here
  }
}
