class SeriesPost {
  int? id;
  String title;
  List<int> postIds;
  String content;
  int score;
  int commentCount;
  bool isPrivate;
  DateTime updatedAt;
  String? createdBy;

  SeriesPost(
      {required this.id,
      required this.title,
      required this.content,
      required this.postIds,
      required this.score,
      required this.commentCount,
      required this.isPrivate,
      required this.updatedAt,
      required this.createdBy});

  factory SeriesPost.fromJson(Map<String, dynamic> json) {
    return SeriesPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      postIds: List<int>.from(json['postIds']),
      score: json['score'],
      commentCount: json['commentCount'],
      isPrivate: json['isPrivate'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
    );
  }

  SeriesPost copyWith({
    int? id,
    String? title,
    String? content,
    List<int>? postIds,
    int? score,
    int? commentCount,
    bool? isPrivate,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return SeriesPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      postIds: postIds ?? this.postIds,
      score: score ?? this.score,
      commentCount: commentCount ?? this.commentCount,
      isPrivate: isPrivate ?? this.isPrivate,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
