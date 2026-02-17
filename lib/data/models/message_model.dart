

/// Message model for chat - stored in [messages] subcollection under chats.
class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final String? imageUrl;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    this.imageUrl,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime timestamp = DateTime.now();
    final raw = map['timestamp'];
    if (raw != null) {
      if (raw is DateTime) timestamp = raw;
    }
    return MessageModel(
      id: id,
      chatId: map['chatId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      message: map['message'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
