import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamController<void> _cancelSearchController =
      StreamController<void>.broadcast();

  Future<String> findOpponent(String userId, String language, String level,
      String category, BuildContext context) async {
    Completer<String> completer = Completer<String>();

    _startSearching(userId, language, level, category, completer, context);

    return completer.future;
  }

  void _startSearching(
      String userId,
      String language,
      String level,
      String category,
      Completer<String> completer,
      BuildContext context) async {
    bool isCanceled = false;

    // Listen for cancel events
    _cancelSearchController.stream.listen((_) async {
      if (!completer.isCompleted) {
        completer.completeError('Search canceled');
      }
      await _deleteQuizRequest(userId);
    });

    try {
      // Create initial quiz request if it doesn't exist
      await _createQuizRequest(userId, language, level, category);

      // Start searching for opponent periodically
      Timer.periodic(Duration(seconds: 1), (timer) async {
        if (completer.isCompleted || isCanceled) {
          timer.cancel();
          return;
        }

        try {
          CollectionReference quizRequestsRef =
              firestore.collection('quiz_requests');
          QuerySnapshot snapshot = await quizRequestsRef
              .where('userId', isNotEqualTo: userId)
              .where('language', isEqualTo: language)
              .where('level', isEqualTo: level)
              .where('category', isEqualTo: category)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (snapshot.docs.isNotEmpty) {
            String opponentId = snapshot.docs.first['userId'];

            await _deleteQuizRequest(userId);
            await _deleteQuizRequest(opponentId);

            await _createQuizDuel(
                userId, opponentId, language, level, category);

            if (!completer.isCompleted) {
              completer.complete(opponentId);
              // Navigate to quiz duel screen
              Navigator.pushNamed(context, '/quiz_duel/$userId-$opponentId');
            }
            timer.cancel();
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.completeError('Failed to find opponent: $e');
          }
          timer.cancel();
        }
      });
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError('Failed to start searching: $e');
      }
    }
  }

  void cancelSearch(String userId) async {
    _cancelSearchController.add(null);
    await _deleteQuizRequest(userId);
  }

  Future<void> _createQuizRequest(
      String userId, String language, String level, String category) async {
    try {
      await firestore.collection('quiz_requests').doc(userId).set({
        'userId': userId,
        'language': language,
        'level': level,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Quiz request created for $userId');
    } catch (e) {
      print('Failed to create quiz request: $e');
    }
  }

  Future<void> _deleteQuizRequest(String userId) async {
    try {
      await firestore.collection('quiz_requests').doc(userId).delete();
      print('Deleted quiz request for $userId');
    } catch (e) {
      print('Failed to delete quiz request: $e');
    }
  }

  Future<void> _createQuizDuel(String user1Id, String user2Id, String language,
      String level, String category) async {
    try {
      DocumentReference duelDocRef = firestore.collection('quiz_duels').doc();
      await duelDocRef.set({
        'user1Id': user1Id,
        'user2Id': user2Id,
        'language': language,
        'level': level,
        'category': category,
        'currentRound': 1,
        'totalRounds': 5,
        'scores': {
          user1Id: 0,
          user2Id: 0,
        },
      });
      print('Quiz duel created between $user1Id and $user2Id');
    } catch (e) {
      print('Failed to create quiz duel: $e');
    }
  }
}
