class BookmarkInfo {
  final int targetId;
  final bool type;

  BookmarkInfo({
    required this.targetId,
    required this.type,
  });

  factory BookmarkInfo.fromJson(Map<String, dynamic> json) {
    return BookmarkInfo(
        targetId: json['targetId'],
        type: json['type']);
  }
  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'type': type,
    };
  }
}
