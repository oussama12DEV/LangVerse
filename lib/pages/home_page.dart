import 'package:flutter/material.dart';
import 'package:langverse/models/Chatroom.dart';
import 'package:langverse/pages/chatrooms/inside_chatroom_page.dart';
import 'package:langverse/pages/settings/settings_page.dart';
import 'package:langverse/services/home_service.dart';
import 'package:langverse/widgets/chatroom_tile_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ChatRoom? _lastJoinedChatRoom;
  bool _isLoading = true;

  late AnimationController _leftController;
  late Animation<Offset> _leftAnimation;
  late AnimationController _rightController;
  late Animation<Offset> _rightAnimation;

  @override
  void initState() {
    super.initState();
    _fetchLastJoinedChatRoom();

    _leftController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _leftAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: _leftController,
      curve: Curves.easeInOut,
    ));

    _rightController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _rightAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: _rightController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  Future<void> _fetchLastJoinedChatRoom() async {
    final lastJoinedChatRoom = await HomeService.fetchLastJoinedChatRoom();
    setState(() {
      _lastJoinedChatRoom = lastJoinedChatRoom;
      _isLoading = false;
    });
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
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: _lastJoinedChatRoom != null
                  ? _buildJoinedRoomContent()
                  : _buildWelcomeContent(),
            ),
    );
  }

  Widget _buildJoinedRoomContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 20.0),
        const Text(
          'Recently Joined Room',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        ChatRoomTile(
          chatRoom: _lastJoinedChatRoom!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InsideChatroomPage(chatRoom: _lastJoinedChatRoom!),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeContent() {
    return Stack(
      children: [
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to LangVerse!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'No chat room joined recently',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 30,
          bottom: 30,
          child: SlideTransition(
            position: _leftAnimation,
            child: Column(
              children: [
                const Text(
                  'Explore Chatrooms',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomPaint(
                  size: const Size(50, 50),
                  painter: DownArrowPainter(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 30,
          bottom: 30,
          child: SlideTransition(
            position: _rightAnimation,
            child: Column(
              children: [
                const Text(
                  'Play Quiz Duel',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomPaint(
                  size: const Size(50, 50),
                  painter: DownArrowPainter(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DownArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff006878)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - 10, size.height - 10);
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 10, size.height - 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
