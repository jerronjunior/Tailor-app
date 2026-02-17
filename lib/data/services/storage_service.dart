import 'dart:io';

/// Mock Storage Service - Firebase removed. Requires backend integration.
/// TODO: Replace with real backend file upload API.
class StorageService {
  Future<String> uploadFile({
    required String path,
    required File file,
    required String userId,
  }) async {
    // Mock: return a placeholder URL
    return 'https://example.com/files/$userId/${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Upload order reference image. Returns download URL.
  Future<String> uploadOrderImage(File file, String userId, String orderId) async {
    return 'https://example.com/orders/$userId/$orderId/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  /// Upload profile image.
  Future<String> uploadProfileImage(File file, String userId) async {
    return 'https://example.com/profiles/$userId.jpg';
  }
}
