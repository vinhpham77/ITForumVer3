class Vote {
  final int targetId;
  final bool targetType;
  final String? username;
  final bool voteType;
  final DateTime updatedAt;

  Vote({
    required this.targetId,
    required this.targetType,
    required this.username,
    required this.voteType,
    required this.updatedAt,
  });

  // Phương thức tạo user từ JSON
  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
        targetId: json['targetId'],
        targetType: json['targetType'],
        username: json['username'],
        voteType: json['voteType'],
        updatedAt: DateTime.parse(json['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'username': username ?? '',
      'targetType': targetType,
      'voteType': voteType,
      'updatedAt': updatedAt.toIso8601String()
    };
  }
}
