class Series {
  int? id;
  String title;
  String content;
  int score;
  int commentCount;
  bool isPrivate;
  String? createdBy;
  DateTime updatedAt;

  Series({
    required this.id,
    required this.title,
    required this.content,
    required this.score,
    required this.commentCount,
    required this.isPrivate,
    required this.createdBy,
    required this.updatedAt,
  });
  factory Series.empty() {
    return Series(
      id: null,
      title: '',
      content: '',
      score: 0,
      commentCount: 0,
      isPrivate: false,
      createdBy: null,
      updatedAt: DateTime.now(),
    );
  }
  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      score: json['score'],
      commentCount: json['commentCount'],
      isPrivate: json['isPrivate'],
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Series copyWith({
    int? id,
    String? title,
    String? content,
    List<int>? postIds,
    int? score,
    int? commentCount,
    bool? isPrivate,
    String? createdBy,
    DateTime? updatedAt,
  }) {
    return Series(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      score: score ?? this.score,
      commentCount: commentCount ?? this.commentCount,
      isPrivate: isPrivate ?? this.isPrivate,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
