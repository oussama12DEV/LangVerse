class Quiz {
  String id;
  String name;

  Quiz({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Quiz fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      name: map['name'],
    );
  }
}
