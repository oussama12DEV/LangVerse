import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/services/chatrooms_service.dart'; // Import the service where joinChatRoom and leaveChatRoom are defined

class InsideChatroomPage extends StatefulWidget {
  final ChatRoom chatRoom;

  InsideChatroomPage({required this.chatRoom});

  @override
  _InsideChatroomPageState createState() => _InsideChatroomPageState();
}

class _InsideChatroomPageState extends State<InsideChatroomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ChatroomsService.joinChatRoom(widget.chatRoom.id);
  }

  @override
  void dispose() {
    ChatroomsService.leaveChatRoom(widget.chatRoom.id);
    super.dispose();
  }

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isEmpty) return;

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.id)
        .collection('messages')
        .add({
      'text': message,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
                  .orderBy('createdAt', descending: true)
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
                    return ListTile(
                      title: Text(message['text']),
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
                      hintText: 'Enter message...',
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
