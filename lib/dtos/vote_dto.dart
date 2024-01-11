class VoteDTO {
  final int targetId;
  final String? username;
  final bool voteType;
  final bool targetType;

  VoteDTO(
      {required this.targetId,
      required this.username,
      required this.voteType,
      required this.targetType});

  factory VoteDTO.fromJson(Map<String, dynamic> json) {
    return VoteDTO(
        targetId: json['targetId'],
        username: json['username'],
        voteType: json['voteType'],
        targetType: json['targetType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'username': username ?? '',
      'voteType': voteType,
      'targetType':targetType
    };
  }
}
