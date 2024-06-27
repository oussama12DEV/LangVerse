import 'package:flutter/material.dart';

class AbandonedDuelWidget extends StatelessWidget {
  final String opponentUsername;
  final VoidCallback onDismissed;

  AbandonedDuelWidget({
    required this.opponentUsername,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Duel Abandoned'),
      content: Text(
          'Your opponent $opponentUsername has abandoned the duel. You win!'),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: onDismissed,
        ),
      ],
    );
  }
}
