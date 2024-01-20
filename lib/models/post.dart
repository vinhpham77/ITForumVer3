import 'package:it_forum/models/tag.dart';

class Post {
  int id;
  String title;
  String content;
  int score;
  List<Tag> tags;
  bool isPrivate;
  int commentCount;
  String createdBy;
  DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.score,
    required this.tags,
    required this.commentCount,
    required this.isPrivate,
    required this.createdBy,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      score: json['score'],
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => Tag.fromJson(tag))
          .toList(),
      commentCount: json['commentCount'],
      isPrivate: json['isPrivate'],
      createdBy: json['createdBy'],
      updatedAt: DateTime.tryParse(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy': createdBy,
      'score': score,
      'title': title,
      'content': content,
      'commentCount': commentCount,
      'isPrivate': isPrivate,
      'updatedAt': updatedAt
    };
  }

  Post copyWith({
    int? id,
    String? title,
    String? content,
    List<Tag>? tags,
    int? score,
    int? commentCount,
    bool? isPrivate,
    String? createdBy,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      score: score ?? this.score,
      tags: tags ?? this.tags,
      commentCount: commentCount ?? this.commentCount,
      isPrivate: isPrivate ?? this.isPrivate,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Post empty() {
    return Post(
      id: 0,
      title: '',
      content: '',
      score: 0,
      tags: [],
      commentCount: 0,
      isPrivate: false,
      createdBy: '',
      updatedAt: DateTime.now(),
    );
  }
}
