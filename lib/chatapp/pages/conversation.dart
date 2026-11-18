import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/chat_service.dart';
import 'chat.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: currentUser == null
          ? const Center(child: Text("Please sign in"))
          : StreamBuilder<List<AppUser>>(
              stream: _chatService.usersStream(currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Unable to load users."),
                  );
                }

                final users = snapshot.data ?? <AppUser>[];
                if (users.isEmpty) {
                  return const Center(
                    child: Text("No other registered users."),
                  );
                }

                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final name = user.email.contains('@')
                        ? user.email.split('@').first
                        : user.email;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          name.isEmpty ? '?' : name.characters.first.toUpperCase(),
                        ),
                      ),
                      title: Text(name),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => ChatPage(otherUser: user),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
