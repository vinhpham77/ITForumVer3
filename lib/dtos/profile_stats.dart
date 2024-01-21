class ProfileStats {
  int postCount;
  int questionCount;
  int seriesCount;
  int followingCount;
  int followerCount;

  ProfileStats({
    required this.postCount,
    required this.questionCount,
    required this.seriesCount,
    required this.followingCount,
    required this.followerCount,
  });

  // copyWith
  ProfileStats copyWith({
    int? postCount,
    int? questionCount,
    int? seriesCount,
    int? followingCount,
    int? followerCount,
  }) {
    return ProfileStats(
      postCount: postCount ?? this.postCount,
      questionCount: questionCount ?? this.questionCount,
      seriesCount: seriesCount ?? this.seriesCount,
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
    );
  }
}
