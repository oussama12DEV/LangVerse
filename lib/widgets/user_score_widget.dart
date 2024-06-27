import 'package:flutter/material.dart';

class UserScoreWidget extends StatelessWidget {
  final String username;
  final int score;
  final bool isCurrentUser;

  UserScoreWidget({
    required this.username,
    required this.score,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(isCurrentUser ? 'You: $username' : 'Opponent: $username'),
        subtitle: Text('Score: $score'),
      ),
    );
  }
}
