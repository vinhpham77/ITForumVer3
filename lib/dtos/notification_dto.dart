class NotificationDTO {
  final int id;
  final String username;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String type;
  final int targetId;

  NotificationDTO({
    required this.id,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.type,
    required this.targetId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'content': content,
      'createdAt': createdAt,
      'isRead': isRead,
      'type': type,
      'targetId': targetId,
    };
  }
}
