import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/widgets/chatroom_tile_widget.dart';
import 'inside_chatroom_page.dart';
import 'create_chatroom_modal.dart';

class ChatroomsPage extends StatefulWidget {
  @override
  _ChatroomsPageState createState() => _ChatroomsPageState();
}

class _ChatroomsPageState extends State<ChatroomsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLanguage = 'All Languages';
  String _selectedFilter = 'All Rooms';
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _chatRoomsStream;

  @override
  void initState() {
    super.initState();
    _chatRoomsStream = _getChatRoomsStream();
  }

  Stream<QuerySnapshot> _getChatRoomsStream() {
    Query query = FirebaseFirestore.instance.collection('chatrooms');

    if (_selectedLanguage != 'All Languages') {
      query = query.where('language', isEqualTo: _selectedLanguage);
    }

    if (_selectedFilter == 'My Rooms') {
      query = query.where('creatorId', isEqualTo: _currentUser!.uid);
    }

    return query.snapshots();
  }

  void _showCreateChatRoomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateChatRoomModal(),
    );
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _chatRoomsStream = _getChatRoomsStream();
    });
  }

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      _chatRoomsStream = _getChatRoomsStream();
    });
  }

  void _searchChatRooms(String searchText) {
    setState(() {
      _chatRoomsStream = _getChatRoomsStream().where((snapshot) {
        return snapshot.docs.any((doc) =>
            (doc.data() as Map<String, dynamic>)['title']
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatrooms'),
        centerTitle: true,
        leading: _buildLeadingIcon(),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: 'Filter by language',
            onSelected: _selectLanguage,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All Languages',
                child: Text('All Languages'),
              ),
              const PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'Spanish',
                child: Text('Spanish'),
              ),
              const PopupMenuItem<String>(
                value: 'French',
                child: Text('French'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for chatrooms... (${_selectedLanguage})',
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
              stream: _chatRoomsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No chatrooms found.'));
                }

                List<ChatRoom> chatRooms = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return ChatRoom.fromMap(data);
                }).toList();

                return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = chatRooms[index];
                    return ChatRoomTile(
                      chatRoom: chatRoom,
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

  Widget _buildLeadingIcon() {
    IconData iconData;
    if (_selectedFilter == 'My Rooms') {
      iconData = Icons.person;
    } else {
      iconData = Icons.group;
    }

    return GestureDetector(
      onTap: () {
        if (_selectedFilter == 'My Rooms') {
          _selectFilter('All Rooms');
        } else {
          _selectFilter('My Rooms');
        }
      },
      child: Icon(iconData),
    );
  }
}
