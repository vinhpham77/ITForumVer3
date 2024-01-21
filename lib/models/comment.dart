class Comment {
  int id;
  int targetId;
  bool type;

  Comment({required this.id, required this.targetId, required this.type});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      targetId: json['targetId'],
      type: json['type'],
    );
  }

  static Comment empty() {
    return Comment(
      id: 0,
      targetId: 0,
      type: true,
    );
  }
}
