import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demopcpsseca/chat/models/app_user.dart';

class ChatService {
  ChatService._();

  static final _db = FirebaseFirestore.instance;

  static String chatIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  static Stream<List<AppUser>> usersStream() {
    return _db
        .collection('users')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppUser.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(
    String chatId,
  ) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage({
    required String chatId,
    required List<String> uids,
    required Map<String, String> participantNames,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final chatRef = _db.collection('chats').doc(chatId);
    final messageRef = chatRef.collection('messages').doc();
    final now = FieldValue.serverTimestamp();

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(chatRef);
      if (!snapshot.exists) {
        transaction.set(chatRef, {
          'participants': uids,
          'participantNames': participantNames,
          'createdAt': now,
          'lastMessage': '',
          'lastMessageAt': now,
          'lastSenderUid': '',
        });
      }
      transaction.set(messageRef, {
        'senderId': senderId,
        'senderName': senderName,
        'text': trimmed,
        'createdAt': now,
      });
      transaction.set(chatRef, {
        'lastMessage': trimmed,
        'lastMessageAt': now,
        'lastSenderUid': senderId,
      }, SetOptions(merge: true));
    });
  }
}