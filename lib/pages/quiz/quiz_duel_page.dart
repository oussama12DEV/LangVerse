import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/services/quiz_service.dart';
import 'package:langverse/widgets/quiz_question_widget.dart';
import 'package:langverse/widgets/user_score_widget.dart';

class DuelPage extends StatefulWidget {
  final String duelId;

  DuelPage({required this.duelId});

  @override
  _DuelPageState createState() => _DuelPageState();
}

class _DuelPageState extends State<DuelPage> {
  late Stream<DocumentSnapshot> _duelStream;
  late String _currentUserId;
  late String _opponentUserId = '';
  String _currentUserUsername = '';
  String _opponentUsername = '';
  bool _isUser1 = false;
  bool _bothUsersStarted = false;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _duelStream = FirebaseFirestore.instance
        .collection('quiz_duels')
        .doc(widget.duelId)
        .snapshots();

    _initializeDuel();
  }

  @override
  void dispose() {
    super.dispose();
    QuizService().abandonDuel(widget.duelId);
  }

  Future<void> _initializeDuel() async {
    DocumentSnapshot duelSnapshot = await FirebaseFirestore.instance
        .collection('quiz_duels')
        .doc(widget.duelId)
        .get();
    _isUser1 = duelSnapshot.get('userId1') == _currentUserId;
    _opponentUserId =
        _isUser1 ? duelSnapshot.get('userId2') : duelSnapshot.get('userId1');

    DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserId)
        .get();
    DocumentSnapshot opponentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_opponentUserId)
        .get();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentUserUsername = currentUserSnapshot.get('username');
          _opponentUsername = opponentUserSnapshot.get('username');
        });
      }
    });
  }

  Future<void> _startDuel() async {
    try {
      await QuizService().markUserAsReady(widget.duelId, _isUser1);
    } catch (e) {
      print('Error starting duel: $e');
    }
  }

  void _showAbandonedDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Duel Abandoned'),
            content: Text(
                'Your opponent $_opponentUsername has abandoned the duel. You win!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pop(); // Optionally, navigate back to another page
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Duel'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _duelStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('Duel data not available'));
          }

          var duelData = snapshot.data!.data() as Map<String, dynamic>;
          _bothUsersStarted =
              duelData['user1Started'] && duelData['user2Started'];

          // Check if opponent abandoned
          if (duelData['abandoned'] == _opponentUserId) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showAbandonedDialog();
            });
            return Container(); // or return some placeholder widget
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserScoreWidget(
                username: _currentUserUsername,
                score: duelData[_isUser1 ? 'score1' : 'score2'],
              ),
              SizedBox(height: 20),
              UserScoreWidget(
                username: _opponentUsername,
                score: duelData[_isUser1 ? 'score2' : 'score1'],
              ),
              SizedBox(height: 20),
              if (!_bothUsersStarted)
                ElevatedButton(
                  onPressed: _startDuel,
                  child: Text('Start Duel'),
                ),
              if (_bothUsersStarted)
                QuizQuestionWidget(), // Replace with your quiz UI
            ],
          );
        },
      ),
    );
  }
}
