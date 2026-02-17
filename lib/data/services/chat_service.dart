import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_app/core/constants/app_constants.dart';
import 'package:tailor_app/data/models/message_model.dart';

/// Chat: we use a composite chatId = sorted [customerId, tailorId] joined (e.g. "id1_id2")
/// so both sides use the same chat document. Messages stored in subcollection.
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .add({
      'chatId': chatId,
      'senderId': senderId,
      'message': text,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Update chat lastMessage for ordering
    await _firestore.collection(AppConstants.chatsCollection).doc(chatId).set({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'participants': chatId.split('_'),
    }, SetOptions(merge: true));
  }

  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) {
              final data = d.data();
              data['timestamp'] = data['timestamp'] ?? Timestamp.now();
              return MessageModel.fromMap(data, d.id);
            })
            .toList());
  }
}
