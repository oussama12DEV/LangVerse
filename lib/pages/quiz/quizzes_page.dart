import 'package:flutter/material.dart';
import 'package:langverse/pages/quiz/quiz_duel_page.dart';
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

  Future<void> _handleFindOpponent(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      String quizRequestId = await quizService.createQuizRequest(
        selectedLanguage,
        selectedLevel,
        selectedCategory,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Searching for opponent..."),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _cancelSearch();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );

      String quizDuelId = await _pollForMatch(quizRequestId);
      Navigator.of(context).pop();

      if (quizDuelId.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DuelPage(duelId: quizDuelId),
          ),
        );
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _pollForMatch(String quizRequestId) async {
    const int pollInterval = 1000;
    String quizDuelId = '';

    while (quizDuelId.isEmpty) {
      quizDuelId = await quizService.findMatchingQuizRequest(
        quizRequestId,
        selectedLanguage,
        selectedLevel,
        selectedCategory,
      );

      if (quizDuelId.isNotEmpty) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: pollInterval));
    }

    return quizDuelId;
  }

  void _cancelSearch() {
    quizService.cancelQuizRequest();
    setState(() {
      isLoading = false;
    });
  }
}
