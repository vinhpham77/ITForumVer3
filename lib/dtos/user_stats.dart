class UserStats {
  final int id;
  final String username;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final int followingCount;
  final int followerCount;

  UserStats({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.role,
    required this.followingCount,
    required this.followerCount,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      followingCount: json['followingCount'],
      followerCount: json['followerCount'],
    );
  }

  factory UserStats.empty() {
    return UserStats(
      id: 0,
      username: '',
      email: '',
      displayName: '',
      avatarUrl: '',
      role: '',
      followingCount: 0,
      followerCount: 0,
    );
  }
}
