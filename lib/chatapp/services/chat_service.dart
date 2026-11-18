import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/chat_message.dart';

class ChatService {
  ChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  String conversationIdFor(String uidA, String uidB) {
    final ids = <String>[uidA, uidB]..sort();
    return ids.join('_');
  }

  Stream<List<AppUser>> usersStream(String currentUid) {
    return _firestore.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map(AppUser.fromSnapshot)
              .where((user) => user.uid != currentUid)
              .toList(),
        );
  }

  Future<String> createOrGetConversation(String currentUid, String otherUid) async {
    final conversationId = conversationIdFor(currentUid, otherUid);
    await _firestore.collection('conversations').doc(conversationId).set(
      <String, dynamic>{
        'participants': <String>[currentUid, otherUid],
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    return conversationId;
  }

  Stream<List<ChatMessage>> messagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(ChatMessage.fromSnapshot).toList(),
        );
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final conversationRef =
        _firestore.collection('conversations').doc(conversationId);
    final messageRef = conversationRef.collection('messages').doc();

    await _firestore.runTransaction((transaction) async {
      transaction.set(
        conversationRef,
        <String, dynamic>{
          'updatedAt': FieldValue.serverTimestamp(),
          'lastMessage': trimmedText,
        },
        SetOptions(merge: true),
      );
      transaction.set(
        messageRef,
        <String, dynamic>{
          'conversationId': conversationId,
          'senderId': senderId,
          'text': trimmedText,
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
        },
      );
    });
  }
}
