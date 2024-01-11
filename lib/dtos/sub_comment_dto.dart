class SubCommentDto {
  final int? subCommentFatherId;

  final String username;

  final String content;

  SubCommentDto({
    this.subCommentFatherId,
    required this.username,
    required this.content
  });

  Map<String, dynamic> toJson() {
    return {
      'subCommentFatherId': subCommentFatherId == null ? "" : subCommentFatherId,
      'username': username,
      'content': content,
    };
  }
}