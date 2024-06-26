import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String chatRoomId;
  String senderId;
  String text;
  Timestamp timestamp;

  Message(
      {required this.id,
      required this.chatRoomId,
      required this.senderId,
      required this.text,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      chatRoomId: map['chatRoomId'],
      senderId: map['senderId'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }
}
