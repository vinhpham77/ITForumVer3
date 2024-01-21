import 'package:it_forum/models/user.dart';

class PostAggregation {
  int? id;
  String title;
  List<String> tags;
  String content;
  int score;
  int commentCount;
  bool private;
  DateTime updatedAt;
  User user;

  PostAggregation(
      {required this.id,
      required this.title,
      required this.content,
      required this.tags,
      required this.score,
      required this.commentCount,
      required this.private,
      required this.updatedAt,
      required this.user});

  PostAggregation.empty()
      : id = null,
        title = '',
        content = '',
        tags = [],
        score = 0,
        commentCount = 0,
        private = false,
        updatedAt = DateTime.now(),
        user = User.empty();

  factory PostAggregation.fromJson(Map<String, dynamic> json) {
    return PostAggregation(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      score: json['score'],
      commentCount: json['commentCount'],
      private: json['private'],
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }

  PostAggregation copyWith({
    int? id,
    String? title,
    String? content,
    List<String>? tags,
    int? score,
    int? commentCount,
    bool? private,
    DateTime? updatedAt,
    User? user,
  }) {
    return PostAggregation(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      score: score ?? this.score,
      commentCount: commentCount ?? this.commentCount,
      private: private ?? this.private,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}
