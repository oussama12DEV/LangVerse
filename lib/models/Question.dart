class Question {
  String id;
  String title;
  List<String> answers;
  int correctAnswerIndex;

  Question({
    required this.id,
    required this.title,
    required this.answers,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'answers': answers,
      'correct_answer_index': correctAnswerIndex,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      title: map['title'],
      answers: List<String>.from(map['answers']),
      correctAnswerIndex: map['correct_answer_index'],
    );
  }
}
