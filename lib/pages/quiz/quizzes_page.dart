import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/services/quiz_service.dart';

class QuizzesPage extends StatefulWidget {
  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  final QuizService quizService = QuizService();
  String selectedLanguage = 'English';
  String selectedLevel = 'Beginner';
  String selectedCategory = 'Vocabulary';
  bool isSearching = false;
  bool isLoading = false;

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
              onPressed: isLoading ? null : () => _handleFindOpponent(context),
              child: const Text('Search for Opponent'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    List<String> languages = ['English', 'Spanish', 'French'];
    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      onChanged: isLoading
          ? null
          : (value) {
              setState(() {
                selectedLanguage = value!;
              });
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
    List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
    return DropdownButtonFormField<String>(
      value: selectedLevel,
      onChanged: isLoading
          ? null
          : (value) {
              setState(() {
                selectedLevel = value!;
              });
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
    List<String> categories = ['Vocabulary', 'Grammar', 'Conjugation'];
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      onChanged: isLoading
          ? null
          : (value) {
              setState(() {
                selectedCategory = value!;
              });
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
    setState(() {
      isSearching = true;
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Searching for opponent..."),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _cancelSearch(context);
                      },
                      child: Text("Cancel Search"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    await _searchForOpponent(context);
  }

  Future<void> _searchForOpponent(BuildContext context) async {
    if (!isSearching) return;

    String language = selectedLanguage;
    String level = selectedLevel;
    String category = selectedCategory;

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      String userId = currentUser.uid;

      String opponentId = await quizService.findOpponent(
          userId, language, level, category, context);

      if (!isSearching) return;

      if (opponentId.isNotEmpty) {
        Navigator.pop(context);
        Navigator.pushNamed(context,
            '/duel/$opponentId'); // Navigate to duel page with opponentId
        setState(() {
          isSearching = false;
          isLoading = false;
        });
        return;
      }

      await Future.delayed(Duration(seconds: 1));
      await _searchForOpponent(context);
    } catch (e) {
      if (isSearching) {
        print("Error finding opponent: $e");
        Navigator.pop(context);
        _showAlertDialog(context, "Error",
            "Failed to find opponent. Please try again later.");
        setState(() {
          isSearching = false;
          isLoading = false;
        });
      }
    }
  }

  void _cancelSearch(BuildContext context) {
    setState(() {
      isSearching = false;
      isLoading = false;
    });
    quizService.cancelSearch(FirebaseAuth.instance.currentUser!.uid);
    Navigator.pop(context);
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
