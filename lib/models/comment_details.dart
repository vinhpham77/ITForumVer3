import 'package:it_forum/models/comment.dart';
import 'package:it_forum/models/user.dart';

class CommentDetails {
  int id;
  Comment comment;
  String createdBy;
  String content;
  DateTime updatedAt;
  int left;
  int right;

  CommentDetails(
      {required this.id,
      required this.comment,
      required this.createdBy,
      required this.content,
      required this.updatedAt,
      required this.left,
      required this.right});

  factory CommentDetails.fromJson(Map<String, dynamic> json) {
    return CommentDetails(
      id: json['id'],
      comment: Comment.fromJson(json['comment']),
      createdBy: json['createdBy'],
      content: json['content'],
      updatedAt: DateTime.tryParse(json['updatedAt']) ?? DateTime.now(),
      left: json['left'],
      right: json['right'],
    );
  }

  static CommentDetails empty() {
    return CommentDetails(
      id: 0,
      comment: Comment.empty(),
      content: '',
      createdBy: '',
      left: 0,
      right: 0,
      updatedAt: DateTime.now(),
    );
  }
}
