import 'package:firebase_messaging/firebase_messaging.dart';

/// FCM: request permission, get token, and handle background/foreground messages.
/// Configure background handler in main.dart (top-level function).
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // Get token for sending to server / Firestore (e.g. users/{uid}/fcmToken)
    final token = await _messaging.getToken();
    if (token != null) {
      // Store token in Firestore under user document for server to send notifications
      // Example: await FirebaseFirestore.instance.collection('users').doc(uid).update({'fcmToken': token});
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Call from main.dart: FirebaseMessaging.onMessage.listen(...)
  static void setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show in-app notification or snackbar
    });
  }
}
