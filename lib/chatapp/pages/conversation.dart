import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/firestore_service.dart';
import 'chat.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final _service = FirestoreService();
  String? _openingUid;

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: currentUid == null
          ? const Center(child: Text('Please sign in to chat.'))
          : StreamBuilder<List<AppUser>>(
              stream: _service.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Unable to load users.'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = (snapshot.data ?? const [])
                    .where((user) => user.uid != currentUid)
                    .toList();
                if (users.isEmpty) {
                  return const Center(
                    child: Text('No other users are registered yet.'),
                  );
                }

                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final displayName =
                        user.displayName.isNotEmpty ? user.displayName : user.email;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName.characters.first.toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(displayName),
                      subtitle: user.email.isNotEmpty ? Text(user.email) : null,
                      trailing: _openingUid == user.uid
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: _openingUid == null
                          ? () => _openChat(currentUid, user)
                          : null,
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _openChat(String currentUid, AppUser otherUser) async {
    setState(() => _openingUid = otherUser.uid);
    try {
      final conversationId =
          await _service.getOrCreateConversation(currentUid, otherUser.uid);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatPage(
            conversationId: conversationId,
            otherUser: otherUser,
          ),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.code == 'permission-denied'
                ? 'Firestore denied this conversation. Deploy the updated '
                    'firestore.rules to your Firebase project.'
                : 'Unable to open conversation (${error.code}).',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open conversation: $error')),
      );
    } finally {
      if (mounted) setState(() => _openingUid = null);
    }
  }
}
