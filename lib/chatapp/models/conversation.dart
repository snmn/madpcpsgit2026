import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.participantIds,
    required this.otherUserId,
    this.lastMessage,
    this.lastMessageTime,
    this.isRead = true,
  });

  final String id;
  final List<String> participantIds;
  final String otherUserId;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool isRead;

  factory Conversation.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Conversation(
      id: snapshot.id,
      participantIds: (data['participantIds'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      otherUserId: data['otherUserId'] as String? ?? '',
      lastMessage: data['lastMessage'] as String?,
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate(),
      isRead: data['isRead'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participantIds': participantIds,
      'otherUserId': otherUserId,
      'lastMessage': lastMessage,
      'lastMessageTime':
          lastMessageTime == null ? null : Timestamp.fromDate(lastMessageTime!),
      'isRead': isRead,
    };
  }
}
