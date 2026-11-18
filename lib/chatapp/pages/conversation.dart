import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demopcpsseca/chatapp/firestore_chat_service.dart';
import 'package:demopcpsseca/chatapp/pages/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: const Center(
          child: Text('Please sign in to view chats.'),
        ),
      );
    }

    final users = FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load users: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final peers = snapshot.data?.docs.where(
                (doc) => doc.id != currentUser.uid,
              ).toList() ??
              <QueryDocumentSnapshot<Map<String, dynamic>>>[];

          if (peers.isEmpty) {
            return const Center(
              child: Text('No other users are available yet.'),
            );
          }

          return ListView.separated(
            itemCount: peers.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final peer = peers[index];
              final data = peer.data();
              final email = (data['email'] as String?)?.trim() ?? '';
              final displayName =
                  (data['displayName'] as String?)?.trim().isNotEmpty == true
                      ? (data['displayName'] as String).trim()
                      : (email.isEmpty ? 'User' : email.split('@').first);

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    displayName.isEmpty
                        ? '?'
                        : displayName.substring(0, 1).toUpperCase(),
                  ),
                ),
                title: Text(displayName),
                subtitle: email.isEmpty ? null : Text(email),
                onTap: () => _openChat(
                  context: context,
                  peerUid: peer.id,
                  peerEmail: email,
                  peerDisplayName: displayName,
                  currentUid: currentUser.uid,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openChat({
    required BuildContext context,
    required String peerUid,
    required String peerEmail,
    required String peerDisplayName,
    required String currentUid,
  }) async {
    try {
      final service = FirestoreChatService();
      final conversationId = service.conversationId(currentUid, peerUid);
      await service.ensureConversation(
        currentUid: currentUid,
        peerUid: peerUid,
        peerEmail: peerEmail,
        peerDisplayName: peerDisplayName,
      );
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Chat(
            conversationId: conversationId,
            peerUid: peerUid,
            peerDisplayName: peerDisplayName,
            peerEmail: peerEmail,
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open chat: $error')),
      );
    }
  }
}
