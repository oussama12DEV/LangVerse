import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/services/quiz_service.dart';

class QuizzesPage extends StatelessWidget {
  final QuizService quizService = QuizService(); // Initialize QuizService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Duels'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Quiz Parameters:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLanguageDropdown(),
            const SizedBox(height: 10),
            _buildLevelDropdown(),
            const SizedBox(height: 10),
            _buildCategoryDropdown(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleFindOpponent(context);
              },
              child: const Text('Search for Opponent'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    // Replace with your language options
    List<String> languages = ['English', 'Spanish', 'French'];
    String selectedLanguage = languages.first; // Default selection

    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      onChanged: (value) {
        selectedLanguage = value!;
      },
      items: languages.map((lang) {
        return DropdownMenuItem<String>(
          value: lang,
          child: Text(lang),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Select Language',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLevelDropdown() {
    // Replace with your level options
    List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
    String selectedLevel = levels.first; // Default selection

    return DropdownButtonFormField<String>(
      value: selectedLevel,
      onChanged: (value) {
        selectedLevel = value!;
      },
      items: levels.map((level) {
        return DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Select Level',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    // Replace with your category options
    List<String> categories = ['Vocabulary', 'Grammar', 'Conjugation'];
    String selectedCategory = categories.first; // Default selection

    return DropdownButtonFormField<String>(
      value: selectedCategory,
      onChanged: (value) {
        selectedCategory = value!;
      },
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _handleFindOpponent(BuildContext context) async {
    // Show loading indicator while searching for opponent
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on outside tap
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Searching for opponent..."),
              ],
            ),
          ),
        );
      },
    );

    // Get selected quiz parameters
    String language = 'English'; // Replace with actual selected value
    String level = 'Beginner'; // Replace with actual selected value
    String category = 'Vocabulary'; // Replace with actual selected value

    try {
      // Get current user ID
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      String userId = currentUser.uid;

      // Call findOpponent method from QuizService
      String opponentId =
          await quizService.findOpponent(userId, language, level, category);

      // Navigate to opponent screen or handle match success
      Navigator.pop(context); // Close loading dialog
      if (opponentId.isNotEmpty) {
        // Navigate to opponent screen or handle match success
        Navigator.pushNamed(context, '/opponent-screen', arguments: opponentId);
      } else {
        // Handle no opponent found scenario
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No opponent found"),
              content: Text("Please try again later."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error finding opponent: $e");
      // Handle error scenario
      Navigator.pop(context); // Close loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to find opponent. Please try again later."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
