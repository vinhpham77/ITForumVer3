class ContentStats {
  int postCount;
  int questionCount;
  int seriesCount;

  ContentStats(
      {required this.postCount,
      required this.questionCount,
      required this.seriesCount});

  factory ContentStats.fromJson(Map<String, dynamic> json) {
    return ContentStats(
        postCount: json['postCount'],
        questionCount: json['questionCount'],
        seriesCount: json['seriesCount']);
  }

  ContentStats copyWith(
      {int? postCount, int? questionCount, int? seriesCount}) {
    return ContentStats(
        postCount: postCount ?? this.postCount,
        questionCount: questionCount ?? this.questionCount,
        seriesCount: seriesCount ?? this.seriesCount);
  }
}
