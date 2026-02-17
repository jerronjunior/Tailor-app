import 'package:tailor_app/data/models/message_model.dart';

/// Mock Chat Service - Firebase removed. Requires backend integration.
/// TODO: Replace with real backend API calls or WebSocket.
class ChatService {
  static final Map<String, List<MessageModel>> _mockMessages = {};

  static String chatId(String user1, String user2) {
    final list = [user1, user2]..sort();
    return '${list[0]}_${list[1]}';
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
  }) async {
    _mockMessages.putIfAbsent(chatId, () => []);
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: senderId,
      message: text,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );
    _mockMessages[chatId]!.add(message);
  }

  Stream<List<MessageModel>> streamMessages(String chatId) {
    return Stream.value(_mockMessages[chatId] ?? []);
  }
}
