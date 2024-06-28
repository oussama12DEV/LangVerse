import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/services/chatrooms_service.dart';
import 'package:langverse/widgets/chatroom_tile_widget.dart';
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
  String _selectedLanguage = 'All Languages';
  String _selectedFilter = 'All Rooms';
  int currentPage = 1;
  final int roomsPerPage = 10;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

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
        limit: roomsPerPage,
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

        if (newChatRooms.length < roomsPerPage) {
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
    }
  }

  void _nextPage() {
    if (_hasMore) {
      _fetchChatRooms(isLoadMore: true);
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

      if (_selectedLanguage != 'All Languages') {
        searchResults = searchResults
            .where((chatRoom) =>
                chatRoom.language.toLowerCase() ==
                _selectedLanguage.toLowerCase())
            .toList();
      }

      if (_selectedFilter == 'My Rooms') {
        searchResults = searchResults
            .where((chatRoom) => chatRoom.creatorId == _currentUser!.uid)
            .toList();
      }

      setState(() {
        _isLoading = false;
        _chatRooms = searchResults;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _chatRooms = [];
      });
    }
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
    });
    _searchChatRooms(_searchController.text.trim());
  }

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _searchChatRooms(_searchController.text.trim());
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
            child: ListView.builder(
              itemCount: _chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = _chatRooms[index];
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
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading && _hasMore)
            TextButton(
              onPressed: _nextPage,
              child: const Text('Next'),
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
