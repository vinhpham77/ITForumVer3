import 'package:flutter/material.dart';

class FNotification {
  final int id;
  final String username;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String type;

  FNotification({
    required this.id,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.type,
  });
}

class NotificationDetailScreen extends StatelessWidget {
  final FNotification notification;

  NotificationDetailScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết thông báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Người gửi: ${notification.username}'),
            Text('Nội dung: ${notification.content}'),
            Text('Ngày tạo: ${notification.createdAt.toString()}'),
            // Các thông tin khác về thông báo
          ],
        ),
      ),
    );
  }
}
