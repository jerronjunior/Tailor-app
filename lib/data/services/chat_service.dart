import 'package:tailor_app/data/models/message_model.dart';
import 'package:tailor_app/data/services/local_app_store.dart';

/// Chat helper backed by the local in-memory store.
class ChatService {
  final LocalAppStore _store = LocalAppStore.instance;

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
    _store.sendMessage(
      chatId: chatId,
      senderId: senderId,
      text: text,
      imageUrl: imageUrl,
    );
  }

  Stream<List<MessageModel>> streamMessages(String chatId) {
    List<MessageModel> current() => _store.messagesForChat(chatId);
    return Stream<List<MessageModel>>.multi((controller) {
      controller.add(current());
      final sub = _store.changes.listen((_) => controller.add(current()));
      controller.onCancel = sub.cancel;
    });
  }
}
