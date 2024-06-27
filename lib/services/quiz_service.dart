import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> findOpponent(
      String userId, String language, String level, String category) async {
    Completer<String> completer = Completer<String>();

    Timer timeout = Timer(Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.completeError('Opponent search timed out');
      }
    });

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

        await _createQuizDuel(userId, opponentId, language, level, category);

        completer.complete(opponentId);
      } else {
        await _createQuizRequest(userId, language, level, category);
      }
    } catch (e) {
      completer.completeError('Failed to find opponent: $e');
    }

    return completer.future;
  }

  Future<void> _createQuizRequest(
      String userId, String language, String level, String category) async {
    try {
      // Create a new quiz request document
      await firestore.collection('quiz_requests').add({
        'userId': userId,
        'language': language,
        'level': level,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Quiz request created for $userId');
    } catch (e) {
      print('Failed to create quiz request: $e');
      // Handle error if needed
    }
  }

  Future<void> _deleteQuizRequest(String userId) async {
    try {
      // Delete the quiz request document for the specified user
      QuerySnapshot snapshot = await firestore
          .collection('quiz_requests')
          .where('userId', isEqualTo: userId)
          .get();
      snapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
      print('Deleted quiz request for $userId');
    } catch (e) {
      print('Failed to delete quiz request: $e');
      // Handle error if needed
    }
  }

  Future<void> _createQuizDuel(String user1Id, String user2Id, String language,
      String level, String category) async {
    try {
      // Create a new quiz duel document
      DocumentReference duelDocRef = firestore.collection('quiz_duels').doc();
      await duelDocRef.set({
        'user1Id': user1Id,
        'user2Id': user2Id,
        'language': language,
        'level': level,
        'category': category,
        'currentRound': 1,
        'totalRounds': 5, // Example: 5 rounds per quiz duel
        'scores': {
          user1Id: 0,
          user2Id: 0,
        },
      });
      print('Quiz duel created between $user1Id and $user2Id');
    } catch (e) {
      print('Failed to create quiz duel: $e');
      // Handle error if needed
    }
  }
}
