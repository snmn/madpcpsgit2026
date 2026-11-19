import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/message.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> createOrUpdateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }

  Stream<List<AppUser>> getAllUsers() {
    return _firestore.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => AppUser.fromSnapshot(doc))
              .toList(),
        );
  }

  String conversationId(String firstUid, String secondUid) {
    final ids = [firstUid, secondUid]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<String> getOrCreateConversation(
    String currentUid,
    String otherUid,
  ) async {
    if (currentUid.isEmpty || otherUid.isEmpty || currentUid == otherUid) {
      throw ArgumentError('A conversation requires two different users.');
    }

    final id = conversationId(currentUid, otherUid);
    final participantIds = [currentUid, otherUid]..sort();
    final batch = _firestore.batch();

    for (final uid in participantIds) {
      final otherId = uid == currentUid ? otherUid : currentUid;
      final conversationRef =
          _firestore.collection('users').doc(uid).collection('conversations').doc(id);
      batch.set(
        conversationRef,
        {
          'participantIds': participantIds,
          'otherUserId': otherId,
          'lastMessage': null,
          'lastMessageTime': null,
          'isRead': true,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
    return id;
  }

  Stream<List<Message>> getMessages(
    String uid,
    String conversationId,
  ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> sendMessage(
    String uid,
    String conversationId,
    String otherUid,
    Message message,
  ) async {
    final text = message.text.trim();
    if (text.isEmpty) return;

    final batch = _firestore.batch();
    final timestamp = Timestamp.fromDate(message.timestamp);
    final messageData = {
      'senderId': uid,
      'text': text,
      'timestamp': timestamp,
      'isRead': false,
    };

    for (final recipientUid in [uid, otherUid]) {
      final conversationRef = _firestore
          .collection('users')
          .doc(recipientUid)
          .collection('conversations')
          .doc(conversationId);
      final messageRef = recipientUid == uid
          ? conversationRef.collection('messages').doc(message.id)
          : conversationRef.collection('messages').doc(message.id);

      batch.set(messageRef, messageData);
      batch.set(
        conversationRef,
        {
          'participantIds': [uid, otherUid]..sort(),
          'otherUserId': recipientUid == uid ? otherUid : uid,
          'lastMessage': text,
          'lastMessageTime': timestamp,
          'isRead': recipientUid == uid,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }

  Future<void> markMessagesAsRead(
    String uid,
    String conversationId,
  ) async {
    final conversationRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('conversations')
        .doc(conversationId);
    final unread = await conversationRef
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .get();

    if (unread.docs.isEmpty) {
      await conversationRef.set({'isRead': true}, SetOptions(merge: true));
      return;
    }

    final batch = _firestore.batch();
    for (final doc in unread.docs) {
      final data = doc.data();
      if (data['senderId'] != uid) {
        batch.update(doc.reference, {'isRead': true});
      }
    }
    batch.set(conversationRef, {'isRead': true}, SetOptions(merge: true));
    await batch.commit();
  }
}
