import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/models/Message.dart';

class ChatroomsService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> createChatRoom(
      String title, int userLimit, String language) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final chatRoomRef =
          FirebaseFirestore.instance.collection('chatrooms').doc();
      ChatRoom chatRoom = ChatRoom(
        id: chatRoomRef.id,
        title: title,
        userLimit: userLimit,
        currentUsers: {}, // Initialize as empty set
        currentUsers: {}, // Initialize as empty set
        language: language,
        creatorId: user.uid,
      );

      await chatRoomRef.set(chatRoom.toMap()); // Save chat room to Firestore
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> removeChatRoom(String chatRoomId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          msg: "User not logged in",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      final chatRoomRef =
          FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId);
      await chatRoomRef.delete(); // Remove the chatroom from Firestore

      Fluttertoast.showToast(
        msg: "Chatroom removed successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await chatRoomRef.set(chatRoom.toMap()); // Save chat room to Firestore
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> removeChatRoom(String chatRoomId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          msg: "User not logged in",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      final chatRoomRef =
          FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId);
      await chatRoomRef.delete(); // Remove the chatroom from Firestore

      Fluttertoast.showToast(
        msg: "Chatroom removed successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<bool> joinChatRoom(String chatRoomId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      Fluttertoast.showToast(
        msg: "User not logged in",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    try {
      final chatRoomRef =
          FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId);
      final chatRoomSnapshot = await chatRoomRef.get();

      if (chatRoomSnapshot.exists) {
        ChatRoom chatRoom = ChatRoom.fromMap(chatRoomSnapshot.data()!);

        if (chatRoom.currentUsers.length < chatRoom.userLimit) {
          chatRoom.currentUsers.add(userId);
          await chatRoomRef.update({'currentUsers': chatRoom.currentUsers});
          return true;
        } else {
          throw Exception('Chat room is full');
        }
      } else {
        throw Exception('Chat room does not exist');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  static Future<void> leaveChatRoom(String chatRoomId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      Fluttertoast.showToast(
        msg: "User not logged in",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      final chatRoomRef =
          FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId);
      final chatRoomSnapshot = await chatRoomRef.get();

      if (chatRoomSnapshot.exists) {
        ChatRoom chatRoom = ChatRoom.fromMap(chatRoomSnapshot.data()!);

        if (chatRoom.currentUsers.contains(userId)) {
          chatRoom.currentUsers.remove(userId);
          await chatRoomRef.update({'currentUsers': chatRoom.currentUsers});
        }
      } else {
        throw Exception('Chat room does not exist');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<Map<String, dynamic>> fetchChatRooms(
      {DocumentSnapshot? lastDocument, int limit = 10}) async {
    try {
      Query query =
          FirebaseFirestore.instance.collection('chatrooms').limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot querySnapshot = await query.get();
      List<ChatRoom> chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      DocumentSnapshot? lastVisible =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return {'chatRooms': chatRooms, 'lastDocument': lastVisible};
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return {'chatRooms': [], 'lastDocument': null};
    }
  }

  static Future<List<ChatRoom>> searchChatRooms(
      {String? name, String? language}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('chatrooms');

      if (name != null && name.isNotEmpty) {
        query = query.where('title', isEqualTo: name);
      }

      if (language != null && language.isNotEmpty) {
        query = query.where('language', isEqualTo: language);
      }

      QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => ChatRoom.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }

  static Future<void> sendMessage(String chatRoomId, String text) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }
      String senderId = currentUser.uid;
      String senderId = currentUser.uid;

      final messageRef = FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc();
          .doc();

      Message message = Message(
        id: messageRef.id,
        chatRoomId: chatRoomId,
        senderId: senderId,
        text: text,
        timestamp: Timestamp.now(),
      );

      await messageRef.set(message.toMap());
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Stream<List<Message>> getMessages(String chatRoomId) {
    try {
      return FirebaseFirestore.instance
          .collection('messages')
          .where('chatRoomId', isEqualTo: chatRoomId)
          .orderBy('timestamp')
          .snapshots()
          .map((query) {
        return query.docs.map((doc) => Message.fromMap(doc.data())).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return Stream.empty();
    }
  }
}
