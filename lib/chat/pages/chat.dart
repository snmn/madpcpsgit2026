import 'package:demopcpsseca/chat/models/app_user.dart';
import 'package:demopcpsseca/chat/pages/conversation.dart';
import 'package:demopcpsseca/chat/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  void _openConversation(AppUser other) {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null) return;
    final chatId = ChatService.chatIdFor(me.uid, other.uid);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => conversation(
          chatId: chatId,
          otherUserId: other.uid,
          otherUserName: other.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: me == null
          ? const Center(child: Text('Sign in to start chatting.'))
          : StreamBuilder<List<AppUser>>(
              stream: ChatService.usersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final users = (snapshot.data ?? [])
                    .where((user) => user.uid != me.uid)
                    .toList();
                if (users.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }
                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openConversation(user),
                    );
                  },
                );
              },
            ),
    );
  }
}