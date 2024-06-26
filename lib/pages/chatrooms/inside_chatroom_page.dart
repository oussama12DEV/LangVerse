import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/services/chatrooms_service.dart';
import 'package:langverse/widgets/message_bubble_widget.dart';

class InsideChatroomPage extends StatefulWidget {
  final ChatRoom chatRoom;

  InsideChatroomPage({required this.chatRoom});

  @override
  _InsideChatroomPageState createState() => _InsideChatroomPageState();
}

class _InsideChatroomPageState extends State<InsideChatroomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? currentUserUid;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    ChatroomsService.joinChatRoom(widget.chatRoom.id);
  }

  void getCurrentUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserUid = currentUser.uid;
      });
    }
  }

  @override
  void dispose() {
    ChatroomsService.leaveChatRoom(widget.chatRoom.id);
    super.dispose();
  }

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isEmpty) return;

    ChatroomsService.sendMessage(widget.chatRoom.id, message).then((_) {
      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }).catchError((error) {
      print("Failed to send message: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(widget.chatRoom.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    String senderId = message['senderId'];
                    bool isCurrentUser =
                        currentUserUid != null && senderId == currentUserUid;

                    return MessageBubble(
                      text: message['text'],
                      senderId: senderId,
                      isCurrentUser: isCurrentUser,
                      createdAt: message['timestamp'],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
