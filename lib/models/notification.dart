
import 'package:it_forum/models/user.dart';

class Notification {
  final int id;
  final User user;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String type;
  final int targetId;

  // Tạo một constructor để khởi tạo các thuộc tính của lớp
  Notification({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.type,
    required this.targetId,
  });
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      user: User.fromJson(json['username']),
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['read'],
      type: json['type'],
      targetId: json['targetId'],
    );
  }

  toJson() {}
}
