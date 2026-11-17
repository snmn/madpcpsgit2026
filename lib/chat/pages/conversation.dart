import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demopcpsseca/chat/models/chat_message.dart';
import 'package:demopcpsseca/chat/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class conversation extends StatefulWidget {
  const conversation({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  final String chatId;
  final String otherUserId;
  final String otherUserName;

  @override
  State<conversation> createState() => _conversationState();
}

class _conversationState extends State<conversation> {
  final _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final me = FirebaseAuth.instance.currentUser;
    final text = _message.text.trim();
    if (me == null || text.isEmpty || _sending) return;

    final meName = me.displayName?.trim().isNotEmpty == true
        ? me.displayName!.trim()
        : (me.email ?? 'Me');
    final uids = [me.uid, widget.otherUserId];
    final names = {me.uid: meName, widget.otherUserId: widget.otherUserName};

    setState(() => _sending = true);
    try {
      await ChatService.sendMessage(
        chatId: widget.chatId,
        uids: uids,
        participantNames: names,
        senderId: me.uid,
        senderName: meName,
        text: text,
      );
      _message.clear();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $error')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ChatService.messagesStream(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = (snapshot.data?.docs ?? [])
                    .map((doc) => ChatMessage.fromMap(doc.data()))
                    .toList();
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == me?.uid;
                    return _MessageBubble(message: msg, isMe: isMe);
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isMe ? Colors.blue : Colors.grey.shade300;
    final textColor = isMe ? Colors.white : Colors.black;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12),
          ),
        ),
        child: Column(
          crossAxisAlignment: align,
          children: [
            if (!isMe &&
                message.senderName.isNotEmpty &&
                message.senderName != 'Me')
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}