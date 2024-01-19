import 'dart:async';

import 'package:it_forum/api_config.dart';
import 'package:dio/dio.dart';
import 'notification_repository.dart';

class UserRepository {
  late Dio dio;
  late NotificationRepository notificationRepository;
  final String baseUrl = "${ApiConfig.userServiceBaseUrl}/${ApiConfig.usersEndpoint}";

  UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    notificationRepository = NotificationRepository();
  }

  Future<Response<dynamic>> getUser(String username) async {
    return dio.get("/$username");
  }

  Future<Response<dynamic>> getFollows({
    required String username,
    required int page,
    required int size,
    required bool isFollowed,
  }) async {
    String object = isFollowed ? "followers" : "followings";
    return dio.get("/$username/$object", queryParameters: {
      "page": page,
      "size": size,
    });
  }

  Future<Response<dynamic>> getTagCounts(String username) async {
    return dio.get("/$username/tags");
  }

  Future<Response<dynamic>> getStats(String username) async {
    return dio.get("/stats/$username");
  }

  Future<Response<dynamic>> followUser(String usernameToFollow) async {
    // Thực hiện logic theo dõi người dùng ở đây...

    // Gửi thông báo khi có sự kiện theo dõi
    final username = 'exampleUser'; // Thay thế bằng tên người dùng thích hợp
    final content = '$username đã bắt đầu theo dõi bạn.';
    
    // Gửi thông báo với loại 'follow'
    await notificationRepository.sendNotification(
      username: usernameToFollow,
      content: content,
      type: 'follow',
    );

    // Trả về response từ API
    return dio.post('/follow', data: {'usernameToFollow': usernameToFollow});
  }
}
