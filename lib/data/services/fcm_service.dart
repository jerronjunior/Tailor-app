/// Notification helper removed with Firebase. This is now a no-op service.
class FcmService {
  Future<void> initialize() async {
    return;
  }

  Future<String?> getToken() async {
    return null;
  }

  static void setupForegroundHandler() {
    return;
  }
}
