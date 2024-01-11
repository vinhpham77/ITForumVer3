
import 'package:it_forum/models/user.dart';

class PostTag {
  int? id;
  String title;
  List<String> tags;
  String content;
  int score;
  int commentCount;
  bool isPrivate;
  DateTime updatedAt;
  User? createdBy;

  PostTag(
      {required this.id,
      required this.title,
      required this.content,
      required this.tags,
      required this.score,
      required this.commentCount,
      required this.isPrivate,
      required this.updatedAt,
        required this.createdBy});

  factory PostTag.fromJson(Map<String, dynamic> json) {
    return PostTag(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      score: json['score'],
      commentCount: json['commentCount'],
      isPrivate: json['isPrivate'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: User.fromJson(json['createdBy']),
    );
  }

  PostTag copyWith({
    int? id,
    String? title,
    String? content,
    List<String>? tags,
    int? score,
    int? commentCount,
    bool? isPrivate,
    DateTime? updatedAt,
    User? createdBy,
  }) {
    return PostTag(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      score: score ?? this.score,
      commentCount: commentCount ?? this.commentCount,
      isPrivate: isPrivate ?? this.isPrivate,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
