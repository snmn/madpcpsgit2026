import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreChatService {
  FirestoreChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> upsertCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final email = (user.email ?? '').trim().toLowerCase();
    final displayName = user.displayName?.trim();
    final document = _firestore.collection('users').doc(user.uid);

    await document.set(<String, Object?>{
      'uid': user.uid,
      'email': email,
      'displayName':
          displayName == null || displayName.isEmpty
              ? (email.isEmpty ? 'User' : email.split('@').first)
              : displayName,
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String conversationId(String firstUid, String secondUid) {
    final sorted = <String>[firstUid, secondUid]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> ensureConversation({
    required String currentUid,
    required String peerUid,
    required String peerEmail,
    required String peerDisplayName,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw StateError('You must be signed in to start a chat.');
    }

    final currentEmail = (currentUser.email ?? '').trim().toLowerCase();
    final currentDisplayName = currentUser.displayName?.trim();
    final conversationId = this.conversationId(currentUid, peerUid);
    final conversationRef =
        _firestore.collection('conversations').doc(conversationId);

    await conversationRef.set(<String, Object?>{
      'participantIds': <String>[currentUid, peerUid],
      'participantInfo': <String, Object>{
        currentUid: <String, Object?>{
          'email': currentEmail,
          'displayName':
              currentDisplayName == null || currentDisplayName.isEmpty
                  ? (currentEmail.isEmpty ? 'User' : currentEmail.split('@').first)
                  : currentDisplayName,
        },
        peerUid: <String, Object?>{
          'email': peerEmail,
          'displayName': peerDisplayName,
        },
      },
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final trimmedText = text.trim();
    if (user == null) {
      throw StateError('You must be signed in to send a message.');
    }
    if (trimmedText.isEmpty) {
      return;
    }

    final conversationRef =
        _firestore.collection('conversations').doc(conversationId);
    final messageRef = conversationRef.collection('messages').doc();
    final batch = _firestore.batch();

    batch.set(messageRef, <String, Object?>{
      'senderId': user.uid,
      'text': trimmedText,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'text',
    });
    batch.set(conversationRef, <String, Object?>{
      'lastMessage': trimmedText,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSenderId': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }
}
