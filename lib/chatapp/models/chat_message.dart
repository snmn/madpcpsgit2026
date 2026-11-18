import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.read,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final Timestamp createdAt;
  final bool read;

  factory ChatMessage.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return ChatMessage(
      id: snapshot.id,
      conversationId: (data['conversationId'] as String?) ?? '',
      senderId: (data['senderId'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?) ?? Timestamp.now(),
      read: (data['read'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
        'createdAt': createdAt,
        'read': read,
      };
}
