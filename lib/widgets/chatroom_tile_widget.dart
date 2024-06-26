import 'package:flutter/material.dart';
import 'package:langverse/models/Chatroom.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const ChatRoomTile({required this.chatRoom, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        onTap: onTap,
        title: Text(chatRoom.title,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Users: ${chatRoom.currentUsers.length} / ${chatRoom.userLimit}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Chip(
                  label: Text(chatRoom.language),
                  backgroundColor: const Color(0xff006878),
                  labelStyle: const TextStyle(color: Colors.white),
                  side: BorderSide.none,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
