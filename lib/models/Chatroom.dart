class ChatRoom {
  String id;
  String creatorId;
  String title;
  String language;
  int userLimit;
  Set<String> currentUsers;

  ChatRoom({
    required this.id,
    required this.title,
    required this.userLimit,
    required this.language,
    required this.creatorId,
    required this.currentUsers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userLimit': userLimit,
      'language': language,
      'creatorId': creatorId,
      'currentUsers': currentUsers.toList(),
    };
  }

  static ChatRoom fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      title: map['title'],
      userLimit: map['userLimit'],
      language: map['language'],
      creatorId: map['creatorId'],
      currentUsers: map['currentUsers'] != null
          ? Set<String>.from(map['currentUsers'])
          : Set<String>(),
    );
  }
}
