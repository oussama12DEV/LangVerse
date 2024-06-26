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

  Future<void> _searchChatRooms() async {
    setState(() {
      _isLoading = true;
      _hasMore = false;
    });

    try {
      List<ChatRoom> searchResults = await ChatroomsService.searchChatRooms(
        name: _searchController.text,
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

  void _showCreateChatRoomModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateChatRoomModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              onSubmitted: (value) {
                _searchChatRooms();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatRooms.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _chatRooms.length) {
                  return ElevatedButton(
                    onPressed: () => _fetchChatRooms(isLoadMore: true),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Show More'),
                  );
                }
                final chatRoom = _chatRooms[index];
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
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChatRoomModal,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
