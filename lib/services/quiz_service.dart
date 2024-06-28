import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/models/Question.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new quiz request
  Future<String> createQuizRequest(
      String language, String level, String category) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('quiz_requests').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'language': language,
        'level': level,
        'category': category,
      });
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Cancel a quiz request
  Future<void> cancelQuizRequest() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('quiz_requests')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Find a matching quiz request (returns quiz duel ID if found)
  Future<String> findMatchingQuizRequest(String quizRequestId, String language,
      String level, String category) async {
    try {
      // Check if current user is already in an active duel
      String? existingDuelId = await _getActiveDuelId();
      if (existingDuelId != null) {
        return existingDuelId;
      }

      // Fetch potential opponents' requests
      QuerySnapshot querySnapshot = await _firestore
          .collection('quiz_requests')
          .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('language', isEqualTo: language)
          .where('level', isEqualTo: level)
          .where('category', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Attempt to create a new quiz duel in a transaction
        String opponentRequestId = querySnapshot.docs.first.id;
        String opponentUserId = querySnapshot.docs.first.get('userId');
        await _deleteQuizRequests(quizRequestId, opponentRequestId);
        String quizDuelId = await _createQuizDuel(
            FirebaseAuth.instance.currentUser!.uid,
            opponentUserId,
            language,
            level,
            category);
        return quizDuelId;
      }

      return '';
    } catch (e) {
      rethrow;
    }
  }

  // Abandon a duel by updating the "abandoned" field
  Future<void> abandonDuel(String duelId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('quiz_duels').doc(duelId).update({
        'active': false,
        'abandoned': currentUserId,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Mark the current user as ready by updating the started field
  Future<void> markUserAsReady(String duelId, bool isUser1) async {
    try {
      String field = isUser1 ? 'user1Started' : 'user2Started';
      await _firestore.collection('quiz_duels').doc(duelId).update({
        field: true,
      });

      DocumentSnapshot duelSnapshot =
          await _firestore.collection('quiz_duels').doc(duelId).get();
      bool user1Started = duelSnapshot.get('user1Started');
      bool user2Started = duelSnapshot.get('user2Started');

      if (user1Started && user2Started) {
        await _startDuel(duelId, duelSnapshot.get('language'),
            duelSnapshot.get('level'), duelSnapshot.get('category'));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Start the duel by adding the first question and setting the start time
  Future<void> _startDuel(
      String duelId, String language, String level, String category) async {
    try {
      // Fetch a random question based on the duel parameters
      QuerySnapshot questionSnapshot = await _firestore
          .collection('quizzes')
          .doc(language)
          .collection(level)
          .doc(category)
          .collection('questions')
          .get();

      if (questionSnapshot.docs.isNotEmpty) {
        DocumentSnapshot questionDoc = questionSnapshot.docs.first;
        Question question =
            Question.fromMap(questionDoc.data() as Map<String, dynamic>);

        await _firestore
            .collection('quiz_duels')
            .doc(duelId)
            .collection('questions')
            .add(question.toMap());
        await _firestore.collection('quiz_duels').doc(duelId).update({
          'startTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _getActiveDuelId() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot activeDuelSnapshot1 = await _firestore
          .collection('quiz_duels')
          .where('active', isEqualTo: true)
          .where('userId1', isEqualTo: currentUserId)
          .get();

      if (activeDuelSnapshot1.docs.isNotEmpty) {
        return activeDuelSnapshot1.docs.first.id;
      }

      QuerySnapshot activeDuelSnapshot2 = await _firestore
          .collection('quiz_duels')
          .where('active', isEqualTo: true)
          .where('userId2', isEqualTo: currentUserId)
          .get();

      if (activeDuelSnapshot2.docs.isNotEmpty) {
        return activeDuelSnapshot2.docs.first.id;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Helper function to delete quiz requests
  Future<void> _deleteQuizRequests(
      String quizRequestId1, String quizRequestId2) async {
    try {
      WriteBatch batch = _firestore.batch();
      batch.delete(_firestore.collection('quiz_requests').doc(quizRequestId1));
      batch.delete(_firestore.collection('quiz_requests').doc(quizRequestId2));
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // Helper function to create a quiz duel
  Future<String> _createQuizDuel(String currentUserId, String opponentUserId,
      String language, String level, String category) async {
    try {
      WriteBatch batch = _firestore.batch();

      // Create a new quiz duel
      DocumentReference quizDuelRef = _firestore.collection('quiz_duels').doc();

      batch.set(quizDuelRef, {
        'userId1': currentUserId,
        'userId2': opponentUserId,
        'score1': 0,
        'score2': 0,
        'numRounds': 5,
        'currentRound': 0,
        'active': true,
        'abandoned': null,
        'user1Started': false,
        'user2Started': false,
        'language': language,
        'level': level,
        'category': category,
      });

      await batch.commit();

      return quizDuelRef.id;
    } catch (e) {
      rethrow;
    }
  }
}
