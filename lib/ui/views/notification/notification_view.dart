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

class Notifications extends StatelessWidget {
  final List<FNotification> notifications; // Danh sách thông báo

  Notifications({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách thông báo'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index].content),
            subtitle: Text(
              'Ngày tạo: ${notifications[index].createdAt.toString()}',
            ),
            onTap: () {
              // Xử lý khi người dùng chọn một thông báo cụ thể
              // Thường là chuyển đến trang chi tiết thông báo
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => NotificationDetailScreen(
              //       notification: notifications[index],
              //     ),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
