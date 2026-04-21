import 'dart:io';

/// Local file helper for uploads. Returns the local path because Firebase Storage has been removed.
class StorageService {
  Future<String> uploadFile({
    required String path,
    required File file,
    required String userId,
  }) async {
    return file.path;
  }

  /// Upload order reference image. Returns the local file path.
  Future<String> uploadOrderImage(File file, String userId, String orderId) async {
    return file.path;
  }

  /// Upload profile image. Returns the local file path.
  Future<String> uploadProfileImage(File file, String userId) async {
    return file.path;
  }
}
