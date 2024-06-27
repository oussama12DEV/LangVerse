import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/pages/chatrooms/inside_chatroom_page.dart';
import 'package:langverse/pages/settings/settings_page.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/widgets/chatroom_tile_widget.dart'; // Update import path if necessary

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _lastJoinedChatRoomId;
  ChatRoom? _lastJoinedChatRoom;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLastJoinedChatRoom();
  }

  Future<void> _fetchLastJoinedChatRoom() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        _lastJoinedChatRoomId = userSnapshot['lastJoinedRoom'];
        if (_lastJoinedChatRoomId != null) {
          final chatRoomRef = FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(_lastJoinedChatRoomId);
          final chatRoomSnapshot = await chatRoomRef.get();
          if (chatRoomSnapshot.exists) {
            setState(() {
              _lastJoinedChatRoom = ChatRoom.fromMap(chatRoomSnapshot.data()!);
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsPage(),
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.black,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: _lastJoinedChatRoom != null
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                            height:
                                20.0), // Add some space between the tile and the graph
                        Container(
                          width: double.infinity,
                          height: 200.0, // Adjust the height as needed
                          color: Colors.grey[300], // Placeholder color
                          child: Center(
                            child: Text(
                              'Graph Placeholder',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0), // Add some space at the top
                        Text(
                          'Recently Joined Room',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            height: 10.0), // Add some space below the title
                        ChatRoomTile(
                          chatRoom: _lastJoinedChatRoom!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InsideChatroomPage(
                                    chatRoom: _lastJoinedChatRoom!),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Text('No chat room joined recently'),
            ),
    );
  }
}
