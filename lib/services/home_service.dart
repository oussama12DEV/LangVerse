import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/models/Chatroom.dart';

class HomeService {
  static Future<ChatRoom?> fetchLastJoinedChatRoom() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final lastJoinedChatRoomId = userSnapshot['lastJoinedRoom'];
        if (lastJoinedChatRoomId != "") {
          final chatRoomRef = FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(lastJoinedChatRoomId);
          final chatRoomSnapshot = await chatRoomRef.get();
          if (chatRoomSnapshot.exists) {
            return ChatRoom.fromMap(chatRoomSnapshot.data()!);
          }
        }
      }
    }
    return null;
  }
}
