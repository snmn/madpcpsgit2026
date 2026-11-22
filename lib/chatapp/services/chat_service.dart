import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/chat_message.dart';
import 'notification_service.dart';

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
    required String recipientId,
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

    unawaited(
      _sendPushBestEffort(
        recipientId: recipientId,
        senderId: senderId,
        conversationId: conversationId,
        text: trimmedText,
      ),
    );
  }

  Future<void> _sendPushBestEffort({
    required String recipientId,
    required String senderId,
    required String conversationId,
    required String text,
  }) async {
    try {
      final recipientSnapshot =
          await _firestore.collection('users').doc(recipientId).get();
      final recipientToken =
          (recipientSnapshot.data()?['fcmToken'] as String?)?.trim();
      if (recipientToken == null || recipientToken.isEmpty) return;

      await NotificationService.instance.sendPushNotification(
        recipientToken: recipientToken,
        title: 'New message',
        body: text,
        data: <String, dynamic>{
          'conversationId': conversationId,
          'senderId': senderId,
        },
      );
    } catch (_) {
      // Firestore delivery succeeds even if push delivery is unavailable.
    }
  }
}
