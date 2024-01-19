import 'package:it_forum/dtos/post_tag.dart';
import 'package:it_forum/models/post.dart';
import 'package:it_forum/models/user.dart';


class Sp {
  int id;
  String title;
  String content;
  List<String> postIds;
  int score;
  bool isPrivate;
  int commentCount;
  String createdBy;
  DateTime updatedAt;
  List<Post> posts;
  User user;

  Sp({
    required this.id,
    required this.title,
    required this.content,
    required this.postIds,
    required this.score,
    required this.isPrivate,
    required this.commentCount,
    required this.createdBy,
    required this.updatedAt,
    required this.posts,
    required this.user
  });
  factory Sp.fromJson(Map<String, dynamic> json) {
    return Sp(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      postIds: List<String>.from(json['postIds'] ?? []),
      score: json['score'] is int ? json['score'] : 0,
      commentCount: json['commentCount'] ?? 0,
      isPrivate: json['private'] ?? false,
      createdBy: json['createdBy'] ?? '',
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      posts: (json['posts'] != null && json['posts'] is List)
          ? List<Post>.from(json['posts'].map((post) => PostTag.fromJson(post)))
          : [],
      user: User.fromJson(json['user']),
    );

  }

}