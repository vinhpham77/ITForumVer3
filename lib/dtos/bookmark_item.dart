import '../models/tag.dart';
import '../models/user.dart';

class BookmarkItem {
  int? id;
  String? title;
  String? content;
  int score;
  int commentCount;
  bool private;
  DateTime? updatedAt;
  String? createdBy;

  BookmarkItem({required this.id,
    required this.title,
    required this.content,
    required this.score,
    required this.commentCount,
    required this.private,
    required this.updatedAt,
    required this.createdBy});

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        score: json['score'],
        commentCount: json['commentCount'],
        private: json['private'],
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        createdBy: json['createdBy']);
  }
}

class PostBookmark extends BookmarkItem {
  List<Tag> tags;

  PostBookmark({required super.id,
    required super.title,
    required super.content,
    required super.score,
    required super.commentCount,
    required super.private,
    required super.updatedAt,
    required super.createdBy,
    required this.tags});

  factory PostBookmark.fromJson(Map<String, dynamic> json) {
    var superBookmarkItem = BookmarkItem.fromJson(json);
    return PostBookmark(
      id: superBookmarkItem.id,
      title: superBookmarkItem.title,
      content: superBookmarkItem.content,
      score: superBookmarkItem.score,
      commentCount: superBookmarkItem.commentCount,
      private: superBookmarkItem.private,
      updatedAt: superBookmarkItem.updatedAt,
      createdBy: superBookmarkItem.createdBy,
      tags: json['tags'] == null
          ? []
          : (json['tags'] as List<dynamic>).map((tag) => Tag.fromJson(tag)).toList(),
    );
  }
}

class SeriesBookmark extends BookmarkItem {
  List<String> postIds;

  SeriesBookmark({required super.id,
    required super.title,
    required super.content,
    required super.score,
    required super.commentCount,
    required super.private,
    required super.updatedAt,
    required super.createdBy,
    required this.postIds});

  factory SeriesBookmark.fromJson(Map<String, dynamic> json) {
    var superBookmarkItem = BookmarkItem.fromJson(json);
    return SeriesBookmark(
      id: superBookmarkItem.id,
      title: superBookmarkItem.title,
      content: superBookmarkItem.content,
      score: superBookmarkItem.score,
      commentCount: superBookmarkItem.commentCount,
      private: superBookmarkItem.private,
      updatedAt: superBookmarkItem.updatedAt,
      createdBy: superBookmarkItem.createdBy,
      postIds: json['postIds'] == null ? [] : json['postIds'].cast<String>(),
    );
  }
}

class BookmarkUserItem {
  BookmarkItem? bookmarkItem;
  User? user;

  BookmarkUserItem({
    required this.bookmarkItem, required this.user
  });

  BookmarkUserItem.empty() {
    bookmarkItem = null;
    user = null;
  }
}

