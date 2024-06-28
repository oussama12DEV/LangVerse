import 'package:flutter/material.dart';

class QuizQuestionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Text(
          'Quiz',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
