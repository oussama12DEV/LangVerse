import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/services/chatrooms_service.dart';
import 'inside_chatroom_page.dart';
import 'create_chatroom_modal.dart';

class ChatroomsPage extends StatefulWidget {
  @override
  _ChatroomsPageState createState() => _ChatroomsPageState();
}

class _ChatroomsPageState extends State<ChatroomsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatRoom> _chatRooms = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms({bool isLoadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result = await ChatroomsService.fetchChatRooms(
        lastDocument: _lastDocument,
        limit: 10,
      );

      List<ChatRoom> newChatRooms = result['chatRooms'];
      DocumentSnapshot? newLastDocument = result['lastDocument'];

      setState(() {
        _isLoading = false;
        if (isLoadMore) {
          _chatRooms.addAll(newChatRooms);
        } else {
          _chatRooms = newChatRooms;
        }

        if (newChatRooms.length < 10) {
          _hasMore = false;
        } else {
          _lastDocument = newLastDocument;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
        _chatRooms = [];
      });

      print('Error fetching chat rooms: $e');
    }
  }

  void _searchChatRooms(String searchText) async {
    setState(() {
      _isLoading = true;
      _hasMore = false;
    });

    try {
      List<ChatRoom> searchResults = await ChatroomsService.searchChatRooms(
        name: searchText,
      );

      setState(() {
        _isLoading = false;
        _chatRooms = searchResults;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _chatRooms = [];
      });

      print('Error searching chat rooms: $e');
    }
  }

  void _showCreateChatRoomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateChatRoomModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatrooms'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for chatrooms...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (value) {
                _searchChatRooms(value.trim());
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<ChatRoom> chatRooms = snapshot.data!.docs.map((doc) {
                  return ChatRoom.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                if (_searchController.text.isNotEmpty) {
                  chatRooms = chatRooms
                      .where((chatRoom) => chatRoom.title
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
                }

                return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = chatRooms[index];
                    return ListTile(
                      title: Text(chatRoom.title),
                      subtitle: Text('Language: ${chatRoom.language}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InsideChatroomPage(chatRoom: chatRoom),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateChatRoomModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
