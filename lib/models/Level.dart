class Level {
  String id;
  String name;

  Level({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Level fromMap(Map<String, dynamic> map) {
    return Level(
      id: map['id'],
      name: map['name'],
    );
  }
}
