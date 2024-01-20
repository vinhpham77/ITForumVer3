class FollowStats {
  int followingCount;
  int followerCount;

  FollowStats({
    required this.followingCount,
    required this.followerCount,
  });

  factory FollowStats.fromJson(Map<String, dynamic> json) {
    return FollowStats(
      followingCount: json['followingCount'],
      followerCount: json['followerCount'],
    );
  }

  FollowStats copyWith({
    int? followingCount,
    int? followerCount,
  }) {
    return FollowStats(
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
    );
  }
}