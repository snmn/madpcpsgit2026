import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final DateTime? createdAt;

  const ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final timestamp = map['createdAt'];
    return ChatMessage(
      senderId: (map['senderId'] as String?) ?? '',
      senderName: (map['senderName'] as String?) ?? '',
      text: (map['text'] as String?) ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'senderName': senderName,
    'text': text,
    'createdAt': createdAt,
  };
}