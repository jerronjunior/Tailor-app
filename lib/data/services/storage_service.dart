import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage helper for uploads.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required String path,
    required File file,
    required String userId,
  }) async {
    final ref = _storage.ref().child('$path/$userId/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  /// Upload order reference image and return download URL.
  Future<String> uploadOrderImage(File file, String userId, String orderId) async {
    final ref = _storage
        .ref()
        .child('orders/$userId/$orderId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  /// Upload profile image and return download URL.
  Future<String> uploadProfileImage(File file, String userId) async {
    final ref = _storage.ref().child('profiles/$userId/profile.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
