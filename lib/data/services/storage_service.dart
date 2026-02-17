import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Upload files to Firebase Storage (e.g. profile images, order reference images).
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required String path,
    required File file,
    required String userId,
  }) async {
    final ref = _storage.ref().child(path).child(userId).child(
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /// Upload order reference image. Returns download URL.
  Future<String> uploadOrderImage(File file, String userId, String orderId) async {
    final ref = _storage
        .ref()
        .child('orders')
        .child(userId)
        .child(orderId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /// Upload profile image.
  Future<String> uploadProfileImage(File file, String userId) async {
    final ref = _storage.ref().child('profiles').child('$userId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
