import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final String senderId;
  final bool isCurrentUser;
  final Timestamp createdAt;

  const MessageBubble({
    super.key,
    required this.text,
    required this.senderId,
    required this.isCurrentUser,
    required this.createdAt,
  });

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool showSubtitle = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: widget.isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showSubtitle = !showSubtitle;
              });
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: widget.isCurrentUser
                    ? const Color(0xff006878)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: widget.isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (showSubtitle)
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                'Sent at: ${widget.createdAt.toDate()}',
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
